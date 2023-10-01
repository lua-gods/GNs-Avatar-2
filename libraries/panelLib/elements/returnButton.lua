local base = require("libraries.panelLib.elements.base")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element.Button.Return : GNpanel.Element
---@field Label Label
---@field pressed boolean
local button = {}
button.__index = function (t,i)
   return button[i] or base[i]
end

---@param obj table?
---@return GNpanel.Element.Button.Return
function button.new(obj)
   local new = obj or base.new()
   new.text = '[{"text":"Empty Button","color":"default"}]'
   setmetatable(new,button)

   new.REBUILD:register(function ()
      new.Label = core.labelLib.new(new.PageParent.BookParent.Part)
   end,"label")
   new.UPDATE:register(function ()
      new.Label:setText('{"text":"Return","color":"red"}'):setPos(new.pos):setEffect("OUTLINE")
      if new.Hovering then
         new.Label:setGlowColor(0.3,0.3,0.3)
      else
         new.Label:setGlowColor(0,0,0)
      end
   end,"label")
   return new
end

return button