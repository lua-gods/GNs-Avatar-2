local tween = require("libraries.GNTweenLib")
local colors = {
   vectors.hexToRGB("#5ac54f")*0.75,
   vectors.hexToRGB("#ea323c")*0.75,
   vectors.hexToRGB("#ffc825")*0.75,
   vectors.hexToRGB("#0098dc")*0.75,
}

---@param gnui GNUI
---@param events GNUI.TV.app
---@param screen GNUI.container
---@param skull WorldSkull
local function new(gnui,screen,events,skull)

   ---@param id Minecraft.soundID
   ---@param pitch number?
   ---@param volume number?
   local function sound(id,pitch,volume)
      sounds:playSound(id,skull.pos,volume or 1,pitch or 1)
   end
   local memory = {}
   local guess = {}
   local lock = false
   local vibe = 0

   local level = 0
   local time = 0
   local loop_cooldown = true
   local next = 1
   local playing = false

   local start_sprite = gnui.newSprite():setTexture(textures["textures.icons"]):setUV(0,10,2,13):setBorderThickness(1,1,1,2)
   local start_button = gnui.newLabel()
   :setText({text="S",color="black"})
   :setDimensions(-10,-10,10,10)
   :setAlign(0.5,0.5)
   :setSprite(start_sprite)
   :setAnchor(0.5,0.5)

   local buttons = {}
   local i = 0
   local grid_size = vectors.vec2(2,2)

   local function nexty()
      next = next + 1
      if next > #memory then
         return
      end
      lock = true
      buttons[memory[next]](true)
      if next + 1 > #memory then
         lock = false
      end
   end

   local function showcase(addnew)
      if addnew then
         level = level + 1
         start_button:setText({text=tostring(level),color="black"}):setAlign(0.5,0.5)
         memory[#memory+1] = math.random(1,grid_size.x * grid_size.y)
      end
   end

   local function checkwin()
      local win = true
      for key, value in pairs(guess) do
         if value ~= memory[key] then
            win = false
         end
      end
      if win then
         if #guess == #memory then
            guess = {}
            next = 0
            loop_cooldown = true
            sound("minecraft:block.note_block.harp",0.5)
            sound("minecraft:block.note_block.harp",0.75)
            sound("minecraft:block.note_block.harp",1)
            sound("minecraft:block.note_block.harp",1.25)
            lock = false
            for key, press in pairs(buttons) do
               press(true,true)
            end
            lock = true
            showcase(true)
         end
      else
         level = 0
         playing = false
         memory = {}
         guess = {}
         sound("minecraft:block.note_block.harp",0.25)
         sound("minecraft:block.bell.use",0.5)
         sound("minecraft:block.note_block.harp",0.5)
         lock = false
         for key, press in pairs(buttons) do
            press(true,true,vectors.vec3(1,0,0))
         end
      end
   end

   for y = 1, grid_size.y, 1 do
      for x = 1, grid_size.x, 1 do
         i = i + 1
         local sprite = gnui.newSprite():setTexture(textures["textures.icons"]):setUV(0,10,2,13):setBorderThickness(1,1,1,2):setColor(colors[((i-1) % #colors) + 1])
         local button = gnui.newContainer():setSprite(sprite)
         button:setAnchor((x-0.95)/grid_size.x,(y-0.95)/grid_size.y,(x-0.05)/grid_size.x,(y-0.05)/grid_size.y)
         local o = i
         
         local function press(ignore,mute,custom_clr)
            if not lock or ignore then
               tween.tweenFunction(5,0,1,"outElastic",function (t,e)
                  button:setDimensions(t,t,-t,-t)
                  sprite:setColor(math.lerp(colors[((o-1) % #colors) + 1],custom_clr or vectors.vec3(1,1,1),math.max(1-e*5,0)))
               end,nil,"simon"..o)
            end
            if not lock or ignore then
               if not mute then
                  sound("minecraft:block.stone_button.click_on")
                  sound("minecraft:block.note_block.bit",2^((o % 24 - 12)/12))
               end
               if not ignore then
                  if level ~= 0 then
                     guess[#guess+1] = o
                  end
                  if #guess >= #memory and level ~= 0 then
                     lock = true -- no overloading the guess
                  end
               end
            end
         end
         buttons[i] = press

         button.PRESSED:register(press)
         screen:addChild(button)
      end
   end   

   start_button.PRESSED:register(function ()
      if level == 0 then
         checkwin()
      end
      playing = true
   end)

   

   events.TICK:register(function ()
      vibe = math.lerp(vibe,playing and 1 or 0,0.1)
      --start_button
      if playing then
         time = time + 1
         if time % 20 == 0 then
            sound("minecraft:block.stone.break",0.5)
         elseif time % 20 == 5 and level >= 10 then
            sound("minecraft:block.note_block.hat",1)
         elseif time % 20 == 7 and level >= 20 then
            sound("minecraft:block.note_block.hat",1)
         elseif time % 20 == 10 and level >= 5 then
            sound("minecraft:block.note_block.snare",0.5)
         elseif time % 20 == 15 and level >= 10 then
            sound("minecraft:block.note_block.hat",1)
         elseif time % 20 == 12 and level >= 15 then
            sound("minecraft:block.note_block.hat",1)
         end
         if not loop_cooldown then
            if level < 30 then
               if time % 20 == 10 or time % 20 == 0 then
                  nexty()
               end
               if (time % 20 == 5 or time % 20 == 15) and level >= 0 then
                  nexty()
               end
            else
               if time % 5 == 0 then
                  nexty()
               end
            end
         end
         if time % 20 == 19 then
            loop_cooldown = false
         end
         if time % 20 == 0 then
            if level ~= 0 then
               checkwin()
            end
         end
      end
   end)
   screen:addChild(start_button)
   local exit = gnui.newLabel():setText({text="[X]"}):setAlign(1,1):setDimensions(0,0,15,10)
   exit.PRESSED:register(function ()
      events.exit()
   end)
   screen:addChild(exit)
end

avatar:store("gnui.app.ee",{
   update = client:getSystemTime(),
   name   = "Simon",
   new    = new,
   icon   = textures["textures.icons"],
   icon_atlas_pos = vectors.vec2(0,0)
})

--avatar:store("gnui.force_app","system:template")
--avatar:store("gnui.debug",true)
--avatar:store("gnui.force_app",client:getViewer():getUUID()..":template")
