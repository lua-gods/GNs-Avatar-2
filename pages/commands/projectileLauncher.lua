local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")

return function ()
   local page = panels.newPage()
   local e = {
      panels.newElement():setText({
         text = "Sniper",
         color = "red"
      }),
         panels.newButton():setIconText(":gun:",true):setText("Shoot"),
         panels.newTextEdit():setText("Entity"):setAcceptedValue("arrow"),
         panels.newSpinbox():setText("Power"):setAcceptedValue(10),
      }
      
      
   e[2].PRESSED:register(function ()
      local vel = player:getLookDir() * (e[4].value or 1)
      host:sendChatCommand(string.format("/summon %s ~ ~%s ~ {Fumse:10,life:1180,pickup:2,Motion:[%.01f,%.01f,%.01f],Owner:\"%s\",player:1b}", e[3].value, player:getEyeHeight(), vel.x, vel.y, vel.z, player:getUUID()))
   end)
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   page:setIcon(":gun:","emoji")

   page:setName("Projectile Launcher")
   page:setHeaderColor("#b92323")
   return page
end