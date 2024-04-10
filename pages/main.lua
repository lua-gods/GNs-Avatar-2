local sidebar = require("host.sidebar")
local elements = require("libraries.panels")
local page = elements.newPage()

local pages = {

   {
      page = require("pages.utilities"),
      name = "Utilities"
   },
   {
      page = require("pages.showAllElements"),
      name = "Show All Elements"
   },
   {
      page = require("pages.commandUtilities"),
      name = "Command Utilities"
   },
   --{
   --   page = require("programs.testbed.quaternionTest"),
   --   name = "Quaternion"
   --},
   {
      page = require("pages.settings"),
      name = "Settings",
      icon = {
         value = ":tool:",
         type = "emoji"
      }
   }
}

--local folder_path = "pages"
--for key, value in pairs(listFiles(folder_path,false)) do
--   if value ~= folder_path..".main" then
--      local name = value:sub(#folder_path+2,-1):gsub("%u", "_%1"):lower()
--      local p,icon = require(value)
--      sidebar:newPage(p,name)
--      pages[#pages+1] = name
--   end
--end

local e = {}

for _, p in pairs(pages) do
   --local name = value:gsub("_", " ")
   --name = name:sub(1,1):upper()..name:sub(2,-1)
   local btn = elements.newButton():setText(p.name)
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
         new = p.instance
         print("new")
      else
         new = p.page()
      end
      sidebar:setPage(new)
   end)
end

page:addElement(elements.newElement():setText({text="Just GN v5",color = "#4dd966"}):setIconText(":@gn:",true))
page:addElement(elements.newElement():forceHeight(8))
page:addElement(table.unpack(e))

sidebar:newPage(page,"main")