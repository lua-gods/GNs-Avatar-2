
local res = vectors.vec2(1920,1080) / 8

---@type table<integer,{pos: Vector3, radius: number, clr: Vector3,emission: number}>>
local scene = {}

---@param pos Vector3
---@param radius number
---@param clr Vector3
---@param emission number?
local function newSphere(pos,radius,clr,emission)
   scene[#scene+1] = {pos=pos,radius=radius,clr=clr,emission=emission or 0}
end

local function RandomValueNormalDistribution()
   local rand = math.random()
   local theta = 2 * math.pi * rand
   local rho = math.sqrt(-2 * math.log(rand))
   return rho * math.cos(theta)
end

local function randomDirection()
   return vectors.vec3(
      RandomValueNormalDistribution(),
      RandomValueNormalDistribution(),
      RandomValueNormalDistribution())
end

---@param normal Vector3
local function RandomValueDirFromNormal(normal)
   local dir = randomDirection()
   return dir * math.sign(normal:dot(dir))
end

local function raySphere(from,dir,center,radius)
   local hit_info = {}
   local v = center - from
   local a = dir:dot(dir)
   local b = 2 * v:dot(dir)
   local c = v:dot(v) - radius * radius
   local discriminant = b * b - 4 * a * c
   if discriminant > 0 then
      local dist = (-b - math.sqrt(discriminant)) / (2 * a)
      if dist >= 0 then
         hit_info.hit_point = from + dir * dist
         hit_info.normal = (hit_info.hit_point - center):normalized()
         return hit_info
      end
   end
end

local function Trace(from,dir)
   local closest_hit_distance = math.huge
   local closest_hit
   for i = 1, #scene, 1 do
      local sphere = scene[i]
      local info = raySphere(from,dir,sphere.pos,sphere.radius)
      if info and closest_hit_distance > (info.hit_point):length() then
         closest_hit = {ray_info=info,sphere=sphere}
         closest_hit_distance = (info.hit_point):length()
      end
   end
   if closest_hit then
      return closest_hit
   end
end

local function fragment(x,y,a)
   local incoming_light = vectors.vec3()
   local ray_clr = vectors.vec3(1,1,1)

   local origin = vectors.vec3()
   local dir = vectors.vec3((x-0.5)*a,y-0.5,-1)
   for i = 1, 1, 1 do
      local result = Trace(origin,dir)
      if result then
         origin = result.ray_info.hit_point
         dir = result.ray_info.normal
         local emitted_light = result.sphere.clr * result.sphere.emission
         incoming_light = incoming_light + emitted_light * ray_clr
         ray_clr = ray_clr * result.sphere.clr
         incoming_light = result.ray_info.normal
      else
         break
      end
   end
   return incoming_light
end

---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
local screen = textures:newTexture("raytracinggaming",res.x,res.y)
   local m = math.max(res.x,res.y) / 16
   skull.model:newSprite("screen"):setTexture(screen,res.x,res.y):setScale(1/m,1/m):setPos(8,16)
   
   
   newSphere(vectors.vec3(0,0,3), 1, vectors.vec3(1,0,0))
   newSphere(vectors.vec3(-2,0,4), .5, vectors.vec3(0,0,1),1)
   newSphere(vectors.vec3(2,0,3), .75, vectors.vec3(0,1,0))
   newSphere(vectors.vec3(0,-1001,3), 1000, vectors.vec3(0.9,1,1))
   
   
   local x = 0
   local y = 0
   local running = true

   events.TICK:register(function ()
      if running then
         screen:update()
         for i = 1, 5000, 1 do
            if avatar:getCurrentInstructions() > 200000 then
               return
            end
            local clr = fragment(x/res.x,y/res.y,res.x/res.y)
            screen:setPixel(x,y,math.clamp(clr.x,0,1),math.clamp(clr.y,0,1),math.clamp(clr.z,0,1))
            x = x + 1
            if x >= res.x then
               x = 0
               y = y + 1
               if y >= res.y then
                  running = false
                  return
               end
            end
         end
      end
   end)
end

---@param skull WorldSkull
return function (skull)
   if world.getBlockState(skull.pos:copy():add(0,-1,0)).id == "minecraft:redstone_lamp" then
      return new
   end
end