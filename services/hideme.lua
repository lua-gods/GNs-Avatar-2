vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
models.plushie:setParentType("SKULL")
models.hat:setParentType("SKULL")

events.SKULL_RENDER:register(function (delta, block, item,entity,context)
   if entity then
      ---@type Vector3
      local clr = entity:getVariable("color") or vectors.hexToRGB("#5ac54f")
      if type(clr) == "Vector3" then
         for i = 1, 4, 1 do
            local w = (i-1)/4
            local a = vectors.rgbToHSV(clr)
            a.g = a.g; a.b = 1
            a.g = math.min(a.g * 1.1,1)
            a = vectors.hsvToRGB(a)
            local b = vectors.rgbToHSV(clr)
            b.b = 0.67; b.g = 1
            b = vectors.hsvToRGB(b)
            b = math.lerp(b,vectors.vec3(0.1,0.2,0.4),0.4)
            models.hat.Tophat.ribbon["color"..i]:setColor(math.lerp(b,a,w))
         end
      end
      models.hat.Tophat:setVisible(true)
   end
   models.hat:setVisible(false)
   if context == "HEAD" then
      models.plushie:setVisible(false)
      models.hat:setVisible(true)
   else
      models.plushie:setVisible(true)
      models.hat:setVisible(false)
      if block then
         local under = world.getBlockState(block:getPos():sub(0,1,0))
         local stack = under.id == "minecraft:player_head"
         models.plushie.Plushie:setVisible(not stack):setRot(0,0,0)
         models.plushie.Extension:setVisible(stack)
      else
         models.plushie.Plushie:setVisible(true)
         models.plushie.Extension:setVisible(false)
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