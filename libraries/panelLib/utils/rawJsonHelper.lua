---@diagnostic disable: assign-type-mismatch
local json_parser = require("libraries.panelLib.utils.json")

local color_override = {
   dark_red = vectors.vec3(0.6666666865, 0, 0),--#000000
   dark_purple = vectors.vec3(0.6666666865, 0, 0.6666666865),--#0000AA
   blue = vectors.vec3(0.3333333432, 0.3333333432, 1),--#00AA00
   dark_aqua = vectors.vec3(0, 0.6666666865, 0.6666666865),--#00AAAA
   dark_gray = vectors.vec3(0.3333333432, 0.3333333432, 0.3333333432),--#AA0000
   light_purple = vectors.vec3(1, 0.3333333432, 1),--#AA00AA
   black = vectors.vec3(0, 0, 0),--#FFAA00
   gold = vectors.vec3(1, 0.6666666865, 0),--#AAAAAA
   green = vectors.vec3(0.3333333432, 1, 0.3333333432),--#555555
   aqua = vectors.vec3(0.3333333432, 1, 1),--#5555FF
   dark_blue = vectors.vec3(0, 0, 0.6666666865),--#55FF55
   yellow = vectors.vec3(1, 1, 0.3333333432),--#55FFFF
   dark_green = vectors.vec3(0, 0.6666666865, 0),--#FF5555
   gray = vectors.vec3(0.6666666865, 0.6666666865, 0.6666666865),--#FF55FF
   red = vectors.vec3(1, 0.3333333432, 0.3333333432),--#FFFF55
   white = vectors.vec3(1, 1, 1),--#fffff
   }


---Parses any string/rawjson(string) into a multi component raw json for ease of gettng data out of it
---* Override Example: `{green = "#ff0000"}` <- makes components with the {"color":"green"} be red. 
---@param json string
---@param overrides table?
---@return table|unknown
return function (json,overrides)
   local parsed = json_parser.decode(json)
   local typ = type(parsed)
   if typ == "string" then -- basic text
      parsed = {{string = parsed, color = "default"}}
   elseif typ == "table" then
      if parsed.text then -- single component
         parsed = {parsed}
      end
   end
   for I, component in pairs(parsed) do
      for name, clr in pairs(color_override) do
         if component.color == name then
            parsed[I].color = clr
            break
         end
      end
      if overrides then
         for name, hex in pairs(overrides) do
            if component.color == name then
               parsed[I].color = hex
               break
            end
         end
      end
   end
   return parsed
end