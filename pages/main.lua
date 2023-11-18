local panel = require("libraries.panelLib.main")
local page = panel.newPage()
local elements = {

panel.newButton():setText('[{"text":"Just GN v3","color":"green"}]'),
panel.newPageButton():setText("Emotes"):setRedirectPage(require("pages.nonHost.emotes"))
}
page:insertElement(elements)
return page