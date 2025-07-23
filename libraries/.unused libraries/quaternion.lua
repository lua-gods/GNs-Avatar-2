local epsilon = 2.22044604925031308e-16

---@class quaternion
---@field x number
---@field y number
---@field z number
---@field w number
local quaternion = {}
quaternion.__index = quaternion

quaternion.__sub = function (lhs, rhs)
   return quaternion.new(lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z, lhs.w-rhs.w)
end

quaternion.__add = function (lhs, rhs)
   return quaternion.new(lhs.x+rhs.x, lhs.y+rhs.y, lhs.z+rhs.z, lhs.w+rhs.w)
end

quaternion.__mul = function (lhs, rhs)
   return quaternion.new(
      lhs.w*rhs.x + lhs.x*rhs.w + lhs.y*rhs.z - lhs.z*rhs.y,
      lhs.w*rhs.y + lhs.y*rhs.w + lhs.z*rhs.x - lhs.x*rhs.z,
      lhs.w*rhs.z + lhs.z*rhs.w + lhs.x*rhs.y - lhs.y*rhs.x,
      lhs.w*rhs.w - lhs.x*rhs.x - lhs.y*rhs.y - lhs.z*rhs.z
   )
end

quaternion.__div = function (lhs, rhs)
   return quaternion.new(
      lhs.x/rhs.x,
      lhs.y/rhs.y,
      lhs.z/rhs.z,
      lhs.w/rhs.w
   )
end

quaternion.__unm = function (lhs)
   return quaternion.new(-lhs.x, -lhs.y, -lhs.z, -lhs.w)
end


quaternion.__eq = function (lhs, rhs)
   return lhs:equals(rhs)
end

quaternion.__tostring = function (lhs)
   return string.format("(%f,%f,%f,%f)",lhs.x,lhs.y,lhs.z,lhs.w)
end

quaternion.__len = function (lhs)
   return lhs:length()
end

quaternion.__call = function (lhs, x,y,z,w)
   return quaternion.new(x,y,z,w)
end

---@overload fun():quaternion
---@overload fun(vec4: Vector4):quaternion
---@overload fun(tbl:integer[]):quaternion
---@overload fun(tbl:{x:number,y:number,z:number,w:number}):quaternion
---@param x number
---@param y number
---@param z number
---@param w number
---@return quaternion
function quaternion.new(x,y,z,w)
   local xt,yt,zt,wt = type(x), type(y), type(z), type(w)
   local new = {}
   setmetatable(new,quaternion)
   if (xt == "number" and yt == "number" and zt == "number" and wt == "number") then
      new.x = x
      new.y = y
      new.z = z
      new.w = w or 1
   elseif xt == "Vector4" and yt == "nil" and zt == "nil" and wt == "nil" then
      new.x = x.x
      new.y = x.y
      new.z = x.z
      new.w = x.w
   elseif xt == "table" then
      if x.x then
         new.x = x.x
         new.y = x.y
         new.z = x.z
         new.w = x.w
      else
         new.x = x[1]
         new.y = x[2]
         new.z = x[3]
         new.w = x[4]
      end
   else
      new.x = 0
      new.y = 0
      new.z = 0
      new.w = 1
   end
   return new
end

---@param x number
---@param y number
---@param z number
---@param w number
---@return quaternion
function quaternion:set(x,y,z,w)
   self.x = x
   self.y = y
   self.z = z
   self.w = w
   return self
end

---@return quaternion
function quaternion:clone()
   return quaternion.new(self.x,self.y,self.z,self.w)
end

---@param quat quaternion
---@return quaternion
function quaternion:copy(quat)
   self.x = quat.x
   self.y = quat.y
   self.z = quat.z
   self.w = quat.w
   return self
end

---@param eular Vector3
---@return quaternion
function quaternion:setFromEular(eular)
   local x,y,z = math.rad(eular.x),math.rad(eular.y),math.rad(eular.z)
   local cos,sin = math.cos,math.sin

   local c1,c2,c3 = cos(x/2),cos(y/2),cos(z/2)
   local s1,s2,s3 = sin(x/2),sin(y/2),sin(z/2)
   -- order is ZYX
   self.x = s1 * c2 * c3 - c1 * s2 * s3;
	self.y = c1 * s2 * c3 + s1 * c2 * s3;
	self.z = c1 * c2 * s3 + s1 * s2 * c3;
	self.w = c1 * c2 * c3 - s1 * s2 * s3;
   return self
