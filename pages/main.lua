local panel = require("libraries.panelLib.main")
local page = panel.newPage()

local getNameplate = require("services.nameplate")

local nametagName = panel.newButton():setText('{"text":"Nameplate to Nametag","color":"default"}')
nametagName.PRESSED:register(function ()
   local name = getNameplate()
   table.insert(name,1,{text="",italic=false})
   for key, value in pairs(name) do
      if value.text == "${badges}" then
         name[key] = {font="figura:badges",text="△",color="#"..avatar:getColor()}
      end
   end
   
   host:setSlot(player:getNbt().SelectedItemSlot,[[minecraft:name_tag{display:{Name:']]..toJson(name)..[['}}]])
   sounds:playSound("minecraft:entity.item.pickup",client:getCameraPos():add(client:getCameraDir()))
end)

local elements = {

panel.newButton():setText('[{"text":"Just GN v3","color":"green"}]'),
panel.newPageButton():setText('{"text":"Emotes","color":"default"}'):setRedirectPage(require("pages.nonHost.emotes")),
nametagName
}
page:insertElement(elements)
return page