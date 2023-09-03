local panel = require("libraries.panelLib.main")

local newPage = panel.newPage()


events.WORLD_RENDER:register(function ()
   local time = client:getSystemTime() / 100
   newPage:setPos(math.sin(time)*10,math.cos(time)*10)
end)

newPage:insertElement(panel.newButton():setText('[{"text":"hello","color":"green"},{"text":"world","color":"yellow"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"I ","color":"dark_purple"},{"text":"am","color":"light_purple"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"GN","color":"green"},{"text":"amimates","color":"dark_green"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"}]'))
newPage:insertElement(panel.newButton():setText('[{"text":"with","color":"red"},{"text":"awesome","color":"gold"},{"text":"awesome","color":"gold"},{"text":"awesome","color":"gold"},{"text":"awesome","color":"gold"}]'))