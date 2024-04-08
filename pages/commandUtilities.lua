local sidebar = require("host.sidebar")
local panels = require("libraries.panels")
local page = panels.newPage()

local e = {
   panels.newButton():setText("balls"),
   sidebar.newReturnButton()
}

page:addElement(table.unpack(e))
sidebar:newPage(page,"command_utilities")