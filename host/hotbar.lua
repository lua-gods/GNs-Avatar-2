local gnui = require("libraries.gnui")
local screen = require("services.screenui")
local tween = require("libraries.GNTweenLib")
local hudSound = require("libraries.hudsound")

local config = {
   unselected_scale = 1,
   selected_scale = 1.5,
}

local hotbar = gnui.newContainer()

local slot_sprite = gnui.newSprite()
slot_sprite:setTexture(textures["textures.ui"])
slot_sprite:setUV(0,16,19,35)
slot_sprite:setRenderType("TRANSLUCENT_CULL")

local slot_tasks = {} --[[@type table<integer,ItemTask>]]
local slot_containers = {} --[[@type table<integer,GNUI.container>]]

for i = 1, 9, 1 do
   local e = i - 9/2 - 1
   local slot = gnui.newContainer()
   slot:setSprite(slot_sprite:duplicate())
   slot:setDimensions(e*20,0,20+e*20,20)
   slot_tasks[i] = slot.Part:newItem("item"):displayMode("GUI"):pos(-10,-10,-16)
   hotbar:addChild(slot)
   slot_containers[i] = slot
end
hotbar:setAnchor(0.5,0.5,0.5,0.5)
screen:addChild(hotbar)

local selected_slot = 0
local last_selected_slot = 0

events.TICK:register(function ()

   for i = 1, 9, 1 do
      local item = host:getSlot("hotbar."..(i-1))
      slot_tasks[i]:item(item)
   end

   local o = 0
   selected_slot = player:getNbt().SelectedItemSlot
   if last_selected_slot ~= selected_slot then
      last_selected_slot = selected_slot
      hudSound("minecraft:entity.player.attack.sweep",5,0.005)
      for i = 1, 9, 1 do
         local item = host:getSlot("hotbar."..(i-1))
         slot_tasks[i]:item(item)
         local slot = slot_containers[i]
         local h = (i-1 == selected_slot and -10 or 0)
         local d = vectors.vec4(o*20,h,20+o*20,20+h)
         local scale = slot.Part:getScale()
         local dim = slot.Dimensions:copy()
         if selected_slot == i-1 then
            tween.tweenFunction(0.1,"outBack",function (y)
               slot:setDimensions(
                  math.lerp(dim.x,d.x,y),
                  math.lerp(dim.y,d.y,y),
                  math.lerp(dim.z,d.z,y),
                  math.lerp(dim.w,d.w,y)
               )
               slot.Part:scale(math.lerp(scale.x,config.selected_scale,y),math.lerp(scale.y,config.selected_scale,y))
            end,nil,"hotbarslot"..i)
            o = o + config.selected_scale
         else
            o = o + config.unselected_scale
            tween.tweenFunction(0.1,"outBack",function (y)
               slot:setDimensions(
                  math.lerp(dim.x,d.x,y),
                  math.lerp(dim.y,d.y,y),
                  math.lerp(dim.z,d.z,y),
                  math.lerp(dim.w,d.w,y)
               )
               slot.Part:scale(math.lerp(scale.x,config.unselected_scale,y),math.lerp(scale.y,config.unselected_scale,y))
            end,nil,"hotbarslot"..i)
         end
      end
   end
end)