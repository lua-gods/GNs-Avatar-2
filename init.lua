
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

-- services are called first, as they are potentially used by programs, but they use libraries
for key, script in pairs(listFiles("services",true)) do
   require(script)
end

-- programs are the lowest level scripts, they use services and libraries
for key, script in pairs(listFiles("programs",true)) do
   require(script)
end



-- only send when player has permission to do so
local og = figuraMetatables.HostAPI.__index.sendChatCommand
---@diagnostic disable-next-line: duplicate-set-field
figuraMetatables.HostAPI.__index.sendChatCommand = function (self, command)
   if player:isLoaded() and player:getPermissionLevel() >= 2 then
      og(self,command)
   end
end


local t = require("libraries.tableUtils")

for key, metatable in pairs(figuraMetatables) do
   figuraMetatables[key] = t.makeReadOnly(metatable,type(metatable) == "table" and getmetatable(metatable) or nil)
end


local function loopTable(table,i)
   table = t.makeReadOnly(table,getmetatable(table))
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