local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local pagePacker = require("pages.utils.pagePacker")

return function ()
   local page = panels.newPage()
   page:addElement(panels.newElement():setText({
      text = "UTILITIES",
      color = "red"
   }))
   page = pagePacker.makePage(sidebar,"pages.utilities",page)
   page:addElement(sidebar.newReturnButton())
   page:setName("Command Utilities")
   page:setHeaderColor("#b92323")
   return page
end