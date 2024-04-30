local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")

return function ()
   local page = panels.newPage()
   for key, value in pairs(panels) do
      if key ~= "newPage" and key ~= "newDisplay" then
         page:addElement(value():setText(key))   
      end
   end
   page:addElement(sidebar.newReturnButton())
   page:setName("Show All Elements")
   page:setHeaderColor("#1e6ca0")
   return page
end