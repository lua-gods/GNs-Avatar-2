local base = require("libraries.panelLib.elements.base")
local raw_helper = require("libraries.panelLib.utils.rawJsonHelper")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element.TextButton : GNpanel.Element
---@field text string
---@field private_methods table
---@field TEXT_CHANGED KattEvent
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
   new.TEXT_CHANGED = core.event.newEvent()
   new.TRANSFORM_CHANGED:register(function ()
      private.text_reposition(new)
   end)
   new.private_methods = { 
      text_parse = private.text_parse,
      text_rebuild = private.text_rebuild,
      text_reposition = private.text_reposition,
      text_write = private.text_write,
   }
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
   local components = btn.private_methods.text_parse(btn)
   if btn.Parent then
      for key, component in pairs(components) do -- build labels json manually
         btn.Labels[#btn.Labels+1] = core.labelLib.newLabel(btn.Parent.Parent.Part)
      end
      btn.private_methods.text_write(btn,components)
   end
end

---@param btn GNpanel.Element.TextButton
---@param components table?
function private.text_write(btn,components)
   if not components then
      components = btn.private_methods.text_parse(btn)
   end
   local glow = btn.Hovering
   for key, component in pairs(components) do -- reposition labels
      local label = btn.Labels[key]
      if glow then
         label:setText(component.text):setColorRGB(vectors.hexToRGB(component.color):unpack())
         label:setOutlineColorRGB((vectors.hexToRGB(component.color) * 0.4):unpack())
      else
         label:setText(component.text):setColorRGB(vectors.hexToRGB(component.color):unpack())
         label:setOutlineColorRGB((vectors.hexToRGB(component.color) * 0.2):unpack())
      end
   end
   btn.private_methods.text_reposition(btn,components)
end

---@param btn GNpanel.Element.TextButton
---@param components table?
function private.text_reposition(btn,components)
   if not components then
      components = btn.private_methods.text_parse(btn)
   end
   local cursor = 0
   if btn.Parent then    
      for key, component in pairs(components) do -- reposition labels
         local label = btn.Labels[key]
         label:setText(component.text):setOffset(btn.pos.x + cursor,btn.pos.y)
         cursor = cursor + client.getTextWidth(component.text)
      end
   end
end

function button:update()
   self.private_methods.text_write(self)
   return self
end

function button:rebuild()
   self.private_methods.text_rebuild(self)
   return self
end

return button