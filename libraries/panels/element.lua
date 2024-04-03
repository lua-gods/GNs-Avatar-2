local gnui = require("libraries.gnui")
local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")

---@class panel.element
---@field id integer
---@field index integer
---@field flat boolean
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
---@field cache table
local element = {}
element.__index = function (t,i)
   return rawget(t,i) or element[i]
end
element.__type = "panel.element"


local next_free_element = 0
---@param preset panel.element?
---@return panel.element
function element.new(preset)
   preset = preset or {}
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
   new._press_handler = function (self,pressed,hovering)
      new.is_hovering = hovering
      new.is_pressed = pressed and hovering
   end
   
   new.cache.normal_sprite = config.default_element_sprite:copy()
   new.cache.hover_sprite = config.default_element_hover_sprite:copy()
   new.cache.pressed_sprite = config.default_element_pressed_sprite:copy()
   local container = gnui.newContainer():setSprite(not new.flat and new.cache.normal_sprite or nil)
   new.HOVER_CHANGED:register(function ()
      if new.is_hovering then
         container:setSprite(new.cache.hover_sprite)
      else
         if new.flat then
            container:setSprite()
         else
            container:setSprite(new.cache.normal_sprite)
         end
      end
   end,"_display")
   new.display = container
   container:setDimensions(0,0,0,12)

   local label = gnui.newLabel()
   label:setName("label")
   :setAnchor(0,0,1,1)
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

return element