

local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")
local element = require("libraries.panels.element")
local button = require("libraries.panels.elements.button")
local gnui = require("libraries.GNUI")
local tween = require("libraries.GNTweenLib")
local key2string = require("libraries.key2string")


---@alias panels.textInput.displayType "HALF" | "FULL"

---@class panels.textInput : panels.button
---@field input_container GNUI.container
---@field input_display GNUI.Label
---@field is_editing boolean
---@field package was_editing boolean
---@field value_color string?
---@field VALUE_CHANGED eventLib
---@field VALUE_ACCEPTED eventLib
---@field prefix string?
---@field suffix string?
---@field value string|number
---@field editing_value string|number
---@field force_full boolean
local textInput = {}
textInput.__index = function (t,i)
   return rawget(t,i) or textInput[i] or button[i] or element[i]
end


textInput.__type = "panels.toggle"
---@param preset panels.toggle?
---@return panels.textInput
function textInput.new(preset)
   ---@type panels.textInput
   ---@diagnostic disable-next-line: assign-type-mismatch
   local new = button.new(preset)
   setmetatable(new,textInput)
   new.force_full = false
   new.value = ""
   new.editing_value = ""
   new.VALUE_CHANGED = eventLib.new()
   new.VALUE_ACCEPTED = eventLib.new()
   new.cache.input_sprite = config.default_display_sprite:copy():setOpacity(0.5)
   local input_container = gnui.newContainer():setSprite(new.cache.input_sprite)
   local input_display = gnui.newLabel():setAlign(0,0.5):setAnchor(0,0,1,1)
   input_container:addChild(input_display)
   new.input_container = input_container
   new.input_display = input_display
   new.display:addChild(input_container)
   new.PRESS_CHANGED:register(function ()
      new:updateValueDisplay()
   end)
   events.CHAR_TYPED:register(function (char, modifiers, codepoint)
      if new.is_editing and new.parent then
         if new.was_editing == new.is_editing then
            local value = tostring(new.editing_value)
            value = value..char
            new.editing_value = value
            new:updateValueDisplay()
            new.VALUE_CHANGED:invoke()
         end
         new.was_editing = new.is_editing -- used to make sure that we dont place a character when pressing the button
      end
   end)
   events.KEY_PRESS:register(function (key, state, modifiers)
      if new.is_editing and new.parent then
         if state == 1 then
            local t = type(new.editing_value)
            local value = tostring(new.editing_value)
            if key == 259 then -- erase
               value = value:sub(1,-2)
            elseif key == 257 then -- accepted
               if t == "number" then
                  value = tonumber(value) or 0
               end
               new.parent:press()
               new:setAcceptedValue(value)
            elseif key == 256 then
               new.parent:press()
               new:updateValueDisplay()
               new:setAcceptedValue(new.value)
               new.VALUE_CHANGED:invoke()
               return true
            end
            new.editing_value = value
            new:updateValueDisplay()
            new.VALUE_CHANGED:invoke()
         end
         return true
      end
   end,"text_input"..new.id)
   new.VALUE_CHANGED:register(function (value)
      new.label:setVisible(#tostring(value) == 0)
      if tonumber(value) then
         new.input_display:setAlign(1,0.5)
      else
         new.input_display:setAlign(0,0.5)
      end
      new:updateValueDisplay()
   end,"_internal")
   new:_updateDisplayType()
   return new
end

---@generic self
---@param self self
---@return self
function textInput:press()
   ---@cast self panels.textInput
   self.is_pressed = not self.is_pressed
   self._capture_cursor = self.is_pressed
   self.is_editing = self.is_pressed
   self.was_editing = false
   self:_updateDisplayType()
   return self
end

---@generic self
---@param self self
---@return self
function textInput:setAcceptedValue(value)
   ---@cast self panels.textInput
   self.is_editing = false
   self.editing_value = tostring(value)
   self.value = value
   self.was_editing = false
   self:updateValueDisplay()
   self.VALUE_ACCEPTED:invoke(self.value)
   return self
end


---@param is_full any
---@generic self
---@param self self
---@return self
function textInput:setForceFull(is_full)
   ---@cast self panels.textInput
   self.force_full = is_full
   self:_updateDisplayType()
   return self
end


---Note: this wont call the VALUE_CHANGED event
---@param value string|number
---@generic self
---@param self self
---@return self
function textInput:setEditingValue(value)
   ---@cast self panels.textInput
   self.editing_value = value
   self:updateValueDisplay()
   return self
end

---@package
function textInput:_updateDisplayType()
   if self.is_pressed or self.force_full then
      local v = self.cache._spinbox_transition
      self:updateValueDisplay()
      tween.tweenFunction(v ,0,0.2,"inOutCubic",function (value, transition)
         self.input_container:setAnchor(value,0,1,1)
         self.cache._spinbox_transition = value
      end,nil,"spinbox"..self.id)
   else
      local v = self.cache._spinbox_transition
      tween.tweenFunction(v,0.5,0.2,"inOutCubic",function (value, transition)
         self.input_container:setAnchor(value,0,1,1)
         self.cache._spinbox_transition = value
      end,function ()
         self:updateValueDisplay()
      end,"spinbox"..self.id)
   end
end


function textInput:updateValueDisplay()
   local text
   local value
   if self.is_editing then
      self.label:setVisible(#tostring(self.value) == 0 and #tostring(self.editing_value) == 0)
      value = tostring(self.editing_value)
      text = value
      if #tostring(self.editing_value) == 0 then
         self.input_display:setVisible(false)
      else
         self.input_display:setVisible(true)
      end
      self.input_container.Sprite:setColor(0.6,0.6,0.6)
   else
      if #tostring(self.value) == 0 then
         self.input_display:setVisible(false)
      else
         self.input_display:setVisible(true)
      end
      value = tostring(self.value)
      text = (self.prefix or "")..value..(self.suffix or "")
      self.input_container.Sprite:setColor(1,1,1)
   end
   if tonumber(value) then
      self.input_display:setText({text=text,color=self.value_color or "white"}):setAlign(1,0.5)
   else
      self.input_display:setText({text=text,color=self.value_color or "white"}):setAlign(0,0.5)
   end
end

---@param prefix string?
---@generic self
---@param self self
---@return self
function textInput:setPrefix(prefix)
   ---@cast self panels.textInput
   self.prefix = prefix
   self:updateValueDisplay()
   return self
end

---@param suffix string?
---@generic self
---@param self self
---@return self
function textInput:setSuffix(suffix)
   ---@cast self panels.textInput
   self.prefix = suffix
   self:updateValueDisplay()
   return self
end

---@param color string?
---@generic self
---@param self self
---@return self
function textInput:setValueColor(color)
   ---@cast self panels.textInput
   if type(color) == "Vector3" then
      color = vectors.rgbToHex(color)
   end
   self.value_color = color
   self:updateValueDisplay()
   return self
end

return textInput