local core = require("libraries.panelLib.panelCore")
local base = require("libraries.panelLib.elements.textButton")
local raw_helper = require("libraries.panelLib.utils.rawJsonHelper")

local private = {}

---@class GNpanel.Element.ToggleButton : GNpanel.Element.TextButton
---@field Toggle boolean
---@field ON_TOGGLE AuriaEvent
local toggle = {}
toggle.__index = function (t,i)
   return toggle[i] or base.__index(t,i)
end


---@return GNpanel.Element.ToggleButton
function toggle.new(obj)
   local new = obj or base.new()
   new.Toggle = false
   new.ON_TOGGLE = core.event.newEvent()
   
   new.TEXT_REPOSITION:register(private.text_reposition,"text")
   new.TEXT_REPOSITION:register(private.switch_reposition,"switch")
   new.TEXT_WRITE:register(private.switch_write,"switch")
   new.TEXT_REBUILD:register(private.switch_rebuild,"switch")
   new.STATE_CHANGED:register(function (state)
      if state == "PRESSED" then
         new.Toggle = not new.Toggle
         private.switch_write(new)
         new.ON_TOGGLE:invoke(new.Toggle)
         if new.Toggle then
            core.tween.tweenFunction(0,1,0.5,"outElastic",function (x)
               private.switch_reposition(new,x)
            end,"toggle")
         else
            core.tween.tweenFunction(1,0,0.5,"outElastic",function (x)
               private.switch_reposition(new,x)
            end,"toggle")
         end
         
      end
   end)
   setmetatable(new,toggle)
   return new
end

---@param btn GNpanel.Element.ToggleButton
function private.switch_rebuild(btn)
   
   btn.Labels.switch =  {
      case_left = core.labelLib.newLabel(btn.Parent.Parent.Part):setText("["),
      case_right = core.labelLib.newLabel(btn.Parent.Parent.Part):setText("]"),
      handle = core.labelLib.newLabel(btn.Parent.Parent.Part):setText("[]"):offsetDepth(1),
   }
end

---@param btn GNpanel.Element.ToggleButton
function private.switch_write(btn,custom)
   local switch_color = ""
   if custom then
      switch_color = custom
   else
      if btn.Toggle then
         switch_color = core.colors.green
      else
         switch_color = core.colors.red
      end
   end
   btn.Labels.switch.case_left:setColorHEX(switch_color)
   btn.Labels.switch.case_right:setColorHEX(switch_color)
   btn.Labels.switch.handle:setColorHEX(core.colors.white)
end

---@param btn GNpanel.Element.ToggleButton
function private.switch_reposition(btn,custom)
   local slide = 0
   if custom then
      slide = custom
   else
      if btn.Toggle then
         slide = 1
      else
         slide = 0
      end
   end
   btn.Labels.switch.case_left:setOffset(btn.pos)
   btn.Labels.switch.case_right:setOffset(btn.pos:copy():add(10,0))
   btn.Labels.switch.handle:setOffset(btn.pos:copy():add(math.lerp(2,4,slide),0))
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