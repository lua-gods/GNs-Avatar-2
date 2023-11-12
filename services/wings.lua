vanilla_model.ELYTRA:setVisible(false)
animations.player.fly:play():blend(0)
local weight = 0
events.RENDER:register(function (_,context)
   if context == "RENDER" then
      if player:getPose() == "FALL_FLYING" then
         if weight < 1 then
            animations.player.fly:blend(weight)
            weight = weight + 0.05
         end
      else
         if weight > 0 then
            animations.player.fly:blend(weight)
            weight = weight - 0.05
         end
      end
   end
end)