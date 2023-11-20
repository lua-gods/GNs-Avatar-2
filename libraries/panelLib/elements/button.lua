local base = require("libraries.panelLib.elements.element")

---@class GNpanel.element.button : GNpanel.element
---@field pressed boolean
local button = {}
button.__index = function (t,i)
   return button[i] or base.__index(t,i)
end
button.__type = "GNpanel.Element.Button"

---@param obj table?
---@return GNpanel.element
function button.new(obj)
   local new = obj or base.new()
   new.pressed = false
   setmetatable(new,button)
   return new --[[@type GNpanel.element]]
end

return button