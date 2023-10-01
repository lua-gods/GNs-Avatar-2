local base = require("libraries.panelLib.elements.base")
local core = require("libraries.panelLib.panelCore")


---@class GNpanel.Element.TextInput : GNpanel.Element
---@field Input string
---@field History table
local text = {}
text.__index = function (t,i)
   return base[i] or base[i]
end

function text.new(obj)
   local new = obj or base.new()
   new.Input = ""
   new.History = {}
   setmetatable(new,text)
   return new
end