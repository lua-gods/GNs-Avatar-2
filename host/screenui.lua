if not host:isHost() then return end
local gnui = require("libraries.gnui")

local screen = gnui.newContainer()
models:addChild(screen.ModelPart)
screen.ModelPart:setParentType("HUD")

local screen_size = vectors.vec2(0,0)
events.WORLD_RENDER:register(function (delta)
   local new_screen_size = client:getScaledWindowSize()
   if screen_size ~= new_screen_size then
      screen_size = new_screen_size
      screen:setBottomRight(new_screen_size)
   end
end)

events.MOUSE_MOVE:register(function (x, y)
   if not host:getScreen() or host:isChatOpen() then
      local pos = client:getMousePos()/client:getGuiScale()
      screen:setCursor(pos)
   end
end)


return screen