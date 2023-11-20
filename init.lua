local files = listFiles("services",false)
local i = 0

events.WORLD_TICK:register(function ()
   i = i + 1
   if i > #files then
      events.WORLD_TICK:remove("require")
      
      return
   end
   nameplate.ALL:setText('[{"text":"'..("|"):rep(i)..'","color":"green"},{"text":"'..("|"):rep(#files-i)..'","color":"dark_gray"},{"text":"\\n'..(files[i])..'","color":"white"}]')
   require(files[i])
end,"require")