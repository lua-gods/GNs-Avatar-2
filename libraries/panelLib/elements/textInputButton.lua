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
      new.Label[4]:setText("|"):setEffect("OUTLINE").TextOverride = o
      new.Label[1]:setPos(new.pos:copy():add(-1,0,0)):setEffect("OUTLINE")
      if #new.Input == 0 then
         new.Label[1]:setText(new.text).TextOverride = {default = "dark_gray"}
         new.Label[4]:setPos(new.pos:copy():add(math.huge,0,0))
      else
         if new.PageParent and new.PageParent.BookParent and new.PageParent.BookParent.LockCursor then
            new.Label[4]:setPos(new.pos:copy():add(-1 - client.getTextWidth(new.Input),0,0))
         else
            new.Label[4]:setPos(new.pos:copy():add(math.huge,0,0))
         end
         new.Label[1]:setText('{"text":"'..new.Input..'"}').TextOverride = o
      end
      new.Label[2]:setText("___________________"):setPos(new.pos:copy():add(0,-1,0)):setEffect("OUTLINE").TextOverride = o
      new.Label[3]:setText("___________________"):setPos(new.pos:copy():add(-1,-1,0)):setEffect("OUTLINE").TextOverride = o
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
   new.PRESSED:register(function ()
      local book = new.PageParent.BookParent
      new.PageParent.BookParent.LockCursor = not book.LockCursor
      if book then
         book.EscapeOverride = function ()
            new.PageParent.BookParent.LockCursor = false
            book.EscapeOverride = nil
            core.uiSound("minecraft:block.wooden_button.click_off",0.6,1)
            return true
         end
      end
   end)
   new.ENTERED_BOOK:register(function (book)
      if old then
         old.KEY_PRESS:remove(new.id)
      end
      book.KEY_PRESSED:register(function (key,id)
         if book.LockCursor and new.PageParent.Elements[book.SelectedIndex] == new then
            if id == 256 then

            elseif id == 257 then
               book.LockCursor = false
            elseif id == 259 then
               new.Input = new.Input:sub(1,-2)
            else
               if key then
                  new.Input = new.Input .. key
                  new:update()
                  return true
               end
            end
            new:update()
         end
      end,new.id)
   end,"book_wait")
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