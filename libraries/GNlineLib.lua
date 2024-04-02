--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]
---@overload fun(pos : Vector3)
---@param x number
---@param y number
---@param z number
---@return Vector3
local function figureOutVec3(x,y,z)
   local typa, typb, typc = type(x), type(y), type(z)
   if typa == "Vector3" and typb == "nil" and typc == "nil" then
      return x:copy()
   elseif typa == "number" and typb == "number" and typc == "number" then
      return vectors.vec3(x,y,z)
   else
      error("Invalid Vector3 parameter, expected Vector3 or (number, number, number), instead got ("..typa..", "..typb..", "..typc..")")
   end
end

---@param v Vector3
---@param n Vector3
---@return Vector3
local function flat(v, n)
   n = n:normalize()
   return v - (n * v:dot(n))
end

---Creates a proxy table for the given table, the proxy table is read only.  
---2nd parameter is a metatable.
---@param tbl table
---@param metatbl table?
---@return table
local function makeTableReadOnly(tbl,metatbl)
   local proxy = {}
   local mt = {
   __index = metatbl ~= nil and (metatbl or tbl) or tbl,
   __newindex = function ()
   error("No modifying metatable for u :trol:", 2)
   end
   }
   setmetatable(proxy, mt)
   return proxy
end

---@class line
---@field from Vector3?
---@field to Vector3?
---@field dir Vector?
---@field width number
---@field color Vector3
---@field alpha number
local line = {}
line.__index = line

---@param preset line?
---@return line
function line.new(preset)
   local new = setmetatable({},line)
   new.from = preset.from
   new.to = preset.to
   new.width = preset.width or 0.1
   new.color = preset.color or vectors.vec3(1,1,1)
   new.alpha = preset.alpha or 1
   return new
end

---@overload fun(self : line, from : Vector3, to :Vector3)
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
function line:setBothEnds(x1,y1,z1,x2,y2,z2)
   if type(x1) == "Vector3" and type(x2) == "Vector3" then
      self.from = x1:copy()
      self.to = x2:copy()
   else
      self.from = vectors.vec3(x1,y1,z1)
      self.to = vectors.vec3(x2,y2,z2)
   end
   return self
end

---@overload fun(self: line ,pos : Vector3)
---@param x number
---@param y number
---@param z number
function line:setFrom(x,y,z)
   self.from = figureOutVec3(x,y,z)
   return self
end

---@overload fun(self: line ,pos : Vector3)
---@param x number
---@param y number
---@param z number
function line:setTo(x,y,z)
   self.to = figureOutVec3(x,y,z)
   return self
end

function line:setWidth(w)
   self.width = w
end