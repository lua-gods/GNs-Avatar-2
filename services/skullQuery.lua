if avatar:getPermissionLevel() ~= "MAX" and client:getVersion() ~= "1.20.4" then models.plushie:setVisible(false) return end
local skull_handler = require("services.skullHandler")
local eventLib = require("libraries.eventLib")

---@class SkullEvents
---@field INIT eventLib
---@field TICK eventLib
---@field FRAME eventLib
---@field EXIT eventLib

local queries = listFiles("skullQuery")
local last_resort = "skullQuery.default"
local query_checks = {}
local skulls = {}

for _, path in pairs(queries) do
   if last_resort ~= path then
      query_checks[#query_checks+1] = require(path)
   end
end
query_checks[#query_checks+1] = require(last_resort)

---@param skull WorldSkull
skull_handler.INIT:register(function (skull)
   local api = {
      TICK = eventLib.new(),
      FRAME = eventLib.new(),
      EXIT = eventLib.new()
   }
   for key, value in pairs(query_checks) do
      local result = value(skull) -- query check
      if result then
         result(skull,api)
         break
      end
   end
   skulls[skull.pos] = {skull=skull,api=api}
end)

---@param skull WorldSkull
skull_handler.EXIT:register(function (skull)
   if skulls[skull.pos].api then
      if skulls[skull.pos].api.EXIT then
         skulls[skull.pos].api.EXIT:invoke()
      end
      skulls[skull.pos] = nil
   end
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
