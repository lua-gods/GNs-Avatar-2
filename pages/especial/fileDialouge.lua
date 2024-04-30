local sidebar = require("host.contextMenu")
local elements = require("libraries.panels")
local page = elements.newPage()
local eventLib = require("libraries.eventLib")

local inUse = false

local display = elements.newDisplay()
local file_page = elements.newPage()

for i = 1, 10, 1 do
   file_page:addElement(elements.newButton():setIconText(":folder:",true):setText(({"Tools","Audio","Textures","Assets","ETC","Scripts","Datasets","Cache","Keys","FV4011 Centurion MK.. "})[i]))
end
display:setPage(file_page)

local toolbar_page = elements.newPage()
local footer_page = elements.newPage()
local icons = {"⬅","➡","^","R"}
for i = 1, 4, 1 do
   toolbar_page:addElement(elements.newButton():setText(icons[i]):setForcedWidth(10))
end
toolbar_page:addElement(elements.newButton():setIconText(":folder:+",true):setForcedWidth(15))
footer_page:addElement(elements.newButton():setText("Open"))
footer_page:addElement(elements.newButton():setText("Cancel"))


local function make()
   local toolbar = elements.newDisplay():setDirection("HORIZONTAL_INDIVIDUAL"):setPage(toolbar_page)
   local footer = elements.newDisplay():setDirection("HORIZONTAL_INDIVIDUAL"):setPage(footer_page)
   local e = {
      elements.newDisplayButton():setDisplay(toolbar),
      elements.newTextEdit():setText("figura/data/"):setForceFull(true),
      elements.newDisplayButton():setDisplay(display),
      elements.newTextEdit():setText("figura/data/"):setForceFull(true),
      elements.newDisplayButton():setDisplay(footer),

   }
   page:addElement(table.unpack(e))

   page:setName("Open a File")
   page:setHeaderColor("#b9af23")
   return page
end

local api = {}

local instance

function api.openFileDialouge()
   local event = eventLib.new()
   instance = instance or make()
   sidebar:setPage(instance)
   return event
end

return api