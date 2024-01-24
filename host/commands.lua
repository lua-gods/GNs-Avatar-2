if not host:isHost() then return end
local command = require("services.commandHandler")
command.register(function (words)
   if words[1] == "calc" or words[1] == "solve" or words[1] == "eval" then -- solve
      table.remove(words,1)
      local solve = load("return " .. table.concat(words," "),"calculate",{math = math})
      command.announce(table.concat(words," ") .." = " .. solve())
   elseif words[1] == "gmatch" then
      command.announce("Matching "..words[3].." with "..words[2])
      local i = 0
      for word in string.gmatch(words[3],words[2]) do
         i = i + 1
         command.announce(i.." '"..word.."'")
      end
   elseif words[1] == "rev" then
      table.remove(words,1)
      local msg = table.concat(words," ")
      local rev = ""
      for i = 1, #msg, 1 do
         rev = msg:sub(i,i) .. rev
      end
      host:sendChatMessage(rev)
   end
end)