local skull_handler = require("services.skullHandler")
local eventLib = require("libraries.eventLib")

---@class SkullEvents
---@field INIT EventLib
---@field TICK EventLib
---@field FRAME EventLib
---@field EXIT EventLib

local queries = listFiles("skullQuery")
local query_checks = {}
local skulls = {}

for _, path in pairs(queries) do
   query_checks[path] = require(path)
end

---@param skull WorldSkull
skull_handler.INIT:register(function (skull)
   local api = {
      TICK = eventLib.new(),
      FRAME = eventLib.new(),
      EXIT = eventLib.new()
   }
   for key, value in pairs(query_checks) do
      local result = value() -- query check
      if result then
         result(skull,api)
      end
   end
   skulls[skull.pos] = {skull=skull,api=api}
end)

---@param skull WorldSkull
skull_handler.EXIT:register(function (skull)
   skulls[skull.pos].api.EXIT:invoke()
   skulls[skull.pos] = nil
end)


local systime = client:getSystemTime()
events.WORLD_TICK:register(function()
   for id, s in pairs(skulls) do
      s.api.TICK:invoke(s.skull)
   end
end)


events.WORLD_RENDER:register(function (delta_tick)
   local t = client:getSystemTime() / 1000
   local delta_frame = t-systime
   systime = t
   for _, s in pairs(skulls) do
      s.api.FRAME:invoke(s.skull,delta_tick,delta_frame)
   end
end)
