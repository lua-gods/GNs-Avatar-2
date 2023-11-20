local base = require("libraries.panelLib.elements.button")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.element.button.textButton : GNpanel.element.button
---@field text string
---@field Label Label
---@field pressed boolean
local txtbtn = {}
txtbtn.__index = function (t,i)
   return txtbtn[i] or base.__index(t,i)
end
txtbtn.__type = "GNpanel.Element.TextButton"

---@param obj table?
---@return GNpanel.element.button.textButton
function txtbtn.new(obj)
   local new = obj or base.new()
   new.text = '[{"text":"Empty Button","color":"default"}]'
   setmetatable(new,txtbtn)
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
         new.Label.TextOverride = txtbtn.get_color_overrides(new.down,new.Hovering)
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
---@return GNpanel.element.button.textButton
function txtbtn:setText(text)
   self.text = text
   if self:shouldRender() then
      self:rebuild()
      self:update()
   end
   return self
end

function txtbtn.get_color_overrides(pressed,hovering)
   if pressed then return core.color_overrides.pressed else
      if hovering then return core.color_overrides.hovering
      else return core.color_overrides.none end
   end
end

function txtbtn:getSize()
   return vectors.vec2(client.getTextWidth(self.text),client.getTextHeight(self.text))
end

return txtbtn