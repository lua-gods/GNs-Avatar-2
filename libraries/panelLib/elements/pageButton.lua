local base = require("libraries.panelLib.elements.textButton")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element.PageButton : GNpanel.Element.TextButton
---@field page GNpanel.page
---@field Label table<any,Label>
local button = {}
button.__index = function (t,i)
   return button[i] or base.__index(t,i)
end
button.__type = "GNpanel.Element.PageButton"
---@param obj table?
---@return GNpanel.Element.PageButton
function button.new(obj)
   ---@type GNpanel.Element.PageButton
   local new = obj or base.new()
   setmetatable(new,button)

   new.REBUILD:register(function ()
      if new.Label then
         for key, value in pairs(new.Label) do
            value:delete()
         end
      end
      if new:shouldRender() then
         new.Label = {
            core.labelLib.new(new.PageParent.BookParent.Part),
            core.labelLib.new(new.PageParent.BookParent.Part)
         }
      end
   end,"label")
   new.UPDATE:register(function ()
      if new.Label then
         local override = button.get_color_overrides(new.down,new.Hovering)
         new.Label[2].TextOverride = override
         new.Label[1].TextOverride = override
         new.Label[2]:setText(new.text):setPos(new.pos:copy():add(-10,0)):setEffect("OUTLINE")
         new.Label[1]:setText(">"):setPos(new.pos):setEffect("OUTLINE")
         if new.Hovering then
            new.Label[1]:setGlowColor(0.3,0.3,0.3)
            new.Label[2]:setGlowColor(0.3,0.3,0.3)
         else
            new.Label[1]:setGlowColor(0,0,0)
            new.Label[2]:setGlowColor(0,0,0)
         end
      end
   end,"label")
   new.PRESSED:register(function ()
      if new.page then
         new.PageParent.BookParent:setPage(new.page)
      end
   end,"redirect")
   return new
end

---@param page GNpanel.page
---@return GNpanel.Element.PageButton
function button:setRedirectPage(page)
   self.page = page
   return self
end

---@param text string
---@return GNpanel.Element.PageButton
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

function button:getSize()
   return vectors.vec2(client.getTextWidth(self.text) + 10,10)
end

function button.get_color_overrides(pressed,hovering)
   if pressed then return core.color_overrides.pressed else
      if hovering then return core.color_overrides.hovering
      else return core.color_overrides.none end
   end
end

return button