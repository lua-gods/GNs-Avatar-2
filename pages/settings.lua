local sidebar = require("host.sidebar")
local panels = require("libraries.panels")

return function ()
   local page = panels.newPage()
   local e = {
      panels.newButton():setText("button")
   }
   
   e[1].PRESSED:register(function () print("ligma") end)
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   return page
end