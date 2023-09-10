local frames = 180
models.image.PORTRAIT:setPrimaryRenderType("BLURRY")
events.WORLD_RENDER:register(function ()
   local t = (client:getSystemTime() / 100) * 2
   local f = math.floor(t)
   local m = t - f
   models.image.PORTRAIT.cube1:setUV(0,(f) / frames)
   models.image.PORTRAIT.cube2:setUV(0,(f+1) / frames):setOpacity(m)
end)