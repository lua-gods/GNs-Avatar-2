
local FASTEST_BLINK = .5 * 20
local SLOWEST_BLINK = 5 * 20

animations.player.blink:speed(2.5)

local blinkTime = 0
events.TICK:register(function ()
   blinkTime = blinkTime - 1
   if blinkTime < 0 then
      blinkTime = math.random(FASTEST_BLINK,SLOWEST_BLINK)
      animations.player.blink:play()
   end
end)