
local DEBUG = true

local ogprint = print
local function print(...)
   if DEBUG then
      ogprint(table.concat({...},", "))
   end
end

local offsets = {
   north = vectors.vec3(-1,0,0),
   south = vectors.vec3(1,0,0),
   west = vectors.vec3(0,0,1),
   east = vectors.vec3(0,0,-1),
}

local last_rid = ""
local last_screen = ""
local server = (client.getServerData().ip or client.getServerData().name):gsub("[^%w._-]", "_")
local block_interacted = nil --[[@type BlockState]]
config:setName(server.."storage_cache")

keybinds:fromVanilla("key.use").press = function ()
   block_interacted = player:getTargetedBlock(true,5)
   if block_interacted.properties.type == "right" then -- make sure double chest blocks are identified as one
      block_interacted:setPos(block_interacted:getPos():add(offsets[block_interacted.properties.facing]))
   end
end

local function isContainer(block)
   return not ((not block:getEntityData() or not block:getEntityData().Items) and not block.id:find("shulker") and not block.id:find("chest$"))
end

local container_screens = {
   ["net.minecraft.class_476"] = true, -- Chest, Ender Chest, Barrel
   ["net.minecraft.class_480"] = true, -- Dispenser, Dropper
   ["net.minecraft.class_488"] = true, -- Hopper
   ["net.minecraft.class_495"] = true  -- Shulker Box
}

local save_timer = 0
events.WORLD_TICK:register(function ()
   local screen = host:getScreen()
   if last_screen ~= screen then
      last_screen = screen
      if block_interacted then -- load cached rid for that block
         local might_rid = config:load(block_interacted:getPos():toString().."rid")
         if might_rid then
            last_rid = might_rid
         end
      end
   end
   save_timer = save_timer - 1
   if block_interacted and container_screens[screen] and isContainer(block_interacted) and save_timer < 0 then -- container + screen
      save_timer = 20

      -- Collect Container Data
      local container = {} --[[@type table<any,ItemStack>]]
      for i = 0, 60, 1 do
         local success, output = pcall(host.getScreenSlot,host,"container."..i)
         if not success then
            break
         end
         local item = output
         container[#container+1] = item
      end

      -- Generate RID to detect changes
      local rid = block_interacted.id..":"..block_interacted:getPos():toString()..":"
      for key, value in pairs(container) do
         if value.id == "minecraft:air" then
            container[key] = nil
            rid = rid .. ":"
         else
            rid = rid .. value.id .. table.concat(value.tag,":") .. ":"
         end
      end

      -- Write to file if something changed
      if last_rid ~= rid then
         last_rid = rid
         print("saved chest state")
         config:save(block_interacted:getPos():toString().."rid",rid)
         config:save(block_interacted:getPos():toString(),container)
      end
   end
end)