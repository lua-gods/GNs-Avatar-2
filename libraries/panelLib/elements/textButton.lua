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

---@param obj table?
---@return GNpanel.Element.TextButton
function button.new(obj)
   local new = obj or base.new()
   new.text = '[{"text":"Empty Button","color":"default"}]'
   new.Pressed = false
   setmetatable(new,button)

   new.REBUILD:register(function ()
      new.Label = core.labelLib.new(new.PageParent.BookParent.Part)
   end,"label")
   new.UPDATE:register(function ()
      new.Label.TextOverride = button.get_color_overrides(new.Pressed,new.Hovering)
      new.Label:setText(new.text):setPos(new.pos):setEffect("OUTLINE")
   end,"label")
   return new
end

---@param text string
---@return GNpanel.Element.TextButton
function button:setText(text)
   if self.Label then
      self.Label:setText(text)
   end
   self.text = text
   if self.PageParent then
      self:rebuild()
   end
   return self
end

function button.get_color_overrides(pressed,hovering)
   if pressed then return core.color_overrides.pressed else
      if hovering then return core.color_overrides.hovering
      else return core.color_overrides.none end
   end
end

return button