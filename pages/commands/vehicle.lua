local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
return function ()
   local page = panels.newPage()
   
   local e = {
         panels.newButton():setText("Ride Selected"),
      }
      
   e[2].PRESSED:register(function ()
      local selected = player:getTargetedEntity(5)
      if selected then
         host:sendChatCommand("/ride @s mount "..selected:getUUID())
      end
   end)
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   page:setIcon(":truck:","emoji")

   page:setName("Projectile Launcher")
   page:setHeaderColor("#ad6060")
   return page
end