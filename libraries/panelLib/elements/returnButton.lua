local base = require("libraries.panelLib.elements.base")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element.Button.Return : GNpanel.Element
---@field Label Label
---@field pressed boolean
local button = {}
button.__index = function (t,i)
   return button[i] or base.__index[i]
end
button.__type = "GNpanel.Element.Button.Return"

---@param obj table?
---@return GNpanel.Element.Button.Return
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
      if state == "HOVERING" then
         core.uiSound("minecraft:entity.item_frame.rotate_item",new.id / #new.PageParent.Elements + 0.75,0.5)
      end

      if state == "PRESSED" then
         if new.PageParent and new.PageParent.BookParent then
            new.PageParent.BookParent:returnPage()
         end
      end
   end,"feature")
   return new
end

function button:getSize()
   return vectors.vec2(client.getTextWidth("Return") + 10,10)
end

return button