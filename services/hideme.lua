vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
models.plushie:setParentType("SKULL")

events.SKULL_RENDER:register(function (delta, block, item)
   if block then
      local under = world.getBlockState(block:getPos():sub(0,1,0))
      local stack = under.id == "minecraft:player_head" and under:getEntityData() and under:getEntityData().SkullOwner.Name == "GNamimates"
      models.plushie.Plushie:setVisible(not stack)
      models.plushie.Extension:setVisible(stack)
   else
      models.plushie.Plushie:setVisible(true)
      models.plushie.Extension:setVisible(false)
   end
end)