local base = require("libraries.panelLib.elements.textButton")
local core = require("libraries.panelLib.panelCore")


---@class GNpanel.Element.TextInput : GNpanel.Element.TextButton
---@field Input string
---@field Placeholder string
---@field History table
local text = {}
text.__index = function (t,i)
   return text[i] or base.__index(t,i)
end

function text.new(obj)
   local new = obj or base.new()
   new.Input = ""
   new.text = '{"text":"Empty Text Input","color":"default"}'
   new.History = {}

   new.REBUILD:register(function ()
      new.Label = {
         core.labelLib.new(new.PageParent.BookParent.Part),
         core.labelLib.new(new.PageParent.BookParent.Part),
         core.labelLib.new(new.PageParent.BookParent.Part),
         core.labelLib.new(new.PageParent.BookParent.Part),
      }
   end,"label")
   new.UPDATE:register(function ()
      local o = base.get_color_overrides(new.Pressed,new.Hovering)
      new.Label[1]:setText(new.text):setPos(new.pos:copy():add(-1,0,0)):setEffect("OUTLINE").TextOverride = o
      new.Label[2]:setText("___________________"):setPos(new.pos:copy():add(0,-1,0)):setEffect("OUTLINE").TextOverride = o
      new.Label[3]:setText("___________________"):setPos(new.pos:copy():add(-1,-1,0)):setEffect("OUTLINE").TextOverride = o
      new.Label[4]:setText("|"):setPos(new.pos:copy():add(-1,0,0)):setEffect("OUTLINE").TextOverride = o
      if new.Hovering then
         for key, value in pairs(new.Label) do
            value:setGlowColor(0.3,0.3,0.3)
         end
      else
         for key, value in pairs(new.Label) do
            value:setGlowColor(0,0,0)
         end
      end
   end,"label")
   setmetatable(new,text)
   return new
end

---@param text string
---@return GNpanel.Element.TextInput
function text:setPlaceholder(text)
   self.text = text
   return self
end

function text:getSize()
   return vectors.vec2(math.max(client.getTextWidth(self.Input),client.getTextWidth("___________________"),client.getTextWidth(self.text)),10)
end

return text