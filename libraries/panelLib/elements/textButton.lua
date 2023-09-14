local base = require("libraries.panelLib.elements.base")
local raw_helper = require("libraries.panelLib.utils.rawJsonHelper")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element.TextButton : GNpanel.Element
---@field text string
---@field parsed_text table<any,table<string,string>>
---@field pressed boolean
---@field TEXT_CHANGED KattEvent
---@field TEXT_REBUILD KattEvent
---@field TEXT_WRITE KattEvent
---@field TEXT_REPOSITION KattEvent
---@field TEXT_PARSE function
local button = {}
button.__index = function (t,i)
   return button[i] or base[i]
end

local private = {}
private.__index = button

---@param obj table?
---@return GNpanel.Element.TextButton
function button.new(obj)
   local new = obj or base.new()
   new.text = '[{"text":"Empty Button"}]'
   new.Pressed = false
   new.parsed_text = {{text="Empty Button"}}
   new.TEXT_CHANGED = core.event.newEvent()
   new.TEXT_REBUILD = core.event.newEvent()
   new.TEXT_WRITE = core.event.newEvent()
   new.TEXT_REPOSITION = core.event.newEvent()
   new.TEXT_PARSE = private.text_parse

   new.TEXT_REBUILD:register(private.text_rebuild)
   new.TEXT_WRITE:register(private.text_write)
   new.TEXT_REPOSITION:register(private.text_reposition)

   new.TRANSFORM_CHANGED:register(function ()
      private.text_reposition(new)
   end)
   setmetatable(new,button)
   return new
end

---@param text string
---@return GNpanel.Element.TextButton
function button:setText(text)
   self.TEXT_CHANGED:invoke(text)
   self.text = text
   if self.Parent then
      self:rebuild()
   end
   return self
end

function private.text_parse(btn)
   local components
   if btn.Pressed then components = raw_helper(btn.text,core.color_overrides.pressed) else
      if btn.Hovering then components = raw_helper(btn.text,core.color_overrides.hovering)
      else components = raw_helper(btn.text,core.color_overrides.none) end end
   return components
end

---@param btn GNpanel.Element.TextButton
function private.text_rebuild(btn)
   for key, value in pairs(btn.Labels) do value:delete() end
   btn.Labels = {}
   if btn.Parent then
      for key, component in pairs(btn.parsed_text) do -- build labels json manually
         btn.Labels[#btn.Labels+1] = core.labelLib.newLabel(btn.Parent.Parent.Part)
      end
   end
end

---@param btn GNpanel.Element.TextButton
function private.text_write(btn)
   local glow = btn.Hovering
   for key, component in pairs(btn.parsed_text) do -- reposition labels
      local label = btn.Labels[key]
      if glow then
         label:setText(component.text):setColorRGB(vectors.hexToRGB(component.color):unpack())
         label:setOutlineColorRGB((vectors.hexToRGB(component.color) * 0.4):unpack())
      else
         label:setText(component.text):setColorRGB(vectors.hexToRGB(component.color):unpack())
         label:setOutlineColorRGB((vectors.hexToRGB(component.color) * 0.2):unpack())
      end
   end
end

---@param btn GNpanel.Element.TextButton
function private.text_reposition(btn)
   local cursor = 0
   if btn.Parent then    
      for key, component in pairs(btn.parsed_text) do -- reposition labels
         local label = btn.Labels[key]
         label:setText(component.text):setOffset(btn.pos.x + cursor,btn.pos.y)
         cursor = cursor + client.getTextWidth(component.text)
      end
   end
end

function button:update()
   self.TEXT_WRITE(self)
   self.TEXT_REPOSITION(self)
   return self
end

function button:rebuild()
   self.TEXT_PARSE(self)
   self.TEXT_REBUILD(self)
   return self
end

function button:delete()

end

return button