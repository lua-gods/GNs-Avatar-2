local lookup = {
}

for i = 0, 15, 1 do
   local angle = -i * (360 / 16)
   lookup[tostring(i)] = angle
end

---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
   local block = world.getBlockState(skull.pos:copy():sub(0,1,0))
   local model = models.plushie.Hat:copy("unique_wow")
   local data = block:getEntityData()
   local owner = data and data.SkullOwner and data.SkullOwner.Id and client:intUUIDToString(table.unpack(data.SkullOwner.Id))
   skull.model_block:addChild(model)
   model:pos(8,-18,8)
   if owner then
      if world.avatarVars()[owner] and world.avatarVars()[owner].plushie_height then
         model:pos(8,-26+world.avatarVars()[owner].plushie_height,8):rot(0,lookup[block.properties.rotation],0)
      end
   end
end

---@param skull WorldSkull
return function (skull)
   if world.getBlockState(skull.pos:copy():sub(0,1,0)).id == "minecraft:player_head" then
      return new
   end
end