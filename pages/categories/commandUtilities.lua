local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local pagePacker = require("pages.utils.pagePacker")

return function ()
   local page = panels.newPage()
   pagePacker.makePage(sidebar,"pages.commands",page)
   page:addElement(sidebar.newReturnButton())

   page:setName("Command Utilities")
   page:setHeaderColor("#a01e1e")
   return page
end