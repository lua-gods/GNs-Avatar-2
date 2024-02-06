local parseChat = require("libraries.chatHandler")
events.CHAT_RECEIVE_MESSAGE:register(function (message, json_text)
   return parseChat(json_text)
end)