local lineLib = require("libraries.GNlineLib")

local function drawCube(x,y,z,dx,dy,dz)
   local lines = {
      lineLib:new():setA(x,y,z):setB(x+dx,y,z):setColor(1,0,0),
      lineLib:new():setA(x+dx,y,z):setB(x+dx,y,z+dz),
      lineLib:new():setA(x+dx,y,z+dz):setB(x,y,z+dz),
      lineLib:new():setA(x,y,z+dz):setB(x,y,z):setColor(0,0,1),

      lineLib:new():setA(x,y+dy,z):setB(x+dx,y+dy,z),
      lineLib:new():setA(x+dx,y+dy,z):setB(x+dx,y+dy,z+dz),
      lineLib:new():setA(x+dx,y+dy,z+dz):setB(x,y+dy,z+dz),
      lineLib:new():setA(x,y+dy,z+dz):setB(x,y+dy,z),

      lineLib:new():setA(x,y,z):setB(x,y+dy,z):setColor(0,1,0),
      lineLib:new():setA(x+dx,y,z):setB(x+dx,y+dy,z),
      lineLib:new():setA(x+dx,y,z+dz):setB(x+dx,y+dy,z+dz),
      lineLib:new():setA(x,y,z+dz):setB(x,y+dy,z+dz),
   }
   for key, line in pairs(lines) do
      line:setWidth(0.05)
   end
   return lines
end

local tile_size = vectors.vec3(5,10,5)
tile_size = tile_size - 1 -- subtracted for optimization

local tileset = {} ---@type {id: integer, sides : {north: string, east: string, south: string, west: string},structure: table<integer,table<integer,table<integer,{block: BlockState, override : string}>>>}[]
local tile_world = {}
local world_origin = vectors.vec3(8179986, 113, 8183379)
local world_size = 32 - 1

local translate = {
   facing = {
      {north = "north",east = "east",south = "south",west = "west"},
      {north = "east",east = "south",south = "west",west = "north"},
      {north = "south",east = "west",south = "north",west = "east"},
      {north = "west",east = "north",south = "east",west = "south"},
   }
}

local function newTile(x,y,z)
   local mat = matrices.mat4()
   for i = 1, 4, 1 do
      local data = {}
      for tx = 0, tile_size.x, 1 do
         data[tx] = {}
         for ty = 0, tile_size.y, 1 do
            data[tx][ty] = {}
         end
      end
      for tx = 0, tile_size.x, 1 do
         data[tx] = {}
         for ty = 0, tile_size.y, 1 do
            data[tx][ty] = {}
            for tz = 0, tile_size.z, 1 do
               local offset = mat:apply(tx,ty,tz):add(x,y,z)
               local block = world.getBlockState(offset)
               local properties_override = {}
               if block.properties.facing then
                  properties_override.facing = translate.facing[i][block.properties.facing]
               end
               data[tx][ty][tz] = {block = block,override = properties_override}

            end
         end
      end
      mat:translate(tile_size.x * -0.5,0,tile_size.z * -0.5)
      mat:rotateY(90)
      mat:translate(tile_size.x * 0.5,0,tile_size.z * 0.5)
      local sides = {
         x = "",
         X = "",
         y = "",
         Y = "",
      }

      for tx = 0, tile_size.x, 1 do
         for ty = 0, tile_size.y, 1 do
            for tz = 0, tile_size.z, 1 do
               if data[tx][ty][tz] then
                  if ty == 0 then
                     if tx == 0 then
                        sides.x = sides.x .. data[tx][ty][tz].block.id:match("minecraft:(.+)") .. " "
                     end
                     if tx == tile_size.x then
                        sides.X = sides.X .. data[tx][ty][tz].block.id:match("minecraft:(.+)") .. " "
                     end
                     if tz == tile_size.z then
                        sides.Y = sides.Y .. data[tx][ty][tz].block.id:match("minecraft:(.+)") .. " "
                     end
                     if tz == 0 then
                        sides.y = sides.y .. data[tx][ty][tz].block.id:match("minecraft:(.+)") .. " "
                     end
                  end
               end
            end
         end
      end

      local id = #tileset+1
      drawCube(x,y,z,tile_size.x+1,tile_size.y+1,tile_size.z+1)
      tileset[id] = {
         structure = data,
         id = id,
         sides = sides,
      }
   end
