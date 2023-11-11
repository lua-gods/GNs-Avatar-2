local command = require("services.command")

command.register(function (words)
   if words[1] == "eval" then
      if #words == 4 and words[3] == "in" then
         command.announce((words[2] / words[4]) * 100 .. "% chance")
      elseif #words >= 2 and words[2]:sub(-1,-1) == "%" and #words == 2 then
         command.announce(" 1 in " .. 100 / tonumber(words[2]:sub(1,-2)) .. " chance")
      else
         local expression = ""
         for i = 2, #words, 1 do
            expression = expression .. words[i] .. " "
         end
         local success, result = pcall(load("return " .. expression))
         if success then
            command.announce(result)
         end
      end
   end
end)