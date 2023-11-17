local tl = models:newPart("HUDTopLeft","HUD")
local tr = models:newPart("HUDTopRight","HUD")
local bl = models:newPart("HUDBottomLeft","HUD")
local br = models:newPart("HUDBottomRight","HUD")
local c = models:newPart("HUDCenter","HUD")

local eventLib = require("libraries.eventLib")
local SCREEN_RESIZED = eventLib.new()

local last_window_size = vectors.vec2()
events.WORLD_RENDER:register(function (delta)
   local window_size = client:getScaledWindowSize()
   if last_window_size.x - window_size.x ~= 0 
   or last_window_size.y - window_size.y ~= 0 then
      tl:pos(0,0,0)
      c:pos(-window_size.x * 0.5,-window_size.y * 0.5,0)
      tr:pos(-window_size.x,0,0)
      bl:pos(0,-window_size.y,0)
      br:pos(-window_size.x,-window_size.y,0)
      SCREEN_RESIZED:invoke(window_size)
   end
   last_window_size = window_size
end)

return {
   BottomLeft = bl,
   BottomRight = br,
   TopLeft = tl,
   TopRight = tr,
   Center = c,
   SCREEN_RESIZED = SCREEN_RESIZED
}