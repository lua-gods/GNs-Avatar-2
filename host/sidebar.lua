local panels = require("libraries.panels")
local screen = require("host.screenui")
local tween = require("libraries.GNTweenLib")
local slide = 1
local gnui = require("libraries.gnui")


local pages = {}

local display_offset = gnui.newContainer():setAnchor(1,1,1,1)
local display = panels.newDisplay()

local levitate = 0
local function slideDisplay(x,y)
   x = x or 0
   y = y or 0
   if x >= 1 then
      display.display:setVisible(true)
   else
      display.display:setVisible(true)
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
   if display.page then 
      if display.page.proxy then
         display.page:popEndProxy()
         return true
      end
   end
   if display.focused and not (host:getScreen() or was_chat_open) then
      display.focused = false
      tween.tweenFunction(slide,1,0.1,"inCubic",function (x,t) 
         slide = x
         slideDisplay(x)
      end,nil,"panels")
      return true
   end
end)


events.MOUSE_SCROLL:register(function (dir)
   if display.focused then
      if display.page then

         display.page:setSelected(math.floor(dir + 0.5),true)
      end
      return true
   end
end)
display_offset:addChild(display.display)
screen:addChild(display_offset)




local sidebar = {}
---@param page panels.page
---@param name string
---@return table
function sidebar:newPage(page,name)
   pages[name] = page
   return self
end

---@param page panels.page|string
function sidebar:setPage(page)
---@diagnostic disable-next-line: param-type-mismatch
   display:setPage(pages[page] or page)
end

function sidebar.newReturnButton()
   local btn = panels.newButton():setText({text="Return",color="#fd4343"})
   btn.PRESSED:register(function ()
      display:returnPage()
   end)
   return btn
end


return sidebar