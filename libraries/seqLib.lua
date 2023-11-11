--[[______   __
  / ____/ | / /
 / / __/  |/ /
/ /_/ / /|  /
\____/_/ |_/ ]]
---@class seqLibObject
---@field timeline table<integer,{time:integer,func:function}>
local seq = {}
seq.__index = seq

local seqID = 0

---@return seqLibObject
function seq.new()
   ---@type seqLibObject
   local new = {
      timeline = {},
   }
   setmetatable(new,seq)
   return new
end

---@param time integer
---@param func function
function seq:newKeyframe(time,func)
   if #self.timeline > 0 then
      local found = false
      for key, value in pairs(self.timeline) do
         if value.time > time then
            found = true
            table.insert(self.timeline,key,{time=time,func=func})
            break
         end
      end
      if not found then
         self.timeline[#self.timeline+1] = {time=time,func=func}
      end
   else
      self.timeline[#self.timeline+1] = {time=time,func=func}
   end
   return self
end

function seq:start()
   local playback = 0
   local next = 1
   events.TICK:register(function ()
      playback = playback + 1
      for i = 1, 10, 1 do
         if self.timeline[next].time < playback then
            if self.timeline[next].func then
               self.timeline[next].func()
            end
            next = next + 1
            if next > #self.timeline then
               events.TICK:remove("gnSeq"..seqID)
               return
            end
         else
            break
         end
      end
   end,"gnSeq"..seqID)
end

return seq