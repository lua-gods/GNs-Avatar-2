# AYO WHAT

local gnui = require("libraries.gnui")
local eventLib = require("libraries.eventLib")

local default_display_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(0,0,4,4):setBorderThickness(2,2,2,2)
local default_element_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(5,2,13,4):setBorderThickness(3,1,3,1)
local default_element_hover_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(6,1)


---@class panel.element
---@field index integer
---@field display GNUI.container|GNUI.container
---@field parent panel.page?
---@field is_hovering boolean
---@field is_pressed boolean
---@field input_changed eventLib
---@field _press_handler fun(self : panel.element, pressed : boolean, hovering : boolean)?
---@field _capture_cursor boolean 
---@field _is_toggle boolean
local element = {}
element.__index = function (t,i)
   return rawget(t,i) or element[i]
end
element.__type = "panel.element"


---@param preset panel.element?
---@return panel.element
function element.new(preset)
   preset = preset or {}
   local new = {}
   new.input_changed = eventLib.new()
   new.is_hovering = preset.is_hovering or false
   new.is_pressed =  preset.is_pressed or false
   new._capture_cursor = preset._capture_cursor or false
   new._is_toggle = preset._is_toggle or false
   
   
   local normal_sprite = default_element_sprite:copy()
   local hover_sprite = default_element_hover_sprite:copy()
   local container = gnui.newContainer():setSprite(normal_sprite):setAnchor(0,0,1,0)
   new.input_changed:register(function ()
      if new.is_hovering then
         container:setSprite(hover_sprite)
      else
         container:setSprite(normal_sprite)
      end
   end)
   container:setDimensions(0,0,0,12)
   new.display = container

   local label = gnui.newLabel()
   label:setName("label")
   :setAnchor(0,0,1,1)
   :setDimensions(0,0,0,12)
   :setDimensions(14,2,-2,-2)
   container:addChild(label)

   setmetatable(new,element)
   return new
end


---@param text string
---@return self
function element:setText(text)
   self.display:getChild("label"):setText("lmao")
   return self
end

---@param icon Minecraft.itemID
---@return self
function element:setIconItem(icon)
   self.display.ModelPart:removeTask("icon")
   self.display.ModelPart:newItem("icon"):item(icon):scale(0.5,0.5,1):pos(-8,-6,-3):displayMode("GUI")
   return self
end


---@param icon Minecraft.blockID
---@return self
function element:setIconBlock(icon)
   self.display.ModelPart:removeTask("icon")
   self.display.ModelPart:newBlock("icon"):block(icon):scale(0.5,0.5,1):pos(-11.5,-10,0)
   return self
end

---@param text string
---@return self
function element:setIconText(text,is_emoji)
   self.display.ModelPart:removeTask("icon")
   local w = is_emoji and 8 or client.getTextWidth(text)
   self.display.ModelPart:newText("icon"):text(text):scale(1,1,1):pos(-8+w/2,-2,0)
   return self
end

---@class panel.page
---@field display panel.display
---@field elements panel.element[]
---@field pressed boolean
---@field mouse_mode boolean
---@field selected_index integer
---@field last_selected panel.element?
---@field selected panel.element?
---@field focused boolean
local page = {}
page.__index = function (t,i)
   return rawget(t,i) or page[i]
end

---@return panel.page
function page.new()
   local new = setmetatable({},page)
   new.elements = {}
   new.mouse_mode = false
   new.pressed = false
   new.selected_index = 0
   new.focused = false
   return new
end

---Sets where to select in the containers. if relative is true, x is added onto the current index.
---@generic self
---@param x integer
---@param relative boolean?
---@return self
function page:setSelected(x, relative)
   if #self.elements == 0 then return self end
   self.last_selected = self.selected

   if not (self.selected and self.selected._capture_cursor) then -- only move when the cursor is not captured
      self.selected_index = math.clamp((relative and self.selected_index or 0) - x, 1, #self.elements)
      self.selected = self.elements[self.selected_index]
   end
   if self.last_selected ~= self.selected then -- moved
      if self.last_selected then
         self.last_selected.is_hovering = false
         if self.last_selected.input_changed then
            self.last_selected.input_changed:invoke(page.pressed,false)
         end
      end

      if self.selected then
         self.selected.is_hovering = true
         if self.selected.input_changed then
            self.selected.input_changed:invoke(page.pressed,true)
         end
      end
   end
   return self
end

---@return panel.page
function page:press()
   self.pressed = true
   if self.selected and self.selected.input_changed then
      self.selected:_press_handler(self.pressed,true)
      self.selected:input_changed(self.pressed,true)
   end
   return self
end

---@return panel.page
function page:release()
   self.pressed = false
   if self.selected and self.selected.input_changed then
      self.selected:_press_handler(self.pressed,true)
      self.selected:input_changed(self.pressed,false)
   end
   return self
end

---@param ... panel.element
---@return panel.page
function page:addElement(...)
   for _,e in pairs({...}) do
      local next_free = #self.elements + 1
      e.parent = self
      e.index = next_free
      self.elements[next_free] = e
   end
   if self.display then
      self.display:updateDisplays()
   end
   return self
end

---@param i integer
---@param e panel.element
function page:insertElement(i,e)
   e.parent = self
   e.index = i
   table.insert(self.elements,i,e)
   self:recalculateChildrenIndexes()
   return self
end

---@param i integer
function page:removeElement(i)
   table.remove(self.elements,i)
   self:recalculateChildrenIndexes()
   return self
end

function page:recalculateChildrenIndexes()
   for i, e in pairs(self.elements) do
      e.index = i
   end
   return self
end





---@class panel.display
---@field page panel.page?
---@field display GNUI.container
---@field focused boolean
local display = {}
display.__index = function (t,i)
   return rawget(t,i) or display[i]
end
display.__type = "panel.container"

---@param preset panel.display?
---@return panel.display
function display.new(preset)
   preset = preset or {}
   local new = {}
   new.page = preset.page
   new.display = gnui.newContainer():setSprite(default_display_sprite:copy())
   new.focused = preset.focused or false
   setmetatable(new,display)
   return new
end

---@param p panel.page
function display:setPage(p)
   if self.page ~= p then
      if self.page then
         self.page.display = nil
         self:detachDisplays()
      end
      self.page = p
      self:updateDisplays()
      self.page.display = self
   end
   return self
end

---@package
function display:detachDisplays()
   if self.page then
      for _, e in pairs(self.page.elements) do
         self.display:removeChild(e.display)
      end
   end
end

---@package
function display:updateDisplays()
   if self.page then
      local lowest = 1
      for _, e in pairs(self.page.elements) do
         self.display:addChild(e.display)
         e.display:offsetDimensions(0,lowest)
         lowest = math.max(lowest,e.display.ContainmentRect.w-1)
      end
      local d = self.display.Dimensions
      self.display:setDimensions(d.x,d.w-lowest-7,d.z,d.w-5)
   end
end

return {
   newElement = element.new,
   newPage = page.new,
   newContainer = display.new
}