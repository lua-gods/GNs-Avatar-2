local next_free = 0
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element
---@field id integer
---@field PageParent GNpanel.page
---@field rebuild function
---@field update function
---@field pos Vector2
---@field Pressed boolean
---@field Hovering boolean
---@field UPDATE AuriaEvent
---@field REBUILD AuriaEvent
---@field STATE_CHANGED AuriaEvent
local element = {}
element.__index = element

function element.new(obj)
   ---@type GNpanel.Element.TextButton
   local new = obj or {}
   new.pos = vectors.vec2()
   new.Pressed = false
   new.Hovering = false
   new.UPDATE = core.event.newEvent()
   new.REBUILD = core.event.newEvent()
   new.STATE_CHANGED = core.event.newEvent()
   new.STATE_CHANGED:register(function (state)
      if state == "HOVERING" then
         core.uiSound("minecraft:entity.item_frame.rotate_item",new.id / #new.PageParent.Elements + 0.75,0.5)
      end
      if state == "PRESSED" then
         core.uiSound("minecraft:block.wooden_button.click_on",1,0.5)
      end
      if state == "RELEASED" then
         core.uiSound("minecraft:block.wooden_button.click_off",0.7,0.5)
      end
   end)
   new.id = next_free
   setmetatable(new,element)

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

return element