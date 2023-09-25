local core = require("libraries.panelLib.panelCore")
local base = require("libraries.panelLib.elements.textButton")

local private = {}

---@class GNpanel.Element.ToggleButton : GNpanel.Element.TextButton
---@field Toggle boolean
---@field Labels table
---@field ON_TOGGLE AuriaEvent
local toggle = {}
toggle.__index = function (t,i)
   return toggle[i] or base.__index(t,i)
end


---@return GNpanel.Element.ToggleButton
function toggle.new(obj)
   local new = obj or base.new()
   new.Toggle = false
   new.ON_TOGGLE = core.event.newEvent()
   new.Labels = {}
   new.STATE_CHANGED:register(function (state)
      if state == "PRESSED" then
         new.Toggle = not new.Toggle
         new.ON_TOGGLE:invoke(new.Toggle)
         if new.Toggle then
            core.tween.tweenFunction(0,1,0.5,"outElastic",function (x)
               new.Labels.switch.handle:setPos(new.pos.x - math.lerp(2,4,x),new.pos.y)
            end,"toggle")
         else
            core.tween.tweenFunction(1,0,0.5,"outElastic",function (x)
               new.Labels.switch.handle:setPos(new.pos.x - math.lerp(2,4,x),new.pos.y)
            end,"toggle")
         end
      end
   end)
   new.REBUILD:register(function ()
      new.Labels.switch =  {
      case_left = core.labelLib.new(new.PageParent.BookParent.Part):setText("["):setEffect("OUTLINE"),
      case_right = core.labelLib.new(new.PageParent.BookParent.Part):setText("]"):setEffect("OUTLINE"),
      handle = core.labelLib.new(new.PageParent.BookParent.Part):setText("[]"):setEffect("OUTLINE"):setDepth(-1),
   }
   end,"switch")
   
   new.UPDATE:register(function ()
      if new.Labels.switch then
         new.Labels.switch.handle:setPos(new.pos.x - math.lerp(2,4,new.Pressed and 1 or 0),new.pos.y)
         new.Labels.switch.case_left:setPos(new.pos):setText(new.Toggle and '{"text":"[","color":"green"}' or '{"text":"[","color":"red"}')
         new.Labels.switch.case_right:setPos(new.pos:copy():add(-10,0)):setText(new.Toggle and '{"text":"]","color":"green"}' or '{"text":"]","color":"red"}')
      end
   end,"switch")

   new.UPDATE:register(function ()
      new.Label.TextOverride = new.get_color_overrides(new.Pressed,new.Hovering)
      new.Label:setText(new.text):setPos(new.pos:copy():add(-18,0)):setEffect("OUTLINE")
   end,"label")
   setmetatable(new,toggle)
   return new
end

return toggle