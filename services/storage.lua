local projector = models:newPart("projector","SKULL"):setScale(16,16,16):setPos(0,-8,8)

local s = 1/16

projector:newItem("Dis"):item("minecraft:redstone"):scale(s * 0.7,s * 0.7,s * 0.7):pos(3,-1,0)

events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
   if ctx == "BLOCK" and block:getPos() == vectors.vec3(889,61,904) then
      projector:setVisible(true)
   else
      projector:setVisible(false)
   end
end)