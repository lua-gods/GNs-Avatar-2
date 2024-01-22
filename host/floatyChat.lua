---@diagnostic disable: param-type-mismatch
if not host:isHost() then return end
local windowManager = require("services.windowManager")
local GNUI = require("libraries.gnui")

local window = windowManager.newWindow(true)
window:setTitle("Chat on the flat")

local HISTORY_SIZE = 10

local chatline = {}
for i = 1, HISTORY_SIZE, 1 do
   local line = GNUI.newLabel()
   line:setAnchor(0,1,1,1)
   line:setDimensions(0,i*-10,0,(i-1)*-10)
   line:setText("")
   line:setAlign(0,1)
   line:canCaptureCursor(false)
   line:setClipOnParent(false)
   window.container:addChild(line)
   chatline[i] = line
end


local history = {}
for i = 1, HISTORY_SIZE, 1 do
   history[#history+1] = "lol"..(math.random() * 100000)
end
local function updateChat()
   local size = math.floor((window.container.Dimensions.w-window.container.Dimensions.y) / 10)-1
   --host:setActionbar(tostring(#history.." "..size.." "..LINE_COUNT.." "..math.min(#history,size,LINE_COUNT)))
   for i = 1, math.min(#history,size,HISTORY_SIZE), 1 do
      chatline[i]:setText(history[i]):setVisible(true)
   end
   if #history > HISTORY_SIZE then
      for i = HISTORY_SIZE, #history, 1 do
         history[#history+1] = nil
      end
   end
end

local parseChat = require("libraries.chatHandler")

local newMessage = 0
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
   newMessage = newMessage + 1
end)

local husound = require("libraries.hudsound")

events.WORLD_RENDER:register(function (delta)
   for i = newMessage, 1, -1 do
      local json = parseJson(host:getChatMessage(i).json).extra
      local parsed = json
      --husound("minecraft:block.note_block.pling",1,1)
      host:setActionbar(tostring(parsed))
      table.insert(history,1,json)
      
      updateChat()
   end
   newMessage = 0
end)

window.container.DIMENSIONS_CHANGED:register(function ()
   updateChat()
end)