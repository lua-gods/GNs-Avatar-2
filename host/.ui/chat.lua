local gnui = require("libraries.gnui")
local screen = require("services.screenui")
local tween = require("libraries.GNTweenLib")
local hudSound = require("libraries.hudsound")
local parseChat = require("libraries.chatHandler")

local HISTORY_SIZE = 10

local window = gnui.newContainer():setAnchor(0,0,1,0):setDimensions(0,0,0,HISTORY_SIZE * 10)
screen:addChild(window)

local chatline = {}
for i = 1, HISTORY_SIZE, 1 do
   local line = gnui.newLabel()
   line:setAnchor(0,1,1,1)
   line:setDimensions(0,i*-10,0,(i-1)*-10)
   line:setText("")
   line:setAlign(0,1)
   line:setTextEffect("OUTLINE")
   line:canCaptureCursor(false)
   line:setClipOnParent(true)
   window:addChild(line)
   chatline[i] = line
end

local newMessage = HISTORY_SIZE
local history = {}

local function updateChat()
   local max_height = math.floor((window.Dimensions.w-window.Dimensions.y) / 10)-1
   for i = 1, math.min(#history,9999,HISTORY_SIZE), 1 do
      chatline[i]:setText(history[i]):setVisible(true)
   end
   if #history > HISTORY_SIZE then
      for i = HISTORY_SIZE, #history, 1 do
         history[#history+1] = nil
      end
   end
end

events.CHAT_RECEIVE_MESSAGE:register(function (message, json_text)
   local json = parseJson(json_text)
   if json.translate == "chat.type.text" then
      if json.with[1].text == "TheBluecreeper64" then
         local flipped = ""
         for i = 1, #json.with[2].text, 1 do
            flipped = json.with[2].text:sub(i,i) .. flipped
         end
         json.with[2].text = flipped
         return toJson(json)
      end
   end
   tween.tweenFunction(0.2,"inOutCubic",function (y)
      window:setDimensions(0,0,0,HISTORY_SIZE * 10 + 10-y*10)
   end,nil,"chatnewmessage")
   newMessage = newMessage + 1
end)

events.WORLD_RENDER:register(function (delta)
   for i = newMessage, 1, -1 do
      if host:getChatMessage(i) then
         local json = parseJson(parseChat(host:getChatMessage(i).json))
         table.insert(history,1,json)
      end
   end
   if newMessage > 0 then
      updateChat()
      newMessage = 0
   end
end)

updateChat()