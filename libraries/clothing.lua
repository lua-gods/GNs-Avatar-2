
local utils = require("libraries.utils")

---@class Clothing
---@field texture Texture
---@field uv Vector2
---@field accessories ModelPart[]
local clothing = {}
clothing.__index = clothing

---@param texture Texture
---@param uv Vector2
---@param accessories ModelPart[]?
---@return Clothing
function clothing.new(texture,uv,accessories)
   local new = {}
   setmetatable(new,clothing)
   new.texture = texture
   new.uv = uv
   new.accessories = accessories or {}
   return new
end


---@class Wardrobe
---@field clothes Clothing[]
---@field current_clothing integer
---@field textured_models ModelPart[]
---@field bake_texture Texture
local wardrobe = {}
wardrobe.__index = wardrobe

local next_free = 0

---@overload fun(textured_models : ModelPart[]?, bake_texture_size : Vector2): Wardrobe
---@param textured_models ModelPart[]?
---@param bake_texture_width number
---@param bake_texture_height number
---@return Wardrobe
function wardrobe.new(textured_models,bake_texture_width,bake_texture_height)
   local new = {}
   setmetatable(new,wardrobe)
   new.clothes = {}
   new.current_clothing = 1
   new.textured_models = textured_models or {}
   if bake_texture_width or bake_texture_height then
      local res = utils.figureOutVec2(bake_texture_width,bake_texture_height)
      new.bake_texture = textures:newTexture("clothing.bake_texture."..next_free,res.x,res.y):fill(0,0,res.x-1,res.y-1,vectors.vec4(0,0,0,0))
   end
   next_free = next_free + 1
   return new
end

---@param c Clothing
---@return Wardrobe
function wardrobe:appendClothing(c)
   table.insert(self.clothes,c)
   return self
end

function wardrobe:setCurrentClothing(id)
   self.current_clothing = id
   wardrobe:_bakeTexture()
   return self
end

---@protected
function wardrobe:_bakeTexture()
   if wardrobe.bake_texture then
      local res = wardrobe.bake_texture:getDimensions():sub(1,1)
      wardrobe.bake_texture:fill(0,0,res.x,res.y,vectors.vec4(0,0,0,0))
      for _,c in pairs(self.clothes) do
         wardrobe.bake_texture:applyFunc(0,0,res.x,res.y,function (color, x, y)
            local sampled = c.texture:getPixel(c.uv.x + x,c.uv.y + y)
            return math.lerp(color,vectors.vec4(sampled.x,sampled.y,sampled.z,1),sampled.w) --[[@as Vector4]]
         end)
      end
   end
end