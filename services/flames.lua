events.TICK:register(function ()
   local pos = player:getPos()
   local bb = player:getBoundingBox()
   local size = bb:length() * 0.4
   particles["smoke"]:pos(
      pos.x + (math.random() - 0.5) * bb.x,
      pos.y + (math.random()) * bb.y,
      pos.z + (math.random() - 0.5) * bb.z
   ):spawn():gravity(-0.025)
   if math.random() > 0.9 then
      particles["flame"]:pos(
      pos.x + (math.random() - 0.5) * bb.x,
      pos.y + (math.random()) * bb.y,
      pos.z + (math.random() - 0.5) * bb.z
   ):spawn():gravity(-0.05):scale(size)
   end
end)

local toggle = false

events.WORLD_RENDER:register(function (delta)
   toggle = not toggle
end)

events.SKULL_RENDER:register(function (delta, block, item, entity)
   if entity and toggle then
      local pos = entity:getPos()
      local bb = entity:getBoundingBox()
      local size = bb:length() * 0.4
      particles["smoke"]:pos(
         pos.x + (math.random() - 0.5) * bb.x,
         pos.y + (math.random()) * bb.y,
         pos.z + (math.random() - 0.5) * bb.z
      ):spawn():gravity(-0.025):scale(size)
      if math.random() > 0.9 then
         particles["flame"]:pos(
         pos.x + (math.random() - 0.5) * bb.x,
         pos.y + (math.random()) * bb.y,
         pos.z + (math.random() - 0.5) * bb.z
      ):spawn():gravity(-0.05):scale(size)
      end
   end
end)

events.ARROW_RENDER:register(function (delta, entity)
   if toggle then
      local vel = entity:getVelocity()
      local pos = entity:getPos(delta)
      local bb = entity:getBoundingBox()
      local size = bb:length() * 1
      particles["smoke"]:pos(
         pos.x + (math.random() - 0.5) * bb.x,
         pos.y + (math.random()) * bb.y,
         pos.z + (math.random() - 0.5) * bb.z
      ):spawn():gravity(-0.025):scale(size):setLifetime(60):velocity(vel * -0.1)
      if math.random() > 0.7 then
         particles["flame"]:pos(
         pos.x + (math.random() - 0.5) * bb.x,
         pos.y + (math.random()) * bb.y,
         pos.z + (math.random() - 0.5) * bb.z
      ):spawn():gravity(-0.05):scale(size):velocity(vel * -0.1)
      end
   end
end)