
models.player.base.torso.Head.Eyes:setPrimaryRenderType("EMISSIVE_SOLID")

function pings.blink()
   animations.player.blink:play()
end

events.TICK:register(function ()
   local b = math.lerp(0.9,1,math.random())
   models.player.base.torso.Head.Eyes:setColor(b,b,b)
end)

if not host:isHost() then return end

local max_wait = 3 * 20
local min_wait = 1 * 20
local wait = min_wait

events.TICK:register(function ()
   wait = wait - 1
   if wait < 0 then
      pings.blink()
      wait = math.floor(math.lerp(min_wait,max_wait,math.random()) + 0.5)
   end
end)