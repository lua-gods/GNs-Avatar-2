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
         local p = require(value)
         if not p.name then
            p:setName(name)
         end
         pages[#pages+1] = p
      end
   end
   
   local e = {}
   for i, p in pairs(pages) do
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
         sidebar:setPage(p)
         p:setSelected(#p.elements)
      end)
   end
   
   page:addElement(table.unpack(e))
   return page
end

return tool