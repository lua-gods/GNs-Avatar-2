if not host:isHost() then return end

local parseChat = require("libraries.chatFormatter")
events.CHAT_RECEIVE_MESSAGE:register(function (message, json_text)
   return parseChat(json_text)
end)