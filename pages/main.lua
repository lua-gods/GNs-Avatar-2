local sidebar = require("host.contextMenu")
local elements = require("libraries.panels")
local pagePacker = require("pages.utils.pagePacker")

local fileDialouge = require("pages.especial.fileDialouge")

local page = elements.newPage()

pagePacker.makePage(sidebar,"pages.categories",page)
page:setSelected(#page.elements)

local openFileButton = elements:newButton():setText("Open File")
page:addElement(openFileButton)
openFileButton.PRESSED:register(function ()
   fileDialouge.openFileDialouge()
end)

page:setName("Just GN v5")
page:setIcon(":@gn:","emoji")
page:setHeaderColor("#388538")

sidebar:newPage(page,"main")
