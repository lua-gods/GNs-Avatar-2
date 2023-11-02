if not host:isHost() or true then return end

local panel = require("libraries.panelLib.main")

local page = panel.newPage()
local book = panel.newBook()



--events.WORLD_RENDER:register(function ()
--   local time = client:getSystemTime() / 100
--   book:setPos(math.sin(time/10)*20,math.cos(time/10)*20)
--end)

for i = 1, 5, 1 do
   page:insertElement(panel.newToggleButton():setText('{"text":"Real Toggle Button '..i..' ","color":"default"}'))
end

book:setAnchor(0,0)

page:insertElement(panel.newButton():setText('[{"text":"Example Button","color":"default"}]'))
page:insertElement(panel.newButton():setText('[{"text":"Another Button","color":"default"}]'))
page:insertElement(panel.newTextInputButton())
page:insertElement(panel.newReturnButton())

--keybinds:newKeybind("any","key.mouse.left"):onPress(function (modifiers, self)
--   page:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
--end)

book.REBUILD:register(function ()

end)

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
local press = keybinds:fromVanilla("figura.config.action_wheel_button")
press.press = function (modifiers, self)
   if book.Visible then
      book:press(true)
      pressing = true
   else
      book:setVisible(true)
   end
   return true
end
press.release = function (modifiers, self)  if book.Visible and pressing then book:press(false) pressing = false end end

book:setPage(page)