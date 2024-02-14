--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
local config = {
   sync_wait_time = 20, -- ticks, second * 20 = ticks
   gn_command_handler_library = "services.commandHandler" -- optional
}

local username = avatar:getEntityName()

local default_colors = {
   vectors.hexToRGB("#5ac54f"),
   vectors.hexToRGB("#d3fc7e"),
   vectors.hexToRGB("#5ac54f"),
   vectors.hexToRGB("#1e6f50"),
}

local colors = default_colors
nameplate.ENTITY:setOutline(true):setBackgroundColor(0,0,0,0)

-->====================[ Mixing Styles ]====================<--

--- fallback of mix_gn_fancy wasnt working as wanted.
---@param clrA Vector3
---@param clrB Vector3
---@param i number
---@return Vector3
local function mix_linear(clrA,clrB,i)
---@diagnostic disable-next-line: return-type-mismatch
   return math.lerp(clrA,clrB,i)
end

---Mixes Multiple colors.
---@param i number
---@param subcolor table<any,Vector3>
---@return Vector3
local function multi_mix(i,subcolor)
   i = i * (#subcolor-1) + 1
   return mix_linear(subcolor[math.floor(i)],subcolor[math.min(math.floor(i+1),#subcolor)],i%1) -- replace mix_gn_fancy with mix_linear
end

-->====================[ Rest ]====================<--

-- Generates a json text for minecraft to interpret as gradient text.
local function generate_gradient_text()
   avatar:color(colors[1])
   local final = {}
   final[#final+1] = {text="${badges}"}
   final[#final+1] = {font="figura:emoji_portrait",text=""} -- top hat
   for i = 1, #username, 1 do
      final[#final+1] = {
         text = username:sub(i,i),
         color = "#"..vectors.rgbToHex(multi_mix(i/#username,colors))
      }
   end
   return toJson(final)
end

function pings.syncName(name,...)
   colors = {...}
   if not host:isHost() then  username = name end
   local final = generate_gradient_text()
   nameplate.ALL:setText(final)
end


-- Host only things that will sync data to non host view of this avatar.
if not host:isHost() then return end
local OK,command = pcall(require, config.gn_command_handler_library)
pings.syncName(username,table.unpack(colors))


-- every config.sync_wait_time, the timer triggers to sync the name to everyone
local timer
timer = config.sync_wait_time
events.TICK:register(function ()
   timer = timer - 1
   if timer < 0 then
      timer = config.sync_wait_time
      pings.syncName(username,table.unpack(colors))
   end
end)

if OK then -- if the library
   command.register(function (words)
      if words[1] == "nick" then
         timer = 0
         if words[2] then
            username = words[2]words[2]:sub(1,255)
            command.announce("renamed to "..username)
         else
            username = avatar:getEntityName()
            command.announce("resetted username")
         end
      elseif words[1] == "clr" then
         timer = 0
         if words[2] then
            local converted = {}
            for word in string.gmatch(words[2],"#[%w]+") do
               converted[#converted+1] = vectors.hexToRGB(word)
            end
            colors = converted
            command.announce("updated colors")
         else
            colors = default_colors
            command.announce("resetted username")
         end
      end
   end)
end