--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
--[[
This service aims to optimize the rendering of skull and adds new events to aid the user.
The technique I used was the idea of 4P5, making only one skull render all of them 
instead of individually rendering each one,saving performance.
]]

---@class WorldSkull
---@field is_wall boolean
---@field id string
---@field order integer
---@field last_seen number
---@field model ModelPart
---@field model_block ModelPart
---@field pos Vector3
---@field rot number
---@field dir Vector3
---@field offset_model Vector3

---@type table<any,WorldSkull>
local skulls = {}
local eventLib = require("libraries.eventLib")

local worldPart = models:newPart("worldPart","SKULL")
local inviskull = models:newPart("inviskull","SKULL"):newBlock("placeholder"):block("dirt"):scale(0,0,0)


local config = {
   expire = 1, -- seconds
}

local api = {
   skulls = skulls,
   INIT = eventLib.new(),
   EXIT = eventLib.new(),
}

local half = vectors.vec3(.5, .5, .5)
local lookup = {
   dir = {
      wall = {
         north = vectors.vec3( 0,  0, -1),
         east  = vectors.vec3( 1,  0,  0),
         south = vectors.vec3( 0,  0,  1),
         west  = vectors.vec3(-1,  0,  0),
      },
      floor = {},
   },
   rot = {
      wall = {
         north = 0,
         east = 270,
         south = 180,
         west = 90,
      },
      floor = {}
   }
}

for i = 0, 15, 1 do
   local angle = -i * (360 / 16)
   lookup.dir.floor[tostring(i)] = vectors.rotateAroundAxis(angle, vectors.vec3(0, 0, -1),vectors.vec3(0, 1, 0))
   lookup.rot.floor[tostring(i)] = angle
end

local systime = client:getSystemTime() / 1000
local order = 0
local king_pos
events.SKULL_RENDER:register(function(delta, block, item, entity, context)
   if block then
      inviskull:setVisible(true)
      local pos = block:getPos()
      local id = pos.x..","..pos.y..","..pos.z
      
      if skulls[id] then
         skulls[id].order = order
         skulls[id].last_seen = systime
         skulls[id].model_block:setLight(world.getBlockLightLevel(pos),world.getSkyLightLevel(pos))
      else
         local dir
         local rot
         local offset
         local properties = block:getProperties()
         local wall = false
         if block.id == "minecraft:player_wall_head" then
            dir = lookup.dir.wall[properties.facing]
            rot = lookup.rot.wall[properties.facing]
            offset = vectors.vec3(8,4,8) - dir * 4
            wall = true
         else
            dir = lookup.dir.floor[properties.rotation]
            rot = lookup.rot.floor[properties.rotation]
            offset = vectors.vec3(8,0,8)
         end
         local part_block = worldPart:newPart(id)
         local part = part_block:newPart("partBlock")
         skulls[id] = {
            id = id,
            order = order,
            is_wall = wall,
            model = part,
            model_block = part_block,
            block = block,
            pos = pos,
            dir = dir,
            rot = rot,
            last_seen = systime,
            offset_model = offset,
         }
         part_block:setPos(pos * 16)
         part:pos(offset):rot(0,rot,0)
         api.INIT:invoke(skulls[id])
      end
      if order == 0 or king_pos == pos then
         local mat = matrices.mat4()
         :translate(-pos * 16)
         :translate(-skulls[id].offset_model)
         :rotateY(-skulls[id].rot)
         worldPart:setMatrix(mat)
         king_pos = pos
         worldPart:setVisible(true)
      else
         worldPart:setVisible(false)
      end
      order = order + 1
   else
      inviskull:setVisible(false)
      worldPart:setVisible(false)
   end
end)


events.WORLD_TICK:register(function()
   for id, skull in pairs(skulls) do
      if not (world.getBlockState(skull.pos).id:find("player") and systime - skull.last_seen < config.expire) then
         api.EXIT:invoke(skulls[id])
         print(id, "expired")
         worldPart:removeChild(skull.model_block)
         skulls[id] = nil
      end
   end
end)

events.WORLD_RENDER:register(function ()
   order = 0
end)


return api
