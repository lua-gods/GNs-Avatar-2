--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
--[[
This service aims to aid the creation of custom commands in chat
]]

if not host:isHost() then return end

---@alias CommandQuery.argumentType string
---| "INT"
---| "NUMBER"
---| "STRING"
---| "STRINGALL" -- all arguments merged into one big string
---| "XPOS" -- position
---| "YPOS"
---| "ZPOS"

---@class CommandQuery
---@field func function
---@field args table<integer,CommandQuery.argumentType|function>


local PREFIX = "$" -- every message with this at the start will get canceled from being sent in chat reguardless if one exists or not
local ANNOUNCE_LAYOUT = '[{"text":"[cmd] ","color":"dark_gray"},{"text":"%s\n","color":"gray"}]'-- replaces %s with the message

local lib = {}
local commands = {}

for key, dir in pairs(listFiles("cmd")) do
   local name = dir:match("%.[%s%S]+$"):sub(2,-1)
   commands[name] = require(dir)
end

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

local new_message = 0
local commanding = false
events.CHAT_RECEIVE_MESSAGE:register(function (message, json)
   new_message = new_message + 1
end)

events.WORLD_RENDER:register(function ()
   if new_message > 0 then
      if commanding then
         local msg = {}
         for i = 1, new_message+1, 1 do
            local m = host:getChatMessage(i)
            if not m then break end
            msg[i] = m.json
         end
         table.insert(msg,1,msg[#msg])
         msg[#msg] = nil
         for i = 1, #msg, 1 do
            host:setChatMessage(i,msg[i])
         end
      end
   end
   new_message = 0
end)

-- makes chat yellow to indicate its not gonna be sent in chat.


events.WORLD_TICK:register(function ()
   local text = host:getChatText()
   if text and text:sub(1,#PREFIX) == PREFIX then
      if not commanding then
         host:setChatColor(1,1,0)
         commanding = true
         print("$ Checkpoint \n[name:string?]")
         new_message = -1
      end
   else
      if commanding then
         host:setChatColor(1,1,1)
         host:setChatMessage(1,nil)
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