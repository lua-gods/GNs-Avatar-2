--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
--[[
This service aims to aid the creation of custom commands in chat
]]

if not host:isHost() then return end

local gnui = require("libraries.gnui")
local PREFIX = "$" -- every message with this at the start will get canceled from being sent in chat reguardless if one exists or not

local screen = require("services.screenui")
local label = gnui.newLabel():setText("HELLO WORLD")
label:setAnchor(0,1,1,1):setTopLeft(4,-13):setZ(100)
screen:addChild(label)

local lib = {}
local queries = {}

local function split(text)
   local words = {}
   local word = ""
   local inside_string = false
   for i = 2, #text, 1 do
      local char = text:sub(i,i)
      if char == " " and not inside_string then
         words[#words+1] = word
         word = ""
      else
         if char == '"' or char == "'" then
            inside_string = not inside_string
         else
            word = word .. char
         end
      end
   end
   words[#words+1] = word
   return words
end

events.CHAT_SEND_MESSAGE:register(function (message)
   if message and message:sub(1,#PREFIX) == PREFIX then
      local words = split(message:sub(2,-1))
      host:appendChatHistory(message)
      for _, func in pairs(queries) do
         local success, result = pcall(func,words)
         if not success then
            print("§c"..result)
         end
      end
      return ""
   end
   return message
end)


-- makes chat yellow to indicate its not gonna be sent in chat.

local commanding = false
local last_text = ""
label:setVisible(false)
events.WORLD_TICK:register(function ()
   local text = host:getChatText()
   if text and text:sub(1,#PREFIX) == PREFIX then
      if not commanding then -- enable
         label:setVisible(true)
         host:setChatColor(1,1,0)
         commanding = true
      end
      if last_text ~= text then -- text changed
         label:setText(text)
         last_text = text
      end
   else
      if commanding then -- disable
         label:setVisible(false)
         host:setChatColor(1,1,1)
         commanding = false
      end
   end
end)


---@class commandType
---@field type "boolean"|"string"|"alias"|"number"|"integer"|"keyword"
---@field name string
---@field data {range:{low:number,high:number}?,alias:table<any,string>?}|string?

---Registers a command that will part take in checking if the message contains the words to trigger it.
---@param func fun(words : table<any,string>)
---@param params table<any,commandType>
function lib.register(func,params)
   queries[#queries+1] = {func = func,params = params}
   return #queries
end

function lib.remove(id)
   queries[id] = nil
end

return lib