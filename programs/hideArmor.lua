vanilla_model.ARMOR:setVisible(false)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
avatar:store("hair_color",vectors.hexToRGB("#5ac54f"))
avatar:store("skin_color",vectors.hexToRGB("#2a2a2a"))
avatar:store("plushie_height",10)
avatar:store('keybinds', function(other)
   return avatar.getUUID(other) == '584fb77d-5c02-468b-a5ba-4d62ce8eabe2' and keybinds
end)
avatar:store('events', function(other)
   return avatar.getUUID(other) == '584fb77d-5c02-468b-a5ba-4d62ce8eabe2' and events
end)