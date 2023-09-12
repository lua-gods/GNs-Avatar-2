local core = require("libraries.panelLib.panelCore")
local base = require("libraries.panelLib.elements.textButton")

---@class GNpanel.Element.ToggleButton : GNpanel.Element.TextButton
---@field toggle boolean
---@field ON_TOGGLE KattEvent
local toggle = {}
toggle.__index = function (t,i)
   return toggle[i] or base.__index(t,i)
end


---@return GNpanel.Element.ToggleButton
function toggle.new(obj)
   local new = obj or base.new()
   --new.toggle = false
   --new.ON_TOGGLE = core.event.newEvent()
   setmetatable(new,toggle)
   return new
end

return toggle