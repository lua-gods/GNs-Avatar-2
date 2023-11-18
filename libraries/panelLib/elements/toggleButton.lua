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
toggle.__type = "GNpanel.Element.ToggleButton"

---@return GNpanel.Element.ToggleButton
function toggle.new(obj)
   local new = obj or base.new()
   setmetatable(new,toggle)
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
            end,nil,"toggle")
         else
            core.tween.tweenFunction(1,0,0.5,"outElastic",function (x)
               new.Labels.switch.handle:setPos(new.pos.x - math.lerp(2,4,x),new.pos.y)
            end,nil,"toggle")
         end
      end
   end)
   new.REBUILD:register(function ()
      if new.Labels.switch then
         for key, value in pairs(new.Labels.switch) do
            value:delete()
         end
      end
      if new:shouldRender() then
         new.Labels.switch =  {
         case_left = core.labelLib.new(new.PageParent.BookParent.Part):setText("["):setEffect("OUTLINE"),
         case_right = core.labelLib.new(new.PageParent.BookParent.Part):setText("]"):setEffect("OUTLINE"),
         handle = core.labelLib.new(new.PageParent.BookParent.Part):setText("[]"):setEffect("OUTLINE"):setDepth(-1),
      }
      end
   end,"switch")
   
   new.UPDATE:register(function ()
      if new.Labels.switch then
         new.Labels.switch.handle:setPos(new.pos.x - (new.Toggle and 4 or 2),new.pos.y)
         new.Labels.switch.case_left:setPos(new.pos):setText(new.Toggle and '{"text":"[","color":"green"}' or '{"text":"[","color":"red"}')
         new.Labels.switch.case_right:setPos(new.pos:copy():add(-10,0)):setText(new.Toggle and '{"text":"]","color":"green"}' or '{"text":"]","color":"red"}')
         if new.Hovering then
            new.Label:setGlowColor(0.3,0.3,0.3)
         else
            new.Label:setGlowColor(0,0,0)
         end
      end
   end,"switch")

   new.UPDATE:register(function ()
      new.Label.TextOverride = new.get_color_overrides(new.Pressed,new.Hovering)
      new.Label:setText(new.text):setPos(new.pos:copy():add(-18,0)):setEffect("OUTLINE")
   end,"label")

   new.STATE_CHANGED:register(function (state)
      if state == "HOVERING" then
         core.uiSound("minecraft:entity.item_frame.rotate_item",new.id / #new.PageParent.Elements + 0.75,0.5)
      end

      if state == "PRESSED" then
         core.uiSound("minecraft:block.note_block.hat",1,0.1)
      end
      if state == "RELEASED" then
         if new.Toggle then
            core.uiSound("minecraft:block.note_block.hat",2,0.5)
         else
            core.uiSound("minecraft:block.note_block.hat",1.2,0.5)
         end
      end
   end,"sounds")
   return new
end

function toggle:getSize()
   return vectors.vec2(client.getTextWidth(self.text) + 10,10)
end

return toggle