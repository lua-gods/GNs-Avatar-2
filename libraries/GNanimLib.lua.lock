--[[______   __
  / ____/ | / / By: GNamimates
 / / __/  |/ / GNanimLib v2.0.0
/ /_/ / /|  / Allows you to play animations with ease.
\____/_/ |_/ https://github.com/lua-gods/GNs-Avatar-2/tree/main/libraries/GNanimLib.lua]]

local tween = require("libraries.GNTweenLib")

---@class animationStateMachine
---@field id integer
---@field current_animation Animation?
---@field last_animation Animation?
---@field blend_time number
---@field queue_next table<any,Animation>
local animationStateMachine = {}
animationStateMachine.__index = animationStateMachine

local next_free = 0
---@return animationStateMachine
function animationStateMachine.new()
   local new = {}
   new.blend_time = 1
   new.queue_next = {}
   new.id = next_free
   setmetatable(new,animationStateMachine)
   next_free = next_free + 1
   return new
end

function animationStateMachine:setBlendTime(seconds)
   self.blend_time = seconds
   return self
end

---Transitions to the given animation from the last playing one.  
---default value is none, this will just blend to having no animation at all
---@param animation Animation?
---@param force boolean?
---@return animationStateMachine
function animationStateMachine:setAnimation(animation,force)
   -- if different
   if animation ~= self.current_animation or force then
      self.last_animation = self.current_animation
      self.current_animation = animation
      local a,b = self.current_animation,self.last_animation
      if a then a:setBlend(0):stop():play() end
      tween.tweenFunction(0,1,self.blend_time,"linear",function (t)
         if a then a:setBlend(t) end
         if b then b:setBlend(1-t) end
      end,function ()
         if a then a:setBlend(1) end
         if b and not force then b:stop() end
      end,tostring(self.id))
   end
   return self
end

return {new = animationStateMachine.new}