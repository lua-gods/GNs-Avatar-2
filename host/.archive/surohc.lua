events.CHAT_RECEIVE_MESSAGE:register(function (message, json_text)
   local json = parseJson(json_text)
   if json.translate == "chat.type.text" then
      if json.with[1].text == "TheBluecreeper64" then
         local flipped = ""
         for i = 1, #json.with[2].text, 1 do
            flipped = json.with[2].text:sub(i,i) .. flipped
         end
         json.with[2].text = flipped
         return toJson(json)
      end
   end
end)