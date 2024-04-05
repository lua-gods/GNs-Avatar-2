local inputLib = {}
local eventLib = require("libraries.eventLib")

local lookup = { -- I did this manually even though GS's Docs have this
   low = {[32]=" ",[39]="'",[44]=",",[45]="-",[46]=".",[47]="/",[48]="0",[49]="1",[50]="2",[51]="3",[52]="4",[53]="5",[54]="6",[55]="7",[56]="8",[57]="9",[59]=";",[61]="=",[65]="a",[66]="b",[67]="c",[68]="d",[69]="e",[60]="f",[62]="h",[71]="g",[73]="i",[74]="j",[75]="k",[76]="l",[77]="m",[78]="n",[79]="o",[70]="f",[81]="q",[72]="h",[80]="p",[82]="r",[83]="s",[84]="t",[85]="u",[86]="v",[87]="w",[88]="x",[89]="y",[90]="z",[91]="[",[92]="\\",[93]="]",[96]="`"
   },high = {[32]=" ",[39]="\"",[44]="<",[45]="_",[46]=">",[47]="?",[48]=")",[49]="!",[50]="@",[51]="#",[52]="$",[53]="%",[54]="^",[55]="&",[56]="*",[57]="(",[59]=":",[61]="+",[65]="A",[66]="B",[67]="C",[68]="D",[69]="E",[60]="f",[62]="H",[71]="G",[73]="I",[74]="J",[75]="K",[76]="L",[77]="M",[78]="N",[79]="O",[70]="F",[81]="Q",[72]="H",[80]="P",[82]="R",[83]="S",[84]="T",[85]="U",[86]="V",[87]="W",[88]="X",[89]="Y",[90]="Z",[91]="{",[92]="|",[93]="}",[96]="~"}}

local function key2string(key,modifier)
   if (modifier or 0) % 2 == 0 then
      return lookup.low[key]
   else 
      return lookup.high[key] 
   end
end
---@class InputEventMouseMotion
---@field relative Vector2
---@field absolute Vector2
local InputEventMouseMotion = {}
InputEventMouseMotion.__index = InputEventMouseMotion
InputEventMouseMotion.__type = "InputEventMouseMotion"

---@class InputEventKey
---@field key integer
---@field char string
---@field modifier integer
---@field shift boolean
---@field ctrl boolean
---@field alt boolean
---@field echo boolean
---@field pressed boolean
local InputEventKey = {}
InputEventKey.__index = InputEventKey
InputEventKey.__type = "InputEventKey"

---@class InputEventMouseButton
---@field button_index Minecraft.mouseID
---@field state Event.Press.state
---@field modifiers Event.Press.modifiers
local InputEventMouseButton = {}
InputEventMouseButton.__index = InputEventMouseButton
InputEventMouseButton.__type = "InputEventMouseButton"

---@class InputListener
---@field InputEvent eventLib
---@field active boolean
---@field id integer
local InputListener = {}
InputListener.__index = InputListener
InputListener.__type = "InputListener"

---@type table<any,InputListener>
local input_listeners = {}

function InputListener.new()
   local new = {}
   setmetatable(new,InputListener)
   new.InputEvent = eventLib.new()
   new.active = false
   local id = #input_listeners+1
   new.id = id
   input_listeners[id] = new
   return new
end

function InputListener:delete()
   input_listeners[self.id] = nil
end

events.KEY_PRESS:register(function (key, state, modifiers)
   for id, input in pairs(input_listeners) do
      ---@type InputEventKey
      local data = setmetatable({},InputEventKey)
      data.char = key2string(key)
      data.key = key
      data.pressed = state == 1
      data.echo = state == 2
      data.modifier = modifiers
      data.shift = (modifiers / 1) % 2 > 0.75 
      data.ctrl = (modifiers / 2) % 2 > 0.75 
      data.alt = (modifiers / 4) % 2 > 0.75 
      
      input.InputEvent:invoke()
   end
end)
--Event.Press.modifiers:
--    | 0  = No modifiers
--    | 1  = Shift
--    | 2  = Ctrl
--    | 3  = Ctrl, Shift
--    | 4  = Alt
--    | 5  = Alt, Shift
--    | 6  = Ctrl, Alt
--    | 7  = Ctrl, Alt, Shift
--    | 8  = Super
--    | 9  = Shift, Super
--    | 10 = Ctrl, Super
--    | 11 = Ctrl, Shift, Super
--    | 12 = Alt, Super
--    | 13 = Alt, Shift, Super
--    | 14 = Ctrl, Alt, Super
--    | 15 = Ctrl, Alt, Shift, Super


return inputLib