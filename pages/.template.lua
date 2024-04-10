local sidebar = require("host.sidebar")
local panels = require("libraries.panels")
local page = panels.newPage()

local e = {
   panels.newButton()
}

page:addElement(table.unpack(e))
page:addElement(sidebar.newReturnButton())
return page