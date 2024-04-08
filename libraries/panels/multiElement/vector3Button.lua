---@diagnostic disable: assign-type-mismatch
local elements = require("libraries.singleElementCollection")
local display_button = require("libraries.panels.elements.displayButton")
local eventLib = require("libraries.eventLib")


local display = require("libraries.panels.display")
local button = require("libraries.panels.elements.button")
local element = require("libraries.panels.element")

---@class panels.vector3Button : panels.button.display
---@field x_spinbox panels.spinbox
---@field y_spinbox panels.spinbox
---@field z_spinbox panels.spinbox
---@field VECTOR_CHANGED eventLib
---@field Vector Vector3
local vector3Button = {}
vector3Button.__index = function (t,i)
   return rawget(t,i) or display_button[i] or vector3Button[i] or display[i] or button[i] or element[i]
end

vector3Button.__type = "panels.vector3Button"

---@param button_preset panels.button.display?
---@param display_preset panels.display?
---@param spinbox_preset panels.spinbox?
---@return panels.button.display
function vector3Button.new(button_preset,display_preset,spinbox_preset)
   display_preset = display_preset or {}
   display_preset.direction = "HORIZONTAL"
   ---@type panels.vector3Button
   local btn = elements.newDisplayButton(button_preset)
   local dis = elements.newDisplay(display_preset)
   local pg = elements.newPage()
   
   btn.x_spinbox = elements.newSpinbox(spinbox_preset):setText({text="X",color="red"}):setForceFull(true):setValueColor("red")
   btn.y_spinbox = elements.newSpinbox(spinbox_preset):setText({text="Y",color="green"}):setForceFull(true):setValueColor("green")
   btn.z_spinbox = elements.newSpinbox(spinbox_preset):setText({text="Z",color="blue"}):setForceFull(true):setValueColor("blue")
   
   dis:setPage(pg,true)
   btn:setDisplay(dis)
   pg:addElement(btn.x_spinbox)
   pg:addElement(btn.y_spinbox)
   pg:addElement(btn.z_spinbox)

   btn.x_spinbox.VALUE_CHANGED:register(function ()
      btn:updateVector()
   end)
   setmetatable(btn,vector3Button)
   
   btn.VECTOR_CHANGED = eventLib.new()
   return btn
end

function vector3Button:updateVector()
   local x = tonumber(self.x_spinbox.editing_value) or self.x_spinbox.value
   local y = tonumber(self.y_spinbox.editing_value) or self.y_spinbox.value
   local z = tonumber(self.z_spinbox.editing_value) or self.z_spinbox.value
   self.Vector = vectors.vec3(x,y,z)
   self.VECTOR_CHANGED:invoke(self.Vector)
end

function vector3Button:setVector(vec)
   self.x_spinbox:setAcceptedValue(vec.x)
   self.y_spinbox:setAcceptedValue(vec.y)
   self.z_spinbox:setAcceptedValue(vec.z)
end

return vector3Button