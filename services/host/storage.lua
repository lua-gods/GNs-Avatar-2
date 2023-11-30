local command = require("services.command")
local lineLib = require("libraries.GNLineLib")

local remembered = {}

local offsets = {
   north = vectors.vec3(-1, 0, 0),
   south = vectors.vec3(1, 0, 0),
   west = vectors.vec3(0, 0, 1),
   east = vectors.vec3(0, 0, -1)
}

local last_rid = ""
local last_screen = ""
local server = client:getServerData().ip
local block_interacted = nil --[[@type BlockState]]
config:setName(server .. "storage_cache")

keybinds:fromVanilla("key.use").press = function()
   block_interacted = player:getTargetedBlock(true, 5)
   if block_interacted.properties.type == "right" then -- make sure double chest blocks are identified as one
      block_interacted:setPos(block_interacted:getPos():add(
                                 offsets[block_interacted.properties.facing]))
   end
end

local save_timer = 0
events.WORLD_TICK:register(function()
   local screen = host:getScreen()
   if last_screen ~= screen then
      last_screen = screen
      if block_interacted then -- load cached rid for that block
         local might_rid = nil -- config:load(block_interacted:getPos():toString().."rid")
         if might_rid and false then last_rid = might_rid end
      end
   end
   save_timer = save_timer - 1
   if block_interacted and screen == "net.minecraft.class_476" and block_interacted.id ==
      "minecraft:chest" and save_timer < 0 then -- chest
      save_timer = 20

      -- Collect Container Data
      local container = {} --[[@type table<any,ItemStack>]]
      for i = 0, 60, 1 do
         local success, output = pcall(host.getScreenSlot, host, "container." .. i)
         if not success then break end
         if output.id ~= "minecraft:air" then
            local bpos = block_interacted:getPos()
            local id = bpos.x .. "," .. bpos.y .. "," .. bpos.z
            local item = output
            if not remembered[id] then remembered[id] = {pos = bpos} end
            remembered[id][output.id] = true
            container[#container + 1] = item
         end
      end

      -- Generate RID to detect changes
      local rid = block_interacted.id .. ":" .. block_interacted:getPos():toString() .. ":"
      for key, value in pairs(container) do
         if value.id == "minecraft:air" then
            container[key] = nil
            rid = rid .. ":"
         else
            rid = rid .. value.id .. table.concat(value.tag, ":") .. ":"
         end
      end

      -- Write to file if something changed
      if last_rid ~= rid then
         last_rid = rid
         print("saved")
         print(remembered)
         -- config:save(block_interacted:getPos():toString().."rid",rid)
         -- config:save(block_interacted:getPos():toString(),container)
      end
   end
end)

local outlines = {}

local function drawCubeOutline(from, to,width,depth)
   local corners = {
      from,
      vectors.vec3(to.x, from.y, from.z),
      vectors.vec3(to.x, to.y, from.z),
      vectors.vec3(from.x, to.y, from.z),
      vectors.vec3(from.x, from.y, to.z),
      vectors.vec3(to.x, from.y, to.z),
      to,
      vectors.vec3(from.x, to.y, to.z)
   }

   -- Connect the corners to form the cube outline
   outlines[#outlines+1] = lineLib:newLine():from(corners[1]):to(corners[2]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[2]):to(corners[3]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[3]):to(corners[4]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[4]):to(corners[1]):depth(depth):width(width)

   outlines[#outlines+1] = lineLib:newLine():from(corners[5]):to(corners[6]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[6]):to(corners[7]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[7]):to(corners[8]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[8]):to(corners[5]):depth(depth):width(width)

   outlines[#outlines+1] = lineLib:newLine():from(corners[1]):to(corners[5]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[2]):to(corners[6]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[3]):to(corners[7]):depth(depth):width(width)
   outlines[#outlines+1] = lineLib:newLine():from(corners[4]):to(corners[8]):depth(depth):width(width)
end



command.register(function(words)
   if #words == 2 then
      if words[1] == "f" then
         local i = 0
         for key, value in pairs(outlines) do
            value:delete()
         end
         outlines = {}
         for idpos, chest in pairs(remembered) do
            local found = false
            for item, _ in pairs(chest) do
               if item ~= "pos" and item:find(words[2]) then
                  i = i + 1
                  found = true
               end
            end
            if found then
               drawCubeOutline(chest.pos,chest.pos:copy():add(1,1,1),0.03,-0.01)
               drawCubeOutline(chest.pos,chest.pos:copy():add(1,1,1),0.01,-0.9)
            end
         end
         if i > 0 then
            if i == 1 then
               command.announce('found a container containing \\"' .. words[2] .. '\\"')
            else
               command.announce("found " .. i .. ' containers containing \\"' .. words[2] .. '\\"')
            end
         else
            command.announce("no results")
         end
      end
   end
end)
