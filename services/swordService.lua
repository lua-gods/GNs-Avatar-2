local swordLib = require("libraries.sword")

local swords = {}
for i = 1, 1, 1 do
   swords[#swords+1] = swordLib.new()
end

events.ENTITY_INIT:register(function ()
   for key, sword in pairs(swords) do
      sword:setPos(player:getPos())
      sword:setVel(0.1,0,0)
      sword.spinvel = 0
   end
end)

events.TICK:register(function ()
   for key, sword in pairs(swords) do
      local target = player:getPos() - sword.pos
      sword.vel = sword.vel * 0.9 + math.random() * 0.1 + target * 0.1 * (math.random() + 0.05)
   end
end)