end

---@param axis Vector3
---@param angle number
---@return quaternion
function quaternion:setFromAxisAngle(axis, angle)
   local half_angle = angle / 2
   local s = math.sin(half_angle)
   self.x = axis.x * s
   self.y = axis.y * s
   self.z = axis.z * s
   self.w = math.cos(half_angle)
   return self
end


---NOTE: BUGGY, INNACURATE
---@param matrix Matrix4
---@return quaternion
function quaternion:setFromMatrix(matrix)
   local trace = matrix.v11 + matrix.v22 + matrix.v33
   if trace > 0 then
      local s = math.sqrt(trace + 1.0) * 2
      self.w = 0.25 * s
      self.x = (matrix.v32 - matrix.v23) / s
      self.y = (matrix.v13 - matrix.v31) / s
      self.z = (matrix.v21 - matrix.v12) / s
   elseif matrix.v11 > matrix.v22 and matrix.v11 > matrix.v33 then
      local s = math.sqrt(1.0 + matrix.v11 - matrix.v22 - matrix.v33) * 2
      self.w = (matrix.v32 - matrix.v23) / s
      self.x = 0.25 * s
      self.y = (matrix.v12 + matrix.v21) / s
      self.z = (matrix.v13 + matrix.v31) / s
   elseif matrix.v22 > matrix.v33 then
      local s = math.sqrt(1.0 + matrix.v22 - matrix.v11 - matrix.v33) * 2
      self.w = (matrix.v13 - matrix.v31) / s
      self.x = (matrix.v12 + matrix.v21) / s
      self.y = 0.25 * s
      self.z = (matrix.v23 + matrix.v32) / s
   else
      local s = math.sqrt(1.0 + matrix.v33 - matrix.v11 - matrix.v22) * 2
      self.w = (matrix.v21 - matrix.v12) / s
      self.x = (matrix.v13 + matrix.v31) / s
      self.y = (matrix.v23 + matrix.v32) / s
      self.z = 0.25 * s
   end
   return self
end

---@param vfrom Vector3
---@param vto Vector3
---@return quaternion
function quaternion:setFromUnitVectors(vfrom, vto)
   local r = vfrom:dot(vto) + 1
   if r < epsilon then
      r = 0
      if math.abs(vfrom.x) > math.abs(vfrom.z) then
         self.x = -vfrom.y
         self.y = vfrom.x
         self.z = 0
         self.w = r
      else
         self.x = 0
         self.y = -vfrom.z
         self.z = vfrom.y
         self.w = r
      end
   else
      self.x = vfrom.y * vto.z - vfrom.z * vto.y
      self.y = vfrom.z * vto.x - vfrom.x * vto.z
      self.z = vfrom.x * vto.y - vfrom.y * vto.x
      self.w = r
   end
   return self
end

---@param q quaternion
---@return number
function quaternion:angleTo(q)
   return 2 * math.acos(math.abs(math.clamp(self:dot(q), -1, 1)))
end

---@param q quaternion
---@param step number
---@return quaternion
function quaternion:rotateTowards(q,step)
   local angle = self:angleTo(q)
   if angle == 0 then return self end
   local t = math.min(1, step / angle)
   return self
end

function quaternion:identity()
   self.x = 0
   self.y = 0
   self.z = 0
   self.w = 1
   return self
end


---@return quaternion
function quaternion:invert()
   return self:conjugate()
end


---@return quaternion
function quaternion:conjugate()
   self.x = -self.x
   self.y = -self.y
   self.z = -self.z
   return self
end

---@param quat quaternion
---@return number
function quaternion:dot(quat)
   return self.x * quat.x + self.y * quat.y + self.z * quat.z + self.w * quat.w
end

---@return number
function quaternion:lengthSq()
   return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w
end

---@return number
function quaternion:length()
   return math.sqrt(self:lengthSq())
end

---@return quaternion
function quaternion:normalize()
   local len = self:length()
   if len > 0 then
      self.x = self.x / len
      self.y = self.y / len
      self.z = self.z / len
      self.w = self.w / len
   else
      len = 1 / len
      self.x = self.x * len
      self.y = self.y * len
      self.z = self.z * len
      self.w = self.w * len
   end
   return self
end

---@param q quaternion
---@return quaternion
function quaternion:multiply(q)
   return self:multiplyQuaternions(self,q)
end

---@param q quaternion
---@return quaternion
function quaternion:premultiply(q)
   return self:multiplyQuaternions(q,self)
