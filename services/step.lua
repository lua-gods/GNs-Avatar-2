local i = 0
local b = 0
local tween = require("libraries.GNTweenLib")
events.ON_PLAY_SOUND:register(function (id, pos, volume, pitch, loop, category, path)
   if id:find("deepslate.step$") then
      i = i % 4 + 1
      sounds:playSound("step"..i,pos,0.1,1)
      return true
   elseif id == "minecraft:block.bell.use" then
      sounds:playSound("bell"..math.random(1,3),pos,1,1)
      return true
   end
end)