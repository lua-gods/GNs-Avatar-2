# AYO WHAT

local gnui = require("libraries.gnui")
local eventLib = require("libraries.eventLib")
local tween = require("libraries.GNTweenLib")


local default_display_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(0,0,4,4):setBorderThickness(2,2,2,2)
local default_display_sprite_borderless = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(1,10,3,12):setBorderThickness(1,1,1,1)
local default_element_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(5,2,13,4):setBorderThickness(3,1,3,1)
local default_element_hover_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(6,1)
local default_element_pressed_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(6,1):setColor(0,0,0)
local generic_ninepatch_srite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(1,6,3,8):setBorderThickness(1,1,1,1)
local generic_ninepatch_srite_border = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(0,14,4,18):setBorderThickness(2,2,2,2)


---@alias panel.any panel.element | panel.button | panel.toggle

---@class panel.element
---@field id integer
---@field index integer
---@field display GNUI.container|GNUI.container
---@field parent panel.page?
---@field is_hovering boolean
---@field is_pressed boolean
---@field PRESS_CHANGED eventLib
---@field HOVER_CHANGED eventLib
---@field KEY_PRESSED eventLib
---@field SCROLLED eventLib
---@field _press_handler fun(self : panel.element, pressed : boolean, hovering : boolean)?
---@field _capture_cursor boolean 
---@field package cache table
local element = {}
element.__index = function (t,i)
   return rawget(t,i) or element[i]
end
element.__type = "panel.element"


local next_free = 0
---@param preset panel.element?
---@return panel.element
function element.new(preset)
   preset = preset or {}
   local new = {}
   new.PRESS_CHANGED = eventLib.new()
   new.HOVER_CHANGED = eventLib.new()
   new.KEY_PRESSED = eventLib.new()
   new.SCROLLED = eventLib.new()

   new.id = next_free
   next_free = next_free + 1
   new.is_hovering = preset.is_hovering or false
   new.is_pressed =  preset.is_pressed or false
   new._capture_cursor = preset._capture_cursor or false
   new.cache = {}
   new._press_handler = function (self,pressed,hovering)
      new.is_hovering = hovering
      new.is_pressed = pressed and hovering
   end
   
   new.cache.normal_sprite = default_element_sprite:copy()
   new.cache.hover_sprite = default_element_hover_sprite:copy()
   new.cache.pressed_sprite = default_element_pressed_sprite:copy()
   local container = gnui.newContainer():setSprite(new.cache.normal_sprite):setAnchor(0,0,1,0)
   new.HOVER_CHANGED:register(function ()
      if new.is_hovering then
         container:setSprite(new.cache.hover_sprite)
      else
         container:setSprite(new.cache.normal_sprite)
      end
   end,"_display")
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





---@param text string|table
---@return self
function element:setText(text)
   self.display:getChild("label"):setText(text)
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




---@class panel.button : panel.element
---@field PRESSED eventLib
---@field RELEASED eventLib
local button = {}
button.__index = function (t,i)
   return rawget(t,i) or button[i] or element[i]
end
button.__type = "panel.button"

---@param preset panel.any?
---@return panel.button
function button.new(preset)
   ---@type panel.button
   ---@diagnostic disable-next-line: assign-type-mismatch
   local new = element.new(preset)
   new.PRESSED = eventLib.new()
   new.RELEASED = eventLib.new()

   local function display_changed()
      if new.is_hovering then
         if new.is_pressed then
            new.display:setSprite(new.cache.pressed_sprite)
         else
            new.display:setSprite(new.cache.hover_sprite)
         end
      else
         new.display:setSprite(new.cache.normal_sprite)
      end
   end

   new.HOVER_CHANGED:register(display_changed,"_display")
   new.PRESS_CHANGED:register(display_changed,"_display")
   new.PRESS_CHANGED:register(function ()
      if new.is_pressed then
         new.PRESSED:invoke()
      else
         new.RELEASED:invoke()
      end
   end,"_internal")
   return setmetatable(new,button)
end





---@class panel.toggle : panel.button
---@field toggle boolean
---@field TOGGLED eventLib
local toggle = {}
toggle.__index = function (t,i)
   return rawget(t,i) or toggle[i] or button[i] or element[i]
end
toggle.__type = "panel.toggle"

local function _toggle_slider(x,slider,handle)
   slider:setColor(math.lerp(vectors.vec3(1,0.5,0.5),vectors.vec3(0.5,1,0.5),math.clamp(x,0,1)))
   local o = x * 6
   handle:setDimensions(-10-7 + o,-5,-10 + o,5)
end

---@param preset panel.any?
function toggle.new(preset)
   ---@type panel.toggle
   ---@diagnostic disable-next-line: assign-type-mismatch
   local new = button.new(preset)
   new.toggle = false
   new.TOGGLED = eventLib.new()
   
   local slider_sprite = generic_ninepatch_srite_border:copy():setOpacity(1)
   local switch_slider = gnui.newContainer():setSprite(slider_sprite)
   switch_slider:setAnchor(1,0.5):setDimensions(-4-13,-4,-4,4)
   new.display:addChild(switch_slider)

   local switch_handle = gnui.newContainer():setSprite(generic_ninepatch_srite_border:copy():setRenderType("EMISSIVE_SOLID"))
   switch_handle:setAnchor(1,0.5):setDimensions(-10-7,-5,-10,5)
   new.display:addChild(switch_handle)

   new.PRESSED:register(function ()
      new.toggle = not new.toggle
      new.TOGGLED:invoke()
   end,"_toggle")

   
   
   new.TOGGLED:register(function ()
      if new.toggle then
         tween.tweenFunction(new.cache.toggle_slider_slide,1,0.5,"outElastic",function (value, transition)
            _toggle_slider(value,slider_sprite,switch_handle)
            new.cache.toggle_slider_slide = value
         end,nil,new.id)
      else
         tween.tweenFunction(new.cache.toggle_slider_slide,0,0.5,"outElastic",function (value, transition)
            _toggle_slider(value,slider_sprite,switch_handle)
            new.cache.toggle_slider_slide = value
         end,nil,new.id)
      end
   end,"_internal")

   return setmetatable(new,toggle)
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
         if self.last_selected._press_handler then
            self.last_selected:_press_handler(self.pressed,false)
         end
         self.last_selected.HOVER_CHANGED:invoke()
      end
      
      if self.selected then
         if self.selected._press_handler then
            self.selected:_press_handler(self.pressed,true)
         end
         self.selected.HOVER_CHANGED:invoke()
      end
   end
   return self
end

---@return panel.page
function page:press()
   self.pressed = true
   if self.selected then
      if self.selected._press_handler then
         self.selected:_press_handler(self.pressed,true)
      end
      self.selected.PRESS_CHANGED:invoke()
   end
   return self
end

---@return panel.page
function page:release()
   self.pressed = false
   if self.selected then
      if self.selected._press_handler then
         self.selected:_press_handler(self.pressed,true)
      end
      self.selected.PRESS_CHANGED:invoke()
   end
   return self
end

---@param ... panel.any
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
   newButton = button.new,
   newToggle = toggle.new,
   newPage = page.new,
   newContainer = display.new,
}