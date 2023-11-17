---@class Sword
---@field id integer
---@field lpos Vector3
---@field pos Vector3
---@field lrot Vector3
---@field rot Vector3
---@field vel Vector3
---@field spin number
---@field spinvel number
---@field part ModelPart
local sword = {}
sword.__index = sword

---@type table<any,Sword>
local swords = {}

---@param premade table?
---@return Sword
function sword.new(premade)
   local new = premade or {}
   new.pos = vectors.vec3()
   new.lpos = vectors.vec3()
   new.vel = vectors.vec3()
   new.lrot = vectors.vec3()
   new.rot = vectors.vec3()
   new.spinvel = 0
   new.spin = 0
   for i = 1, #swords+1, 1 do
      if not swords[i] then
         swords[i] = new
         new.id = i
         new.part = models.sword:copy("gnkatana"..i):setParentType("WORLD")
         models:addChild(new.part)
         break
      end
   end
   setmetatable(new,sword)
   return new
end

local function toAngle(vec3pos)
   local y = math.atan(vec3pos.x,vec3pos.z)
   local result = vectors.vec3(math.atan((math.sin(y)*vec3pos.x)+(math.cos(y)*vec3pos.z),vec3pos.y),y)
   result = vectors.vec3(result.x,result.y,0)
   result = (result / 3.14159) * 180
   return result
end

events.WORLD_TICK:register(function ()
   for i, s in pairs(swords) do
      s.lpos = s.pos
      s.lrot = s.rot
      s.pos = s.pos + s.vel
      s.lspin = s.spin
      s.spin = s.spin + s.spinvel
      s.rot = toAngle(s.vel):add(-s.spin,0,0)
   end
end)

events.WORLD_RENDER:register(function (delta)
   for i, s in pairs(swords) do
      s.part:setPos(math.lerp(s.lpos,s.pos,delta) * 16):setRot(vectors.vec3(
         math.lerpAngle(s.lrot.x,s.rot.x,delta),
         math.lerpAngle(s.lrot.y,s.rot.y,delta),
         math.lerpAngle(s.lrot.z,s.rot.z,delta)
      ))
   end
end)

---@param vecx Vector3|number
---@param y number?
---@param z number?
---@return Sword
function sword:setPos(vecx,y,z)
   if type(vecx) == "Vector3" then
      self.pos = vecx:copy()
   else
      self.pos = vectors.vec3(vecx,y,z)
   end
   return self
end

---@param vecx Vector3|number
---@param y number?
---@param z number?
---@return Sword
function sword:setVel(vecx,y,z)
   if type(vecx) == "Vector3" then
      self.vel = vecx:copy()
   else
      self.vel = vectors.vec3(vecx,y,z)
   end
   return self
end

return sword