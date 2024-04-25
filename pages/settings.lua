local sidebar = require("host.sidebar")
local panels = require("libraries.panels")

return function ()
   local page = panels.newPage()
   local e = {}
   
   for i = 1, 50, 1 do
      e[#e+1] = panels.newButton():setText("button")
   end
   e[1].PRESSED:register(function () print("ligma") end)
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   return page
end