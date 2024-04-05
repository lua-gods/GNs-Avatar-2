--[[______   __
  / ____/ | / / By: GNamimates
 / / __/  |/ / GNlineLib v2.0.1
/ /_/ / /|  / Allows you to draw lines in the world at ease.
\____/_/ |_/ https://github.com/lua-gods/GNs-Avatar-2/tree/main/libraries/GNlineLib.lua]]

local default_model = models:newPart("gnlinelibline","WORLD"):scale(16,16,16)
local default_texture = textures["1x1white"] or textures:newTexture("1x1white",1,1):setPixel(0,0,vectors.vec3(1,1,1))
local lines = {} ---@type line[]
local queue_update = {} ---@type line[]

local cpos = client:getCameraPos()

---@overload fun(pos : Vector3)
---@param x number
---@param y number
---@param z number
---@return Vector3
local function figureOutVec3(x,y,z)
   local typa = type(x)
   if typa == "Vector3" then
      return x:copy()
   elseif typa == "number" then
      return vectors.vec3(x,y,z)
   end
end

---@class line
---@field id integer
---@field a Vector3?
---@field b Vector3?
---@field dir Vector3?
---@field length number
---@field width number
---@field color Vector4
---@field alpha number
---@field depth number
---@field package _queue_update boolean
---@field package _distance_to_camera number
---@field model SpriteTask
local line = {}
line.__index = line
line.__type = "gn.line"

---@param preset line?
---@return line
function line.new(preset)
   preset = preset or {}
   local next_free = #lines+1 
   local new = setmetatable({},line)
   new.a = preset.a or vectors.vec3()
   new.b = preset.b or vectors.vec3()
   new.width = preset.width or 0.125
   new.color = preset.color or vectors.vec3(1,1,1)
   new.alpha = preset.alpha or 1
   new.depth = preset.depth or 1
   new._distance_to_camera = math.huge
   new.model = default_model:newSprite("line"..next_free):setTexture(default_texture,1,1):setRenderType("CUTOUT_EMISSIVE_SOLID")
   new.id = next_free
   lines[next_free] = new
   return new
end

---@overload fun(self : line, from : Vector3, to :Vector3)
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
function line:setAB(x1,y1,z1,x2,y2,z2)
   if type(x1) == "Vector3" and type(x2) == "Vector3" then
      self.a = x1:copy()
      self.b = x2:copy()
   else
      self.a = vectors.vec3(x1,y1,z1)
      self.b = vectors.vec3(x2,y2,z2)
   end
   self:update()
   return self
end

---@overload fun(self: line ,pos : Vector3)
---@param x number
---@param y number
---@param z number
function line:setA(x,y,z)
   self.a = figureOutVec3(x,y,z)
   self:update()
   return self
end

---@overload fun(self: line ,pos : Vector3)
---@param x number
---@param y number
---@param z number
function line:setB(x,y,z)
   self.b = figureOutVec3(x,y,z)
   self:update()
   return self
end

function line:setWidth(w)
   self.width = w
   self:update()
end

---@param render_type ModelPart.renderType
---@return line
function line:setRenderType(render_type)
   self.model:setRenderType(render_type)
   return self
end

---@overload fun(self : line, rgb : Vector3): line
---@overload fun(self : line, rgb : Vector4): line
---@overload fun(self : line, string): line
---@param r number
---@param g number
---@param b number
---@Param a number
function line:setColor(r,g,b,a)
   local rt,yt,bt = type(r),type(g),type(b)
   if rt == "number" and yt == "number" and bt == "number" then
      self.color = vectors.vec4(r,g,b,a or 1)
   elseif rt == "Vector3" then
      self.color = r:augmented()
   elseif rt == "Vector4" then
      self.color = r
   elseif rt == "string" and rt:find("#%x%x%x%x%x%x") then
      self.color = vectors.hexToRGB(r):augmented(1)
   else
      error("Invalid Color parameter, expected Vector3, (number, number, number) or Hexcode, instead got ("..rt..", "..yt..", "..bt..")")
   end
   self.model:setColor(self.color)
   return self
end

---@param z number
function line:setDepth(z)
   self.depth = z
   return self
end

function line:update()
   ---insertion sort
   if not self._queue_update then
      queue_update[#queue_update+1] = self
      self._queue_update = true
   end
   return self
end

function line:immediateUpdate()
   local offset = cpos - self.a
   local a,b = self.a,self.b
   local dir = (b - a)
   self.dir = dir
   local l = dir:length()
   self.length = l
   local w = self.width
   local d = dir:normalized()
   local p = (offset - d * offset:copy():dot(d)):normalize()
   local c = p:copy():cross(d) * w
   local mat = matrices.mat4(
      (p:cross(d) * w):augmented(0),
      (-d * (l + w * 0.5)):augmented(0),
      p:augmented(0),
      (a + c * 0.5):augmented()
   )
   self.model:setMatrix(mat * self.depth)
end

events.WORLD_RENDER:register(function ()
   local c = client:getCameraPos()
   if c ~= cpos then
      cpos = c
      for key, l in pairs(lines) do
         l:update()
      end
   end
   for i = 1, #queue_update, 1 do
      local l = queue_update[i]
      l:immediateUpdate()
      l._queue_update = false
   end
   queue_update = {}

end)

return {
   new = line.new,
   default_model = default_model,
   default_texture = default_texture,
   _VERSION = "2.0.1"
}
