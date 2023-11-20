local core = require("libraries.panelLib.panelCore")

---@type table<any,GNpanel.book>
local books = {}
local WINDOW_RESIZED = core.event.newEvent()

local next_free = 0
---@class GNpanel.book
---@field Position Vector2 # tells where the book is at
---@field Origin Vector2 # tells where the placements start
---@field Anchor Vector2 # tells what corner of the screen the origin anchors to
---@field DefaultPlacement fun(x: number,y: number,sx: number,sy: number,i: number): Vector2 # tells how each page is displayed
---@field EscapeOverride function # tells how each page is displayed
---@field Page GNpanel.page
---@field PageHistory table<any,GNpanel.page>
---@field BoundingBox Vector4
---@field Part ModelPart
---@field Active boolean
---@field LockCursor boolean
---@field SelectedIndex integer
---@field Selected GNpanel.element
---@field Visible boolean
---@field REBUILD AuriaEvent #delete all render tasks and make new ones
---@field TRANSFORM AuriaEvent #reposition, translates, rotates or scales
---@field CHILDREN_REPOSITIONED AuriaEvent #triggers when all childrens are repositioned
---@field KEY_PRESSED AuriaEvent #returns a character of the button pressed
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
   new.Anchor = vectors.vec2(-1,-1)
   new.BoundingBox = vectors.vec4(0,0,0,0)
   new.DefaultPlacement = function (x,y,sx,sy)
      return vectors.vec2(x, y - sy)
   end
   new.Part = core.HUD:newPart("panelInstance"..next_free)
   new.PageHistory = {}
   new.Active = false
   new.Visible = true
   new.SelectedIndex = 1
   new.Selected = nil
   new.LockCursor = false
   new.REBUILD = core.event.newEvent()
   new.TRANSFORM = core.event.newEvent()
   new.CHILDREN_REPOSITIONED = core.event.newEvent()
   new.KEY_PRESSED = core.event.newEvent()
   setmetatable(new,Book)
   WINDOW_RESIZED:register(function ()Book._positionUpdate(new)end)
   
   books[next_free] = new
   return new
end

function Book:_positionUpdate()
   if self.Part then
      local sws = client:getScaledWindowSize()
      self.Part:setPos(
         self.Position.x - sws.x * (self.Anchor.x * 0.5 + 0.5),
         self.Position.y - sws.y * (self.Anchor.y * 0.5 + 0.5),0)
   end
end

---@param x Vector2|number
---@param y number
function Book:setPos(x,y)
   if type(x) == "Vector2" then
      self.Position = x:copy()
   else
      self.Position = vectors.vec2(x,y)
   end
   self:_positionUpdate()
end

---@param x Vector2|number
---@param y number
---@return GNpanel.book
function Book:setAnchor(x,y)
   if type(x) == "Vector2" then
      self.Anchor = x:copy()
   else
      self.Anchor = vectors.vec2(x,y)
   end
   self:_positionUpdate()
   return self
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
      self.BoundingBox = vectors.vec4(0,0,0,0)
      for i, child in pairs(self.Page.Elements) do
         local dim = child:getSize()
         cursor = self.Page.Placement and self.Page.Placement(cursor.x,cursor.y,dim.x,dim.y,i) or self.DefaultPlacement(cursor.x,cursor.y,dim.x,dim.y, i)
         child:setPos(cursor)
         self.BoundingBox.x = math.min(cursor.x + dim.x, cursor.x, self.BoundingBox.x)
         self.BoundingBox.y = math.min(cursor.y + dim.y, cursor.y, self.BoundingBox.y)
         self.BoundingBox.z = math.max(cursor.x + dim.x, cursor.x, self.BoundingBox.z)
         self.BoundingBox.w = math.max(cursor.y + dim.y, cursor.y, self.BoundingBox.w)
      end
      self.CHILDREN_REPOSITIONED:invoke(self.BoundingBox)
   end
end

---@return GNpanel.book
function Book:rebuild()
   self.rebuild_queue = true
   self.update_queue = true
   return self
end

function Book:forceRebuild()
   if self.Page then
      self.Page:rebuild()
   end
   self.rebuild_queue = false
end


---@param visible boolean
---@return GNpanel.book
function Book:setVisible(visible)
   self.Visible = visible
   self.Part:setVisible(visible)
   return self
end

---@param active boolean
---@return GNpanel.book
function Book:setActive(active)
   self.Active = active
   return self
end

function Book:setSelected(id)
   if self.Page and not self.LockCursor and self.Active and self.Visible then
      local was_pressed = false
      if self.Selected then
         self.Selected.Hovering = false
         if self.Selected.down then
            was_pressed = true
            self.Selected.down = false
            self.Selected.STATE_CHANGED:invoke("RELEASED")
         end
      end
      self.SelectedIndex = id
      self.Selected = self.Page.Elements[id]
      if self.Selected then
         self.Selected.Hovering = true
         self.Selected.down = was_pressed
         self.Selected.STATE_CHANGED:invoke("HOVERING")
         if was_pressed then
            self.Selected.STATE_CHANGED:invoke("PRESSED")
         end
         
      end
      self:update()
   end
   return id
end

---@param toggle boolean
---@return GNpanel.book
function Book:press(toggle)
   if self.Active and self.Visible then
      if self.Selected then
         self.Selected.down = toggle
         if toggle then
            self.Selected.PRESSED:invoke()
            self.Selected.STATE_CHANGED:invoke("PRESSED")
         else
            self.Selected.RELEASED:invoke()
            self.Selected.STATE_CHANGED:invoke("RELEASED")
         end
         self.Selected:update()
      end
   end
   return self
end

---Inserts the element into the page.  
---* of no index is given, element will be appended at the top
---@param page GNpanel.page
---@param index any
---@return GNpanel.book
function Book:setPage(page,index)
   if not page.BookParent then
      if self.Page then
         local last = page.BookParent
         self.Page.BookParent = nil
         self.Page.BOOK_CHANGED:invoke(last,page.BookParent)
         self.Page:rebuild()
      end
      self:press(false)
      self.Page = page
      local last = page.BookParent
      page.BookParent = self
      page.BOOK_CHANGED:invoke(last,page.BookParent)
      self.PageHistory[#self.PageHistory+1] = page
         
      self:setSelected(1)
      self:rebuild()
   else
      error("Tried to parent an already parented element!",2)
   end
   return self
end

function Book:returnPage()
   if #self.PageHistory > 1 then
      self.PageHistory[#self.PageHistory] = nil
      self:setPage(self.PageHistory[#self.PageHistory])
   end
   return self
end

events.KEY_PRESS:register(function (key,status,modifier)
   if status == 1 or status == 2 then
      local char = core.key2string(key,modifier)
      local cancel = false
      for _, book in pairs(books) do
         if book.Visible and book.Active then
            local returned = book.KEY_PRESSED:invoke(char,key)
            for _, subscribers in pairs(returned) do
               for _, req in pairs(returned) do
                  if req[1] then
                     cancel = true
                  end
               end
            end
         end
      end
      return cancel
   end
end)

local last_window_size = vectors.vec2()

events.WORLD_RENDER:register(function (delta)
   local window_size = client:getWindowSize()
   if last_window_size.x - window_size.x + last_window_size.y - window_size.y ~= 0 then
      WINDOW_RESIZED:invoke(window_size)
   end
   last_window_size = window_size
   for I, page in pairs(books) do
      if page.rebuild_queue then
         page:forceRebuild()
      end
      if page.update_queue then
         page:forceUpdate()
      end
   end
end)

return Book