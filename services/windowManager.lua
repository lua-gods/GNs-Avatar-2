local gnui = require("libraries.gnui")
local screen = require("services.screenui")


local sprite_window = gnui.newSprite()
sprite_window:setTexture(textures["textures.window"])
sprite_window:setBorderThickness(2,12,24,1)

local window = gnui.newContainer()
window:setSprite(sprite_window)
window:setSize(130,120):setPos(16,16)
local window_label = gnui.newLabel()
window_label:setText("#000000Window Example")
window_label:setAnchor(0,0,1,1)
window_label:setMargin(1,1,1,1)
window_label:canCaptureCursor(false)
window:addChild(window_label)

local input = {
   mouse_left = keybinds:newKeybind("Left Mouse","key.mouse.left",true)
}

events.MOUSE_MOVE:register(function (x, y)
   local drag = vectors.vec2(x,y) / client:getGuiScale()
   if window.Hovering and input.mouse_left:isPressed() then
      local dim = window.Dimensions
      if window.Cursor.x < 3 and window.Cursor.y < 3 then -- top left
         dim.xy = dim.xy + drag
         dim.zw = dim.zw - drag
      elseif window.Dimensions.z-window.Cursor.x < 3 and window.Cursor.y < 3 then -- top right
         dim.z = dim.z + drag.x
         dim.y = dim.y + drag.y
         dim.w = dim.w - drag.y
      elseif window.Cursor.x < 3 and window.Dimensions.w-window.Cursor.y < 3  then -- bottom left
         dim.z = dim.z - drag.x
         dim.x = dim.x + drag.x
         dim.w = dim.w + drag.y
      elseif window.Dimensions.z-window.Cursor.x < 3 and window.Dimensions.w-window.Cursor.y < 3 then -- bottom right
         dim.z = dim.z + drag.x
         dim.w = dim.w + drag.y
      elseif window.Cursor.x < 3 then -- left edge
         dim.x = dim.x + drag.x
         dim.z = dim.z - drag.x
      elseif window.Cursor.y < 3 then -- top edge
         dim.y = dim.y + drag.y
         dim.w = dim.w - drag.y
      elseif window.Dimensions.z-window.Cursor.x < 3 then -- bottom edge
         dim.z = dim.z + drag.x
      elseif window.Dimensions.w-window.Cursor.y < 3 then -- bottom edge
         dim.w = dim.w + drag.y
      elseif window.Cursor.y < 10 then -- top bar
         dim.xy = dim.xy + drag
      end
      dim.z = math.max(dim.z,25)
      dim.w = math.max(dim.w,15)

      window:setTopLeft(dim.xy)
      window:setSize(dim.z,dim.w)
   end
end)

screen:addChild(window)