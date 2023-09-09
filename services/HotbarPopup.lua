local panel = require("libraries.panelLib.main")

local page = panel.newPage()
local book = panel.newBook()



events.WORLD_RENDER:register(function ()
   local time = client:getSystemTime() / 100
   book:setPos(math.sin(time/10)*20,math.cos(time/10)*20)
end)

page:insertElement(panel.newButton():setText('[{"text":"hello","color":"green"},{"text":"world","color":"yellow"}]'))
page:insertElement(panel.newButton():setText('[{"text":"I ","color":"dark_purple"},{"text":"am","color":"light_purple"}]'))
page:insertElement(panel.newButton():setText('[{"text":"GN","color":"green"},{"text":"amimates","color":"dark_green"}]'))
page:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
page:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"},{"text":"awesome","color":"gold"},{"text":"awesome","color":"gold"},{"text":"awesome","color":"gold"}]'))

keybinds:newKeybind("any","key.mouse.left"):onPress(function (modifiers, self)
   page:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
end)

book.REBUILD:register(function ()
   print("UPDATE")
end)

events.MOUSE_SCROLL:register(function (dir)
   book:setSelected((book.SelectedIndex + dir - 1) % #book.Page.Elements + 1)
end)

book:setPage(page)