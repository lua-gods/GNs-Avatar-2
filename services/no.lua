--renderer:setRenderHUD(false)
local GNUI = require("libraries.gnui")
local background = GNUI.newSprite()

local history = {}
events.CHAT_RECEIVE_MESSAGE:register(function (message, json)
   
end)