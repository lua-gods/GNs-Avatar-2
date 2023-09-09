local core = require("libraries.panelLib.panelCore")

---@type table<any,GNpanel.book>
local pages = {}

local next_free = 0
---@class GNpanel.book
---@field Position Vector2 # tells where the book is at
---@field Origin Vector2 # tells where the placements start
---@field Anchor Vector2 # tells what corner of the screen the origin anchors to
---@field DefaultPlacement function # tells how each page is displayed
---@field Page GNpanel.page
---@field Part ModelPart
---@field Active boolean
---@field SelectedIndex integer
---@field Selected GNpanel.Element
---@field Visible boolean
---@field REBUILD KattEvent #delete all render tasks and make new ones
---@field TRANSFORM KattEvent #reposition, translates, rotates or scales
local Book = {}
Book.__index = Book

---Creates a new empty Page
---@param obj table?
---@return GNpanel.book
function Book.new(obj)
   next_free = next_free + 1
   local new = obj or {}
   new.Position = vectors.vec2(0,0)
   new.Origin = vectors.vec2(0,0)
   new.Anchor = vectors.vec2()
   new.DefaultPlacement = function (x,y,sx,sy) return vectors.vec2(x,y + sy) end
   new.CurrentPage = 1
   new.Part = core.HUD:newPart("panelInstance"..next_free)
   new.Active = false
   new.Visible = true
   new.SelectedIndex = 1
   new.Selected = nil
   new.REBUILD = core.event.newEvent()
   new.TRANSFORM = core.event.newEvent()
   setmetatable(new,Book)
   
   pages[next_free] = new
   return new
end

---@param posx Vector2|number
---@param y number
function Book:setPos(posx,y)
   if type(posx) == "Vector2" then
      self.Position = posx:copy()
   else
      self.Position = vectors.vec2(posx,y)
   end
   self.Part:setPos(self.Position.x,self.Position.y,0)
end

---@return GNpanel.book
function Book:update()
   self.update_queue = true
   return self
end

function Book:forceUpdate()
   self:updatePlacement()
   for key, value in pairs(self.Page.Elements) do
      value:update()
   end
   self.update_queue = false
end

function Book:updatePlacement()
   local cursor = self.Origin:copy()
   if self.Page then
      for key, child in pairs(self.Page.Elements) do
         local dim = child:getSize()
         cursor = self.DefaultPlacement(cursor.x,cursor.y,dim.x,dim.y)
         child:setPos(cursor)
      end
   end
end

---@return GNpanel.book
function Book:rebuild()
   self.rebuild_queue = true
   self.update_queue = true
   return self
end

function Book:forceRebuild()
   for key, value in pairs(self.Page.Elements) do
      value:rebuild()
   end
   self.rebuild_queue = false
end


---@param visible boolean
---@return GNpanel.book
function Book:setVisible(visible)
   self.Visible = visible
   return self
end

function Book:setSelected(id)
   if self.Page then
      if self.Selected then
         self.Selected.Hovering = false
      end
      self.SelectedIndex = id
      self.Selected = self.Page.Elements[id]
      if self.Selected then
         self.Selected.Hovering = true
      end
      self:update()
   end
   return id
end

---Inserts the element into the page.  
---* of no index is given, element will be appended at the top
---@param page GNpanel.page
---@param index any
---@return GNpanel.book
function Book:setPage(page,index)
   if not page.Parent then
      self.Page = page
      page.Parent = self
      self:setSelected(1)
      self:rebuild()
   else
      error("Tried to parent an already parented element!",2)
   end
   return self
end

events.WORLD_RENDER:register(function (delta)
   for I, page in pairs(pages) do
      if page.rebuild_queue then
         page:forceRebuild()
      end
      if page.update_queue then
         page:forceUpdate()
      end
   end
end)

return Book