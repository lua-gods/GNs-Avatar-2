local tweenLib = require("libraries.GNTweenLib")

local emotes = {
   {
      name = "Clipping",
      anim = animations.player.clip:speed(2),
      sound = "clipping"
   },{
      name = "Kazotsky kick",
      anim = animations.player.Kazotskykick,
   },{
      name = "Kazotsky kick2",
      anim = animations.player.Kazotskykick2,
   },{
      name = "Club Penguin",
      anim = animations.player.clubpenguin,
   },{
      name = "Shake",
      anim = animations.player.duckDance:setSpeed(1),
   },{
      name = "Shake Smooth",
      anim = animations.player.duckDance2:setSpeed(1),
   },{
      name = "T Pose",
      anim = animations.player.tpose,
   },{
      name = "Sit Down",
      anim = animations.player.sit,
   },{
      name = "Sit Shame",
      anim = animations.player.sitShame,
   },{
      name = "Roblox death",
      anim = animations.player.roblox,
   },{
      name = "Carramel Dancen",
      anim = animations.player.carrameldancen,
   },{
      name = "Family guy Toilet",
      anim = animations.player.Toilet,
   },{
      name = "Spin",
      anim = animations.player.spin,
      sound = "lovely",
   },{
      name = "Morph Cow",
      anim = animations.player.cow,
   },{
      name = "Morph Penguin",
      anim = animations.player.penguin,
   }
}

for id, anim in pairs(emotes) do
   emotes[id].weight = 0
   if emotes[id].sound then
      emotes[id].sound = sounds[emotes[id].sound]:loop(true)
   end
   emotes[id].playing = false
end

function pings.emote(id,toggle,canplay)
   if toggle then
      emotes[id].anim:stop():play():blend(0)
      tweenLib.tweenFunction(emotes[id].weight,1,0.2,"inOutQuad",function (x)
         emotes[id].weight = x
         emotes[id].anim:blend(x)
      end,nil,"emote"..id)
      if emotes[id].sound and canplay then
         emotes[id].sound:play()
      end
      emotes[id].playing = true
   else
      tweenLib.tweenFunction(emotes[id].weight,0,0.2,"inOutQuad",function (x)
         emotes[id].weight = x
         emotes[id].anim:blend(x)
      end,function ()
         emotes[id].anim:stop()
      end,"emote"..id)
      if emotes[id].sound then
         emotes[id].sound:stop()
      end
      emotes[id].playing = false
   end
end

events.TICK:register(function ()
   local pos = player:getPos()
   for key, emote in pairs(emotes) do
      if emote.playing and emote.sound then
         emote.sound:pos(pos)
      end
   end
end)

if not host:isHost() then return end

local panel = require("libraries.panelLib.main")
local page = panel.newPage()

local first_row = 25
local rest_row = 20

page.Placement = function (x, y, sx, sy, i)
   if i <= first_row and ((i-1) % (first_row-1) == 0 and i ~= 1) or (i > first_row and ((i-1-(first_row-1)) % rest_row == 0) and i ~= 1) then
      if i > first_row then
         return vectors.vec2(x+60,y+rest_row * 10 - 10)
      else
         return vectors.vec2(x+60,y+(first_row * 10 - 20))
      end
   else
      return vectors.vec2(x,y-10)
   end
end

local mute_button = panel.newToggleButton():setText('{"text":"Mute","color":"default"}')

local elements = {
panel.newButton():setText('{"text":"EMOTES","color":"red"}'),
mute_button,
panel.newButton():setText('{"text":""}'),
}

mute_button.ON_TOGGLE:register(function (toggle)
   if toggle then
      
   end
end)

for id, emote in pairs(emotes) do
   local loop = emote.anim:getLoop()
   if loop == "LOOP" or loop == "HOLD" then
      local btn = panel.newToggleButton()
      btn.ON_TOGGLE:register(function (toggle)
         pings.emote(id,toggle,not mute_button.Toggle)
      end)
      btn:setText('{"text":"'..emote.name..'","color":"default"}')
      elements[#elements+1] = btn
   else
      local btn = panel.newButton()
      btn.PRESSED:register(function ()
         pings.emote(id,true,not mute_button.Toggle)
      end)
      btn:setText('{"text":"'..emote.name..'","color":"default"}')
      elements[#elements+1] = btn
   end
end

page:insertElement(elements)
page:insertElement(panel.newReturnButton())
local die = panel.newButton()
die.PRESSED:register(function ()
   pings.NOW()
end)
page:insertElement(die)
return page