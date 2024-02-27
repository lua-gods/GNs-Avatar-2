local model = models.player
local was_close = false
events.RENDER:register(function (dt,ctx)
   if ctx == "RENDER" and player:isLoaded() then
      local prot = player:getRot()
      local ppos = player:getPos()
      local cpos = client:getCameraPos()
      local distance = cpos-vectors.vec3(ppos.x,math.clamp(cpos.y,ppos.y,ppos.y+2),ppos.z)
      if distance.x + distance.y + distance.z < 3^3 then
         distance = distance:length() * 1.8
      else
         distance = math.huge
      end
      local close = (distance < 4) and 1 or 0
      model:setOpacity(math.clamp((distance - 1) * 2,0,1))
      if distance < 1 then close = 2 end
      if close ~= was_close then
         was_close = close
         if close == 1 then
            model:setPrimaryRenderType("TRANSLUCENT_CULL"):setVisible(true)
         elseif close == 2 then
            model:setVisible(false)
         else
            model:setPrimaryRenderType("CUTOUT_CULL"):setVisible(true)
         end
      end
      local crot = client:getCameraPos()-player:getPos()
      models.player.base.Torso.Head.Glass:setUV(0, math.atan2(crot.z,crot.x) + prot.x / 90)
   end
end)
models.player.base.Torso.Head.Glass:setPrimaryRenderType("EYES"):setColor(0.4,0.4,0.4)

if host:isHost() then
   events.RENDER:register(function (delta, context)
      if context ~= "RENDER" then
         model:setVisible(true):setOpacity(1)
      end
   end)
end
