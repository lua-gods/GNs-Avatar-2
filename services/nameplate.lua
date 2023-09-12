local username = avatar:getEntityName()
local json = require("libraries.panelLib.utils.json")
local composition = {{text="${badges}:@gn:"}}

local colorA = vectors.rgbToHSV(vectors.hexToRGB("#d3fc7e"))
local colorB = vectors.rgbToHSV(vectors.hexToRGB("#1e6f50"))

for i = 1, #username, 1 do
   composition[#composition+1] = {
      text = username:sub(i,i),
      color = "#"..vectors.rgbToHex(
         vectors.hsvToRGB(
         math.lerpAngle(colorA.x * math.pi,colorB.x * math.pi,i/#username) / math.pi,
         math.lerp(colorA.y,colorB.y,i/#username),
         math.lerp(colorA.z,colorB.z,i/#username)
      )
      )
   }
end

nameplate.ALL:setText(json.encode(composition))
nameplate.ENTITY:setOutline(true):setBackgroundColor(0,0,0,0)