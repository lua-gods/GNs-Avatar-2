local sidebar = require("host.sidebar")
local panels = require("libraries.panels")
local page = panels.newPage()

local pages = {
   "command_utilities"
}

local e = {}

for key, value in pairs(pages) do
   local btn = panels.newButton():setText(value:gsub("_"," "))
   e[#e+1] = btn
   btn.PRESSED:register(function ()
      sidebar:setPage(value)
   end)
end

page:addElement(table.unpack(e))

page:addElement(panels.newSpinbox())
page:addElement(panels.newVector3Button())

sidebar:newPage(page,"main")