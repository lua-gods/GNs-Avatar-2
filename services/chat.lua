--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
--[[ A Service script that adds tweaks to chat ]]
if not host:isHost() then return end

local chat_sounds = {
   { -- talk
      when = {
         "chat.type.text",
         "chat.type.emote",
         "chat.type.announcement"
      },
      play = {{id="minecraft:entity.item.pickup",pitch=0.6,volume=0.08}}
   },
   {
      when = {
         "chat.type.admin",
         "commands.",   
      },
      play = {
         --{id="minecraft:block.note_block.banjo",pitch=1.5,volume=0.2},--{id="minecraft:entity.elder_guardian.hurt",pitch=0.9,volume=1},--{id="minecraft:entity.blaze.hurt",pitch=0.5,volume=1},
         {id="minecraft:entity.item.pickup",pitch=3,volume=0.2}
      },
   },
   {
      when = {
         "multiplayer.player.left",
      },
      play = {{id="minecraft:block.barrel.close",pitch=0.9,volume=1},}
   },
   {
      when = {
         "multiplayer.player.joined",
         "multiplayer.player.joined.renamed",
      },
      play = {{id="minecraft:block.barrel.open",pitch=0.9,volume=1},}
   },
   ping = {
      play = {{id="minecraft:block.note_block.pling",pitch=1.2,volume=1}}
   },
   death = {
      play = {{id="minecraft:block.bell.use",pitch=0.5,volume=1}}
   }
}

--[[local function fragment(text,keyword)
   keyword = keyword:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
   local fragments = {}
   for word,kw in string.gmatch(text .. "#000000" ,"([^"..keyword.."]*)("..keyword..")") do
      if #word > 0 then
         fragments[#fragments+1] = word
      end
      if #kw > 0 then
         fragments[#fragments+1] = kw
      end
   end
   fragments[#fragments] = nil
   return fragments
end]]

local function fragment(text,keyword)
   local init = 0
   local slice = {}
   slice[1] = 0
   for i = 1, 100, 1 do
      local a,b = string.find(text,keyword,init)
      if not b then break end
      init = b
      slice[#slice+1] = a
      slice[#slice+1] = b
   end
   local split = {}
   
   for i = 1, #slice, 1 do
      split[#split+1] = text:sub(
         #split % 2 == 1 and slice[i] or slice[i]+1,
         slice[i+1] and (#split % 2 == 1 and slice[i+1] or slice[i+1]-1) or -1)
   end
   return split
end

--print(fragment("Heello Weerld","ee"))

--print(fragment("hex detect #00ff00 cool #ff0000 amazing","#%x%x%x%x%x%x"))

events.CHAT_RECEIVE_MESSAGE:register(function (message, json_text)
   local json = parseJson(json_text)
   if json.translate then
      local found = false
      for _, query in pairs(chat_sounds) do
         if query.when then
            for _, pattern in pairs(query.when) do
               if json.translate:find(pattern) then -- same context
                  for key, soundata in pairs(query.play) do
                     sounds[soundata.id]:pos(client:getCameraPos():add(client:getCameraDir())):pitch(soundata.pitch or 1):volume(soundata.volume or 1):play()
                     found = true
                  end
                  break
               end
            end
         end
         if found then
            break
         end
      end
      local translation = client.getTranslatedString(json.translate)
      local compose = {{text=""}} --[[@type table<any,any> why]]

      -- convert plain text translation to raw json text translation
      for word,place in string.gmatch(translation .. "%s" ,"([^%%s]*)(%%s*)") do
         if #word > 0 then
            compose[#compose+1] = {text = word}
         end
         if #place > 0 then
            compose[#compose+1] = "%s"
         end
      end

      -- replace all placeholders with json.with
      local placeholder_found = 0
      for i = 1, #compose, 1 do 
         if compose[i] == "%s" then
            placeholder_found = placeholder_found + 1
            compose[i] = json.with[placeholder_found]
            if #json.with == placeholder_found then
               break
            end
         end
      end

      -- trim off existing empty place holders
      for key, value in pairs(compose) do
         if value == "%s" then
            table.remove(compose,key)
         end
      end

      -- replace hex codes with colored ones
      for i = 1, #compose, 1 do
         local component = compose[i]
         local inserted = false
         local frag = fragment(component.text,"#%x%x%x%x%x%x")
         if #frag > 1 then -- if modified
            table.remove(compose,i) -- remove last
            for o, txtfrag in pairs(frag) do
               if txtfrag:find("#%x%x%x%x%x%x") then
                  table.insert(compose,i,{
                     text=txtfrag,
                     color=txtfrag,
                     clickEvent={
                        action="suggest_command",
                        value=txtfrag
                     },
                     hoverEvent={
                        action = "show_text",
                        contents = "Copy to Clipboard"
                     }
                  })
               else
                  table.insert(compose,i,{text=txtfrag})
               end
               i = i + 1
            end
         end
      end
      --printTable(compose,3)
      return toJson(compose)
   else
      return toJson(json)
   end
end)