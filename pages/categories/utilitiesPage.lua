local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local pagePacker = require("pages.utils.pagePacker")

local page = panels.newPage()
page:addElement(panels.newElement():setText({
   text = "UTILITIES",
   color = "red"
}))
page = pagePacker.makePage(sidebar,"pages.utilities",page)
page:addElement(sidebar.newReturnButton())
return page