if client.compareVersions("0.1.3-pre.5+1.20.1-9623a67",client:getFiguraVersion()) < 0 then
   return
end
local tween = require("libraries.GNTweenLib")

---@class Skull.StorageLabel
---@field name string
---@field item Minecraft.itemID?
---@field items table<any, Minecraft.itemID|string>?
---@field pos Vector2
---@field renderTask {title:TextTask, icon:ItemTask}?

---@param ray_dir Vector3
---@param plane_dir Vector3
---@param plane_pos Vector3
---@return Vector3?
local function ray2plane(ray_pos, ray_dir, plane_pos, plane_dir)
   ray_dir = ray_dir:normalize()
   plane_dir = plane_dir:normalize()
   local dot = ray_dir:dot(plane_dir)
   if dot < 1e-6 then return nil end
   local t = (plane_pos - ray_pos):dot(plane_dir) / dot
   if t < 0 then return nil end
   local intersection = ray_pos + ray_dir * t
   return intersection
end

local HOVER_SIZE = vectors.vec2(0.5,0.8)
local s = 1/16

local adjacent = {
   vectors.vec3(0,1,0),
   vectors.vec3(0,-1,0),
   vectors.vec3(1,0,0),
   vectors.vec3(-1,0,0),
}

---@param skull WorldSkull
---@param events SkullEvents
local function new(skull,events)
   local labels = {}
   local mat = matrices.mat4()
   mat:rotateY(skull.rot)
   mat:translate(skull.pos)
   local flood = {}
   local query_check = {}

   local function set(pos,tbl,data)
      tbl[pos.x..","..pos.y..","..pos.z] = {pos = pos,data = data}
   end

   local function get(pos)
      return flood[pos.x..","..pos.y..","..pos.z]
   end

   local function check(pos)
      return world.getBlockState(mat:apply(pos)).id:find("sign$")
   end
   if check(vectors.vec3(0,1,0)) then
      set(vectors.vec3(0,1,0),flood,1)
      query_check[#query_check+1] = vectors.vec3(0,1,0)
   end
   local next_query = {}
   for i = 1, 10, 1 do
      for key, pos in pairs(query_check) do
         local offset
         for _, o in pairs(adjacent) do
            offset = vectors.vec3(pos.x+o.x,pos.y+o.y,pos.z+o.z)
            if not get(offset) and check(offset) then -- 
               set(offset,flood,true)
               next_query[#query_check+1] = offset
            end
         end
      end
      query_check = next_query
   end
   local function highlighted_changed(pos,lpos)
      local selected = labels[pos:toString()]
      if selected then
         -- sounds:playSound("minecraft:block.wooden_button.click_off",vectors.vec3(selected.x,selected.y,0)+PROJECTOR_ORIGIN,1,1)
         -- text
         selected.title:setVisible(true)
         tween.tweenFunction(0,1,0.25,"outBack",function(x)
            local r = math.lerp(HOVER_SIZE.x,HOVER_SIZE.y,x)*s
            selected.icon:setScale(r,r,r):setPos(0,x*0.1,0)
            selected.t = x
         end,nil,pos:toString()..'icon')
         -- icon
         tween.tweenFunction(0,1,0.25,"outCubic",function(x)
            local r, r2 = x * s * 0.3, (x * 0.5 + 0.5) * s * 0.3
            selected.title:setScale(r2, r, r2):setPos(0,0-0.25 + x * 0.1,-0.1)
         end,nil,pos:toString()..'text')
      end
      if lpos and labels[lpos:toString()] then
         local lselected = labels[lpos:toString()]
         -- icon
         tween.tweenFunction(0,1,0.5,"outBack",function(x)
            local r = math.lerp(HOVER_SIZE.x,HOVER_SIZE.y,1-x)*s
            lselected.icon:setScale(r,r,r):setPos(0,(1-x)*0.1,0)
            lselected.t = 1-x
         end,nil,lpos:toString()..'icon')
         -- text
         if lselected.title then
            tween.tweenFunction(0,1,0.25,"outCubic",function(x)
               local r, r2 = (1-x) * s * 0.3, ((1-x) * 0.5 + 0.5) * s * 0.3
               lselected.title:setScale(r2, r, r2):setPos(0,0-0.25 + (1-x) * 0.1,-0.1)
            end,function ()
               if lselected then
                  lselected.title:setVisible(false)
               end
            end,lpos:toString()..'text')
         end
      end
   end

   local model_origin = skull.model_block:newPart("categorigin"):rot(0,skull.rot,0):pos(8,8,8):scale(16,16,16)
   for key, data in pairs(flood) do
      particles:newParticle("minecraft:end_rod",mat:apply(data.pos):add(0.5,0.5,0.5))
      local pos = data.pos
      local sign = world.getBlockState(mat:apply(pos)):getEntityData().front_text.messages
      local line1,line2,line3,line4 = sign[1]:sub(10,-3),sign[2]:sub(10,-3),sign[3]:sub(10,-3),sign[4]:sub(10,-3)
      local model = model_origin:newPart(pos.x..","..pos.y..","..pos.z..line2..","..line3):pos(pos.x,pos.y,2.5):rot(0,180,0)
      local model_flat = model:newPart("flat")
      local category
      category = {
         title = model:newText("label")
         :setText('[{"text":"'..line2..'\n","color":"'..(#line4 > 0 and line4 or "#ffffff")..'"},{"text":"'..line3..'","color":"dark_gray"}]')
         :setAlignment("CENTER")
         :setOutline(true)
         :setSeeThrough(true)
         :setVisible(false)
         --:scale(s * 0.3,s * 0.3,s * 0.3)
         :light(15, 15),
      icon = model_flat:newItem(key.."icon")
         :setDisplayMode("FIXED")
         :scale(s * HOVER_SIZE.x, s * HOVER_SIZE.x, s * HOVER_SIZE.x)
         :rot(0, 180, 0)
      }
      local ok, result = pcall(category.icon.item,category.icon,line1)
      if not ok then
         model:getParent():removeChild(model)
      end
      labels[tostring(pos.xy)] = category
   end

   local invmat = mat:copy()
   invmat:invert()

   local lpos = vectors.vec2()
   events.TICK:register(function ()
      local player = client:getViewer()
      local eyePos = player:getPos():add(0,player:getEyeHeight())
      local eyeDir = player:getLookDir()
      local pos = ray2plane(eyePos,eyeDir,skull.pos + vectors.vec3(0.5,0.5,0.5) - skull.dir * 2.5,skull.dir)
      if pos then
         pos = invmat:apply(pos + vectors.vec3(0,0.5,0) + (vectors.rotateAroundAxis(90,skull.dir,vectors.vec3(0,1,0)) * -0.5 - 0.5))
         pos = vectors.vec2(math.floor(pos.x),math.floor(pos.y))
         if labels[tostring(pos)] then
         else
            pos = vectors.vec3(math.huge,math.huge,math.huge)
         end
         if lpos ~= pos then
            highlighted_changed(pos,lpos)
            lpos = pos
         end
      end
   end)
end

---@param skull WorldSkull
return function (skull)
   if world.getBlockState(skull.pos - skull.dir + vectors.vec3(0,1,0)).id == "minecraft:chest" then
      return new
   end
end