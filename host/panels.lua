local panels = require("libraries.panels")
local screen = require("host.screenui")
local tween = require("libraries.GNTweenLib")
local slide = 1


local display = panels.newContainer()
local page = panels.newPage()

local function slideDisplay(x)
   if x >= 1 then
      display.display:setVisible(false)
   else
      display.display:setVisible(false)
   end
   x = (x or 0) * 125
   local d = display.display.Dimensions
   display.display:setDimensions(-125 + x,d.y,-2 + x,d.w):setAnchor(1,1,1,1)
end
slideDisplay(1)


local input = keybinds:fromVanilla("figura.config.action_wheel_button")
local escape = keybinds:newKeybind("panels close","key.keyboard.escape")
input:onPress(function ()
   if not display.focused then
      display.focused = true
      tween.tweenFunction(slide,0,0.1,"outCubic",function (x,t) 
         slide = x
         slideDisplay(x)
      end,nil,"panels")
   end
   return true
end):onRelease(function ()
end)

escape:onPress(function ()
   if display.focused then
      display.focused = false
      tween.tweenFunction(slide,1,0.1,"inCubic",function (x,t) 
         slide = x
         slideDisplay(x)
      end,nil,"panels")
      return true
   end
end)

for i = 1, 10, 1 do
   local e = panels.newElement()
   page:addElement(e)
   e:setIconText(":folder:",true)
   e:setText("Example "..i)
end

display:setPage(page)
events.MOUSE_SCROLL:register(function (dir)
   if display.focused then
      display.page:setSelected(math.floor(dir + 0.5),true)
      return true
   end
end)


screen:addChild(display.display)