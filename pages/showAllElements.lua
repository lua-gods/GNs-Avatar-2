local sidebar = require("host.sidebar")
local panels = require("libraries.panels")

return function ()
   local page = panels.newPage()
   for key, value in pairs(panels) do
      if key ~= "newPage" and key ~= "newDisplay" then
         page:addElement(value():setText(key))   
      end
   end
   page:addElement(sidebar.newReturnButton())
   return page
end