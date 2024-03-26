local mute = {
   GNamimates = true
}

local new_message = 0
local parseChat = require("libraries.chatHandler")
events.CHAT_RECEIVE_MESSAGE:register(function (message, json_text)
   local json = parseJson(json_text)
   --if json and json.translate == "chat.type.text" then
   --   local block = false
   --   if mute[json.with[1].text] then
   --      new_message = new_message + 1
   --      return nil
   --   end
   --end
   return parseChat(json_text)
end)