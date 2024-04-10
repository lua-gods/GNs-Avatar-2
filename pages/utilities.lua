local sidebar = require("host.sidebar")
local panels = require("libraries.panels")

return function ()
   local page = panels.newPage()

   local pages = {}
   
   local folder_path = "pages.utilities."
   for key, value in pairs(listFiles(folder_path,false)) do
      if value ~= folder_path..".main" then
         local name = value:sub(#folder_path+2,-1):gsub("%u", "_%1"):lower()
         local p = require(value)
         sidebar:newPage(p,name)
         pages[#pages+1] = name
      end
   end
   
   
   local e = {}
   
   for key, value in pairs(pages) do
      local name = value:gsub("_", " ")
      name = name:sub(1,1):upper()..name:sub(2,-1)
      local btn = panels.newButton():setText(name)
      e[#e+1] = btn
      btn.PRESSED:register(function ()
         sidebar:setPage(value)
      end)
   end
   
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   return page
end