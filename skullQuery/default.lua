local plushie = models.plushie
models.plushie:setScale(0,0,0)


---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
   local model = plushie:copy(skull.id)
   skull.model:addChild(model)
   
   -- basic variables
   local offset = vec(0, 1, 0)
   local vec3 = vec(1, 1, 1)
   local vec2Half = vec(0.5, 0.5)
   local myUuid = avatar:getUUID()
   
   -- check for head
   local function isMyHead(bl)
      local data = bl:getEntityData()
      return data and data.SkullOwner and data.SkullOwner.Id and client.intUUIDToString(table.unpack(data.SkullOwner.Id)) == myUuid
   end
   
   local pos = skull.pos
   local floor = world.getBlockState(pos - offset)
   -- dont render when part of stack
   if isMyHead(floor) then
      return true
   else
      --stack
      local size = 1
      while isMyHead(world.getBlockState(pos + offset * size)) do
         size = size + 1
      end
      model:setScale(vec3 * size)
      -- move to floor
      if not skull.is_wall then
         if floor.id:match("stairs") and floor.properties and floor.properties.half == "bottom" then
            model:setPos(vectors.vec3(0, -8, -2))
         else
            local height = 0
            local shape = floor:getOutlineShape()
            for _, v in ipairs(shape) do
               if v[1].xz <= vec2Half and v[2].xz >= vec2Half then
                  height = math.max(height, v[2].y)
               end
            end
            if #shape >= 1 then
               model:setPos(0, height * 16 - 16, 0)
            else
               model:setPos(0, 0, 0)
            end
         end
      else
         model:setPos(0, 0, 0)
      end
   end
end

---@param skull WorldSkull
return function (skull)
   return new
end