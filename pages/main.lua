local panel = require("libraries.panelLib.main")
local page = panel.newPage()
local elements = {

panel.newButton():setText('[{"text":"Just GN v3","color":"green"}]'),
panel.newPageButton():setText('{"text":"Emotes","color":"default"}'):setRedirectPage(require("pages.nonHost.emotes")),
panel.newPageButton():setText('{"text":"Clipboard","color":"default"}'):setRedirectPage(require("pages.clipboard"))
}
page:insertElement(elements)
return page