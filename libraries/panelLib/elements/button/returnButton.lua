local base = require("libraries.panelLib.elements.element")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.element.button.return : GNpanel.element
---@field Label Label
---@field pressed boolean
local button = {}
button.__index = function (t,i)
   return button[i] or base.__index(t,i)
end
button.__type = "GNpanel.Element.Button.Return"

---@param obj table?
---@return GNpanel.element.button.return
function button.new(obj)
   local new = obj or base.new()
   new.text = '[{"text":"Empty Button","color":"default"}]'
   setmetatable(new,button)

   new.REBUILD:register(function ()
      if new.Label then new.Label:delete() end
      if new:shouldRender() then
         new.Label = core.labelLib.new(new.PageParent.BookParent.Part)
      end
   end,"label")
   new.UPDATE:register(function ()
      if new.Label then
         new.Label:setText('{"text":"Return","color":"red"}'):setPos(new.pos):setEffect("OUTLINE")
         if new.Hovering then
            new.Label:setGlowColor(0.3,0.3,0.3)
         else
            new.Label:setGlowColor(0,0,0)
         end
      end
   end,"label")
   
   new.STATE_CHANGED:register(function (state)
      if state == "PRESSED" then
         if new.PageParent and new.PageParent.BookParent then
            new.PageParent.BookParent:returnPage()
         end
      end
   end,"feature")
   return new --[[@type GNpanel.element.button.return]]
end

function button:getSize()
   return vectors.vec2(client.getTextWidth("Return") + 10,10)
end

return button