

local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")
local element = require("libraries.panels.element")
local button = require("libraries.panels.elements.button")
local gnui = require("libraries.gnui")
local tween = require("libraries.GNTweenLib")



---@class panels.toggle : panels.button
---@field toggle boolean
---@field TOGGLED eventLib
local toggle = {}
toggle.__index = function (t,i)
   return rawget(t,i) or toggle[i] or button[i] or element[i]
end
toggle.__type = "panels.toggle"

local function _toggle_slider(x,t)
   t.cache.slider_sprite:setColor(math.lerp(vectors.vec3(1,0.5,0.5),vectors.vec3(0.5,1,0.5),math.clamp(x,0,1)))
   local o = x * 6
   t.cache.switch_handle:setDimensions(-10-7 + o,-5,-10 + o,5)
end

---@param preset panels.toggle?
---@return panels.toggle
function toggle.new(preset)
   ---@type panels.toggle
   ---@diagnostic disable-next-line: assign-type-mismatch
   local new = button.new(preset)
   new.toggle = false
   new.TOGGLED = eventLib.new()
   
   new.cache.slider_sprite = config.generic_ninepatch_srite_border:copy():setOpacity(1)
   local switch_slider = gnui.newContainer():setSprite(new.cache.slider_sprite)
   switch_slider:setAnchor(1,0.5):setDimensions(-4-13,-4,-4,4)
   new.display:addChild(switch_slider)

   new.cache.switch_handle = gnui.newContainer():setSprite(config.generic_ninepatch_srite_border:copy():setRenderType("EMISSIVE_SOLID"))
   new.cache.switch_handle:setAnchor(1,0.5):setDimensions(-10-7,-5,-10,5)
   new.display:addChild(new.cache.switch_handle)

   new.PRESSED:register(function ()
      new.toggle = not new.toggle
      new.TOGGLED:invoke(new.toggle)
   end,"_toggle")

   
   _toggle_slider(0,new)
   new.TOGGLED:register(function ()
      if new.toggle then
         tween.tweenFunction(new.cache.toggle_slider_slide,1,0.5,"outElastic",function (value, transition)
            _toggle_slider(value,new)
            new.cache.toggle_slider_slide = value
         end,nil,new.id)
      else
         tween.tweenFunction(new.cache.toggle_slider_slide,0,0.5,"outElastic",function (value, transition)
            _toggle_slider(value,new)
            new.cache.toggle_slider_slide = value
         end,nil,new.id)
      end
   end,"_internal")

   return setmetatable(new,toggle)
end


---@param state boolean
---@param instant boolean
---@generic self
---@param self self
---@return self
function toggle:setToggle(state, instant)
   ---@cast self panels.toggle
   if self.toggle ~= state then
      self.toggle = state
      if instant then
         _toggle_slider(state and 1 or 0,self)
      else
         self.TOGGLED:invoke()
      end
   end
   return self
end

return toggle