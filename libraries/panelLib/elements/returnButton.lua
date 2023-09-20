local core = require("libraries.panelLib.panelCore")
local base = require("libraries.panelLib.elements.base")

---@class GNpanel.Element.Return : GNpanel.Element
local element = {}
element.__index = function (t,i)
   return element[i] or base[i]
end

function element.new(obj)
   ---@type GNpanel.Element.Return
   local new = obj or base
   setmetatable(new,element)
   return new
end

function element:update()
   local red = vectors.hexToRGB(core.colors.red)
   self.Labels[1]:setText("Return")
   if self.Hovering then
      self.Labels[1]:setColorRGB(red:unpack())
      self.Labels[1]:setOutlineColorRGB((red * 0.4):unpack())
   else
      self.Labels[1]:setColorRGB(red:unpack())
      self.Labels[1]:setOutlineColorRGB((red * 0.2):unpack())
   end
   self.Labels[1]:setText("Return")
   return self
end
function element:rebuild()
   if self.Labels[1] then
      self.Labels[1]:delete()
   end
   self.Labels[1] = core.labelLib.newLabel(self.Parent.Parent.Part)
   return self
end
function element:delete() return self end

function element:setHovering(is_hovering)
   self.Hovering = is_hovering
   return self
end

return element