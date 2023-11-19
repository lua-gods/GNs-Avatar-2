local tweenLib = require("libraries.GNTweenLib")

local lookup = {}

for id, anim in pairs(animations.player) do
   lookup[id] = {weight = 0,anim = anim}
end

function pings.emote(id,toggle)
   if toggle then
      lookup[id].anim:stop():play():blend(0)
      tweenLib.tweenFunction(lookup[id].weight,1,0.2,"inOutQuad",function (x)
         lookup[id].weight = x
         lookup[id].anim:blend(x)
      end,nil,"emote"..id)
   else
      tweenLib.tweenFunction(lookup[id].weight,0,0.4,"inQuad",function (x)
         lookup[id].weight = x
         lookup[id].anim:blend(x)
      end,function ()
         lookup[id].anim:stop()
      end,"emote"..id)
   end
end

if not host:isHost() then return end

local panel = require("libraries.panelLib.main")
local page = panel.newPage()

page.Placement = function (x, y, sx, sy, i)
   if i % 13 == 0 then
      return vectors.vec2(x+60,y+100)
   else
      return vectors.vec2(x,y-10)
   end
end

local elements = {
panel.newButton():setText('{"text":"EMOTES","color":"red"}'),
}

for id, anim in pairs(animations.player) do
   local loop = anim:getLoop()
   if loop == "LOOP" or loop == "HOLD" then
      local btn = panel.newToggleButton()
      btn.ON_TOGGLE:register(function (toggle)
         pings.emote(id,toggle)
      end)
      btn:setText('{"text":"'..anim:getName()..'","color":"default"}')
      elements[#elements+1] = btn
   else
      local btn = panel.newButton()
      btn.PRESSED:register(function ()
         pings.emote(id,true)
      end)
      btn:setText('{"text":"'..anim:getName()..'","color":"default"}')
      elements[#elements+1] = btn
   end
end

page:insertElement(elements)
page:insertElement(panel.newReturnButton())

return page