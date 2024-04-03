local panels = require("libraries.panels")
local screen = require("host.screenui")
local tween = require("libraries.GNTweenLib")
local slide = 0
local gnui = require("libraries.gnui")



local display_offset = gnui.newContainer():setAnchor(1,1,1,1)
local display = panels.newDisplay()
local page = panels.newPage()

local levitate = 0

local function slideDisplay(x,y)
   x = x or 0
   y = y or 0
   if x >= 1 then
      display.display:setVisible(false)
   else
      display.display:setVisible(false)
   end
   x = (x or 0) * 125
   local d = display.display.Dimensions
   display.display:setDimensions(-125 + x,d.y,-2 + x,d.w):setAnchor(1,1,1,1)
   display_offset:setDimensions(0,-y-4,0,-y-4)
end
slideDisplay(slide,levitate)

local was_chat_open = false
events.WORLD_RENDER:register(function ()
   local is_chat_open = host:isChatOpen()
   if is_chat_open ~= was_chat_open then
      was_chat_open = is_chat_open
      if is_chat_open then
         tween.tweenFunction(levitate,10,0.1,"inOutCubic",function (value, transition)
            levitate = value
            slideDisplay(slide,levitate)
         end,nil,"panel_chat_levitate")
      else
         tween.tweenFunction(levitate,0,0.1,"inOutCubic",function (value, transition)
            levitate = value
            slideDisplay(slide,levitate)
         end,nil,"panel_chat_levitate")
      end
   end
end)


local input = keybinds:fromVanilla("figura.config.action_wheel_button")
local escape = keybinds:newKeybind("panels close","key.keyboard.escape")
input:onPress(function ()
   if not display.focused then
      display.focused = true
      tween.tweenFunction(slide,0,0.1,"outCubic",function (x,t) 
         slide = x
         slideDisplay(slide,levitate)
      end,nil,"panels")
   else
      if display.page then
         display.page:press()
      end
   end
   return true
end):onRelease(function ()
   if display.focused then
      if display.page then
         display.page:release()
      end
   end
end)

escape:onPress(function ()
   if display.focused and not (host:getScreen() or was_chat_open) then
      display.focused = false
      tween.tweenFunction(slide,1,0.1,"inCubic",function (x,t) 
         slide = x
         slideDisplay(x)
      end,nil,"panels")
      return true
   end
end)


local subpage = panels.newPage()
for i = 1, 4, 1 do
   local e = panels.newToggle()
   subpage:addElement(e)
   e:setIconText(":folder:",true)
   e:setText("Sub"..i)
end

local especial = panels.newDisplayButton()
especial:setDisplay(panels.newDisplay():setPage(subpage))
page:addElement(especial)

local subsubpage = panels.newPage()
for i = 1, 2, 1 do
   local e = panels.newToggle()
   subsubpage:addElement(e)
   e:setIconText(":folder:",true)
   e:setText("Sub"..i)
end

local subespecial = panels.newDisplayButton()
subespecial:setDisplay(panels.newDisplay():setPage(subsubpage))
subpage:addElement(subespecial)

for i = 1, 5, 1 do
   local e = panels.newElement()
   page:addElement(e)
   e:setIconText(":folder:",true)
   e:setText("Example"..i)
end

do
   local e = panels.newButton()
   page:addElement(e)
   e:setIconItem("apple")
   e:setText("Give Apple")
   e.PRESSED:register(function ()
      host:sendChatCommand("/give @s apple")
   end)
end

do
   local e = panels.newToggle()
   page:addElement(e)
   e:setIconItem("apple")
   e:setText("Toggle button")
   e.TOGGLED:register(function ()
      if e.toggle then
         host:sendChatCommand("/give @s apple")
      else
         host:sendChatCommand("/clear @s apple 1")
      end
   end)
end


display:setPage(page)
events.MOUSE_SCROLL:register(function (dir)
   if display.focused then
      display.page:setSelected(math.floor(dir + 0.5),true)
      return true
   end
end)

display_offset:addChild(display.display)
screen:addChild(display_offset)