local anchor = require("services.host.anchors")
local d = textures.cute:getDimensions() * 16
local contain = models:newPart("ky","WORLD")
local sprite = contain:newSprite("NOW"):texture(textures.cute):setRenderType("BLURRY")
sprite:setPos(d.x/32,d.y/32,0)
events.WORLD_RENDER:register(function (delta)
   contain:setPos(client:getCameraPos():add(client:getCameraDir()) * 16)
   contain:setRot(client:getCameraRot():mul(1,-1,1)):setScale(0.6,0.4,0.4)
end)

local visibility = 1

events.WORLD_TICK:register(function ()
   if visibility > 0 then
      sprite:visible(true):setColor(1,1,1,math.min(visibility/10,1))
      visibility = visibility - 1
   else
      sprite:visible(false)
   end
end)

events.ON_PLAY_SOUND:register(function (id, pos, volume, pitch, loop, category, path)
   if id == "minecraft:entity.lightning_bolt.thunder" then
      visibility = 10
   end
end)