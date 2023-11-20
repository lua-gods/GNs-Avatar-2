local next_free = 0
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.element
---@field id integer
---@field PageParent GNpanel.page
---@field rebuild function
---@field update function
---@field pos Vector2
---@field down boolean
---@field Hovering boolean
---@field UPDATE AuriaEvent
---@field REBUILD AuriaEvent
---@field PAGE_CHANGED AuriaEvent
---@field BOOK_CHANGED AuriaEvent
---@field STATE_CHANGED AuriaEvent
---@field PRESSED AuriaEvent
---@field RELEASED AuriaEvent
local element = {}
element.__index = function (t,i)
   return element[i]
end
element.__type = "GNpanel.Element"

function element.new(obj)
   ---@type GNpanel.element
   local new = obj or {}
   setmetatable(new,element)
   new.pos = vectors.vec2()
   new.down = false
   new.Hovering = false
   new.UPDATE = core.event.newEvent()
   new.REBUILD = core.event.newEvent()
   new.PAGE_CHANGED = core.event.newEvent()
   new.BOOK_CHANGED = core.event.newEvent()
   new.STATE_CHANGED = core.event.newEvent()
   new.PRESSED = core.event.newEvent()
   new.RELEASED = core.event.newEvent()
   new.STATE_CHANGED:register(function (state)
      if state == "HOVERING" then
         core.uiSound("minecraft:entity.item_frame.rotate_item",0.75,0.5)
      end
      if state == "PRESSED" then
         core.uiSound("minecraft:block.wooden_button.click_on",1,0.5)
      end
      if state == "RELEASED" then
         core.uiSound("minecraft:block.wooden_button.click_off",0.7,0.5)
      end
   end,"sounds")
   new.id = next_free
   next_free = next_free + 1
   return new
end

---@param posx Vector2|number
---@param y number?
function element:setPos(posx,y)
   if type(posx) == "Vector2" then
      self.pos = posx:copy()
   else
      self.pos.x = posx
      self.pos.y = y
   end
   self:update()
end

function element:getSize()
   return vectors.vec2(10,10)
end
function element:update() self.UPDATE:invoke() return self end
function element:rebuild() self.REBUILD:invoke() return self end
function element:delete() return self end
function element:setHovering(is_hovering)
   self.Hovering = is_hovering
   return self
end
function element:shouldRender()
   return self.PageParent and self.PageParent.BookParent
end

return element