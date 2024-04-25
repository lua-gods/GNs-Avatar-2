local sidebar = require("host.sidebar")
local panels = require("libraries.panels")
local page = panels.newPage()

local scale = 10

return function ()
   local e = {
      panels.newToggle():setText("Enable"),
      panels.newSpinbox():setMaximumValue(50):setMinimumValue(5):setAcceptedValue(scale)
   }

   e[2].VALUE_CHANGED:register(function (v)
      scale = v or scale
   end)
   e[2].VALUE_ACCEPTED:register(function (v)
      scale = v or scale
   end)
   
   e[1].TOGGLED:register(function (t)
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
            renderer:setFOV(math.min(scale/math.max((pos-o):length(),0.01),1))
         end,"utilities.dynamicZoom")
      else
         events.TICK:remove("utilities.dynamicZoom")
         renderer:setFOV()
      end
   end)

   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   return page
end, "Dynamic Zoom", ":mag:","emoji"

