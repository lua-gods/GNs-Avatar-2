
local eventLib = require("libraries.eventLib")


local next_free = 0
---@class panels.page
---@field id integer
---@field name string
---@field icon string
---@field icon_type string
---@field display panels.display
---@field elements panels.any
---@field pressed boolean
---@field mouse_mode boolean
---@field selected panels.element?
---@field selected_index integer
---@field last_selected panels.element?
---@field PRESSENCE_CHANGED eventLib
---@field TICK eventLib
---@field FRAME eventLib
---@field proxy panels.page?
---@field proxied_from panels.page?
local page = {}
page.__index = function (t,i)
   return rawget(t,i) or page[i]
end

---@return panels.page
function page.new()
   next_free = next_free + 1
   local new = setmetatable({},page)
   new.elements = {}
   new.id = next_free
   new.mouse_mode = false
   new.pressed = false
   new.selected_index = 0
   new.PRESSENCE_CHANGED = eventLib.new()
   new.TICK = eventLib.new()
   new.FRAME = eventLib.new()
   new.PRESSENCE_CHANGED:register(function (opened)
      if opened then
         events.WORLD_TICK:register(function ()
            new.TICK:invoke()
         end,"gnui.panels.page." .. new.id)
         events.WORLD_RENDER:register(function ()
            new.FRAME:invoke()
         end,"gnui.panels.page." .. new.id)
      else
         events.WORLD_TICK:remove("gnui.panels.page." .. new.id)
         events.WORLD_RENDER:remove("gnui.panels.page." .. new.id)
      end
   end,"_internal")
   return new
end

---@param p panels.page
function page:setProxyPage(p)
   self.proxy = p
   p.proxied_from = self
   self.pressed = false
   return self
end

---@return panels.page
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
---@return panels.page
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
   if self.proxy then -- process proxy instead of default if one exists
      self.proxy:setSelected(x,relative)
      return self
   end

   if #self.elements == 0 then return self end -- no elements
   
   self.last_selected = self.selected
   local new_pos
   if relative then new_pos = self.selected_index - x
   else new_pos = x end
   new_pos = math.clamp(new_pos, 1, #self.elements) -- clamp
   
   if not (self.selected and self.selected._capture_cursor) then -- only move when the cursor is not captured
      self.selected_index = new_pos
      self.selected = self.elements[self.selected_index]
   end
   if self.last_selected ~= self.selected then -- moved
      if self.last_selected then
         self.last_selected:unhover()
         self.last_selected.HOVER_CHANGED:invoke(false)
      end
      
      if self.selected then
         self.selected:hover()
         self.selected.HOVER_CHANGED:invoke(true)
      end
   end
   return self
end

---@return panels.page
function page:press()
   if self.proxy then
      self.proxy:press()
      return self
   end
   self.pressed = true
   if self.selected then
      self.selected:press()
   end
   return self
end

---@return panels.page
function page:release()
   if self.proxy then
      self.proxy:release()
      return self
   end
   self.pressed = false
   if self.selected then
      self.selected:release()
   end
   return self
end

---@param ... panels.any
---@return panels.page
function page:addElement(...)
   for _,e in pairs({...}) do
      if not (type(e)):find("panels.") then
         error("bad argument #1 to 'addElement' (panels.any expected, got "..type(e)..")",2)
      end
      local nf = #self.elements + 1
      e.parent = self
      e.index = nf
      self.elements[nf] = e
   end
   if self.display and self.display.container.Visible then
      self.display:updateDisplays()
   end
   return self
end

---@param i integer
---@param e panels.element
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

function page:setName(name)
   self.name = name
   return self
end

---@param icon string
---@param type panels.icon_type
---@return panels.page
function page:setIcon(icon,type)
   self.icon = icon
   self.icon_type = type
   return self
end

function page:recalculateChildrenIndexes()
   for i, e in pairs(self.elements) do
      e.index = i
   end
   return self
end

return page