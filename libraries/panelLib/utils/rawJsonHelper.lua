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

return function(json)
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
      for name, hex in pairs(color_override) do
         if component.color == name then
            parsed[I].color = hex
            break
         end
      end
   end
   return parsed
end
