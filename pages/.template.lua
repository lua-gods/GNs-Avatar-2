local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local page = panels.newPage()

return function ()
   local e = {
      panels.newButton()
   }
   
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   return page
end