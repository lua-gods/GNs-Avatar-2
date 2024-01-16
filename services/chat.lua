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
   end
   --json.with[1].text = "Amogus"
   return toJson(json)
end)