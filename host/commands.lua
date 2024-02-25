if not host:isHost() then return end

local chpos,chrot

local horn_proxy = {
   feet = "73ede7e6-8404-44c0-a692-18f22cf17e66", -- gd defeat
   hoho = "1fc12595-38f7-48fe-b9f1-129a04e2d783", -- gd flashbang
   ["fire in the hole"] = "c15f44e1-5e85-46c9-a44d-50416ec0effc",
   ["spongebob dramatic queue"] = "c6447916-520e-4b2f-82ef-3c4a0c694276",
   rah = "781874b1-d434-4586-b6be-0334b2ba50b5",
   ["taco bell"] = "75fe2138-8de0-4927-8dc5-6cdebb7feb16",
}

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
   
   elseif words[1] == "tonether" and #words == 3 then -- solve
      command.announce("nether: " .. tonumber(words[2]) / 8 .. " " .. tonumber(words[3]) / 8)
   
   elseif words[1] == "tooverworld" and #words == 3 then -- solve
      command.announce("overworld: " .. tonumber(words[2]) * 8 .. "~" .. tonumber(words[2]+1) * 8 .. " " .. tonumber(words[3]) * 8 .. "~" .. tonumber(words[3]+1) * 8)
   
   elseif words[1] == "checkpoint" then
      if chpos then
         host:sendChatCommand("/tp @s "..chpos.x.." "..chpos.y.." "..chpos.z.." "..chrot.y.." "..chrot.x)
         chpos = nil
         command.announce("back to checkpoint")
      else
         chpos = player:getPos()
         chrot = player:getRot()
         command.announce("checkpoint saved")
      end
   
   elseif words[1] == "pos" and #words == 1 then
      local pos = player:getPos():floor()
      host:appendChatHistory(pos.x.." "..pos.y.." "..pos.z)
      command.announce("pos: "..pos.x.." "..pos.y.." "..pos.z)
   elseif words[1] == "horn" and words[2] then
      table.remove(words,1)
      local final = table.concat(words," ")
      if horn_proxy[final] then
         if player:getHeldItem().id == "minecraft:goat_horn" then
            host:sendChatCommand("/audioplayer goathorn "..horn_proxy[final])
         else
            command.announce("hold a goat horn")
         end
      else
         command.announce("no proxy for that key")
      end
   end
end)