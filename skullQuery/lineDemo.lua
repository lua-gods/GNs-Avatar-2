local lineLib = require("libraries.GNLineLib")

---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
   lineLib.new()
end

---@param skull WorldSkull
return function (skull)
   if world.getBlockState(skull.pos:copy():sub(0,2)).id == "minecraft:emerald_block"
   and world.getBlockState(skull.pos:copy():sub(0,3)).id == "minecraft:red_wool" then
      return new
   end
end