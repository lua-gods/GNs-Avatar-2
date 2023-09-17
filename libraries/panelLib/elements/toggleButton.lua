local core = require("libraries.panelLib.panelCore")
local base = require("libraries.panelLib.elements.textButton")
local raw_helper = require("libraries.panelLib.utils.rawJsonHelper")

local private = {}

---@class GNpanel.Element.ToggleButton : GNpanel.Element.TextButton
---@field toggle boolean
---@field ON_TOGGLE AuriaEvent
local toggle = {}
toggle.__index = function (t,i)
   return toggle[i] or base.__index(t,i)
end


---@return GNpanel.Element.ToggleButton
function toggle.new(obj)
   local new = obj or base.new()
   new.toggle = false
   new.ON_TOGGLE = core.event.newEvent()
   
   new.TEXT_REPOSITION:register(private.text_reposition,"text")
   new.TEXT_REPOSITION:register(private.switch_reposition,"switch")
   new.TEXT_REBUILD:register(private.switch_rebuild,"switch")
   setmetatable(new,toggle)
   return new
end

---@param btn GNpanel.Element.TextButton
function private.switch_rebuild(btn)
   btn.Labels.switch =  {
      case = core.labelLib.newLabel(btn.Parent.Parent.Part):setText(btn.TEXT_PARSE('{"text":"["}')),
      handle = core.labelLib.newLabel(btn.Parent.Parent.Part):setText("[]"),
   }
end

---@param btn GNpanel.Element.ToggleButton
function private.switch_reposition(btn)
   btn.Labels.switch.case:setOffset(btn.pos)
   btn.Labels.switch.handle:setOffset(btn.pos)
end

---@param btn GNpanel.Element.ToggleButton
function private.text_reposition(btn)
   local cursor = 18
   if btn.Parent then    
      for key, component in pairs(btn.parsed_text) do -- reposition labels
         local label = btn.Labels.text[key]
         label:setText(component.text):setOffset(btn.pos.x + cursor,btn.pos.y)
         cursor = cursor + client.getTextWidth(component.text)
      end
   end
end

return toggle