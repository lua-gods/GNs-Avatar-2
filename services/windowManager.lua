local gnui = require("libraries.gnui")
local screen = require("services.screenui")

local winapi = {windows = {}}

local sprite_window = gnui.newSprite()
sprite_window:setTexture(textures["textures.window"])
sprite_window:setBorderThickness(2,12,24,1)

function winapi.newWindow()
   local window = gnui.newContainer()
   window:setSprite(sprite_window:duplicate())
   window:setSize(130,120):setPos(16,16)
   local window_label = gnui.newLabel()
   window_label:setText("#000000Window Example")
   window_label:setAnchor(0,0,1,1)
   window_label:setPadding(5,5,5,5)
   window_label:setMargin(5,5,5,5)
   window_label:canCaptureCursor(false)
   window:addChild(window_label)
   screen:addChild(window)
   winapi.windows[#winapi.windows+1] = window
   return window
end

winapi.newWindow()
winapi.newWindow()

local input = {
   mouse_left = keybinds:newKeybind("Left Mouse","key.mouse.left",true),
   action_wheel = keybinds:fromVanilla("figura.config.action_wheel_button")
}

local window_selected
local window_resize_type = 0
input.action_wheel.press = function ()
   host:setUnlockCursor(true)
   return true
end

input.action_wheel.release = function ()
   host:setUnlockCursor(false)
   return true
end

input.mouse_left.press = function ()
   window_resize_type = 0
   for id, window in pairs(winapi.windows) do
      if window.Hovering then
         window_selected = window
         if window.Cursor.x < 3 and window.Cursor.y < 3 then -- top left
            window_resize_type = 1
         elseif window.Dimensions.z-window.Cursor.x < 3 and window.Cursor.y < 3 then -- top right
            window_resize_type = 2
         elseif window.Cursor.x < 3 and window.Dimensions.w-window.Cursor.y < 3  then -- bottom left
            window_resize_type = 3
         elseif window.Dimensions.z-window.Cursor.x < 3 and window.Dimensions.w-window.Cursor.y < 3 then -- bottom right
            window_resize_type = 4
         elseif window.Cursor.x < 3 then -- left edge
            window_resize_type = 5
         elseif window.Cursor.y < 3 then -- top edge
            window_resize_type = 6
         elseif window.Dimensions.z-window.Cursor.x < 3 then -- bottom edge
            window_resize_type = 7
         elseif window.Dimensions.w-window.Cursor.y < 3 then -- bottom edge
            window_resize_type = 8
         elseif window.Cursor.y < 10 then -- top bar
            window_resize_type = 9
         end
         break
      end
   end
end

input.mouse_left.release = function ()
   window_selected = nil
   window_resize_type = 0
end

events.MOUSE_MOVE:register(function (x, y)
   local drag = vectors.vec2(x,y) / client:getGuiScale()
   if window_selected and input.mouse_left:isPressed() then
      local dim = window_selected.Dimensions
      if window_resize_type == 1 then -- top left
         dim.xy = dim.xy + drag
         dim.zw = dim.zw - drag
      elseif window_resize_type == 2 then -- top right
         dim.z = dim.z + drag.x
         dim.y = dim.y + drag.y
         dim.w = dim.w - drag.y
      elseif window_resize_type == 3 then -- bottom left
         dim.z = dim.z - drag.x
         dim.x = dim.x + drag.x
         dim.w = dim.w + drag.y
      elseif window_resize_type == 4 then -- bottom right
         dim.z = dim.z + drag.x
         dim.w = dim.w + drag.y
      elseif window_resize_type == 5 then -- left edge
         dim.x = dim.x + drag.x
         dim.z = dim.z - drag.x
      elseif window_resize_type == 6 then -- top edge
         dim.y = dim.y + drag.y
         dim.w = dim.w - drag.y
      elseif window_resize_type == 7 then -- bottom edge
         dim.z = dim.z + drag.x
      elseif window_resize_type == 8 then -- bottom edge
         dim.w = dim.w + drag.y
      elseif window_resize_type == 9 then -- top bar
         dim.xy = dim.xy + drag
      end
      dim.z = math.max(dim.z,25)
      dim.w = math.max(dim.w,15)

      window_selected:setTopLeft(dim.xy)
      window_selected:setSize(dim.z,dim.w)
   end
end)

return winapi