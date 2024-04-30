local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local pagePacker = require("pages.utils.pagePacker")

return function ()
   local page = panels.newPage()
   page:addElement(panels.newElement():setText({
      text = "COMMAND UTILITIES",
      color = "red"
   }))
   pagePacker.makePage(sidebar,"pages.commands",page)
   page:addElement(sidebar.newReturnButton())

   page:setName("Command Utilities")
   page:setHeaderColor("#a01e1e")
   return page
end