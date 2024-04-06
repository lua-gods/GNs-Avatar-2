

local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")
local element = require("libraries.panels.element")
local button = require("libraries.panels.elements.button")
local gnui = require("libraries.gnui")
local tween = require("libraries.GNTweenLib")
local key2string = require("libraries.key2string")


---@alias panel.textInput.displayType "HALF" | "FULL"

---@class panel.textInput : panel.button
---@field input_display GNUI.Label
---@field is_editing boolean
---@field VALUE_CHANGED eventLib
---@field VALUE_ACCEPTED eventLib
---@field value string
---@field force_full boolean
local textInput = {}
textInput.__index = function (t,i)
   return rawget(t,i) or textInput[i] or button[i] or element[i]
end
textInput.__type = "panel.toggle"
---@param preset panel.toggle?
function textInput.new(preset)
   ---@type panel.textInput
   ---@diagnostic disable-next-line: assign-type-mismatch
   local new = button.new(preset)
   setmetatable(new,textInput)
   new.force_full = false
   new.value = ""
   new.VALUE_CHANGED = eventLib.new()
   new.VALUE_ACCEPTED = eventLib.new()
   new.cache.input_sprite = config.default_display_sprite:copy():setOpacity(0.5)
   local input_display = gnui.newLabel():setSprite(new.cache.input_sprite):setAlign(0,0.5)
   new.display:addChild(input_display)
   new.input_display = input_display
   events.KEY_PRESS:register(function (key, state, modifiers)
      local k = key2string(key,modifiers)
      if new.is_editing and new.parent and k ~= "escape" then
         if state == 1 then
            if #k == 1 then
               new.value = new.value..k
            elseif k == "backspace" then
               new.value = new.value:sub(1,-2)
            elseif k == "enter" then
               new.parent:press()
               new.VALUE_ACCEPTED:invoke(new.value)
            end
            new.VALUE_CHANGED:invoke(new.value)
         end
         return true
      end
   end,"spinbox"..new.id)
   new.VALUE_CHANGED:register(function (value)
      new.label:setVisible(#value == 0)
      if tonumber(value) then
         new.input_display:setText({text=" "..value.. " "}):setAlign(1,0.5)
      else
         new.input_display:setText({text=" "..value.. " "}):setAlign(0,0.5)
      end
   end)
   new._press_handler = function (press)
      if press then
         new.is_pressed = not new.is_pressed
         new._capture_cursor = new.is_pressed
         new.is_editing = new.is_pressed
         new:_updateDisplayType()
      end
   end
   new:_updateDisplayType()
   return new
end

function textInput:setForceFull(is_full)
   self.force_full = is_full
   self:_updateDisplayType()
   return self
end

---@param text string
---@return self
function textInput:setValue(text)
   self.value = text
   return self
end
---@package
function textInput:_updateDisplayType()
   if self.is_pressed or self.force_full then
      local v = self.cache._spinbox_transition
      self.label:setVisible(#self.value == 0)
      tween.tweenFunction(v ,0,0.2,"inOutCubic",function (value, transition)
         self.input_display:setAnchor(value,0,1,1)
         self.cache._spinbox_transition = value
      end,nil,"spinbox"..self.id)
   else
      local v = self.cache._spinbox_transition
      tween.tweenFunction(v,0.5,0.2,"inOutCubic",function (value, transition)
         self.input_display:setAnchor(value,0,1,1)
         self.cache._spinbox_transition = value
      end,function ()
         self.label:setVisible(true)
      end,"spinbox"..self.id)
   end
end

return textInput