local sidebar = require("host.contextMenu")
local elements = require("libraries.panels")
local pagePacker = require("pages.utils.pagePacker")

local page = elements.newPage()
local title = elements.newElement():setText({{text="GN's Avatar",color = "#4dd966"},{text=" v5",color = "gray"}}):setIconText(":@gn:",true)
page:addElement(title)
page:addElement(elements.newElement():forceHeight(8))

pagePacker.makePage(sidebar,"pages.categories",page)
page:setSelected(#page.elements)

sidebar:newPage(page,"main")
