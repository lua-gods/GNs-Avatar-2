local img = textures.cute
local dim = img:getDimensions():sub(1,1)
local resolution = 9 + 9 + 9 + 9
local lines = 9

local chars = {"","","","","","","","","",
}

local composed_lines = {}
for line = 1, resolution, lines do
   local compose = {}
   for x = 1, resolution, 1 do
      for s = 1, #chars, 1 do
         local y = line + s -1
         local clr = img:getPixel(
            math.floor(math.map(x,1,resolution,0,dim.x)),
            math.floor(math.map(y,1,resolution,dim.y,0))
         )
         compose[#compose+1] = {text=chars[s],color="#"..vectors.rgbToHex(clr.xyz)}
      end
   end
   compose[#compose+1] = {text="\n"}
   table.insert(composed_lines,1,compose)
end

for key, value in pairs(composed_lines) do
   printJson(toJson(value))
end