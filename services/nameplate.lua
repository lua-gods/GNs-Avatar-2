local username = avatar:getEntityName()
local json = require("libraries.panelLib.utils.json")
local composition = {}

for i = 1, #username, 1 do
   composition[i] = {text = username:sub(i,i)}
end
local cache = {}
for i = 1, 30, 1 do cache[i] = "#".. vectors.rgbToHex(math.random(),math.random(),math.random()) end

events.TICK:register(function ()
   for i = 1, #username, 1 do
      composition [i].color = cache[math.random(1,#cache)]
   end
   nameplate.ALL:setText(json.encode(composition))
end)