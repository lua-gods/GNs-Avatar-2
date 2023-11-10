local command = require("services.command")

command.register(function (words)
   if words[1] == "eval" then
      local expression = ""
      for i = 2, #words, 1 do
         expression = expression .. words[i] .. " "
      end
      local success, result = pcall(load("return " .. expression))
      if success then
         command.announce(result)
      end
   end
   print()
   if words[1] == "convert" then
      if words[3] == "in"  and #words == 4 then
         command.announce((words[2] / words[4]) * 100 .. "% chance")
      elseif words[2]:sub(#words[2],#words[2]) == "%" and #words == 2 then
         command.announce(" 1 in " .. tostring(100 / tonumber(words[2]:sub(1,#words[2]-1))) .. " chance")
      end
   end
end)