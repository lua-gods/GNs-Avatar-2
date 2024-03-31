--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
--[[ A Service script that adds tweaks to chat ]]
if not host:isHost() then error("Script made to run on host only") end

local chat = {}

---@type {when:string[],play:{id:Minecraft.soundID,pitch:number,volume:number}[],override:string}[]
local properties = {
   { -- talk
      when = {
         "chat.type.text",
      },
      override = "%s §8: §r%s",
      play = {{id="minecraft:entity.item.pickup",pitch=0.6,volume=0.08}}
   },
   { -- /me
      when = {
         "chat.type.emote",
      },
      override = "* %s %s",
      play = {{id="minecraft:entity.item.pickup",pitch=0.55,volume=0.08}}
   },
   { -- /say
      when = {
         "chat.type.announcement"
      },
      override = "[%s] §8: §r%s",
      play = {{id="minecraft:entity.item.pickup",pitch=0.55,volume=0.08}}
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
      override = "§e%s §eleft the game",
      play = {{id="minecraft:block.barrel.close",pitch=0.9,volume=1},},
   },
   {
      when = {
         "multiplayer.player.joined",
      },
      override = "§e%s §ejoined the game",
      play = {{id="minecraft:block.barrel.open",pitch=0.9,volume=1},}
   },
   {
      when = {
         "multiplayer.player.joined.renamed",
      },
      override = "§e%s §e(formly known as %s) joined the game",
      play = {{id="minecraft:block.barrel.open",pitch=0.9,volume=1},}
   },
   ping = {
      play = {{id="minecraft:block.note_block.pling",pitch=1.2,volume=1}}
   },
   death = {
      play = {{id="minecraft:block.bell.use",pitch=0.5,volume=1}}
   }
}

local function fragment(text,keyword)
   local init = 1
   local slice = {}
   slice[1] = 1
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

local function parseChatMessage(json_text)
   local json = type(json_text) == "string" and parseJson(json_text) or json_text
   if json.translate then
      local translation = client.getTranslatedString(json.translate) or "%s"
      
      -- play sounds and override translation
      local found_sound = false
      for _, query in pairs(properties) do
         if query.when then
            for _, pattern in pairs(query.when) do
               if json.translate:find(pattern) then -- same context
                  for key, soundata in pairs(query.play) do
                     sounds[soundata.id]:pos(client:getCameraPos():add(client:getCameraDir())):pitch(soundata.pitch or 1):volume(soundata.volume or 1):play()
                     found_sound = true
                  end
                  if query.override then
                     translation = query.override
                  end
                  break
               end
            end
         end
         if found_sound then
            break
         end
      end


      local compose = {} --[[@type table<any,any> why]]
      compose[#compose+1] = ""

      --if not overriden_translation and client.getTranslatedString(translation) == translation then -- no translation found
      --   translation = json.fallback
      --end

      if not json.with then
         compose[1] = json.fallback
      end
      
      -- convert plain text translation to raw json text translation
      do
         local last_next = 0
         local accumulated = ""
         local i = 0
         for _ = 1, #translation, 1 do
            i = i + 1
            local what_sus = ""
            local found_sus = false
            if translation:sub(i,i+1) == "%s" then -- convert %s to %1$s
               
               if #accumulated:sub(#what_sus,-1) > 0 then
                  compose[#compose+1] = accumulated:sub(#what_sus,-1)
               end
               accumulated = ""
               
               last_next = last_next + 1
               what_sus = "%"..(last_next).."$s"
               i = i + 1
               found_sus = true
            else
               for d = 1, 10, 1 do
                  local sus = "%"..d.."$s"
                  if translation:sub(i,i+#sus-1) == sus then  -- if already converted
                     found_sus = true
                     what_sus = sus 
                     i = i + #what_sus-1
                     break
                  end
               end
            end

            if found_sus then
               if #accumulated:sub(#what_sus,-1) > 0 then
                  compose[#compose+1] = accumulated:sub(#what_sus,-1)
               end
               accumulated = ""
               compose[#compose+1] = what_sus
            else
               accumulated = accumulated .. translation:sub(i,i)
            end
         end
         if #accumulated > 0 then
            compose[#compose+1] = accumulated
         end
      end

      -- replace all placeholders with json.with
      local placeholder_found = 0
      for i = 1, #compose, 1 do 
         if compose[i]:match("%%%d+$s") then
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
         local frag = fragment(component.text or "","#%x%x%x%x%x%x")
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

      -- replace links with clickable links
      for i = 1, #compose, 1 do
         local component = compose[i]
         local frag = fragment(component.text or "","https://[%a%d;,/?:@&=+$-_.!~*'()#]+")
         if #frag > 1 then -- if modified
            table.remove(compose,i) -- remove last
            for o, txtfrag in pairs(frag) do
               if txtfrag:find("https://[%a%d;,/?:@&=+$-_.!~*'()#]+") then
                  table.insert(compose,i,{
                     text = txtfrag,
                     color = "yellow",
                     underlined = true,
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
                  component.text = txtfrag
                  table.insert(compose,i,component)
               end
               i = i + 1
            end
         end
      end
      
      -- debug mode
      
      if false then
         table.insert(compose,2,{
            text = "[json]",
            color = "#00ff00",
            hoverEvent = {
               action = "show_text",
               contents = printTable(compose,10,true)
               :gsub("\t"," ")
               :gsub("%[%d+%] = table: ","")
               :gsub("^table: ","")
               :gsub("%[\"",'"')
               :gsub("\"]","'")
               :gsub("}[ \n]+{","}{")
            }
         })

         table.insert(compose,2,{
            text = "[t]",
            color = "#ffaa00",
            hoverEvent = {
               action = "show_text",
               contents = json.translate
            }
         })
         table.insert(compose,2,{
            text = "[t]",
            color = "#ffcc00",
            hoverEvent = {
               action = "show_text",
               contents = client.getTranslatedString(json.translate)
            }
         })


         table.insert(compose,2,{
            text = "[pre]",
            color = "#ff0000",
            hoverEvent = {
               action = "show_text",
               contents = toJson(json)
            }
         })
      end
      return toJson(compose)
   else
      return toJson(json)
   end
end

return parseChatMessage,properties