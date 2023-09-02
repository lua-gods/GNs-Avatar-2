local core = require("libraries.panelLib.panelCore")
local pages = {}

local next_free = 0
---@class GNpanel.page
---@field Placement function # tells how each page is displayed
---@field id integer # tells how each page is displayed
---@field Origin Vector2 # tells where the placements start
---@field Anchor Vector2 # tells what corner of the screen the origin anchors to
---@field Elements table<any,GNpanel.Element>
---@field Active boolean
---@field Visible boolean
---@field REBUILD KattEvent #delete all render tasks and make new ones
---@field TRANSFORM KattEvent #reposition, translates, rotates or scales
local Page = {}
Page.__index = Page

---Creates a new empty Page
---@param obj table?
---@return GNpanel.page
function Page.new(obj)
   local new = obj or {}
   new.id = next_free
   new.Origin = vectors.vec2(0,0)
   new.Anchor = vectors.vec2()
   new.Placement = function (x,y,sx,sy) return vectors.vec2(x,y + sy) end
   new.Elements = {}
   new.Active = false
   new.Visible = true
   new.REBUILD = core.event.newEvent()
   new.TRANSFORM = core.event.newEvent()
   setmetatable(new,Page)
   next_free = next_free + 1
   pages[next_free] = new
   return new
end

---@return GNpanel.page
function Page:update()
   self.update_queue = true
   return self
end

---@return GNpanel.page
function Page:rebuild()
   self.rebuild_queue = true
   return self
end

---@param visible boolean
---@return GNpanel.page
function Page:setVisible(visible)
   self.Visible = visible
   return self
end

---Inserts the element into the page.  
---* of no index is given, element will be appended at the top
---@param element GNpanel.Element
---@param index any
---@return GNpanel.page
function Page:insertElement(element,index)
   if not element.Parent then
      if not index then
         index = #self.Elements+1
      end
      table.insert(self.Elements,index,element)
      element:rebuild()
      self:update()
      self:repositionChildren()
   else
      error("Tried to parent an already parented element!",2)
   end
   return self
end

function Page:repositionChildren()
   local cursor = self.Origin:copy()
   for key, child in pairs(self.Elements) do
      local dim = child:getSize()
      cursor = self.Placement(cursor.x,cursor.y,dim.x,dim.y)
      child:setPos(cursor)
   end
end

return Page