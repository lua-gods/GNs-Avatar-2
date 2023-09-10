local panel = require("libraries.panelLib.main")

local page = panel.newPage()
local book = panel.newBook()



events.WORLD_RENDER:register(function ()
   local time = client:getSystemTime() / 100
   book:setPos(math.sin(time/10)*20,math.cos(time/10)*20)
end)

page:insertElement(panel.newToggleButton():setText('{"text":"64 bitches"}'))
page:insertElement(panel.newButton():setText('[{"text":"|","color":"red"},{"text":"[]","color":"default"},{"text":"]","color":"red"},{"text":" Fake Toggle Button","color":"default"}]'))
page:insertElement(panel.newButton():setText('[{"text":"|","color":"red"},{"text":"[]","color":"default"},{"text":"]","color":"red"},{"text":" Extra Fake","color":"default"}]'))

keybinds:newKeybind("any","key.mouse.left"):onPress(function (modifiers, self)
   page:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
end)

book.REBUILD:register(function ()

end)

events.MOUSE_SCROLL:register(function (dir)
   book:setSelected((book.SelectedIndex + dir - 1) % #book.Page.Elements + 1)
end)

local press = keybinds:fromVanilla("figura.config.action_wheel_button")
press.press = function (modifiers, self) book:press(true) return true end
press.release = function (modifiers, self) book:press(false) end

book:setPage(page)