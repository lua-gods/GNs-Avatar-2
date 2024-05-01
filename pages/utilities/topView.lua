local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local tween = require("libraries.GNTweenLib")
return function ()
local page = panels.newPage()

local pos = vectors.vec3()
local zoom = 30
local e = {
   panels.newToggle():setText("Enable"),
   panels.newToggle():setText("Orthographic Mode"),
   panels.newSpinbox():setText("Zoom"):setAcceptedValue(zoom),
}

e[3].VALUE_CHANGED:register(function (v)
   zoom = v or zoom or 30
end)

local ortho = 0
e[2].TOGGLED:register(function (enabled)
   if enabled then
      tween.tweenFunction(0,1,0.5,"inOutQuad",function (value, transition)
         ortho = value
      end)
   else
      tween.tweenFunction(1,0,0.25,"inOutQuad",function (value, transition)
         ortho = value
      end)
   end
end)

local mouse_primary = keybinds:newKeybind("mouse.left","key.mouse.left")

local function getHeight(x,z)
   local h = 0
   local d = 20
   local s = 4
   for w = -d, d, s do
      for t = -d, d, s do
         h = h + world.getHeight(x + w, z + t,"WORLD_SURFACE")
      end
   end
   h = h / ((d * 2 / s) * (d * 2 / s))
   return h
end

e[1].TOGGLED:register(function (enabled)
   if enabled then
---@diagnostic disable-next-line: assign-type-mismatch
      pos = player:getPos().xyz ---@type Vector3
      local lst = client:getSystemTime()
      events.WORLD_RENDER:register(function ()
         pos.y = math.lerp(pos.y,getHeight(pos.x,pos.z) + zoom,0.1)
         renderer
         :setCameraPivot(pos)
         :setCameraRot(90,0,0)
         host:setUnlockCursor(true)
         models.player:setScale(0,0,0) -- hide hand
         renderer:setRenderHUD(false)

         -- ortho
         local fov = client:getFOV()
         local F = fov*(1-(-(math.cos(math.pi * ortho) - 1) / 2) * 0.99)
         local cmat = matrices.mat4(
            vec(1,0,0,0),
            vec(0,1,0,0),
            vec(0,0,F/fov, (F/fov)-1),
            vec(0,0,0,1)
         ):transpose()
         renderer:setCameraMatrix(matrices.translate4(0,0,-zoom) * cmat * matrices.translate4(0,0,zoom))
      end,"utilities.topView")
      events.MOUSE_MOVE:register(function (x, y)
         if mouse_primary:isPressed() then
            local r = zoom * 0.1
            pos.x = pos.x + x * 0.1
            pos.z = pos.z + y * 0.1
         end
      end,"utilities.topView")
   else
      events.WORLD_RENDER:remove("utilities.topView")
      events.MOUSE_MOVE:remove("utilities.topView")
      models.player:setScale(1,1,1) -- unhide hand
      renderer:setRenderHUD(true)
      renderer:setCameraMatrix()
      host:setUnlockCursor(false)
      renderer
      :setCameraPivot()
      :setCameraRot()
   end
end)



page:addElement(table.unpack(e))
page:addElement(sidebar.newReturnButton())

page:setIcon(":earth:","emoji")
page:setName("Top View")
page:setHeaderColor("#3777b3")
return page
end