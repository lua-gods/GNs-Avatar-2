
local colors = {
   vectors.hexToRGB("#d3fc7e"),
   vectors.hexToRGB("#99e65f"),
   vectors.hexToRGB("#5ac54f"),
   vectors.hexToRGB("#33984b"),
   vectors.hexToRGB("#1e6f50"),
   vectors.hexToRGB("#134c4c"),
   vectors.hexToRGB("#0c2e44"),
}



function pings.GNPOOF(x,y,z,appear)
   local pos = vectors.vec3(x,y,z)
   particles:newParticle("minecraft:flash",pos):setColor(0.5,1,0.4)
   local max_pow = 0.5
   for ci = 1, #colors, 1 do
      local clr = colors[ci]
      local low_pow,high_pow = (ci-1) / #colors * max_pow,ci / #colors * max_pow
      for i = 1, 50, 1 do
         local mpow = math.lerp(low_pow,high_pow,math.random())
         local inv_pow = math.pow((1 - mpow )* max_pow,3)
         local v = vectors.angleToDir(math.random()*360,math.random()*180)*mpow
         v:mul(0.5,1,0.5)
         local p = particles
         :newParticle("minecraft:end_rod",pos)
         
         if not appear then
            p:setVelocity(v)
            :color(clr)
            :lifetime(math.pow((1 - mpow )* max_pow,2) * 300)
            :gravity(-10*(inv_pow))
         else
            p:pos(pos+v*10)
            p:setVelocity(-v)
            :color(clr)
            :lifetime(math.pow((1 - mpow )* max_pow,2) * 300)
            :gravity(0)
         end
      end
   end
   --sounds:playSound("minecraft:entity.illusioner.cast_spell",pos,1,1)
   sounds:playSound("minecraft:entity.generic.extinguish_fire",pos,0.1,0.8)
   --sounds:playSound("minecraft:entity.allay.item_taken",pos,1,1)
   for i = 1, 3, 1 do
      sounds:playSound("minecraft:particle.soul_escape",pos,1,1)
   end
   sounds:playSound("minecraft:entity.ghast.shoot",pos,0.2,.75)
end

if not host:isHost() then return end

local last_gamemode = nil

events.TICK:register(function ()
   local gamemode = player:getGamemode()
   if last_gamemode and last_gamemode ~= gamemode and (gamemode == "SPECTATOR" or last_gamemode == "SPECTATOR") then
      local pos = player:getPos():add(0,1,0)
      pings.GNPOOF(pos.x,pos.y,pos.z,gamemode ~= "SPECTATOR")
   end
   last_gamemode = gamemode
end)