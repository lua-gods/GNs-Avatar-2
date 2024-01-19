
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
for key, script in pairs(listFiles("services")) do
   require(script)
end

-- programs are the lowest level scripts, they use services and libraries
for key, script in pairs(listFiles("programs")) do
   require(script)
end

if not host:isHost() then return end
-- hosts are just programs but only runs on the host
for key, script in pairs(listFiles("host")) do
   require(script)
end