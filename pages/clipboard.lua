local panel = require("libraries.panelLib.main")
local page = panel.newPage()

local display = panel.newButton()

local last_clipboard = ""
events.TICK:register(function ()
   local clipboard = host:getClipboard()
   if last_clipboard ~= clipboard then
      last_clipboard = clipboard
      if #clipboard == 0 then
         display:setText('{"text":"Unknwon format","color":"dark_gray"}')
      else
         display:setText(clipboard)
      end
      if display:shouldRender() then
         page.BookParent:forceUpdate()
      end
   end
end)

local elements = {
panel.newButton():setText('{"text":"CLIPBOARD","color":"red"}'),
display
}

page:insertElement(elements)
page:insertElement(panel.newReturnButton())
return page
