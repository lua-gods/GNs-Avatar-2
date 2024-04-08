local --- smooth step function
function step(v,s)
   return math.floor(v / s + 0.5) * s
end

---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
   local sound = sounds:playSound("minecraft:music_disc.stal",skull.pos:copy():add(0.5,0.5,0.5))
   events.FRAME:register(function ()
      local time = client:getSystemTime()/100
      sound:pitch(step(math.sin(time)*0.3+1,1/6))
   end)

   events.EXIT:register(function ()
      sound:stop()
   end)
end

---@param skull WorldSkull
return function (skull)
   if world.getBlockState(skull.pos:copy():add(0,-1,0)).id == "minecraft:jukebox" then
      return new
   end
end

