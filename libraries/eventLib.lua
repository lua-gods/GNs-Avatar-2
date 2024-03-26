--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
-- An event library for connecting multiple functions into one.
local eventlib = {}

---@class Listener
---@field id integer
---@field priority integer
---@field event eventLib
local Listener = {}
Listener.__index = Listener

function Listener.new(priority,id,event)
   local new = {
      priority = priority,
      id = id,
      event = event
   }
   setmetatable(new,Listener)
   return new
end

function Listener:disconnect()
   self.event[self.priority][self.id] = nil
   self = nil
end


---@class eventLib
---@field priorities table<any,number>
---@field listensers table<number,table<any,function>>
local eventLib = {}
eventLib.__index = eventLib

---@return eventLib
function eventlib.new()
   local new = {}
   new.priorities = {}
   new.listensers = {}
   setmetatable(new,eventLib)
   return new
end

function eventLib:copy()
   local new = eventlib.new()
   new.priorities = self.priorities
   new.listensers = self.listensers
   return new
end

function eventLib:invoke(...)
   for _, priority in pairs(self.priorities) do
      for _, listener in pairs(self.listensers[priority]) do
         listener(...)
      end
   end
   return self
end

---comment
---@param func any
---@param priority any
function eventLib:register(func,priority)
   priority = priority or 0
   local exists = false
   -- check if the priority already exists
   for key, value in pairs(self.priorities) do
      if value == priority then
         exists = true
         break
      end
   end
   
   -- insertion sort
   if not exists then
      local placed = false
      self.listensers[priority] = {}
      for i = 1, #self.priorities, 1 do
         local value = self.priorities[i]
         if value > priority then
            table.insert(self.priorities,i,priority)
            placed = true
            break
         end
      end
      if not placed then
         self.priorities[#self.priorities+1] = priority
      end
   end

   local next_free = #self.listensers[priority]+1
   self.listensers[priority][next_free] = func
   return Listener.new(priority,next_free,self)
end

return eventlib