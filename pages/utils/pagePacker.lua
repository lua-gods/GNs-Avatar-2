local tool = {}

---@alias panels.icon_type "text"|"emoji"|"item"|"block"
local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")

---Creates a page with buttons based on a given path
---@param path string
---@param ctx_menu contextMenu
---@param page panels.page?
---@return panels.page
tool.makePage = function(ctx_menu,path,page)
   page = page or panels.newPage()
   local pages = {}
   for key, value in pairs(listFiles(path,false)) do
      if value ~= path then
         local name =(" "..value:sub(#path+2,-1):gsub("%u", " %1"):lower()):gsub('%A%a', string.upper):sub(2, -1)
         local p = {
            new = require(value),
            name = name
         }
         if not p.name then
            p:setName(name)
         end
         pages[#pages+1] = p
      end
   end
   
   local e = {}
   for i, p in pairs(pages) do
      local btn = panels.newButton():setText(p.name)
      --if p.icon then
      --   if p.icon_type == "emoji" then
      --      btn:setIconText(p.icon,true)
      --   elseif p.icon_type == "text" then
      --      btn:setIconText(p.icon,false)
      --   elseif p.icon_type == "item" then
      --      btn:setIconItem(p.icon)
      --   elseif p.icon_type == "block" then
      --      btn:setIconBlock(p.icon)
      --   end
      --end
      e[#e+1] = btn
      btn.PRESSED:register(function ()
         local instance = pages.instance or p.new()
         sidebar:setPage(instance)
         instance:setSelected(#instance.elements)
      end)
   end
   
   page:addElement(table.unpack(e))
   return page
end

return tool