local base = require("libraries.panelLib.elements.base")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element.TextButton : GNpanel.Element
---@field text string
---@field Label Label
---@field pressed boolean
local button = {}
button.__index = function (t,i)
   return button[i] or base[i]
end
button.__type = "GNpanel.Element.TextButton"

---@param obj table?
---@return GNpanel.Element.TextButton
function button.new(obj)
   local new = obj or base.new()
   new.text = '[{"text":"Empty Button","color":"default"}]'
   new.down = false
   setmetatable(new,button)
   new.REBUILD:register(function ()
      if new.Label then
         new.Label:delete()
      end
      if new:shouldRender() then
         new.Label = core.labelLib.new(new.PageParent.BookParent.Part)
      end
   end,"label")
   new.UPDATE:register(function ()
      if new.Label then
         new.Label.TextOverride = button.get_color_overrides(new.down,new.Hovering)
         new.Label:setText(new.text):setPos(new.pos):setEffect("OUTLINE")
         if new.Hovering then
            new.Label:setGlowColor(0.3,0.3,0.3)
         else
            new.Label:setGlowColor(0,0,0)
         end
      end
   end,"label")
   return new
end

---@param text string
---@return GNpanel.Element.TextButton
function button:setText(text)
   self.text = text
   if self:shouldRender() then
      self:rebuild()
      self:update()
   end
   return self
end

function button.get_color_overrides(pressed,hovering)
   if pressed then return core.color_overrides.pressed else
      if hovering then return core.color_overrides.hovering
      else return core.color_overrides.none end
   end
end

function button:getSize()
   return vectors.vec2(client.getTextWidth(self.text),client.getTextHeight(self.text))
end

return button