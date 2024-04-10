local sidebar = require("host.sidebar")
local elements = require("libraries.panels")

return function ()
   local page = elements.newPage()
   local output
   
   local e = {
      elements.newElement():setText({text="CLONE COMMAND HELPER",color = "red"}),
      elements.newElement():setText("Source Position"),
      elements.newVector3Button(),
      elements.newButton():setText("Source to Selected"):setIconText(":pencil:",true),
      
      elements.newElement():forceHeight(8),
      
      elements.newElement():setText("Clone From / To"),
      elements.newVector3Button(),
      elements.newVector3Button(),
      elements.newButton():setText("set From to Selected"):setIconText(":pencil:",true),
      elements.newButton():setText("set To to Selected"):setIconText(":pencil:",true),
      
      elements.newElement():forceHeight(8),
      
      elements.newElement():setText("Paste To"),
      elements.newVector3Button(),
      elements.newButton():setText("set Paste to Selected"):setIconText(":pencil:",true),
      
      elements.newElement():forceHeight(8),
      elements.newElement():setText({text="Output goes here...",color="gray"}):setIconText(":mag:",true),
      elements.newButton():setText("Apply to Clipboard"):setIconText(":scroll:",true),
      sidebar.newReturnButton(),
   }
   
   local extraLine = require("libraries.GNLineExtra")
   local source = extraLine.newCube()
   local target = extraLine.newCube()
   local to = extraLine.newCube()
   
   page.PRESSENCE_CHANGED:register(function (active)
      source:setVisible(active)
      target:setVisible(active)
      to:setVisible(active)
   end)
   
   local function sourceChanged()
      local a = e[7].Vector
      local b = e[8].Vector
      local t = e[13].Vector
      local s = e[3].Vector
      source:setFrom(s):setTo(s + 1)
      
      if a and b then
         local low = vectors.vec3()
         local high = vectors.vec3(math.huge,math.huge,math.huge)
         
         low.x = math.min(a.x,b.x)
         low.y = math.min(a.y,b.y)
         low.z = math.min(a.z,b.z)
         
         high.x = math.max(a.x,b.x)
         high.y = math.max(a.y,b.y)
         high.z = math.max(a.z,b.z)
         target:setFrom(low):setTo(high + 1)
         if t then
            local size = high - low
            to:setFrom(t):setTo(t+size + 1)
   
            if s then
               output = string.format(
                  "/clone ~%i ~%i ~%i ~%i ~%i ~%i ~%i ~%i ~%i",
                  low.x - s.x, 
                  low.y - s.y, 
                  low.z - s.z,
      
                  high.x - s.x, 
                  high.y - s.y, 
                  high.z - s.z,
   
                  t.x - s.x,
                  t.y - s.y,
                  t.z - s.z
               )
               e[16]:setText({text=output,color="gray"})
            end
         end
      end
   end
   
   
   e[3].VECTOR_CHANGED:register(sourceChanged)
   e[7].VECTOR_CHANGED:register(sourceChanged)
   e[8].VECTOR_CHANGED:register(sourceChanged)
   e[13].VECTOR_CHANGED:register(sourceChanged)
   e[17].PRESSED:register(function ()
      host:setClipboard(output)
   end)
   
   e[4].PRESSED:register(function ()
      e[3]:setVector(player:getTargetedBlock():getPos())
   end)
   
   e[9].PRESSED:register(function ()
      e[7]:setVector(player:getTargetedBlock():getPos())
   end)
   e[10].PRESSED:register(function ()
      e[8]:setVector(player:getTargetedBlock():getPos())
   end)
   
   e[14].PRESSED:register(function ()
      e[13]:setVector(player:getTargetedBlock():getPos())
   end)
   
   page:addElement(table.unpack(e))
   return page
end