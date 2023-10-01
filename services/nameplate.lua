local username = avatar:getEntityName()
local composition = {}
local afk_label = {}

avatar:color(vectors.hexToRGB("#edab5"))
local colorA = vectors.rgbToHSV(vectors.hexToRGB("#edab50"))
local colorB = vectors.rgbToHSV(vectors.hexToRGB("#8e251d"))

--local colorA = vectors.rgbToHSV(vectors.hexToRGB("#d3fc7e"))
--local colorB = vectors.rgbToHSV(vectors.hexToRGB("#1e6f50"))

composition[#composition+1] = {text="[AFK : 15s]",color="gray"}
composition[#composition+1] = {text="\n"}

composition[#composition+1] = {text="${badges}:@scarlet:"}
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

avatar:store("color",vectors.hexToRGB("e07438"))

nameplate.ALL:setText(toJson(composition))
nameplate.ENTITY:setOutline(true):setBackgroundColor(0,0,0,0)

