local anchor = require("services.host.anchors")
local overlay = anchor.TopLeft:newSprite("NOW"):texture(textures.cute):setRenderType("BLURRY")

anchor.SCREEN_RESIZED:register(function (size)
   local dim = overlay:getDimensions()
   local scale = size / dim
   overlay:scale(scale.x,scale.y,1)
end)

local visibility = 1

events.WORLD_TICK:register(function ()
   if visibility > 0 then
      overlay:visible(true):setColor(1,1,1,math.min(visibility/20,1))
      visibility = visibility - 1
   else
      overlay:visible(false)
   end
end)

events.ON_PLAY_SOUND:register(function (id, pos, volume, pitch, loop, category, path)
   if id == "minecraft:entity.lightning_bolt.thunder" then
      visibility = 20
   end
end)