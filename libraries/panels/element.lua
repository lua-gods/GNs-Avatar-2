local gnui = require("libraries.GNUI")
local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")

---@class panels.element
---@field id integer
---@field index integer
---@field flat boolean
---@field display GNUI.container
---@field label GNUI.Label
---@field parent panels.page?
---@field is_hovering boolean
---@field has_icon boolean
---@field is_pressed boolean
---@field PRESS_CHANGED eventLib
---@field HOVER_CHANGED eventLib
---@field KEY_PRESSED eventLib
---@field SCROLLED eventLib
---@field _capture_cursor boolean 
---@field cache table
local element = {}
element.__index = function (t,i)
   return rawget(t,i) or element[i]
end
element.__type = "panels.element"


local next_free_element = 0
---@param preset panels.element?
---@return panels.element
function element.new(preset)
   preset = preset or {}
   ---@type panels.element
---@diagnostic disable-next-line: missing-fields
   local new = {}
   new.flat = false
   new.PRESS_CHANGED = eventLib.new()
   new.HOVER_CHANGED = eventLib.new()
   new.KEY_PRESSED = eventLib.new()
   new.SCROLLED = eventLib.new()

   new.id = next_free_element
   next_free_element = next_free_element + 1
   new.is_hovering = preset.is_hovering or false
   new.is_pressed =  preset.is_pressed or false
   new._capture_cursor = preset._capture_cursor or false
   new.cache = {}

   new.cache.border_sprite = config.default_display_sprite:copy()
   new.cache.normal_sprite = config.default_element_sprite:copy()
   new.cache.hover_sprite = config.default_element_hover_sprite:copy()
   new.cache.pressed_sprite = config.default_element_pressed_sprite:copy()
   local container = gnui.newContainer()
   new.HOVER_CHANGED:register(function ()
      if new.cache.borders then
         container:setSprite(config.border_sprite)
      else
         if new.is_hovering then
            container:setSprite(config.border_sprite)
         else
            if new.flat then
               container:setSprite()
            else
               container:setSprite(new.cache.normal_sprite)
            end
         end
      end
   end,"_display")
   new.HOVER_CHANGED:invoke()
   new.display = container
   container:setDimensions(0,0,0,12)

   local label = gnui.newLabel()
   label:setName("label")
   :setAnchor(0,0,1,1)
   :setDimensions(2,2,-2,-2)
   new.label = label
   container:addChild(label)

   setmetatable(new,element)
   return new
end

---@generic self
---@param self self
---@return self
---@param custom_height number?
function element:setForcedHeight(custom_height)
   ---@cast self panels.element
   self.custom_height = custom_height or 12
   self.display:setDimensions(0,0,0,self.custom_height)
   return self
end

---@generic self
---@param self self
---@return self
---@param custom_width number?
function element:setForcedWidth(custom_width)
   ---@cast self panels.element
   self.custom_width = custom_width or 12
   return self
end

function element:press()
   if not self.is_pressed then
      self.is_pressed = true
      self.PRESS_CHANGED:invoke(true)
   end
end

function element:release()
   if self.is_pressed then
      self.is_pressed = false
      self.PRESS_CHANGED:invoke(false)
   end
end

function element:hover()
   if not self.is_hovering then
      self.is_hovering = true
      self.HOVER_CHANGED:invoke(true)
   end
end

function element:unhover()
   if self.is_hovering then
      self.is_hovering = false
      self.HOVER_CHANGED:invoke(false)
   end
end

---@param text string|table
---@generic self
---@param self self
---@return self
function element:setText(text)
   ---@cast self panels.element
   self.display:getChild("label"):setText(text)
   return self
end

--- returns the GNUI label of the element.
---@return GNUI.Label
function element:getLabel()
   return self.label
end

---@param icon Minecraft.itemID
---@generic self
---@param self self
---@return self
function element:setIconItem(icon)
   ---@cast self panels.element
   if not self.has_icon then
      self.cache.icon_anchor = self.display:addChild(gnui.newContainer():setAnchor(0,0.5))
      self.label:setDimensions(12,2,-2,-2)
      self.has_icon = true
   end
   self.cache.icon_anchor.ModelPart:removeTask("icon")
   self.cache.icon_anchor.ModelPart:newItem("icon"):item(icon):scale(0.5,0.5,1):pos(-6,-6,-3):displayMode("GUI")
   return self
end


---@param icon Minecraft.blockID
---@generic self
---@param self self
---@return self
function element:setIconBlock(icon)
   ---@cast self panels.element
   if not self.has_icon then
      self.cache.icon_anchor = self.display:addChild(gnui.newContainer():setAnchor(0,0.5))
      self.label:setDimensions(12,2,-2,-2)
      self.has_icon = true
   end
   self.cache.icon_anchor.ModelPart:removeTask("icon")
   self.cache.icon_anchor.ModelPart:newBlock("icon"):block(icon):scale(0.5,0.5,1):pos(-10.5,-10,0)
   return self
end

---@param text string
---@param is_emoji boolean
---@generic self
---@param self self
---@return self
function element:setIconText(text,is_emoji)
   ---@cast self panels.element
   if not self.has_icon then
      self.cache.icon_anchor = gnui.newPointAnchor():setAnchor(0,0.5):setOffset(0,2)
      self.display:addChild(self.cache.icon_anchor)
      self.label:setDimensions(12,2,-2,-2)
      self.has_icon = true
   end
   self.cache.icon_anchor.ModelPart:removeTask("icon")
   local w = is_emoji and 8 or client.getTextWidth(text)
   self.cache.icon_anchor.ModelPart:newText("icon"):text(text):scale(1,1,1):pos(-8+w/2+2,5,0)
   return self
end


---@generic self
---@param self self
---@return self
function element:removeIcon()
   ---@cast self panels.element
   if self.has_icon then
      self.label:setDimensions(2,2,-2,-2)
      self.has_icon = false
      self.cache.icon_anchor.ModelPart:removeTask("icon")
   end
   return self
end

return element