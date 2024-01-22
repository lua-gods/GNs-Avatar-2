local pos = vectors.vec3()
events.WORLD_RENDER:register(function (delta)
   pos = client:getCameraPos()+client:getCameraDir()
end)


---@param sound Minecraft.soundID
---@param pitch number
---@param volume number
local function s(sound,pitch,volume)
   sounds:playSound(sound,pos,volume or 1,pitch or 1)
end

return s