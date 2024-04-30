local gnui = require("libraries.GNUI")
local screen = require("services.screenui")
local tween = require("libraries.GNTweenLib")
local hudSound = require("libraries.hudsound")

local config = {
   uv = vectors.vec4(0,0,10,10)
}

local sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(config.uv):setRenderType("TRANSLUCENT_CULL")

local crosshair = gnui.newContainer():setSprite(sprite)
local size = vectors.vec2(config.uv.z-config.uv.x,config.uv.w-config.uv.y):mul(0.5,0.5)
crosshair:setDimensions(-size.x,-size.y,size.x,size.y):setAnchor(0.5,0.5,0.5,0.5)
screen:addChild(crosshair)

events.WORLD_RENDER:register(function ()
   if renderer:isFirstPerson() then
      local data = raycast:block(client:getCameraPos(),client:getCameraPos()+client:getCameraDir()*100) --[[@type BlockState]]
      local clr = data:getMapColor()
      sprite:setColor(1-clr.x,1-clr.y,1-clr.z)
      crosshair:setVisible(true)
   else
      crosshair:setVisible(false)
   end
end)

