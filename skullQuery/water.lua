local plushie = models.plushie

local function superSine(value,seed,depth)
   math.randomseed(seed)
   local result = 0
   for i = 1, depth, 1 do
      result = result + math.sin(value * (math.random() * math.pi * depth) + math.random() * math.pi * depth)
   end
   return result / depth
end

---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
   local model = plushie:copy(skull.id):setScale(1,1,1)
   skull.model:addChild(model)
   events.FRAME:register(function ()
      local time = client:getSystemTime() / 100
      model:setPos(0,superSine(time * 0.05+skull.id,123,4)*4-8)
      :rot(
         superSine(time * 0.04+skull.id,213,4)*15,
         superSine(time * 0.02+skull.id,413,4)*15,
         superSine(time * 0.03+skull.id,23,4)*15)
   end)
end

---@param skull WorldSkull
return function (skull)
   if world.getBlockState(skull.pos - vectors.vec3(0,1,0)).id == "minecraft:water" then
      return new
   end
end