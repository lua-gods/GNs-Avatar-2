---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
   local p = skull.pos:copy():div(3,3,3):floor()

   -- checkered pattern
   if p.x % 2 ~= p.z % 2 then
      skull.model_block:newBlock("lol"):block("minecraft:snow_block"):pos(0,-8,0)
   else
      skull.model_block:newBlock("lol"):block("minecraft:white_concrete"):pos(0,-8,0)
   end
end

---@param skull WorldSkull
return function (skull)
   if skull.pos.y == 319 then
      return new
   end
end