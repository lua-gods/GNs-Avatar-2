local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local page = panels.newPage()
local gnui = require("libraries.GNUI")

---@type Texture[]
local samples = {}

---@type Sprite[]
local gallery = {}

---@param ray_dir Vector3
---@param plane_dir Vector3
---@return Vector3?
local function ray2plane(ray_dir, plane_dir)
   ray_dir = ray_dir:normalize()
   plane_dir = plane_dir:normalize()
   local dot = ray_dir:dot(plane_dir)
   local t = (plane_dir):dot(plane_dir) / dot
   local intersection = ray_dir * t
   return intersection
end

local resolution = vectors.vec2(2048,1024) * 1
resolution = resolution:floor()

return function ()
   local e = {
      panels.newButton():setText("Screenshots"),	
      panels.newButton():setForcedHeight(40),
      panels.newButton():setForcedHeight(40),
      panels.newButton():setForcedHeight(40),
      panels.newButton():setText("Skybox"),
      panels.newButton():setForcedHeight(40),
      panels.newButton():setForcedHeight(40),
      panels.newButton():setText("Final Output"),
      panels.newButton():setForcedHeight(60),
      panels.newButton():setText("Start"),	
   }

   for y = 2, 4, 1 do
      for x = 0, 1, 1 do
         local left = gnui.newContainer()
         :setAnchor(x*0.5,0,x*0.5+0.5,1):setDimensions(1,1,-1,-1)
         local gallery_frame = gnui.newSprite()
         left:setSprite(gallery_frame)
         gallery[#gallery+1] = gallery_frame
         e[y].display:addChild(left)
      end
   end

   for y = 6, 7, 1 do
      for x = 0, 2, 1 do
         local left = gnui.newContainer()
         :setAnchor(x*0.3333,0,x*0.3333+0.3333,1):setDimensions(1,1,-1,-1)
         local gallery_frame = gnui.newSprite()
         left:setSprite(gallery_frame)
         gallery[#gallery+1] = gallery_frame
         e[y].display:addChild(left)
      end
   end


   local frame = gnui.newContainer():setAnchor(0,0,1,1):setDimensions(1,1,-1,-1)
   local output_sprite = gnui.newSprite()
   frame:setSprite(output_sprite)
   gallery[#gallery+1] = output_sprite
   e[9].display:addChild(frame)
   e[10].PRESSED:register(function ()
      events.WORLD_RENDER:remove("gopro")
      local t = 0
      local phase = 0
      models:setVisible(false)
      local x,y,z,dx,dy,w = 0,0,0,0,0,1
      events.WORLD_RENDER:register(function ()
         if true then
            if phase == 0 then
               w = w - 1
               if w < 0 then
                  t = t + 1
                  if client:hasShaderPack() then
                     w = 20
                  else
                     w = 1
                  end
                  if t == 1 then renderer:setCameraRot(0,0,0) renderer:setFOV(90 / client:getFOV())
                  elseif t == 2 then samples[1] = host:screenshot("front"); gallery[1]:setTexture(samples[1]) 
                  elseif t == 3 then renderer:setCameraRot(0,90,0)
                  elseif t == 4 then samples[2] = host:screenshot("right"); gallery[2]:setTexture(samples[2]) 
                  elseif t == 5 then renderer:setCameraRot(0,180,0)
                  elseif t == 6 then samples[3] = host:screenshot("back"); gallery[3]:setTexture(samples[3]) 
                  elseif t == 7 then renderer:setCameraRot(0,270,0)
                  elseif t == 8 then samples[4] = host:screenshot("left"); gallery[4]:setTexture(samples[4]) 
                  elseif t == 9 then renderer:setCameraRot(90,0,0)
                  elseif t == 10 then samples[5] = host:screenshot("top"); gallery[5]:setTexture(samples[5]) 
                  elseif t == 11 then renderer:setCameraRot(-90,0,0)
                  elseif t == 12 then samples[6] = host:screenshot("bottom"); gallery[6]:setTexture(samples[6]) 
                  elseif t == 13 then renderer:setCameraRot() models:setVisible() renderer:setFOV()phase = 1 t = 0 w = 1 
                  end
               end
            elseif phase == 1 then
               t = t + 1
               if t == 1 then
                  dx = samples[w]:getDimensions().x
                  dy = samples[w]:getDimensions().y
                  z = dx*0.5-dy*0.5
                  samples[w+6] = textures:newTexture(w.."square",dy,dy)
                  gallery[w+6]:setTexture(samples[w+6])
                  x,y = 0,0
               end
               for i = 1, 10000, 1 do
                  if avatar:getCurrentInstructions() > 200000 then
                     break
                  end
                  x = x + 1
                  if x >= dy then
                     x = 0
                     y = y + 1
                     if y >= dy then
                        t = 0
                        samples[w+6]:update()
                        w = w + 1
                        if w > 6 then
                           phase = 2
                           t = 0
                           return
                        end
                        break
                     end
                  end
                  samples[w+6]:setPixel(x,y,samples[w]:getPixel(x+z,y))
               end
               if samples[w+6] then
                  samples[w+6]:update()
               end
            elseif phase == 2 then
               t = t + 1
               if t == 1 then
                  samples[13] = textures:newTexture("gopro_outut",resolution.x,resolution.y)
                  gallery[13]:setTexture(samples[13])
                  x,y = 0,0
               end
               for i = 1, 40000, 1 do
                  if avatar:getCurrentInstructions() > 200000 then
                     break
                  end
                  x = x + 1
                  if x >= resolution.x then
                     x = 0
                     y = y + 1
                     if y >= resolution.y then
                        t = 0
                        samples[13]:update()
                        phase = 3
                        t = 0
                        return
                     end
                  end
                  local dir = vectors.angleToDir(y/resolution.y*180-90,x/resolution.x*-380+180)
                  local sign_dir = vectors.vec3()
                  local axis = {x = math.abs(dir.x), y = math.abs(dir.y), z = math.abs(dir.z)}
                  local maxAxis = math.max(axis.x, axis.y, axis.z)
                  local sign
                  if maxAxis == axis.x then
                     sign_dir.x = math.sign(dir.x)
                  elseif maxAxis == axis.y then
                     sign_dir.y = math.sign(dir.y)
                  else
                     sign_dir.z = math.sign(dir.z)
                  end

                  -- dir to equirectangular projection
                  if sign_dir.x == 1 and sign_dir.y == 0 and sign_dir.z == 0 then
                     local uv = ray2plane(dir,vectors.vec3(1,0,0))
                     samples[13]:setPixel(x,y,samples[2+6]:getPixel(math.map(uv.z,1,-1,0,(dy-1)),math.map(uv.y,1,-1,0,(dy-1))))
                  elseif sign_dir.x == 0 and sign_dir.y == 0 and sign_dir.z == 1 then
                     local uv = ray2plane(dir,vectors.vec3(0,0,1))
                     samples[13]:setPixel(x,y,samples[1+6]:getPixel(math.map(uv.x,-1,1,0,(dy-1)),math.map(uv.y,1,-1,0,(dy-1))))
                  elseif sign_dir.x == -1 and sign_dir.y == 0 and sign_dir.z == 0 then
                     local uv = ray2plane(dir,vectors.vec3(-1,0,0))
                     samples[13]:setPixel(x,y,samples[4+6]:getPixel(math.map(uv.z,-1,1,0,(dy-1)),math.map(uv.y,1,-1,0,(dy-1))))
                  elseif sign_dir.x == 0 and sign_dir.y == 0 and sign_dir.z == -1 then
                     local uv = ray2plane(dir,vectors.vec3(0,0,-1))
                     samples[13]:setPixel(x,y,samples[3+6]:getPixel(math.map(uv.x,1,-1,0,(dy-1)),math.map(uv.y,1,-1,0,(dy-1))))
                  elseif sign_dir.x == 0 and sign_dir.y == 1 and sign_dir.z == 0 then
                     local uv = ray2plane(dir,vectors.vec3(0,1,0))
                     samples[13]:setPixel(x,y,samples[6+6]:getPixel(math.map(-uv.x,1,-1,0,(dy-1)),math.map(-uv.z,1,-1,0,(dy-1))))
                  elseif sign_dir.x == 0 and sign_dir.y == -1 and sign_dir.z == 0 then
                     local uv = ray2plane(dir,vectors.vec3(0,-1,0))
                     samples[13]:setPixel(x,y,samples[5+6]:getPixel(math.map(-uv.x,1,-1,0,(dy-1)),math.map(uv.z,1,-1,0,(dy-1))))
                  end
               end
               samples[13]:update()
            elseif phase == 3 then
               local base = samples[13]:save()
               local stream = file:openWriteStream("images/panorama.png")
               local buff = data:createBuffer(#base)
               buff:writeBase64(base)
               buff:setPosition(0)
               buff:writeToStream(stream)
               buff:close()
               stream:close()
               phase = 4
            end
         end
   end,"gopro")
   end)
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   page:setName("360 GoPro")
   return page
end