
--local colors = {
--   vectors.hexToRGB("#d3fc7e"),
--   vectors.hexToRGB("#99e65f"),
--   vectors.hexToRGB("#5ac54f"),
--   vectors.hexToRGB("#33984b"),
--   vectors.hexToRGB("#1e6f50"),
--   vectors.hexToRGB("#134c4c"),
--   vectors.hexToRGB("#0c2e44"),
--}

local colors = {
   vectors.hexToRGB("#edab50"),
   vectors.hexToRGB("#e07438"),
   vectors.hexToRGB("#c64524"),
   vectors.hexToRGB("#8e251d"),
}

function pings.poof(x,y,z,w,t)
   local pos = vectors.vec3(x,y,z)
   sounds:playSound("minecraft:item.totem.use",pos,0.2,0.8)
   sounds:playSound("minecraft:entity.bat.takeoff",pos,0.5,0.8)
   sounds:playSound("minecraft:entity.evoker.cast_spell",pos,0.5,1)
   for i = 1, 150, 1 do
      local offset = vectors.vec3(
         (math.random()-0.5),
         (math.random()-0.5),
         (math.random()-0.5)
      )
      particles["end_rod"]:pos(
         x + offset.x * w,
         y + offset.y * t,
         z + offset.z * w)
         :velocity(offset:normalize() * math.random() * 0.3):color(colors[math.random(1,#colors)]):setScale(math.lerp(0.25,0.75,math.random()))
         :spawn()
   end

   for i = 1, 150, 1 do
      local offset = vectors.vec3(
         (math.random()-0.5),
         (math.random()-0.5),
         (math.random()-0.5)
      )
      particles["smoke"]:pos(
         x + offset.x * w,
         y + offset.y * t,
         z + offset.z * w)
         :velocity(offset:normalize() * math.random() * 0.3):scale(2)
         :spawn()
   end
end

local last_gamemode
events.TICK:register(function ()
   local gamemode = player:getGamemode()
   if last_gamemode and last_gamemode ~= gamemode and (last_gamemode == "SPECTATOR" or gamemode == "SPECTATOR") then
      local bb = player:getBoundingBox()
      local pos = player:getPos():add(0,bb.y * 0.5)
      pings.poof(pos.x,pos.y,pos.z,bb.x,bb.y)
   end
   last_gamemode = gamemode
end)