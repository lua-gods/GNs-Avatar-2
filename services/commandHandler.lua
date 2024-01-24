--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
--[[
This service aims to aid the creation of custom commands in chat
]]

if not host:isHost() then return end


local PREFIX = "$" -- every message with this at the start will get canceled from being sent in chat reguardless if one exists or not
local ANNOUNCE_LAYOUT = '[{"text":"[cmd] ","color":"dark_gray"},{"text":"%s\n","color":"gray"}]'-- replaces %s with the message

local screen = require("services.screenui")
local lib = {}
local commands = {}
function lib.announce(message)
   printJson(ANNOUNCE_LAYOUT:format(message))
end

events.CHAT_SEND_MESSAGE:register(function (message)
   if message and message:sub(1,#PREFIX) == PREFIX then
      local words = {}
      local word = ""
      local inside_string = false
      for i = 2, #message, 1 do
         local char = message:sub(i,i)
         if char == " " and not inside_string then
            words[#words+1] = word
            word = ""
         else
            if char == '"' or char == "'" then
               inside_string = not inside_string
            else
               word = word .. char
            end
         end
      end
      words[#words+1] = word
      host:appendChatHistory(message)
      for _, func in pairs(commands) do
         local success, result = pcall(func,words)
         if not success then
            print("§c"..result)
         end
      end
      return ""
   end
   return message
end)


-- makes chat yellow to indicate its not gonna be sent in chat.

local commanding = false
events.WORLD_TICK:register(function ()
   local text = host:getChatText()
   if text and text:sub(1,#PREFIX) == PREFIX then
      if not commanding then
         host:setChatColor(1,1,0)
         commanding = true
      end
   else
      if commanding then
         host:setChatColor(1,1,1)
         commanding = false
      end
   end
end)

---Registers a command that will part take in checking if the message contains the words to trigger it.
---@param func fun(words : table<any,string>)
function lib.register(func)
   commands[#commands+1] = func
   return #commands
end

function lib.remove(id)
   commands[id] = nil
end

return lib