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
   local model = plushie:copy(skull.order):setScale(1,1,1)
   skull.model:addChild(model)
   events.FRAME:register(function ()
      local time = client:getSystemTime() / 100
      model:setPos(0,superSine(time * 0.05+skull.order,123,4)*1-4)
      :rot(
         superSine(time * 0.04+skull.order,213,4)*5,
         superSine(time * 0.02+skull.order,413,4)*5,
         superSine(time * 0.03+skull.order,23,4)*5)
   end)
end

---@param skull WorldSkull
return function (skull)
   local bellow = world.getBlockState(skull.pos - vectors.vec3(0,1,0)).id 
   if bellow == "minecraft:water" or bellow == "minecraft:water_cauldron" then
      return new
   end
end