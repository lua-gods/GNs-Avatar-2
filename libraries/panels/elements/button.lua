
local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")
local element = require("libraries.panels.element")

---@class panels.button : panels.element
---@field PRESSED eventLib
---@field RELEASED eventLib
local button = {}
button.__index = function (t,i)
   return rawget(t,i) or button[i] or element[i]
end
button.__type = "panels.button"


---@param preset panels.button?
---@return panels.button
function button.new(preset)
   ---@type panels.button
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
         if new.flat then
            new.display:setSprite()
         else
            new.display:setSprite(new.cache.normal_sprite)
         end
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
return button