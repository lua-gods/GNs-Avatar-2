if not host:isHost() then return end

local parseChat = require("libraries.chatFormatter")
events.CHAT_RECEIVE_MESSAGE:register(function (message, json_text)
   if message == "Could not set the block" then
      return false
   end
   return parseChat(json_text)
end)

--local filters = {
--   what = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
--   with = "48CD3F6H1JKLMN0PQR5+UVWXY2",
--}
--
--events.CHAT_SEND_MESSAGE:register(function (message)
--   for i = 1, #filters.what, 1 do
--      local a,b = filters.what:sub(i,i), filters.with:sub(i,i)
--      message = message:upper():gsub(a,b)
--   end
--   return message:lower()
--end)