end

local function setTile(x,y,id)
   if x >= 0 and x <= world_size and y >= 0 and y <= world_size then
      if tile_world[x] == nil then
         tile_world[x] = {}
      end
      tile_world[x][y] = id
   
      local pos = world_origin + vectors.vec3(x * (tile_size.x+1),0,y * (tile_size.z+1))
      local tile_data = tileset[id]
      for tx = 0, tile_size.x, 1 do
         for ty = 0, tile_size.y, 1 do
            for tz = 0, tile_size.z, 1 do
               local block = tile_data.structure[tx][ty][tz]
               local compose = ""
               for key, value in pairs(block.block.properties) do
                  compose = compose .. ("%s=%s,"):format(key, block.override[key] or value)
               end
               compose = "["..compose:sub(1,-2) .. "]"
               if block.block.id ~= "minecraft:air" then
                  host:sendChatCommand(("/setblock %i %i %i %s"):format(pos.x + tx, pos.y + ty, pos.z + tz, block.block.id .. compose))
               end
            end
         end
      end
   end
end

local function getTile(x,y)
   if not tile_world[x] then
      return nil
   end
   return tileset[tile_world[x][y]]
end

local adjacent = {
   {x = 0, y = 1, sides = {"Y","y"}},
   {x = 0, y = -1, sides = {"y","Y"}},
   {x = 1, y = 0, sides = {"X","x"}},
   {x = -1, y = 0, sides = {"x","X"}},
}

local function coundAjacentTiles(x,y)
   local count = 0
   for _, offset in pairs(adjacent) do
      if getTile(x+offset.x,y+offset.y) then
         count = count + 1
      end
   end
   return count
end

local function doesAllHaveTiles()
   for x = 0, world_size, 1 do
      for y = 0, world_size, 1 do
         if not getTile(x,y) then
            return false
         end
      end
   end
   return true
end

local possible_tiles = {}

local function setPossibleStates(x,y,data)
   if not possible_tiles[x] then
      possible_tiles[x] = {}
   end
   if not possible_tiles[x][y] then
      possible_tiles[x][y] = {}
   end
   possible_tiles[x][y] = data
end



---@type {x: number, y: number, possible_states: table<number, boolean>[]}[][]
local test_results = {}

local connections = {
   --{
   --   "smooth_stone smooth_stone white_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone white_wool smooth_stone smooth_stone ",
   --},
   --{
   --   "smooth_stone smooth_stone light_gray_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone light_gray_wool smooth_stone smooth_stone ",
   --},
   {
      "smooth_stone smooth_stone gray_concrete smooth_stone smooth_stone ",
      "smooth_stone smooth_stone gray_wool smooth_stone smooth_stone ",
   },
   --{
   --   "smooth_stone smooth_stone brown_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone brown_wool smooth_stone smooth_stone ",
   --},
   {
      "smooth_stone smooth_stone red_concrete smooth_stone smooth_stone ",
      "smooth_stone smooth_stone red_wool smooth_stone smooth_stone ",
   },
   --{
   --   "smooth_stone smooth_stone orange_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone orange_wool smooth_stone smooth_stone ",
   --},
   --{
   --   "smooth_stone smooth_stone yellow_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone yellow_wool smooth_stone smooth_stone ",
   --},
   --{
   --   "smooth_stone smooth_stone lime_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone lime_wool smooth_stone smooth_stone ",
   --},
   --{
   --   "smooth_stone smooth_stone green_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone green_wool smooth_stone smooth_stone ",
   --},
   {
      "smooth_stone smooth_stone cyan_concrete smooth_stone smooth_stone ",
      "smooth_stone smooth_stone cyan_wool smooth_stone smooth_stone ",
   },
   {
      "smooth_stone smooth_stone light_blue_concrete smooth_stone smooth_stone ",
      "smooth_stone smooth_stone light_blue_wool smooth_stone smooth_stone ",
   },
   --{
   --   "smooth_stone smooth_stone purple_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone purple_wool smooth_stone smooth_stone ",
   --},
   --{
   --   "smooth_stone smooth_stone magenta_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone magenta_wool smooth_stone smooth_stone ",
   --},
   --{
   --   "smooth_stone smooth_stone pink_concrete smooth_stone smooth_stone ",
   --   "smooth_stone smooth_stone pink_wool smooth_stone smooth_stone ",
   --}
}




