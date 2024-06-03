if avatar:getPermissionLevel() ~= "MAX" then models.sword:setVisible(false) return end

models.sword:setPrimaryRenderType("CUTOUT_CULL")

local is_holding_sword = false
local was_holding_sword

local GNanim = require("libraries.GNanimLib")
local extraMath = require("libraries.extraMath")
local trail = require("libraries.GNtrailLib")

local state = GNanim.new()


local lpos = vectors.vec3()
local pos = vectors.vec3()
local lrot = 0
local rot = 0

local swing_count = 0
local roll2 = 0
local roll1 = 0
local weary = 0.9
local sword = models.sword
sword:setParentType("WORLD")
local sword_trail = trail:newTwoLeadTrail(textures["textures.trail"])
sword_trail:setDivergeness(0)
sword_trail:setDuration(10)
sword_trail:setRenderType("EMISSIVE_SOLID")

events.ENTITY_INIT:register(function ()
   pos = player:getPos()
   lpos = pos:copy()
   rot = player:getRot().y
   lrot = rot
end)

local speed = 1
for key, value in pairs(animations.sword) do
   value:speed(speed)
end
state:setBlendTime(0.1 / speed)

events.TICK:register(function ()
   lrot = rot
   lpos = pos
   pos = math.lerp(pos,player:getPos(),vectors.vec3(0.8,0.3,0.8))
   rot = math.lerp(rot,player:getBodyYaw(),0.3)
   if was_holding_sword ~= is_holding_sword then
      state:setAnimation(is_holding_sword and animations.sword.idle2prepare or animations.sword.prepare2idle)
      was_holding_sword = is_holding_sword
      if not is_holding_sword then
         swing_count = 0
      end
   end
   if is_holding_sword then
      if player:getSwingTime() == 1 then
         sounds:playSound("swing",player:getPos():add(0,1,0),1,1+(math.random()-0.5)*0.2)
         if swing_count % 2 == 1 then
            roll1 = math.random(-45,45)
            state:setAnimation(animations.sword.swing2swing2)
         else
            roll2 = math.random(-45,45)
            state:setAnimation(animations.sword.swing2swing)
         end
         swing_count = swing_count + 1
      end
   end
end)

local gm = ""
events.WORLD_RENDER:register(function (dt)
   if player:isLoaded() then
      local meta = models.sword.metadata:getAnimPos()
      local mat = models.sword.Roll.Pole.Handle:partToWorldMatrix()
      sword_trail:setLeads (mat:apply(0,0,1),mat:apply(0,0,-25),meta.x * 2) r = player:getBodyYaw(dt)
      local sneak = player:isSneaking() and player:isOnGround()
      local dir = vectors.rotateAroundAxis(-r,vectors.vec3(0,.25,1),vectors.vec3(0,1,0))
      sword:pos(math.lerp(player:getPos(dt),math.lerp(lpos,pos,dt),weary) * 16 + (sneak and dir*-10 or vectors.vec3(0,0,0)))
      sword:rot(sneak and -30 or 0,180-math.lerp(r,math.lerp(lrot,rot,dt),weary),0)
      sword.Roll:setRot(0,0,math.lerp(roll1,roll2,meta.x) * meta.y)
      is_holding_sword = (player:getHeldItem().id:find("sword") and true or false)
   end
end)

events.ITEM_RENDER:register(function ()
   if is_holding_sword then
      return sword.Item
   end
end)

events.RENDER:register(function (delta, context)
   if context == "FIRST_PERSON" then
      if weary == 0 then
         sword:setVisible(false)
      else
         sword:setOpacity(weary):setVisible(true)
      end
   else
      sword:setVisible(context == "RENDER"):setOpacity(1)
   end
   vanilla_model.RIGHT_ARM:setOffsetRot(is_holding_sword and -15 or 0,0,0)
   local meta = models.sword.metadata:getAnimPos()
   local systime = client:getSystemTime() / 10000
   weary = meta.y
   models.sword.Roll.Pole.Handle
   :rot(
      extraMath.superSine(systime,135351,10,0.5,1.4)*90 * weary,
      extraMath.superSine(systime,253631,10,0.5,1.4)*90 * weary,
      extraMath.superSine(systime,34124 ,10,0.5,1.4)*90 * weary):pos(
      extraMath.superSine(systime,4214 ,10,0.5,1.2)*16 * weary,
      extraMath.superSine(systime,53631,10,0.5,1.2)*16 * weary,
      extraMath.superSine(systime,4124 ,10,0.5,1.2)*16 * weary)
end)