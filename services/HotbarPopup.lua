local panel = require("libraries.panelLib.main")

local page = panel.newPage()
local book = panel.newBook()



--events.WORLD_RENDER:register(function ()
--   local time = client:getSystemTime() / 100
--   book:setPos(math.sin(time/10)*20,math.cos(time/10)*20)
--end)

for i = 1, 5, 1 do
   page:insertElement(panel.newToggleButton():setText('{"text":"Real Toggle Button '..i..' "}'))
end
page:insertElement(panel.newButton():setText('[{"text":"|","color":"red"},{"text":"[]","color":"default"},{"text":"]","color":"red"},{"text":" Fake Toggle Button","color":"default"}]'))
page:insertElement(panel.newButton():setText('[{"text":"|","color":"red"},{"text":"[]","color":"default"},{"text":"]","color":"red"},{"text":" Extra Fake","color":"default"}]'))
page:insertElement(panel.newReturnButton())

--keybinds:newKeybind("any","key.mouse.left"):onPress(function (modifiers, self)
--   page:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
--end)

book.REBUILD:register(function ()

end)

local scroll = 0
events.MOUSE_SCROLL:register(function (dir)
   scroll = (scroll + dir - 1) % #book.Page.Elements + 1
   book:setSelected(math.floor(scroll))
end)

local press = keybinds:fromVanilla("figura.config.action_wheel_button")
press.press = function (modifiers, self) book:press(true) return true end
press.release = function (modifiers, self) book:press(false) end

book:setPage(page)