local gn = {}
local eventsLib = require("libraries.KattEventsAPI")
local hud = models:newPart("UI"):setParentType("HUD")
local defaultTexture = textures:newTexture("GNUI.SpriteTask.default", 16, 16):fill(0, 0, 16, 16,
                                                                                   vectors.vec3(1,
                                                                                                1, 1))

local i = 0
---@class GNUI.SpriteTask
---@field Pos Vector2
---@field Size Vector2
---@field Tint Vector3
---@field Visible boolean
---@field TopLeft Vector2
---@field BottomRight Vector2
---@field Texture {source:Texture,dimensions:Vector2}
---@field Sprite any
---@field TEXTURE_CHANGED KattEvent
---@field TINT_CHANGED KattEvent
---@field TRANSFORMED KattEvent
---@field VISIBILITY_CHANGED KattEvent
local GNST = {}
GNST.__index = GNST

---@return GNUI.SpriteTask
function gn:newSprite()
   ---@type GNUI.SpriteTask
   local compose = {
      Pos = vectors.vec2(0, 0),
      Size = vectors.vec2(0, 0),
      TopLeft = vectors.vec2(0, 0),
      BottomRight = vectors.vec2(0, 0),
      Tint = vectors.vec3(1, 1, 1),
      Visible = true,
      Depth = 0,
      TRANSFORMED = eventsLib.newEvent(),
      TEXTURE_CHANGED = eventsLib.newEvent(),
      TINT_CHANGED = eventsLib.newEvent(),
      VISIBILITY_CHANGED = eventsLib.newEvent(),
      Texture = {source = defaultTexture, dimensions = defaultTexture:getDimensions()},
      Sprite = hud:newSprite(i):setTexture(defaultTexture),
      Parent = hud
   }
   setmetatable(compose, GNST)
   i = i + 1
   compose:update()
   return compose
end

---@param texture Texture
function GNST:setTexture(texture)
   if type(texture) ~= "Texture" then
      error("Given texture is invalid, type is " .. type(texture), 2)
   end
   self.Texture.source = texture
   self.Texture.dimensions = texture:getDimensions()
   self.Sprite:setTexture(texture)
   self.TEXTURE_CHANGED:invoke(texture)
   return self
end

---@param r number|Vector3
---@param g number?
---@param b number?
function GNST:setTint(r, g, b)
   local vec
   if type(r) == "Vector3" then
      vec = r:copy()
   else
      vec = vectors.vec3(r, g, b)
   end
   self.Sprite:setColor(r, g, b)
   self.TINT_CHANGED:invoke(vec)
   return self
end

---@param depth number
---@return GNUI.SpriteTask
function GNST:depth(depth)
   self.Depth = -depth
   return self
end

---@param visible boolean
function GNST:setVisible(visible)
   self.Sprite:setVisible(visible)
   self.Visible = visible
   self.VISIBILITY_CHANGED:invoke(visible)
   return self
end

---@param x number|Vector2
---@param y number?
function GNST:pos(x, y)
   if type(x) == "Vector2" then
      self.Pos = x:copy()
   else
      self.Pos.x, self.Pos.y = x, y
   end
   self.TRANSFORMED:invoke(self)
   self:update()
   return self
end
---@param x number|Vector2
---@param y number?
function GNST:size(x, y)
   if type(x) == "Vector2" then
      self.Size = x:copy()
   else
      self.Size.x, self.Size.y = x, y
   end
   self.TRANSFORMED:invoke(self)
   self:update()
   return self
end

function GNST:update()
   local to = self.Pos + self.Size
   self.BottomRight = vectors.vec2(math.min(self.Pos.x, to.x), math.min(self.Pos.y, to.y))
   self.TopLeft = vectors.vec2(math.max(self.Pos.x, to.x), math.max(self.Pos.y, to.y))
   local size = self.BottomRight - self.TopLeft
   self.Sprite:setPos((-self.TopLeft - size).xy_:add(0, 0, self.Depth)):setScale(-(size /self.Texture.dimensions).xy_)
end

return gn
