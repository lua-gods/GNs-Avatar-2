vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
models.plushie:setParentType("SKULL")

local time = 0

events.WORLD_RENDER:register(function (delta)
   time = client:getSystemTime()
end)

events.SKULL_RENDER:register(function (delta, block, item,entity,context)
   if context == "HEAD" then
      models.plushie.Plushie:setVisible(false)
      models.plushie.Extension:setVisible(false)
      models.plushie.Tophat:setVisible(true)
   else
      models.plushie.Tophat:setVisible(false)
      if block then
         local under = world.getBlockState(block:getPos():sub(0,1,0))
         local stack = under.id == "minecraft:player_head" and under:getEntityData() and under:getEntityData().SkullOwner.Name == "GNamimates"
         models.plushie.Plushie:setVisible(not stack):setRot(0,0,0)
         models.plushie.Extension:setVisible(stack)
      else
         models.plushie.Plushie:setVisible(true)
         models.plushie.Extension:setVisible(false)
         if item then
            models.plushie.Plushie:setRot(0,time * -0.055)
         else
         end
      end
   end
end)

--local shadow = models.player:copy("shadow")
--local floor_height = 0
--models:addChild(shadow:setColor(0,0,0))
--
--events.RENDER:register(function (delta, context)
--   if player:isLoaded() then
--      local pos = player:getPos(delta)
--      if player:isOnGround() then
--         floor_height = pos.y
--      end
--      local diff = (floor_height-pos.y)
--      local offset = 0
--      if player:isSneaking() then
--         offset = 0.16
--      end
--      local yaw = math.rad(player:getBodyYaw(delta))
--      shadow:setMatrix(matrices.mat4(
--      vectors.vec4(1,0,0,0),
--      vectors.vec4(math.sin(yaw),0,math.cos(yaw),0),
--      vectors.vec4(0,0,1,0),
--      vectors.vec4(0,0,0,1)
--   ):translate(math.sin(yaw) * diff * -16,(diff + offset) * math.worldScale * 16,math.cos(yaw) * -16 * diff))
--      
--   end
--end)