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