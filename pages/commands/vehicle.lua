local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local page = panels.newPage()
   
local e = {
   panels.newElement():setText({
      text = "Vehicle",
      color = "red"
   }),
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
page:setIcon(":gun:","emoji")
return page