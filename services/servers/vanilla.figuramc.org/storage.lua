---@diagnostic disable: param-type-mismatch, inject-field, undefined-field, assign-type-mismatch

local main = models:newPart("main projector")
local is_available = false
local is_available_frames = 0
local projectorItems = main:newPart("projectorFlat","SKULL"):setScale(16,16,8):setPos(0,8,8)
local projectorText = main:newPart("projector","SKULL"):setPos(0,8,8)
local garage = main:newPart("garage","SKULL"):setScale(16,16,16):setPos(0,0,0)

---@class Category
---@field name string
---@field item Minecraft.itemID?
---@field items table<any, Minecraft.itemID|string>?
---@field pos Vector2
---@field renderTask {title:TextTask, icon:ItemTask}?


---@type table<any,Category>
local categories = {
   {
      name = "Terrain",
      item = "minecraft:grass_block",
      pos  = vectors.vec2(5,-2),
      items = {}
   },
   {
      name = "Timber",
      item = "minecraft:oak_log",
      pos  = vectors.vec2(4,-2),
   },
   {
      name = "Redstone",
      item = "minecraft:redstone",
      pos  = vectors.vec2(3,-2),
   },
   {
      name = "Food",
      item = "minecraft:apple",
      pos  = vectors.vec2(2,-2),
   },
   {
      name = "Suppreme Armory",
      item = "minecraft:diamond_helmet",
      pos  = vectors.vec2(1,-2),
   },
   ----------------------------------------ROW 2
   {
      name = "Underground Terrain",
      item = "minecraft:stone",
      pos  = vectors.vec2(5,-3),
      items = {}
   },
   {
      name = "Furnitures",
      item = "minecraft:dark_oak_fence",
      pos  = vectors.vec2(4,-3),
      items = {}
   },
   {
      name = "Emissives",
      item = "minecraft:lantern",
      pos  = vectors.vec2(3,-3),
      items = {}
   },
   {
      name = "Decoratives",
      item = "minecraft:pink_stained_glass",
      pos  = vectors.vec2(2,-3),
      items = {}
   },
   {
      name = "Alchemy",
      item = "minecraft:potion",
      pos  = vectors.vec2(1,-3),
      items = {}
   },
   ----------------------------------------ROW 3
   {
      name = "Undergound terrain2",
      item = "minecraft:deepslate",
      pos  = vectors.vec2(5,-4),
      items = {}
   },
   {
      name = "Forest",
      item = "minecraft:spruce_sapling",
      pos  = vectors.vec2(4,-4),
      items = {}
   },
   {
      name = "Misc",
      item = "minecraft:leather",
      pos  = vectors.vec2(3,-4),
      items = {}
   },
   {
      name = "Monster Loot",
      item = "minecraft:rotten_flesh",
      pos  = vectors.vec2(2,-4),
      items = {}
   },
   {
      name = "Garden",
      item = "minecraft:lily_pad",
      pos  = vectors.vec2(1,-4),
      items = {}
   },

   --========================================OTHER SIDE

   {
      name = "Minerals",
      item = "minecraft:diamond",
      pos  = vectors.vec2(-5,-2),
      items = {}
   },
   {
      name = "Treasures",
      item = "minecraft:nautilus_shell",
      pos  = vectors.vec2(-4,-2),
   },
   {
      name = "etc Armor",
      item = "minecraft:leather_helmet",
      pos  = vectors.vec2(-3,-2),
   },
   {
      name = "The End",
      item = "minecraft:chorus_flower",
      pos  = vectors.vec2(-2,-2),
   },
   {
      name = "Enchanting",
      item = "minecraft:enchanted_book",
      pos  = vectors.vec2(-1,-2),
   },
   ----------------------------------------ROW 2
   {
      name = "Human Organs",
      item = "minecraft:red_concrete",
      pos  = vectors.vec2(-5,-3),
      items = {}
   },
   {
      name = "Sliced off Human Heads",
      item = "minecraft:player_head",
      pos  = vectors.vec2(-4,-3),
      items = {}
   },
   {
      name = "etc Weaponry",
      item = "minecraft:iron_sword",
      pos  = vectors.vec2(-3,-3),
      items = {}
   },
   {
      name = "The Nether",
      item = "minecraft:netherrack",
      pos  = vectors.vec2(-2,-3),
      items = {}
   },
   {
      name = "Ocean",
      item = "minecraft:prismarine_shard",
      pos  = vectors.vec2(-1,-3),
      items = {}
   },
   ----------------------------------------ROW 3
   {
      name = "Fake Legal Documents",
      item = "minecraft:paper",
      pos  = vectors.vec2(-5,-4),
      items = {}
   },
   {
      name = "Illegal Compound of Medicines Recipes",
      item = "minecraft:map",
      pos  = vectors.vec2(-4,-4),
      items = {}
   },
   {
      name = "etc Tools",
      item = "minecraft:iron_pickaxe",
      pos  = vectors.vec2(-3,-4),
      items = {}
   },
   {
      name = "etc Functional",
      item = "minecraft:fletching_table",
      pos  = vectors.vec2(-2,-4),
      items = {}
   },
   {
      name = "Rocket Power",
      item = "minecraft:firework_rocket",
      pos  = vectors.vec2(-1,-4),
      items = {}
   },
}

