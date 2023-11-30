if not host:isHost() then return end
local lib = {}
local commands = {}
local prefix = "$"

function lib.announce(message)
   printJson('{"text":"'..message..'\n","color":"gray"}')
end

events.CHAT_SEND_MESSAGE:register(function (message)
   if message:sub(1,#prefix) == prefix then
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
      for key, func in pairs(commands) do
         local success, result = pcall(func,words)
         if not success then
            print("§c"..result)
         end
      end
      return ""
   end
   return message
end)

events.WORLD_TICK:register(function ()
   local text = host:getChatText()
   if text and text:sub(1,#prefix) == prefix then
      host:setChatColor(1,1,0)
   else
      host:setChatColor(1,1,1)
   end
end)

---@param func fun(words : table<any,string>)
function lib.register(func)
   commands[#commands+1] = func
   return #commands
end

function lib.remove(id)
   commands[id] = nil
end

return lib