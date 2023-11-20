local core = require("libraries.panelLib.panelCore")

---@type table<any,GNpanel.page>
local pages = {}

local next_free = 0
---@class GNpanel.page
---@field Placement fun(x: number,y: number,sx: number,sy: number,i: number): Vector2 # tells how each page is displayed
---@field CursorPlacement function # tells how each page is displayed
---@field id integer # tells how each page is displayed
---@field BookParent GNpanel.book?
---@field Elements table<any,GNpanel.element>
---@field BOOK_CHANGED AuriaEvent
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
   new.BOOK_CHANGED = core.event.new()
   new.BOOK_CHANGED:register(function (_,current)
      for _, element in pairs(new.Elements) do
         element.BOOK_CHANGED:invoke(current)
      end
   end)
   setmetatable(new,Page)
   
   pages[next_free] = new
   return new
end

---Inserts the element into the page.  
---* of no index is given, element will be appended at the top
---@param element GNpanel.element|table<any,GNpanel.element>
---@param index integer?
---@return GNpanel.page
function Page:insertElement(element,index)
   if type(element) == "table" then
      for i = #element, 1, -1 do
         local elem = element[i]
         if not elem.PageParent then
            if not index then
               index = #self.Elements+1
            end
            elem.PageParent = self
            table.insert(self.Elements,index,elem)
            elem.PAGE_CHANGED:invoke(self)
            if self.BookParent then
               elem.BOOK_CHANGED:invoke(self.BookParent)
               self.BookParent:update()
            end
         end
      end
   else
      if not element.PageParent then
         if not index then
            index = #self.Elements+1
         end
         element.PageParent = self
         table.insert(self.Elements,index,element)
         element.PAGE_CHANGED:invoke(self)
         if self.BookParent then
            element.BOOK_CHANGED:invoke(self.BookParent)
            self.BookParent:update()
         end
      else
         error("Tried to parent an already parented element!",2)
      end
   end
   return self
end

function Page:rebuild()
   for key, value in pairs(self.Elements) do
      value:rebuild()
   end
   return self
end

return Page