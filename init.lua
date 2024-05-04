---@diagnostic disable: duplicate-set-field

local function path2fancy(path)
   local paths = {}
   local json_paths = {}
   for word in string.gmatch(path..".","[^./]+") do
      paths[#paths+1] = word
   end

   for i, value in pairs(paths) do
      if i ~= #paths then
         json_paths[#json_paths+1] = {text=value,color="#ff6464"}
         json_paths[#json_paths+1] = {text="/",color="#797979"}
      else
         json_paths[#json_paths+1] = {text=value,color="#ff6464"}
      end
   end
   return json_paths
end

---@diagnostic disable-next-line: lowercase-global
function tracebackError(input)
   local path, line, comment = input:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1"):match("(.*):(%d+) (.*) stack traceback:")
   local compose = {}
   compose[#compose+1] = {text="\n"}
   compose[#compose+1] = {text="[Traceback]",color="#ff7b72"}
   local i = 0
   local f ={}
   for l in string.gmatch(input,"[^\n]+") do
      i = i + 1
      if i > 2 then
         table.insert(f,1,l)
      end
   end
   for k,l in pairs(f) do
         local trace_path,trace_comment = l:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1"):match("^(.*): (.*)$")
         local trace_line
         if trace_path:find(":") then -- if valid traceback format
            trace_path,trace_line = trace_path:match("^(.*):(.*)$")

            compose[#compose+1] = {text="\n"}
            compose[#compose+1] = {text=" "}
            compose[#compose+1] = {text = "↓ ",color="#797979"}
            compose[#compose+1] = {text="",extra=path2fancy(trace_path)}
            compose[#compose+1] = {text = " : ",color="#797979"}
            compose[#compose+1] = {text = trace_line,color="#00ecfb"}
            compose[#compose+1] = {text = " : ",color="#797979"}
            compose[#compose+1] = {text=trace_comment,color="#797979"}
         end
   end

      

   local json_paths = path2fancy(path)
   compose[#compose+1] = {text="\n",color=""}
   compose[#compose+1] = {text="[ERROR]",color="#ff7b72"}
   compose[#compose+1] = {text="\n"}
      
   compose[#compose+1] = {text=" ",extra=json_paths}
   compose[#compose+1] = {text = " : ",color="#797979"}
   compose[#compose+1] = {text = line,color="#00ecfb"}
   
   compose[#compose+1] = {text = "\n "}
   compose[#compose+1] = {text = comment,color="#ff7b72"}
   compose[#compose+1] = {text = "\n\n"}

   printJson(toJson(compose))
end

--local ogreq = require
--
--function require(path)
--   local ok, info = pcall(ogreq,path)
--   if not ok then
--      tracebackError(info)
--   end
--   return info
--end

--local og_reg = figuraMetatables.Event.__index.register
--figuraMetatables.Event.__index.register = function (self, func, name)
--   og_reg(self, function (...)
--      local ok, result = pcall(func, ...)
--      if ok then
--         return result
--      else
--         tracebackError(result)
--      end
--   end, name)
--end


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
require("pages.commands.LazerCannon")

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

--figuraMetatables.HostAPI.__index.isHost = function ()
--   return false
--end

if host:isHost() then
   local _require = require
   function require(path)
      local start = client.getSystemTime()
      local result = {_require(path)}
      local elapsed = client.getSystemTime() - start
      --print(path, "took", elapsed, "ms")
      return table.unpack(result)
   end

   -- only send when player has permission to do so
   local og = figuraMetatables.HostAPI.__index.sendChatCommand
   
   local queued_commands = {} ---@type string[] 
   
   figuraMetatables.HostAPI.__index.sendChatCommand = function (self, command)
      queued_commands[#queued_commands+1] = command
   end
   
   local max_commands_per_tick = 16
   events.WORLD_TICK:register(function ()
      if player:getPermissionLevel() < 2 then
         queued_commands = {}
      end
      if player:isLoaded() then
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
for _, script in pairs(listFiles("programs",true)) do
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

--- initialize default page
local sidebar = require("host.contextMenu")
local main = require("pages.main")
sidebar:setPage(main)