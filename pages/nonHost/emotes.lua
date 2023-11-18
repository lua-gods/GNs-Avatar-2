local panel = require("libraries.panelLib.main")
local page = panel.newPage()
local tweenLib = require("libraries.GNTweenLib")
local elements = {
panel.newButton():setText('{"text":"EMOTES","color":"red"}'),
}

local lookup = {}

function pings.emote(id,toggle)
   if toggle then
      lookup[id].anim:play():blend(0)
      tweenLib.tweenFunction(lookup[id].weight,1,0.2,"inOutQuad",function (x)
         lookup[id].weight = x
         lookup[id].anim:blend(x)
      end,nil,"emote"..id)
   else
      tweenLib.tweenFunction(lookup[id].weight,0,0.2,"inOutQuad",function (x)
         lookup[id].anim:blend(x)
      end,function ()
         lookup[id].anim:stop()
      end,"emote"..id)
   end
end

for id, anim in pairs(animations.player) do
   lookup[id] = {weight = 0,anim = anim}
   local btn = panel.newToggleButton()
   btn.ON_TOGGLE:register(function (toggle)
      pings.emote(id,toggle)
   end)
   btn:setText('{"text":"'..anim:getName()..'","color":"default"}')
   elements[#elements+1] = btn
end

page:insertElement(elements)
page:insertElement(panel.newReturnButton())

return page