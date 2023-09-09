local base = require("libraries.panelLib.elements.base")
local raw_helper = require("libraries.panelLib.utils.rawJsonHelper")
local core = require("libraries.panelLib.panelCore")

---@class GNpanel.Element.TextButton : GNpanel.Element
---@field text string
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
   new.STATE_CHANGED:register(function ()
      private.text_write(new)
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

---@param btn GNpanel.Element.TextButton
function private.text_rebuild(btn)
   for key, value in pairs(btn.Labels) do value:delete() end
   btn.Labels = {}
   
   local components = raw_helper(btn.text)
   if btn.Parent then
      for key, component in pairs(components) do -- build labels json manually
         btn.Labels[#btn.Labels+1] = core.labelLib.newLabel(btn.Parent.Parent.Part)
      end
      private.text_write(btn)
   end
end

function private.text_write(btn)
   local components = raw_helper(btn.text)
   local glow = btn.Hovering
   for key, component in pairs(components) do -- reposition labels
      local label = btn.Labels[key]
      label:setText(component.text):setColorHEX(component.color)
      if glow then
         label:setOutlineColorRGB(1,1,1)
      else
         label:setOutlineColorRGB((vectors.hexToRGB(component.color) * 0.2):unpack())
      end
   end
   private.text_reposition(btn)
end

---@param btn GNpanel.Element.TextButton
function private.text_reposition(btn)
   local components = raw_helper(btn.text)
   local glow = btn.Hovering
   local cursor = 0
   if btn.Parent then    
      for key, component in pairs(components) do -- reposition labels
         local label = btn.Labels[key]
         label:setText(component.text):setOffset(btn.pos.x + cursor,btn.pos.y):setColorHEX(component.color)
         cursor = cursor + client.getTextWidth(component.text)
         if glow then
            label:setOutlineColorRGB(1,1,1)
         else
            label:setOutlineColorRGB((vectors.hexToRGB(component.color) * 0.2):unpack())
         end
      end
   end
end

function button:update()
   return self
end

function button:rebuild()
   private.text_rebuild(self)
   return self
end

return button