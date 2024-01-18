
local itemModel = models.tinyhat.item:scale(1.2,1.2,1.2)
local headModel = models.tinyhat.head:scale(1.15,1.15,1.15)

local AMBIENT = vectors.hexToRGB("#14462b")

itemModel:setParentType("Skull")
headModel:setParentType("Skull")
local avatarVars = {}
events.SKULL_RENDER:register(function (delta, block, item, entity, context)
   if context == "HEAD" then
      if entity:getType() == "minecraft:player" and avatarVars[entity:getUUID()] then
         local vars = avatarVars[entity:getUUID()]
         local color = vars.color or "#5ac54f"
         local height = vars.hat_height and tonumber(vars.hat_height) or 7
         if type(color) == "string" then
            color = vectors.hexToRGB(color)
         end
         headModel.cylinder:setScale(1,height or 10,1)
         headModel.ribbon.shade4:setColor(color)
         headModel.ribbon.shade3:setColor(math.lerp(color,AMBIENT,0.2))
         headModel.ribbon.shade2:setColor(math.lerp(color,AMBIENT,0.4))
         headModel.ribbon.shade1:setColor(math.lerp(color,AMBIENT,0.6))
      end
      headModel:setVisible(true)
      itemModel:setVisible(false)
   elseif context == "BLOCK" then
      headModel:setVisible(false)
      itemModel:setVisible(false)
   else
      headModel:setVisible(false)
      itemModel:setVisible(true)
   end
end)


events.WORLD_RENDER:register(function (delta)
   avatarVars = world.avatarVars()
end)