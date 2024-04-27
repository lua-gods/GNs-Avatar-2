local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")

local page = panels.newPage()
for key, value in pairs(panels) do
   if key ~= "newPage" and key ~= "newDisplay" then
      page:addElement(value():setText(key))   
   end
end
page:addElement(sidebar.newReturnButton())
return page