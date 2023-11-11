if not host:isHost() then return end

local input = {
   primary = keybinds:fromVanilla("figura.config.action_wheel_button"),
   close = keybinds:newKeybind("exit","key.keyboard.escape")
}
local panel = require("libraries.panelLib.main")

local page = panel.newPage()
local book = panel.newBook()
local core = require("libraries.panelLib.panelCore")

for i = 1, 5, 1 do
   page:insertElement(panel.newToggleButton():setText('{"text":"Real Toggle Button '..i..' ","color":"default"}'))
end

book:setAnchor(0,1)

local function repositionBook(offset)
   book:setPos(-95,-book.BoundingBox.y+10 + offset)
end

book.CHILDREN_REPOSITIONED:register(function ()
   repositionBook(0)
end)

page:insertElement(panel.newPageButton())
page:insertElement(panel.newButton():setText('[{"text":"Example Button","color":"default"}]'))
page:insertElement(panel.newButton():setText('[{"text":"Another Button","color":"default"}]'))
page:insertElement(panel.newTextInputButton())
page:insertElement(panel.newReturnButton())

local scroll = 0
events.MOUSE_SCROLL:register(function (dir)
   if book.Visible then
      scroll = (scroll - dir - 1) % #book.Page.Elements + 1
      book:setSelected(math.floor(scroll))
      return true
   end
end)
local pressing = false
book:setVisible(false)
input.primary.press = function (modifiers, self)
   if book.Visible then
      book:press(true)
      pressing = true
   else
      book:setVisible(true)
      core.tween.tweenFunction(-200,0,0.1,"outQuad",function (x)
         repositionBook(x)
      end,nil,"hotbar_popup_transition")
      core.uiSound("minecraft:block.lever.click",2,1)
   end
   
   return true
end
input.primary.release = function (modifiers, self)  if book.Visible and pressing then book:press(false) pressing = false end end

input.close.press = function ()
   if book.Visible then
      core.tween.tweenFunction(0,-200,0.2,"inQuad",function (x)
         repositionBook(x)
      end,function ()
         book:setVisible(false)
      end,"hotbar_popup_transition")
      core.uiSound("minecraft:block.lever.click",1.5,1)
      return true
   end
end

book:setPage(page)