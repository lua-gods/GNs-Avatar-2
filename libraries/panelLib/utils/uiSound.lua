
---@param sound Minecraft.soundID
---@param pitch number
---@param volume number
return function (sound,pitch,volume)
   sounds[sound]
   :pos(client:getCameraDir()+client:getCameraPos())
   :setAttenuation(999)
   :setPitch(pitch)
   :volume(volume)
   :play()
end