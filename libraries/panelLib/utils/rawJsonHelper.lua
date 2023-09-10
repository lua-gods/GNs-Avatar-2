local json_parser = require("libraries.panelLib.utils.json")

local color_override = {
   black = "#000000",
   dark_blue = "#0000AA",
   dark_green = "#00AA00",
   dark_aqua = "#00AAAA",
   dark_red = "#AA0000",
   dark_purple = "#AA00AA",
   gold = "#FFAA00",
   gray = "#AAAAAA",
   dark_gray = "#555555",
   blue = "#5555FF",
   green = "#55FF55",
   aqua = "#55FFFF",
   red = "#FF5555",
   light_purple = "#FF55FF",
   yellow = "#FFFF55",
   white = "#ffffff"
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
      if overrides then
         for name, clr in pairs(overrides) do
            if component.color == name then
               parsed[I].color = clr
               break
            end
         end
      end
      for name, hex in pairs(color_override) do
         if component.color == name then
            parsed[I].color = hex
            break
         end
      end
   end
   return parsed
end