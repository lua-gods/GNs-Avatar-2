
--[[
do
   local r = require
   function require(a, b, ...)
      local t = avatar:getCurrentInstructions()
      local l = {r(a, b, ...)}
      local s = avatar:getCurrentInstructions() - t - 10
      if s >= 1 then
         print(a, s)
      end
      return table.unpack(l)
   end
end]]

local repetitiveness = 0
local last_sound = ""
function pings.playSound(x,y,z,sound,pitch)
   local pos = player:getPos():add(x,y,z)
   if last_sound ~= sound then
      last_sound = sound
      repetitiveness = 0
   end
   repetitiveness = repetitiveness + 1
   if repetitiveness == 1 then
      sounds[sound]:pos(pos):attenuation(3):volume(0.25):play()
   else
      sounds[sound]:pos(pos):attenuation(3):volume(0.01):play()
   end
end

local function sound(x,y,z,sond,pitch)
   if player:isLoaded() then
      local pos = vectors.vec3(x,y,z):sub(player:getPos())
      pings.playSound(pos.x,pos.y,pos.z,sond,pitch)
   end
end

if host:isHost() then
   -- only send when player has permission to do so
   local og = figuraMetatables.HostAPI.__index.sendChatCommand
   
   local queued_commands = {} ---@type string[] 
   
   ---@diagnostic disable-next-line: duplicate-set-field
   figuraMetatables.HostAPI.__index.sendChatCommand = function (self, command)
      queued_commands[#queued_commands+1] = command
   end
   
   local max_commands_per_tick = 16
   events.WORLD_TICK:register(function ()
      if player:isLoaded() and player:getPermissionLevel() >= 2 then
         for i = 1, math.min(#queued_commands,max_commands_per_tick), 1 do
            local cmd = queued_commands[1]
            og(host,cmd)
            --if cmd:find("^/?setblock") then
            --   local x,y,z,block = cmd:match("^/?setblock (~?[%d.]+) (~?[%d.]+) (~?[%d.]+) ([%S]+)")
            --   sound(x,y,z,world.newBlock(block):getSounds().place,0.8)
            --end
            table.remove(queued_commands,1)
         end
      end
   end)
end



-- services are called first, as they are potentially used by programs, but they use libraries
for key, script in pairs(listFiles("services",true)) do
   require(script)
end

-- programs are the lowest level scripts, they use services and libraries
for key, script in pairs(listFiles("programs",true)) do
   require(script)
end


local t = require("libraries.utils")

for key, metatable in pairs(figuraMetatables) do
   figuraMetatables[key] = t.makeTableReadOnly(metatable)
end


local function loopTable(table,i)
   table = t.makeTableReadOnly(table)
   if i > 50 then
      return
   end
   for key, value in pairs(table) do
      if type(value) == "table" then
         loopTable(value,i+1)
      end
   end
end
loopTable(_G, 1)

if not host:isHost() then return end
-- hosts are just programs but only runs on the host
for key, script in pairs(listFiles("host",true)) do
   require(script)
end