end

---@param a quaternion
---@param b quaternion
---@return quaternion
function quaternion:multiplyQuaternions(a,b)
   local qax, qay, qaz, qaw = a.x, a.y, a.z, a.w
   local qbx, qby, qbz, qbw = b.x, b.y, b.z, b.w
   
   self.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qbx
   self.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz
   self.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx
   self.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz
   return self
end

function quaternion:getMatrix()
   local mat = matrices.mat4()
   local x,y,z,w = self.x,self.y,self.z,self.w
   local x2,y2,z2 = x+x, y+y, z+z
   local xx, xy, xz = x*x2, x*y2, x*z2
   local yy, yz, zz = y*y2, y*z2, z*z2
   local wx, wy, wz = w*x2, w*y2, w*z2

   mat.v11 = 1 - (yy+zz)
   mat.v21 = xy - wz
   mat.v31 = xz + wy
   mat.v41 = 0
   
   mat.v12 = xy + wz
   mat.v22 = 1 - (xx+zz)
   mat.v32 = yz - wx
   mat.v42 = 0
   
   mat.v13 = xz - wy
   mat.v23 = yz + wx
   mat.v33 = 1 - (xx+yy)
   mat.v43 = 0
   
   mat.v14 = 0
   mat.v24 = 0
   mat.v34 = 0
   mat.v44 = 1
   return mat
end

function quaternion:getEular()
   local mat = self:getMatrix()

   local x = math.asin(math.clamp(mat.v23, -1,1))
   local y,z
   if math.abs(mat.v23) < 0.99999 then
      y = math.atan2(-mat.v13, mat.v33)
      z = math.atan2(-mat.v21, mat.v22)
   else
      --x = 0
      y = math.atan2(- mat.v12, mat.v11) * math.sign(-mat.v23)
      z = 0
   end

   
   return vectors.vec3(math.deg(x), math.deg(y), math.deg(z))
end

---@param qb quaternion
---@param t number
---@return quaternion
function quaternion:slerp(qb, t)
   if t == 1 then return self end
   if t == 1 then return self:copy(qb) end

   local x = self.x
   local y = self.y
   local z = self.z
   local w = self.w
   local cos_half_theta = w * qb.w + x * qb.x + y * qb.y + z * qb.z
   if (cos_half_theta < 0) then
      self.w = -qb.w
      self.x = -qb.x
      self.y = -qb.y
      self.z = -qb.z
      cos_half_theta = -cos_half_theta
   else
      self:copy(qb)
   end
   if (cos_half_theta >= 1.0) then
      self.w = w
      self.x = x
      self.y = y
      self.z = z
      return self
   end

   local sqr_sin_half_theta = 1.0 - cos_half_theta * cos_half_theta
   if (sqr_sin_half_theta <= epsilon) then
      local s = 1 - t
      self.w = s * w + t * self.w
      self.x = s * x + t * self.x
      self.y = s * y + t * self.y
      self.z = s * z + t * self.z
      return self
   end
   
   local sin_half_theta = math.sqrt(sqr_sin_half_theta)
   local half_theta = math.atan2(sin_half_theta, cos_half_theta)
   local ratio_a = math.sin((1 - t) * half_theta) / sin_half_theta
   local ratio_b = math.sin(t * half_theta) / sin_half_theta
   
   self.w = (w * ratio_a + self.w * ratio_b)
   self.x = (x * ratio_a + self.x * ratio_b)
   self.y = (y * ratio_a + self.y * ratio_b)
   self.z = (z * ratio_a + self.z * ratio_b)
   return self
end

---@param qa quaternion
---@param qb quaternion
---@param t number
---@return quaternion
function quaternion:slerpQuaternions(qa,qb,t)
   return self:copy(qa):slerp(qb,t)
end

---@return quaternion
function quaternion:random()
   local theta1 = 2 * math.pi * math.random()
   local theta2 = 2 * math.pi * math.random()

   local x0 = math.sin(theta1) * math.cos(theta2)
   local r1 = math.sqrt(1 - x0)
   local r2 = math.sqrt(x0)

   self:set(
      r1 * math.sin(theta1),
      r1 * math.cos(theta1),
      r2 * math.sin(theta2),
      r2 * math.cos(theta2)
   )
   return self
end

---@param q quaternion
---@return boolean
function quaternion:equals(q)
   return self.x == q.x
      and self.y == q.y
      and self.z == q.z
      and self.w == q.w
end

return quaternion