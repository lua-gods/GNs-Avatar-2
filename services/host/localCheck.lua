local anchors = require("services.host.anchors")
local labelLib = require("libraries.GNLabelLib")
local label = labelLib.new(anchors.BottomLeft):setText("Local Mode"):setPos(-1,1):setEffect("SHADOW")

if host:isAvatarUploaded() then
   label:delete()
else
   local timer = 0
   events.WORLD_TICK:register(function ()
      timer = timer - 1
      if timer < 0 then
         timer = 20
         if host:isAvatarUploaded() then
            label:delete()
            events.WORLD_TICK:remove("uploadAwait") 
         end
      end
   end,"uploadAwait")
end