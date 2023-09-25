local core = require("libraries.panelLib.panelCore")

---@type table<any,GNpanel.page>
local pages = {}

local next_free = 0
---@class GNpanel.page
---@field Placement function # tells how each page is displayed
---@field id integer # tells how each page is displayed
---@field BookParent GNpanel.book
---@field Elements table<any,GNpanel.Element>
local Page = {}
Page.__index = Page

---Creates a new empty Page
---@param obj table?
---@return GNpanel.page
function Page.new(obj)
   next_free = next_free + 1
   local new = obj or {}
   new.id = next_free
   new.Elements = {}
   setmetatable(new,Page)
   
   pages[next_free] = new
   return new
end

---Inserts the element into the page.  
---* of no index is given, element will be appended at the top
---@param element GNpanel.Element
---@param index any
---@return GNpanel.page
function Page:insertElement(element,index)
   if not element.PageParent then
      if not index then
         index = #self.Elements+1
      end
      table.insert(self.Elements,index,element)
      element.PageParent = self
      if self.BookParent then
         element:rebuild()
         self.BookParent:update()
      end
   else
      error("Tried to parent an already parented element!",2)
   end
   return self
end

return Page