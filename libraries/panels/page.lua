

---@class panel.page
---@field display panel.display
---@field elements panel.element[]
---@field pressed boolean
---@field mouse_mode boolean
---@field selected_index integer
---@field last_selected panel.element?
---@field selected panel.element?
---@field focused boolean
local page = {}
page.__index = function (t,i)
   return rawget(t,i) or page[i]
end

---@return panel.page
function page.new()
   local new = setmetatable({},page)
   new.elements = {}
   new.mouse_mode = false
   new.pressed = false
   new.selected_index = 0
   new.focused = false
   return new
end

---Sets where to select in the containers. if relative is true, x is added onto the current index.
---@generic self
---@param x integer
---@param relative boolean?
---@return self
function page:setSelected(x, relative)
   if #self.elements == 0 then return self end
   self.last_selected = self.selected

   if not (self.selected and self.selected._capture_cursor) then -- only move when the cursor is not captured
      self.selected_index = math.clamp((relative and self.selected_index or 0) - x, 1, #self.elements)
      self.selected = self.elements[self.selected_index]
   end
   if self.last_selected ~= self.selected then -- moved
      if self.last_selected then
         if self.last_selected._press_handler then
            self.last_selected:_press_handler(self.pressed,false)
         end
         self.last_selected.HOVER_CHANGED:invoke()
      end
      
      if self.selected then
         if self.selected._press_handler then
            self.selected:_press_handler(self.pressed,true)
         end
         self.selected.HOVER_CHANGED:invoke()
      end
   end
   return self
end

---@return panel.page
function page:press()
   self.pressed = true
   if self.selected then
      if self.selected._press_handler then
         self.selected:_press_handler(self.pressed,true)
      end
      self.selected.PRESS_CHANGED:invoke()
   end
   return self
end

---@return panel.page
function page:release()
   self.pressed = false
   if self.selected then
      if self.selected._press_handler then
         self.selected:_press_handler(self.pressed,true)
      end
      self.selected.PRESS_CHANGED:invoke()
   end
   return self
end

---@param ... panel.any
---@return panel.page
function page:addElement(...)
   for _,e in pairs({...}) do
      local next_free = #self.elements + 1
      e.parent = self
      e.index = next_free
      self.elements[next_free] = e
   end
   if self.display then
      self.display:updateDisplays()
   end
   return self
end

---@param i integer
---@param e panel.element
function page:insertElement(i,e)
   e.parent = self
   e.index = i
   table.insert(self.elements,i,e)
   self:recalculateChildrenIndexes()
   return self
end

---@param i integer
function page:removeElement(i)
   table.remove(self.elements,i)
   self:recalculateChildrenIndexes()
   return self
end

function page:recalculateChildrenIndexes()
   for i, e in pairs(self.elements) do
      e.index = i
   end
   return self
end

return page