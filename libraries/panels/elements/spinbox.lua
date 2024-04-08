---@diagnostic disable: assign-type-mismatch, param-type-mismatch

local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")
local gnui = require("libraries.gnui")
local tween = require("libraries.GNTweenLib")

local element = require("libraries.panels.element")
local button = require("libraries.panels.elements.button")
local textInput = require("libraries.panels.elements.textInput")



---@class panels.spinbox : panels.textInput
---@field min_value number
---@field max_value number
---@field step_value number
---@field value number
local spinbox = {}
spinbox.__index = function (t,i)
   return rawget(t,i) or spinbox[i] or textInput[i] or button[i] or element[i]
end
spinbox.__type = "panels.spinbox"

---@param preset panels.spinbox?
---@return panels.spinbox
function spinbox.new(preset)
   preset = preset or {}
   ---@type panels.spinbox
   local new = textInput.new(preset)
   setmetatable(new,spinbox)
   new.min_value = preset.min_value or 0
   new.max_value = preset.max_value or 100
   new.step_value = preset.step_value or 1

   events.MOUSE_SCROLL:register(function (dir)
      if new.is_editing and tonumber(new.editing_value) then
         local e = new.editing_value
         e = e + new.step_value*dir
         
         if new.min_value then
            e = math.max(e,new.min_value)
         end
         
         if new.max_value then
            e = math.min(e,new.max_value)
         end
         new.editing_value = tostring(e)
         new.VALUE_CHANGED:invoke(new.editing_value)
      end
      new:updateValueDisplay()
   end,"text_input"..new.id)

   return setmetatable(new,spinbox)
end


---Note: this wont call the VALUE_CHANGED event
---@param number number
---@generic self
---@param self self
---@return self
function spinbox:setAcceptedValue(number)
   self.editing_value = ""
   ---@cast self panels.spinbox
   if #tostring(number) > 0 then
      self.value = self:validateValue(number)
   else
      self.value = ""
   end
   self:updateValueDisplay()
   self.VALUE_ACCEPTED:invoke(self.value)
   return self
end

function spinbox:validateValue(value)
   local n = string.gsub(tostring(value),"[^%d%.%-]","")
   local result = tonumber(n)
   if result then
      return result
   end
   return self.value
end

return spinbox