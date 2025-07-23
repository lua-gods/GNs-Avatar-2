local lineLib = require("libraries.GNLineLib")
local input = keybinds:newKeybind("weapon.use","key.mouse.middle")

local enabled = false
local shooting = false

if not host:isHost() then
   enabled = true
end

local scale = 500
local s = 0

local lazer = {
   lineLib.new(),
   lineLib.new():setWidth(0.5):setColor(0,1,0):setDepth(0.1),
   lineLib.new():setWidth(1):setColor(0,1,0,0.2):setDepth(0.1):setRenderType("CUTOUT_EMISSIVE_SOLID"),
   lineLib.new():setWidth(2):setColor(0,1,0,0.1):setDepth(0.2):setRenderType("CUTOUT_EMISSIVE_SOLID"),
}

function pings.shootingLazer(toggle)
   s = 0
   shooting = toggle
   for key, line in pairs(lazer) do
      line:setVisible(toggle)
   end
end

input.press = function ()
   if enabled then
      pings.shootingLazer(true)
      return true
   end
end

input.release = function ()
   if enabled then
      pings.shootingLazer(false)
   end
end

local function r(a,b)
   return math.lerp(a,b,math.random())
end

events.WORLD_RENDER:register(function (dt)
   if player:isLoaded() then
      if shooting then
         local height = player:getEyeHeight()
         local from = player:getPos(dt):add(0,height)
         local to = from + player:getLookDir() * 500
         local block,pos = raycast:block(from,to)
         if host:isHost() and renderer:isFirstPerson() then
            from:sub(0,height * 0.5)
         end
         for key, line in pairs(lazer) do
            line:setA(from):setB(pos)
         end
         s = math.min(math.lerp(s,scale,0.0001),4)
         lazer[4]:setWidth(math.lerp(1,3,math.random()) * s)
         lazer[3]:setWidth(math.lerp(1,3,math.random()) * s)
         lazer[2]:setWidth(math.lerp(0.5,1,math.random()) * s)
         lazer[1]:setWidth(math.lerp(0.25,0.5,math.random()) * s)
         
         particles:newParticle("minecraft:flash",pos):color(0,1,0)
         
         local len = math.max((from-pos):length() / 16,1)
         for i = 1, len, 1 do
            local sp = math.lerp(from,pos,i / len)
            sounds["minecraft:particle.soul_escape"]:pos(sp):pitch(r(0.4,0.6)):attenuation(4):play()
            sounds["minecraft:entity.lighting_bolt.thunder"]:pos(sp):pitch(r(0.4,0.6)):attenuation(4):play()
            sounds["minecraft:block.beacon.mood"]:pos(sp):pitch(r(1.8,2.8)):attenuation(4):play()
            sounds["minecraft:block.beacon.ambient"]:pos(sp):pitch(r(2.8,3.3)):attenuation(4):play()
            sounds["minecraft:entity.elder_guardian.ambient"]:pos(sp):pitch(r(2.8,3.4)):attenuation(4):play()
            sounds["minecraft:entity.ghast.shoot"]:pos(sp):pitch(r(0.3,0.5)):attenuation(4):play()
         end
         
         local dir = (to-from):normalize()
         if player:getPermissionLevel() > 2 then
            for i = 0, 64, 16 do
               local p = pos + dir * i + vectors.vec3((math.random()-0.5) * 0.5 * s * 2,(math.random()-0.5) * 0.5 * s * 2,(math.random()-0.5) * 0.5 * s * 2)
               host:sendChatCommand(string.format("/summon tnt %.2f %.2f %.2f {Fuse:-1,Invunerable:1b,ExplosionRadius:%i}",p.x,p.y,p.z,math.clamp(s,1,16)))
            end
         end
         --host:sendChatCommand(string.format("/playsound minecraft:entity.generic.explode block @a %.2f %.2f %.2f",pos.x,pos.y,pos.z))
      end
   end
end)

if not host:isHost() then return end

local sidebar = require("host.contextMenu")
local elements = require("libraries.panels")

return function ()
   local page = elements.newPage()
   local e = {
      elements.newElement():setText({text="Lazer Test",color = "red"}),
      elements.newToggle():setText("Lazer Cannon"),
      sidebar.newReturnButton(),
   }
   e[2].TOGGLED:register(function ()
      enabled = e[2].toggle
   end)
   
   page:addElement(table.unpack(e))
   page:setIcon(":knife:","emoji")

   page:setName("Projectile Launcher")
   page:setHeaderColor("#b92323")
   return page
end