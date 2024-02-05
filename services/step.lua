local i = 0
local b = 0
local tween = require("libraries.GNTweenLib")
events.ON_PLAY_SOUND:register(function (id, pos, volume, pitch, loop, category, path)
   if id:find("deepslate.step$") then
      i = i % 4 + 1
      sounds:playSound("step"..i,pos,0.1,1)
      return true
   elseif id == "minecraft:entity.villager.ambient" then
      b = b % 4 + 1
      if b == 1 then
         sounds:playSound("minecraft:block.note_block.basedrum",pos,1,1)
      elseif b == 2 then
         sounds:playSound("minecraft:block.note_block.hat",pos,1,1)
      elseif b == 3 then
         sounds:playSound("minecraft:block.note_block.snare",pos,1,1)
      elseif b == 4 then
         sounds:playSound("minecraft:block.note_block.hat",pos,1,1)
      end
      particles:newParticle("minecraft:note",pos:add(0,2,0))
   elseif id == "minecraft:block.bell.use" then
      sounds:playSound("bell"..math.random(1,3),pos,1,1)
      return true
   end
end)