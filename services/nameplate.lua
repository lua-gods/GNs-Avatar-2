local config = {
   sync_wait_time = 20,
}

local username = ""
--local colorA = vectors.rgbToHSV(vectors.hexToRGB("#edab50"))
--local colorB = vectors.rgbToHSV(vectors.hexToRGB("#8e251d"))

local colorA = vectors.rgbToHSV(vectors.hexToRGB("#d3fc7e"))
local colorB = vectors.rgbToHSV(vectors.hexToRGB("#1e6f50"))

--composition[#composition+1] = {text="[AFK : 15s]",color="gray"}
--composition[#composition+1] = {text="\n"}



local function update()
   local composition = {}
   composition[#composition+1] = {text="${badges}:@gn:"}
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
   nameplate.ALL:setText(toJson(composition))
   nameplate.ENTITY:setOutline(true):setBackgroundColor(0,0,0,0)
end

if host:isHost() then
   local sync_name_timer = config.sync_wait_time
   events.TICK:register(function ()
      sync_name_timer = sync_name_timer - 1
      if sync_name_timer < 0 then
         sync_name_timer = config.sync_wait_time
         pings.syncName(avatar:getEntityName())
      end
   end)
end

function pings.syncName(name)
   username = name
   update()
end