local sidebar = require("host.sidebar")
local panels = require("libraries.panels")
local page = panels.newPage()

local e = {
   panels.newButton(),
   panels.newButton(),
   panels.newButton(),
   panels.newButton()
}

e[1].PRESSED:register(function () print("ligma") end)
page:addElement(table.unpack(e))
sidebar:newPage(page,"clone_command_helper")