local PROJECTOR_ORIGIN = vectors.vec3(889,61,904)
local PROJECTOR_AREA = vectors.vec4(-5,-4,5,-2)
local HOVER_SIZE = vectors.vec2(0.5,0.8)

local s = 1/16
do
   ---@type table<Vector2,Category>
   local temp = {}
   for key, category in pairs(categories) do
      category.renderTask = {
      title = projectorText:newText(key.."name")
         :setText(category.name)
         :setAlignment("CENTER")
         :setOutline(true)
         :setSeeThrough(true)
         :scale(0, 0, 0)
         -- :scale(s * 0.3,s * 0.3,s * 0.3)
         :setPos(category.pos.x,category.pos.y-0.25,-0.1)
         :light(15, 15),
      icon = projectorItems:newItem(key.."icon")
         :item(category.item or "minecraft:grass_block")
         :setDisplayMode("fixed")
         :scale(s * HOVER_SIZE.x, s * HOVER_SIZE.x, s * HOVER_SIZE.x)
         :rot(0, 180, 0)
         :pos(category.pos.x,category.pos.y,0)
      }
      temp[category.pos:toString()] = category
      local gag = garage:newBlock(key.."block")
      :scale(s,s,s)
      :pos(category.pos.x-0.5,category.pos.y,0.5)
      if category.pos.y == -4 then
         gag:block("minecraft:dark_oak_planks")
      else
         gag:block("minecraft:deepslate_tiles")
      end
   end
   categories = temp
end

local tween = require("libraries.GNTweenLib")


local _target_block = vectors.vec3()
local hovering = false
local _hovering = false

local enabled = false
local _enabled = false

