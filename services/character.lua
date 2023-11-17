
local config = {
   update_interval = 4
}
local update_timer = 0

local lrot = vectors.vec2()
local rot = vectors.vec2()
local time = 0

events.RENDER:register(function (delta, context)
   if context == "RENDER" then
      if player:isLoaded() then
         local d = (update_timer + delta) / config.update_interval
         local trot = -math.lerp(lrot,rot,d)
         local breath = (time + delta) * 0.1
         models.player.base:setPos(0,0,trot.x*-0.022)
         models.player.base.LeftLeg:setPos(0,0,trot.x * 0.01 + trot.y * 0.02):setRot(trot.x * -0.05 + trot.y * 0.1,trot.y * 0.25,0)
         models.player.base.RightLeg:setPos(0,0,trot.x * 0.01 - trot.y * 0.02):setRot(trot.x * -0.05 - trot.y * 0.1,trot.y * 0.25,0)
         models.player.base.Torso:setRot(trot.x * 0.2,trot.y * 0.5,0):pos(0,(math.sin(breath)+1) * 0.1,0)
         models.player.base.Torso.Head:setRot(trot.x * -0.4,trot.y * -0.75,trot.y * (math.abs(math.rad(math.min(trot.x,0)))) * -0.25)
         models.player.base.Torso.LeftArm:setRot(trot.x * -0.1 + trot.y * -0.2,0,math.abs(trot.y)*-0.05)
         models.player.base.Torso.RightArm:setRot(trot.x * -0.1 - trot.y * -0.2,0,math.abs(trot.y)*0.05)
         models.player.base.Torso.Head.HClothing.eyes:setPos(trot.y * -0.01,0,0)
         models.player.base.Torso.Head.HClothing.Mouth:setRot(0,0,trot.y * 0.1)
      end
   elseif context == "FIRST_PERSON" then
      models.player.base.Torso.LeftArm:setRot(0,0,0)
      models.player.base.Torso.RightArm:setRot(0,0,0)
   end
end)

events.TICK:register(function ()
   time = time + 1
   update_timer = (update_timer + 1) % config.update_interval
   if update_timer == 0 then
      lrot = rot

      rot = player:getRot():sub(0,player:getBodyYaw())
      rot.y = (rot.y + 180) % 360 - 180
   end
end)

function pings.blink()
   animations.player.blink:play()
end


if not host:isHost() then return end

local max_wait = 8 * 20
local min_wait = 1 * 20
local wait = min_wait

events.TICK:register(function ()
   wait = wait - 1
   if wait < 0 then
      pings.blink()
      wait = math.floor(math.lerp(min_wait,max_wait,math.random()) + 0.5)
   end
end)