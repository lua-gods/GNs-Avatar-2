return function ()
   local sidebar = require("host.sidebar")
   local panels = require("libraries.panels")
   local page = panels.newPage()
   
   local e = {
      panels.newTextEdit():setText("data/images/*.png"):setForceFull(true),
      panels.newButton():setIconText(":pencil:",true):setText("Give")
   }
   
   e[2].PRESSED:register(function ()
      local t = e[1].value 
      ---@cast t string

      local file = require("libraries.file")
      local base64 = require("libraries.base64")
      local f = file.new("images/"..t..".png")
      local ok,result = pcall(f.readByteArray,f,t)
      if ok then
         local data = base64.encode("images;"..(result))
         local text = 'minecraft:player_head{SkullOwner:{Id:[I;1481619325,1543653003,-1514517150,-829510686],Properties:{textures:[{Value:"'..data..'"}]}}}'
         if #text < 65536 then
            host:setSlot("hotbar.0",text)
            print("Generated ("..#text.." < 65536)")
         else
            print("Exceeded byte limit ("..#text.." > 65536)")
         end
      end
   end)
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   return page
end