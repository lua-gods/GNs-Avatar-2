
---@param sound Minecraft.soundID
---@param pitch number
---@param volume number
return function (sound,pitch,volume)
   sounds[sound]
   :pos(client:getCameraDir() * 100 + client:getCameraPos())
   :setAttenuation(9999)
   :setPitch(pitch)
   :volume(volume)
   :play()
end