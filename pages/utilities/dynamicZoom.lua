local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local page = panels.newPage()

local scale = 10
local final = 1

local e = {
   panels.newElement():setText({
      text = "DYNAMIC ZOOM",
      color = "red"
   }),
   panels.newToggle():setText("Enable"),
   panels.newSpinbox():setMaximumValue(50):setMinimumValue(5):setAcceptedValue(scale),
   panels.newElement():setText({
      text = "x1",
      color = "gray"
   }),
}

e[4].label:setAlign(1,0)

e[3].VALUE_CHANGED:register(function (v)
   scale = v or scale
end)
e[3].VALUE_ACCEPTED:register(function (v)
   scale = v or scale
end)

e[2].TOGGLED:register(function (t)
   if t then
      events.TICK:register(function ()
         local o = player:getPos():add(0,player:getEyeHeight())
      ---@diagnostic disable-next-line: missing-parameter
         local block,pos = raycast:block(o,o+player:getLookDir()*100)
      ---@diagnostic disable-next-line: missing-parameter
         local entity,epos = raycast:entity(o,o+player:getLookDir()*100,function (entity)
            return entity ~= player
         end)
         if entity then
            pos = epos
         end
         final = math.min(scale/math.max((pos-o):length(),0.01),1)
         renderer:setFOV(final)
      end,"utilities.dynamicZoom")
   else
      events.TICK:remove("utilities.dynamicZoom")
      renderer:setFOV()
      final = 1
   end
end)

page:addElement(table.unpack(e))
page:addElement(sidebar.newReturnButton())

page:setIcon(":mag:","emoji")
return page
