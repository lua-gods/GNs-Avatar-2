events.WORLD_TICK:register(function ()
   local selected = player:getTargetedBlock(true,5)
   local held = player:getHeldItem()
   renderer:setRenderCrosshair(selected.id ~= "minecraft:air" or held.id ~= "minecraft:air")
end)