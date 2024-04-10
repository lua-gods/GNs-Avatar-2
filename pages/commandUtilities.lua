local sidebar = require("host.sidebar")
local panels = require("libraries.panels")
local page = panels.newPage()

return function ()
   local pages = {}

   local folder_path = "pages.commands"
   for key, value in pairs(listFiles(folder_path,false)) do
      if value ~= folder_path..".main" then
         local name = value:sub(#folder_path+2,-1):gsub("%u", " %1"):lower()
         local p = require(value)
         pages[#pages+1] = {
            name = name,
            page = p,
         }
      end
   end
   
   
   local e = {}
   
   for _, p in pairs(pages) do
      --local name = value:gsub("_", " ")
      --name = name:sub(1,1):upper()..name:sub(2,-1)
      local btn = panels.newButton():setText(p.name)
      if p.icon then
         if p.icon.type == "emoji" then
            btn:setIconText(p.icon.value,true)
         elseif p.icon.type == "text" then
            btn:setIconText(p.icon.value,false)
         elseif p.icon.type == "item" then
            btn:setIconItem(p.icon.value)
         elseif p.icon.type == "block" then
            btn:setIconBlock(p.icon.value)
         end
      end
      e[#e+1] = btn
      btn.PRESSED:register(function ()
         local new
         if not p.instance then
            p.instance = p.page()
            new = p.instance
         else
            new = p.page()
         end
         sidebar:setPage(new)
      end)
   end
   
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   
   return page
end