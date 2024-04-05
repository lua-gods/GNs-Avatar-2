--[[______   __
  / ____/ | / /
 / / __/  |/ /
/ /_/ / /|  /
\____/_/ |_/ ]]


---@param id Minecraft.soundID
---@param offset Vector3
---@param pitch number?
function pings.playsound(id,offset,pitch)
   if player:isLoaded() then
      sounds:playSound(id,player:getPos():add(offset),1,pitch or 1)
   end
end
if not host:isHost() then return end
local selection = models:newPart("shulkerblock_selection","WORLD")
selection:newBlock("selection"):block("minecraft:white_stained_glass"):scale(1.02,1.02,1.02):pos(-0.01,-0.01,-0.01)



local inputs = {
   place = keybinds:newKeybind("shulkerblock place","key.mouse.right"),
   destroy = keybinds:newKeybind("shulkerblock break","key.mouse.left")
}

local blocks = {}
for key, block in pairs(client.getRegistry("minecraft:block")) do
   blocks[block] = true
end

local function posToTag(pos)
   return 'block'..table.concat({pos:copy():floor():unpack()}):gsub('%-', 'n')
end

local place_axis = 0
local facing = "up"
local bpos
local break_offset
local place_offset


inputs.place.press = function ()
   if not (host:getScreen() or host:isChatOpen()) and bpos and player:isLoaded() then
      local held = player:getHeldItem()
      if blocks[held.id == "minecraft:air" and "aa" or held.id] then
         host:sendChatCommand(string.format('/summon shulker %i %i %i {Silent:1,NoAI:1,Health:1,ActiveEffects:[{Id:14,Duration:-1,Amplifier:0,ShowParticles:0b},{Id:11,Duration:-1,Amplifier:255,ShowParticles:0b}],Tags:["%s"]}',bpos.x + place_offset.x,bpos.y + place_offset.y,bpos.z + place_offset.z,posToTag(bpos + place_offset)))
         host:sendChatCommand(string.format('/summon block_display %i.0 %i %i.0 {block_state:{Name:"%s",Properties:{axis:"%s",facing:"%s"}},brightness:{sky:15,block:10},Tags:["%s"]}',bpos.x + place_offset.x,bpos.y + place_offset.y,bpos.z + place_offset.z,held.id,place_axis,facing,posToTag(bpos + place_offset)))
         host:swingArm()
         pings.playsound(world.newBlock(held.id):getSounds().place,bpos + place_offset - player:getPos(),0.8)
      end
   end
end

inputs.destroy.press = function ()
   local held = player:getHeldItem()
   if not (held.id:find("_axe") or held.id:find("_sword") or held.id:find("_trident")) and player:isLoaded() then
      if not (host:getScreen() or host:isChatOpen()) and bpos then
         host:sendChatCommand(string.format('/execute as @e[type=shulker,x=%i.5,y=%i.5,z=%i.5,distance=..1,nbt={Tags:["%s"]}] at @s run tp @s ~ -9999 ~',bpos.x + break_offset.x,bpos.y + break_offset.y,bpos.z + break_offset.z,posToTag(bpos + break_offset)))
         host:sendChatCommand(string.format('/kill @e[x=%i.5,y=%i.5,z=%i.5,distance=..1,nbt={Tags:["%s"]}]',bpos.x + break_offset.x,bpos.y + break_offset.y,bpos.z + break_offset.z,posToTag(bpos + break_offset)))
         host:swingArm()
         pings.playsound(world.newBlock(held.id):getSounds()["break"],bpos + place_offset - player:getPos(),0.8)
      end
   end
end

events.TICK:register(function ()
   local entity,pos = player:getTargetedEntity()
   if entity and entity:getType() == "minecraft:shulker" then
      -- shift selection to the block in front of the face intersecting only
      bpos = pos:copy():floor()
      local diff = (pos - entity:getPos():add(0,0.5))
      local adiff = vectors.vec3(math.abs(diff.x),math.abs(diff.y),math.abs(diff.z))
      
      place_offset = vectors.vec3()
      break_offset = vectors.vec3()
      if adiff.x > adiff.y and adiff.x > adiff.z then
         local v = math.sign(diff.x) * 0.5 - 0.5
         place_offset:add(v,0,0)
         place_axis = "x"
         break_offset:sub(v+1,0,0)
         if v == 0 then
            facing = "west"
         else
            facing = "east"
         end
      end
      if adiff.y > adiff.x and adiff.y > adiff.z then
         local v = math.sign(diff.y) * 0.5 - 0.5
         place_offset:add(0,math.sign(diff.y) * 0.5 - 0.5,0)
         place_axis = "y"
         break_offset:sub(0,v+1,0)
         if v == 0 then
            facing = "down"
         else
            facing = "up"
         end
      end
      if adiff.z > adiff.x and adiff.z > adiff.y then
         local v = math.sign(diff.z) * 0.5 - 0.5
         place_offset:add(0,0,v)
         place_axis = "z"
         break_offset:sub(0,0,v+1)
         if v == 0 then
            facing = "north"
         else
            facing = "south"
         end
      end

      selection:setPos((bpos + break_offset) * 16):visible(true)
   else
      selection:visible(false)
   end
end)