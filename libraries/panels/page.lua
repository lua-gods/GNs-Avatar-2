
local eventLib = require("libraries.eventLib")


---@class panel.page
---@field display panel.display
---@field elements panel.element[]
---@field pressed boolean
---@field mouse_mode boolean
---@field selected_index integer
---@field last_selected panel.element?
---@field selected panel.element?
---@field proxy panel.page?
---@field proxied_from panel.page?
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
   return new
end

---@param p panel.page
function page:setProxyPage(p)
   self.proxy = p
   p.proxied_from = self
   self.pressed = false
   return self
end

---@return panel.page
function page:detatchProxyPage()
   if self.proxy then
      self.proxy.proxied_from = nil
      self.proxy:setSelected(0,false)
      self.proxy = nil
   end
   return self
end


--- Detach last proxy.  
---Returns true if there was a proxy.
---@return boolean
function page:popEndProxy()
   if self.proxy then
      return self.proxy:popEndProxy()
   else
      if self.proxied_from then
         self.proxied_from:detatchProxyPage()
         return true
      else
         return false
      end
   end
end

---finds the end of the proxy
---@return panel.page
function page:getTruePage()
   if self.proxy then
      return self.proxy:getTruePage()
   else
      return self
   end
end

---Sets where to select in the containers. if relative is true, x is added onto the current index.
---@generic self
---@param x integer
---@param relative boolean?
---@return self
function page:setSelected(x, relative)
   if x == 0 and relative == false then
      if self.selected._hover_handler then
         self.selected._hover_handler(false)
      end
      self.selected.HOVER_CHANGED:invoke()

      self.selected = self.elements[1]
      self.selected_index = 1
      return self
   end
   if self.proxy then
      self.proxy:setSelected(x,relative)
      return self
   end
   if #self.elements == 0 then return self end
   self.last_selected = self.selected
   
   local new_pos = math.clamp((relative and self.selected_index or 0) - x, 1, #self.elements)
   if not (self.selected and self.selected._capture_cursor) then -- only move when the cursor is not captured
      self.selected_index = new_pos
      self.selected = self.elements[self.selected_index]
   end
   if self.last_selected ~= self.selected then -- moved
      if self.last_selected then
         if self.last_selected._hover_handler then
            self.last_selected._hover_handler(false)
         end
         self.last_selected.HOVER_CHANGED:invoke()
      end
      
      if self.selected then
         if self.selected._hover_handler then
            self.selected._hover_handler(true)
         end
         self.selected.HOVER_CHANGED:invoke()
      end
   end
   return self
end

---@return panel.page
function page:press()
   if self.proxy then
      self.proxy:press()
      return self
   end
   self.pressed = true
   if self.selected then
      if self.selected._press_handler then
         self.selected._press_handler(true)
      end
      self.selected.PRESS_CHANGED:invoke()
   end
   return self
end

---@return panel.page
function page:release()
   if self.proxy then
      self.proxy:release()
      return self
   end
   self.pressed = false
   if self.selected then
      if self.selected._press_handler then
         self.selected._press_handler(false)
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