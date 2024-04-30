local utils = require("libraries.utils")
local line = require("libraries.GNLineLib")

---@class line.cube
---@field from Vector3
---@field to Vector3
---@field line line[]
local cube = {}
cube.__index = cube
cube.__type = "line.cube"

---@return line.cube
function cube.new()
   local new = {}
   new.from = vectors.vec3(0,0,0)
   new.to = vectors.vec3(1,1,1)
   new.line = {
      line.new(),
      line.new(),
      line.new(),
      line.new(),

      line.new(),
      line.new(),
      line.new(),
      line.new(),
      
      line.new(),
      line.new(),
      line.new(),
      line.new(),
   }
   setmetatable(new,cube)
   return new
end

function cube:update()
   if self.from and self.to then
      local from = self.from
      local to = self.to
  
      local x = from.x
      local y = from.y
      local z = from.z
      local dx = to.x
      local dy = to.y
      local dz = to.z
      
      
      self.line[1]:setA(x,y,z):setB(dx,y,z):setColor(1,0,0)
      self.line[2]:setA(dx,y,z):setB(dx,y,dz)
      self.line[3]:setA(dx,y,dz):setB(x,y,dz)
      self.line[4]:setA(x,y,dz):setB(x,y,z):setColor(0,0,1)
   
      self.line[5]:setA(x,dy,z):setB(dx,dy,z)
      self.line[6]:setA(dx,dy,z):setB(dx,dy,dz)
      self.line[7]:setA(dx,dy,dz):setB(x,dy,dz)
      self.line[8]:setA(x,dy,dz):setB(x,dy,z)
   
      self.line[9]:setA(x,y,z):setB(x,dy,z):setColor(0,1,0)
      self.line[10]:setA(dx,y,z):setB(dx,dy,z)
      self.line[11]:setA(dx,y,dz):setB(dx,dy,dz)
      self.line[12]:setA(x,y,dz):setB(x,dy,dz)
   end

end

---@overload fun(self : line.cube, vec : Vector3):line.cube
---@param x number
---@param y number
---@param z number
---@return line.cube
function cube:setFrom(x,y,z)
   local new = utils.figureOutVec3(x,y,z)
   self.from = new
   self:update()
   return self
end

---@overload fun(self : line.cube, vec : Vector3):line.cube
---@param x number
---@param y number
---@param z number
---@return line.cube
function cube:setTo(x,y,z)
   local new = utils.figureOutVec3(x,y,z)
   self.to = new
   self:update()
   return self
end

function cube:setVisible(visible)
   for key, value in pairs(self.line) do
      value:setVisible(visible)
   end
   return self
end

local api = {}
api.newCube = cube.new

return api