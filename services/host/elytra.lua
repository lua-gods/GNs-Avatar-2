local anchor = require("services.host.anchors")
local labelLib = require("libraries.GNLabelLib")
local tween = require("libraries.GNTweenLib")
local elements = {
north = labelLib.new(anchor.Center):setText('{"text":"N","color":"blue"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
northEast = labelLib.new(anchor.Center):setText('{"text":"•","color":"gray"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
east = labelLib.new(anchor.Center):setText('{"text":"E","color":"red"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
southEast = labelLib.new(anchor.Center):setText('{"text":"•","color":"gray"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
south = labelLib.new(anchor.Center):setText('{"text":"S","color":"blue"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
southWest = labelLib.new(anchor.Center):setText('{"text":"•","color":"gray"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
west = labelLib.new(anchor.Center):setText('{"text":"W","color":"red"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
northWest = labelLib.new(anchor.Center):setText('{"text":"•","color":"gray"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
forward = labelLib.new(anchor.Center):setText('{"text":"|","color":"white"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
angle = labelLib.new(anchor.Center):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
speed = labelLib.new(anchor.Center):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
center = labelLib.new(anchor.Center):setText('{"text":"+","color":"white"}'):setEffect("OUTLINE"):setAlign(0,0):setVisible(false),
}
local spread = 0.05
local corner = 0.71717171717

local height = 0
local safe = false
local active = false
local blend = 0
local last_speed = 0

local was_elytra = false
local function toggleElytra(toggle)
   if toggle then
      active = true
      for key, value in pairs(elements) do
         value:setVisible(true)
      end
      tween.tweenFunction(blend,1,0.5,"outQuad",function (x)
         spread = x * 1
         blend = x
      end,function ()
         
      end,"elytraUI")
   else
      tween.tweenFunction(blend,0,0.5,"inQuad",function (x)
         spread = x * 1
         blend = x
      end,function ()
         active = false
         for key, value in pairs(elements) do
            value:setVisible(false)
         end
         renderer:setRenderCrosshair(true)
      end,"elytraUI")
   end
end

events.TICK:register(function ()
   local elytra = player:getPose() == "FALL_FLYING"
   if was_elytra ~= elytra then
      toggleElytra(elytra)
      was_elytra = elytra
   end
   if active then
      renderer:setRenderCrosshair(false)
      local pos = player:getPos()
      height = 0
      safe = false
      for i = 1, 100, 1 do
         pos:sub(0,1,0)
         local block = world.getBlockState(pos)
         if block.id == "minecraft:water" then
            safe = true
         end
         if block:hasCollision() then
            break
         end
         height = height + 1
      end
   end
end)

local function coloring(weight)
   weight = math.clamp(weight,-1,1)
   return math.lerp(vectors.vec3(1,0,0),math.lerp(vectors.vec3(1,1,1),vectors.vec3(0,1,0),math.max(weight,0)),1+math.min(weight,0))
end

local mat = matrices.mat4()

local function compass(x,y,z)
   return mat:apply(-x,y,z):mul(1,1,-1) * 32
end

events.WORLD_RENDER:register(function (delta)
   local crot = client:getCameraRot()
   mat = matrices.mat4():rotateY(-crot.y):rotateX(crot.x)
   if active and player:isLoaded() then
      local speed = player:getVelocity():length() * 20 * 18 / 5
      local speed_diff = speed - last_speed
      last_speed = math.lerp(last_speed,speed,0.1)
      local cdir = client:getCameraDir():mul(1,0,1):normalized()
      elements.east:setPos(compass(-spread,0,0))
      elements.west:setPos(compass(spread,0,0))
      elements.south:setPos(compass(0,0,-spread))
      elements.north:setPos(compass(0,0,spread))
      elements.northEast:setPos(compass(-spread * corner,0,spread * corner))
      elements.northWest:setPos(compass(spread * corner,0,spread * corner))
      elements.southEast:setPos(compass(-spread * corner,0,-spread * corner))
      elements.southWest:setPos(compass(spread * corner,0,-spread * corner))
      elements.forward:setPos(compass(cdir.x * -spread,0,cdir.z * -spread):add(0,0,-1))
      local top = compass(cdir.x * -spread,0,cdir.z * -spread)
      elements.angle:setPos(vectors.vec3(top.x,math.abs(top.y),top.z):add(0,10,-1)):setText('{"text":"'..(math.floor(crot.y * 10 + 0.5) / 10 % 360)..'","color":"white"}')
      elements.speed:setPos(vectors.vec3(top.x,-math.abs(top.y),top.z):add(0,-10,-1)):setText('{"text":"'..(math.floor(speed * 10 + 0.5) / 10)..'km/h","color":"#'..vectors.rgbToHex(coloring(speed_diff/10))..'"}')
   
      if safe then
         elements.center:setText('{"text":"'..height..'m","color":"#'..vectors.rgbToHex(math.lerp(vectors.vec3(0,0,1),vectors.vec3(1,1,1),math.clamp(height/100,0,1)))..'"}')
      else
         elements.center:setText('{"text":"'..height..'m","color":"#'..vectors.rgbToHex(math.lerp(vectors.vec3(1,0,0),vectors.vec3(1,1,1),math.clamp(height/100,0,1)))..'"}')
      end
   end
end)