local function highlighted_changed(pos,lpos)
   local selected = categories[pos:toString()]
   local lselected = categories[lpos:toString()]
   if selected then
      -- sounds:playSound("minecraft:block.wooden_button.click_off",vectors.vec3(selected.x,selected.y,0)+PROJECTOR_ORIGIN,1,1)
      -- text
      tween.tweenFunction(selected.t or 0,1,0.25,"outBack",function(x)
         local r = math.lerp(HOVER_SIZE.x,HOVER_SIZE.y,x)*s
         selected.renderTask.icon:setScale(r,r,r)
         selected.t = x
      end,nil,selected.pos:toString()..'icon')
      -- icon
      tween.tweenFunction(selected.t or 0,1,0.25,"outCubic",function(x)
         local r, r2 = x * s * 0.3, (x * 0.5 + 0.5) * s * 0.3
         selected.renderTask.title:setScale(r2, r, r2)
      end,nil,selected.pos:toString()..'text')
   end
   if lselected then
      -- icon
      tween.tweenFunction(lselected.t or 1,0,0.5,"outBack",function(x)
         local r = math.lerp(HOVER_SIZE.x,HOVER_SIZE.y,x)*s
         lselected.renderTask.icon:setScale(r,r,r)
         lselected.t = x
      end,nil,lselected.pos:toString()..'icon')
      -- text
      tween.tweenFunction(lselected.t or 1,0,0.25,"outCubic",function(x)
         local r, r2 = x * s * 0.3, (x * 0.5 + 0.5) * s * 0.3
         lselected.renderTask.title:setScale(r2, r, r2)
      end,nil,lselected.pos:toString()..'text')
   end
end
local age = 0
local g = 0
local sound_slide = sounds["minecraft:entity.minecart.riding"]:stop():pitch(0.5)
local function lmao_garage(x)
   garage:setPos(0,x*-49,0)
   local squish = math.clamp(((x-1) * 10) + 1,0.01,1)
   projectorItems:scale(16,16,16*squish):pos(0,8,7.99+(1-squish))
   projectorText:setVisible(x ~= 0)
   if not (x == 0 or x == 1) then
      if not sound_slide:isPlaying() then
         sound_slide:play():pos(PROJECTOR_ORIGIN)
      end
   else
      sound_slide:stop()
      if age > 40 then
         sounds:playSound("minecraft:block.fire.extinguish",PROJECTOR_ORIGIN)
         sounds:playSound("minecraft:block.piston.contract",PROJECTOR_ORIGIN,1,0.5)
      end
   end
   g = x
end

events.WORLD_TICK:register(function ()
   if is_available then
      if enabled ~= _enabled then
         _enabled = enabled
         if enabled then
            tween.tweenFunction(g,1,1.5,"inOutQuad",lmao_garage,nil,"garag")
         else
            highlighted_changed(vec(0, 0, 0),_target_block.xy)
            tween.tweenFunction(g,0,1.5,"inOutQuad",lmao_garage,nil,"garag")
         end
      end
      local switch = world.getBlockState(PROJECTOR_ORIGIN:copy():sub(0,2,0))
      if switch.id == "minecraft:lever" then
         enabled = switch.properties.powered == "true" or player:isSneaking()
         if age == 0 then
            lmao_garage(enabled and 1 or 0)
         end
      end
      age = age + 1
      local target_block = (client:getViewer():getTargetedBlock(true,12):getPos()-PROJECTOR_ORIGIN)
      if _target_block ~= target_block and enabled then
         hovering = PROJECTOR_AREA.x <= target_block.x
         and PROJECTOR_AREA.y <= target_block.y
         and PROJECTOR_AREA.z >= target_block.x
         and PROJECTOR_AREA.w >= target_block.y
         and target_block.z == 1
         if hovering then
            highlighted_changed(target_block.xy,_target_block.xy)
            _target_block = target_block
         elseif hovering ~= _hovering then
            highlighted_changed(vectors.vec2(),_target_block.xy) -- deselect
            _target_block = vectors.vec2()
         end
         _hovering = hovering
      end
   end
end)

events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
   if ctx == "BLOCK" and block:getPos() == PROJECTOR_ORIGIN then
      is_available_frames = 2
      main:setVisible(true)
      projectorItems:setVisible(true)
      projectorText:setScale(16, 16, 16)
      garage:setVisible(true)
   else
      main:setVisible(false)
      projectorItems:setVisible(false)
      projectorText:setScale(0, 0, 0)
      garage:setVisible(false)
   end
end)

events.world_render:register(function()
   is_available_frames = math.max(is_available_frames - 1, 0)
   is_available = is_available_frames >= 1
end)