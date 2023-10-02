events.RENDER:register(function (delta, context)
   if context == "RENDER" then
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
   end
end)

local toggle = false

events.WORLD_RENDER:register(function (delta)
   toggle = not toggle
end)

events.SKULL_RENDER:register(function (delta, block, item, entity)
   --if entity and toggle then
   --   if ((entity:getPos():add(0, entity:getEyeHeight(), 0) - client.getCameraPos()):lengthSquared()) < 1 then
   --      return
   --   end
   --   local pos = entity:getPos()
   --   local bb = entity:getBoundingBox()
   --   local size = bb:length() * 0.2
   --   particles["smoke"]:pos(
   --      pos.x + (math.random() - 0.5) * bb.x,
   --      pos.y + (math.random()) * bb.y,
   --      pos.z + (math.random() - 0.5) * bb.z
   --   ):spawn():gravity(-0.025):scale(size)
   --   if math.random() > 0.9 then
   --      particles["flame"]:pos(
   --      pos.x + (math.random() - 0.5) * bb.x,
   --      pos.y + (math.random()) * bb.y,
   --      pos.z + (math.random() - 0.5) * bb.z
   --   ):spawn():gravity(-0.05):scale(size)
   --   end
   --end
end)

events.ARROW_RENDER:register(function (delta, entity)
   if toggle then
      local vel = entity:getVelocity()
      local pos = entity:getPos(delta)
      local bb = entity:getBoundingBox()
      local size = bb:length() * 1
      for i = 1, math.clamp(vel:length()*5,0,10), 1 do
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
   end
end)