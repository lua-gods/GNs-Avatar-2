if not host:isHost() then return end
---@diagnostic disable: undefined-field
local gnui = require("libraries.gnui")
local screen = require("services.screenui")
local tween = require("libraries.GNTweenLib")
local eventLib = require("libraries.eventHandler")

local winapi = {
   windows = {} --[[@type table<any,Window>]]
}

---@class Window
---@field invincible boolean
---@field minimized boolean
---@field size Vector2
---@field TICK EventLib
---@field FRAME EventLib
---@field EXIT EventLib
---@field container GNUI.container
---@field titlebar GNUI.container
---@field window_close GNUI.container
---@field label GNUI.Label
local Window = {}
Window.__index = Window

---@param title string
---@return Window
function Window:setTitle(title)
   self.label:setText(title)
   return self
end

function Window:close()
   self.EXIT:invoke()
   self.container:free()
   winapi.windows[self.id] = nil
end

function Window:hide()
   
end

function Window:show()
   
end

local sprite_window = gnui.newSprite()
sprite_window:setTexture(textures["textures.window"])
sprite_window:setBorderThickness(1,1,1,1)
sprite_window:setUV(0,4,2,6)
sprite_window:setRenderType("TRANSLUCENT")

local sprite_titlebar = gnui.newSprite()
sprite_titlebar:setTexture(textures["textures.window"])
sprite_titlebar:setBorderThickness(1,1,1,2)
sprite_titlebar:setUV(0,0,2,3)

local sprite_close = gnui.newSprite()
sprite_close:setTexture(textures["textures.window"])
sprite_close:setUV(7,0,13,6)
sprite_close:setRenderType("CUTOUT_CULL")

local sprite_minimize = gnui.newSprite()
sprite_minimize:setTexture(textures["textures.window"])
sprite_minimize:setUV(14,0,20,6)
sprite_minimize:setRenderType("CUTOUT_CULL")

---@param invincible boolean?
---@return Window
function winapi.newWindow(invincible)
   local window = gnui.newContainer()
   window:setSprite(sprite_window:duplicate())
   window:setDimensions(32,32,128,128)

   local window_titlebar = gnui.newContainer()
   window_titlebar:setAnchor(0,0,1,0)
   window_titlebar:offsetBottomRight(0,10)
   window_titlebar:setSprite(sprite_titlebar:duplicate())
   window_titlebar:canCaptureCursor(false)
   window_titlebar:setZ(2)

   local window_label = gnui.newLabel()
   window_label:setText("Untitled")
   window_label:setAnchor(0,0,1,1):setDimensions(0.5,0.5,-0.5,-0.5)
   window_label:canCaptureCursor(false)
   window_label:setZ(2)
   
   local x = 0
   local window_close
   if not invincible then
      window_close = gnui.newContainer()
      window_close:setSprite(sprite_close)
      window_close:setAnchor(1,0,1,0)
      window_close:setDimensions(-8+x,1,-1,8+x)
      x = x - 8
   end

   local window_minimize = gnui.newContainer()
   window_minimize:setSprite(sprite_minimize)
   window_minimize:setAnchor(1,0,1,0)
   window_minimize:setDimensions(-8+x,1,-1+x,8)
   window_minimize:setZ(2)
   
   window:addChild(window_titlebar)
   window:addChild(window_label)
   if window_close then
      window:addChild(window_close)
   end
   window:addChild(window_minimize)
   screen:addChild(window)
   
   local new = {}
   new.TICK = eventLib.new()
   new.FRAME = eventLib.new()
   new.EXIT = eventLib.new()
   new.container = window
   new.invincible = invincible
   new.minimized = false
   new.titlebar = window_titlebar
   new.label = window_label
   new.button_close = window_close
   new.button_minimize = window_minimize
   local id = #winapi.windows+1
   new.id = id
   setmetatable(new,Window)
   winapi.windows[id] = new
   return new
end


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
   for id, win_dat in pairs(winapi.windows) do
      if win_dat.button_close and win_dat.button_close.Hovering then
         win_dat:close()
      end
      if win_dat.button_minimize and win_dat.button_minimize.Hovering then
         win_dat.minimized = not win_dat.minimized
         if win_dat.minimized then
            win_dat:hide()
         else
            win_dat:show()
         end
      end
      local window = win_dat.container
      if window.Hovering then
         window_selected = win_dat
         local size = window.ContainmentRect.zw-window.ContainmentRect.xy
         if window.Cursor.x < 3 and window.Cursor.y < 3 then -- top left
            window_resize_type = 1
         elseif size.x-window.Cursor.x < 3 and window.Cursor.y < 3 then -- top right
            window_resize_type = 2
         elseif window.Cursor.x < 3 and size.y-window.Cursor.y < 3  then -- bottom left
            window_resize_type = 3
         elseif size.x-window.Cursor.x < 3 and size.y-window.Cursor.y < 3 then -- bottom right
            window_resize_type = 4
         elseif window.Cursor.x < 3 then -- left edge
            window_resize_type = 5
         elseif window.Cursor.y < 3 then -- top edge
            window_resize_type = 6
         elseif size.x-window.Cursor.x < 3 then -- bottom edge
            window_resize_type = 7
         elseif size.y-window.Cursor.y < 3 then -- bottom edge
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
   if (host:getScreen() or host:isCursorUnlocked()) and window_selected and input.mouse_left:isPressed() then
      local dim = window_selected.container.Dimensions
      if not window_selected.minimized then
         if window_resize_type == 1 then -- top left
            dim.xy = dim.xy + drag
         elseif window_resize_type == 2 then -- top right
            dim.z = dim.z + drag.x
            dim.y = dim.y + drag.y
         elseif window_resize_type == 3 then -- bottom left
            dim.x = dim.x + drag.x
            dim.w = dim.w + drag.y
         elseif window_resize_type == 4 then -- bottom right
            dim.z = dim.z + drag.x
            dim.w = dim.w + drag.y
         elseif window_resize_type == 5 then -- left edge
            dim.x = dim.x + drag.x
         elseif window_resize_type == 6 then -- top edge
            dim.y = dim.y + drag.y
         elseif window_resize_type == 7 then -- bottom edge
            dim.z = dim.z + drag.x
         elseif window_resize_type == 8 then -- bottom edge
            dim.w = dim.w + drag.y
         elseif window_resize_type == 9 then -- top bar
            dim.xy = dim.xy + drag
            dim.zw = dim.zw + drag
         end
      else
         if window_resize_type == 9 then -- top bar
            dim.xy = dim.xy + drag
            dim.zw = dim.zw + drag
         end
         
      end
      dim.z = math.max(dim.z-dim.x,25)+dim.x
      dim.w = math.max(dim.w-dim.y,15)+dim.y

      local center = vectors.vec2(
         math.lerp(dim.x,dim.z,0.5),
         math.lerp(dim.y,dim.w,0.5)
      ) / screen.Dimensions.zw
      
      window_selected.container:setDimensions(dim)
   end
end)

events.WORLD_TICK:register(function ()
   for id, windowData in pairs(winapi.windows) do
      windowData.TICK:invoke()
   end
end)

local last_system_time = client:getSystemTime()
events.WORLD_RENDER:register(function ()
   local system_time = client:getSystemTime()
   local delta = (system_time - last_system_time) / 1000
   last_system_time = system_time
   for id, windowData in pairs(winapi.windows) do
      windowData.FRAME:invoke(delta)
   end
end)

return winapi