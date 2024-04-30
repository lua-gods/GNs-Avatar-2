local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
return function ()
   local page = panels.newPage()

local scale = 5
local final = 1
local final_goal = 1
local active = false

local e = {
   panels.newToggle():setText("Enable"),
   panels.newToggle():setText("Auto Zoom"),
   panels.newSpinbox():setMaximumValue(100):setMinimumValue(1):setAcceptedValue(scale),
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

e[1].TOGGLED:register(function (t)
   if t and not active then
      active = true
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
         if e[1].toggle then
            if e[2].toggle then
               final_goal = math.min((20/scale)/math.max((pos-o):length(),0.01),1)
            else
               final_goal = 1/scale
            end
         else
            final_goal = 1
         end
         local speed = 0.1 * final
         final = final + math.clamp((final_goal - final),-speed,speed)
         renderer:setFOV(final)
         if not e[1].toggle then
            if final_goal == final then
               active = false
               events.TICK:remove("utilities.dynamicZoom")
               renderer:setFOV()
            end
         end
      end,"utilities.dynamicZoom")
   end
end)

page:addElement(table.unpack(e))
page:addElement(sidebar.newReturnButton())

page.TICK:register(function ()
   if not e[1].toggle then return end
   e[4]:setText({
      text = "x"..(math.floor((1 / final) * 10 + 0.5) / 10),
      color = "gray"
   })
end)

page:setIcon(":mag:","emoji")
page:setName("Camera Zoom")
page:setHeaderColor("#3777b3")
return page
end