local function updatePossibleTileStates(x,y)
   local tile_data = getTile(x,y)

   local ac = coundAjacentTiles(x,y)
   if ac == 0 then
      return
   end
   if not tile_data then -- no tile here
      local possible_states = {}
      for i = 1, #tileset, 1 do
         possible_states[i] = true
      end

      for _, offset in pairs(adjacent) do
         local adjacent_tile = getTile(x+offset.x,y+offset.y)
         if adjacent_tile then -- only filter when theres a tile there
            for check_id in pairs(possible_states) do -- check who are still possible
               local not_found = true
               for i = 1, #connections, 1 do
                  if tileset[check_id].sides[offset.sides[1]] == connections[i][1] then
                     not_found = false
                     if adjacent_tile.sides[offset.sides[2]] ~= connections[i][2] then
                        possible_states[check_id] = nil
                        break
                     end
                  elseif tileset[check_id].sides[offset.sides[1]] == connections[i][2] then
                     not_found = false
                     if adjacent_tile.sides[offset.sides[2]] ~= connections[i][1] then
                        possible_states[check_id] = nil
                        break
                     end
                  end
               end
               if not_found then
                  if tileset[check_id].sides[offset.sides[1]] ~= adjacent_tile.sides[offset.sides[2]] then
                     possible_states[check_id] = nil
                  end
               end

               --if tileset[check_id].sides[offset.sides[1]] ~= adjacent_tile.sides[offset.sides[2]] then
               --   possible_states[check_id] = nil
               --end
            end
         end
      end

      -- convert keys into values
      local ps = {}
      for key in pairs(possible_states) do
         ps[#ps+1] = key
      end

      local psa = #ps
      if not test_results[psa] then
         test_results[psa] = {}
      end
      setPossibleStates(x,y,tostring(psa))
      test_results[psa][#test_results[psa]+1] = {x = x, y = y, possible_states = ps}
   end
end

local function resetPossibleTiles()
   test_results = {}
   possible_tiles = {}
end

local function updatePossibleTiles()
   -- check for possible states on missing tiles
   for x = 0, world_size, 1 do
      for y = 0, world_size, 1 do
         updatePossibleTileStates(x,y)
      end
   end
   
   
end

local function placePossibleTiles()
   -- find the one with the least amount of possible state and set it
   for i = 1, #tileset, 1 do
      if test_results[i] then -- this tile has at least one possible state
         local test_result = test_results[i][math.random(1,#test_results[i])]
         local ps = test_result.possible_states
         setTile(test_result.x, test_result.y, ps[math.random(1,#ps)])
         break
      end
   end
end


host:sendChatCommand(("/fill %i %i %i %i %i %i air"):format(
   world_origin.x, 
   world_origin.y, 
   world_origin.z, 
   world_origin.x + (world_size+1) * (tile_size.x+1)-1, 
   world_origin.y + 10, 
   world_origin.z + (world_size+1) * (tile_size.z+1)-1)
)

for i = 0, 25, 1 do
   newTile(8179986 + i * 6, 113, 8183373)
end

if true then
   local phase = 0
   local x,y = 0,0
   events.WORLD_TICK:register(function ()
      local benchmark = -avatar:getCurrentInstructions()
      for i = 1, 1000, 1 do
         if benchmark + avatar:getCurrentInstructions() > 10^5 then
            break
         end
         if phase == 0 then
            resetPossibleTiles()
            host:setActionbar("resetting")
            phase = 1
         elseif phase == 1 then
            x = x + 1
            if x >= world_size then
               x = 0
               y = y + 1
               if y >= world_size then
                  y = 0
                  phase = 2
               end
            end
            host:setActionbar("calculating "..x.." "..y)
            updatePossibleTileStates(x,y)
         elseif phase == 2 then
            placePossibleTiles()
            phase = 0
         end
         if doesAllHaveTiles() then
            events.WORLD_TICK:remove("wafefunccollapse")
         end
      end
   end,"wafefunccollapse")
end


setTile(math.random(0,world_size),math.random(0,world_size),math.random(1,#tileset))
