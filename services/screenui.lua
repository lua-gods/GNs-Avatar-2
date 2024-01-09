if not host:isHost() then return end
local gnui = require("libraries.gnui")

local panel_texture = gnui.newSprite()
:setTexture(textures["textures.window"])
:setBorderThickness(2,2,2,2)
:excludeMiddle(false)

local screen = gnui.newContainer()
models:addChild(screen.Part)
screen.Part:setParentType("HUD")
--window:setSprite(panel_texture)


local screen_size = vectors.vec2(0,0)
events.WORLD_RENDER:register(function (delta)
   local new_screen_size = client:getScaledWindowSize()
   if screen_size ~= new_screen_size then
      screen_size = new_screen_size
      screen:setSize(new_screen_size)
   end
end)

events.MOUSE_MOVE:register(function (x, y)
   if not host:getScreen() or host:isChatOpen() then
      local pos = client:getMousePos()/client:getGuiScale()
      screen:setCursor(pos)
   end
end)


return screen