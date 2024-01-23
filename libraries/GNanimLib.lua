--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
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
function animationStateMachine.new()
   local new = {}
   new.blend_time = 1
   new.queue_next = {}
   next_free = next_free + 1
   new.id = next_free
   setmetatable(new,animationStateMachine)
   return new
end

---Transitions to the given animation from the last playing one.  
---default value is none, this will just blend to having no animation at all
---@param animation Animation?
function animationStateMachine:setAnimation(animation)
   tween.tweenFunction(self.blend_time,"linear",function (t)
      
   end,function ()
      
   end,tostring(self.id))
end

return {new = animationStateMachine.new}