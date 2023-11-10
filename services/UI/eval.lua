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
end)