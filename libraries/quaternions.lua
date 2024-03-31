
math.epsilon = 0.00001

---@class Quaternion
---@field x number
---@field y number
---@field z number
---@field w number
Quat = {}
Quat.__index = Quat

function Quat.new(x, y, z, w)
   local self = setmetatable({}, Quat)
   self.x = x or 0
   self.y = y or 0
   self.z = z or 0
   self.w = w or 1
   return self
end

function Quat:set(x, y, z, w)
   self.x = x
   self.y = y
   self.z = z
   self.w = w
   return self
end

function Quat:addTime(v, t)
   local ax = v.x
   local ay = v.y
   local az = v.z
   local qw = self.w
   local qx = self.x
   local qy = self.y
   local qz = self.z
   t = t * 0.5
   self.x = self.x + t * (ax * qw + ay * qz - az * qy)
   self.y = self.y + t * (ay * qw + az * qx - ax * qz)
   self.z = self.z + t * (az * qw + ax * qy - ay * qx)
   self.w = self.w + t * (-ax * qx - ay * qy - az * qz)
   self:normalize()
   return self
end

function Quat:multiply(q, p)
   if p then
      return self:multiplyQuaternions(q, p)
   else
      return self:multiplyQuaternions(self, q)
   end
end

function Quat:multiplyQuaternions(a, b)
   local qax = a.x
   local qay = a.y
   local qaz = a.z
   local qaw = a.w
   local qbx = b.x
   local qby = b.y
   local qbz = b.z
   local qbw = b.w
   self.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby
   self.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz
   self.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx
   self.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz
   return self
end

function Quat:setFromUnitVectors(v1, v2)
   local vx = vectors.vec3()
   local r = v1:dot(v2) + 1
   if r < math.epsilon then
      r = 0
      if math.abs(v1.x) > math.abs(v1.z) then
         vx:set(-v1.y, v1.x, 0)
      else
         vx:set(0, -v1.z, v1.y)
      end
   else
      vx:crossVectors(v1, v2)
   end
   self._x = vx.x
   self._y = vx.y
   self._z = vx.z
   self._w = r
   return self:normalize()
end

function Quat:arc(v1, v2)
   local x1 = v1.x
   local y1 = v1.y
   local z1 = v1.z
   local x2 = v2.x
   local y2 = v2.y
   local z2 = v2.z
   local d = x1 * x2 + y1 * y2 + z1 * z2
   if d == -1 then
      x2 = y1 * x1 - z1 * z1
      y2 = -z1 * y1 - x1 * x1
      z2 = x1 * z1 + y1 * y1
      d = 1 / math.sqrt(x2 * x2 + y2 * y2 + z2 * z2)
      self.w = 0
      self.x = x2 * d
      self.y = y2 * d
      self.z = z2 * d
      return self
   end
   local cx = y1 * z2 - z1 * y2
   local cy = z1 * x2 - x1 * z2
   local cz = x1 * y2 - y1 * x2
   self.w = math.sqrt((1 + d) * 0.5)
   d = 0.5 / self.w
   self.x = cx * d
   self.y = cy * d
   self.z = cz * d
   return self
end

function Quat:normalize()
   local l = self:length()
   if l == 0 then
      self:set(0, 0, 0, 1)
   else
      l = 1 / l
      self.x = self.x * l
      self.y = self.y * l
      self.z = self.z * l
      self.w = self.w * l
   end
   return self
end

function Quat:inverse()
   return self:conjugate():normalize()
end

function Quat:invert(q)
   self.x = q.x
   self.y = q.y
   self.z = q.z
   self.w = q.w
   self:conjugate():normalize()
   return self
end

function Quat:conjugate()
   self.x = -self.x
   self.y = -self.y
   self.z = -self.z
   return self
end

function Quat:length()
   return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w)
end

function Quat:lengthSq()
   return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w
end

function Quat:copy(q)
   self.x = q.x
   self.y = q.y
   self.z = q.z
   self.w = q.w
   return self
end

function Quat:clone(q)
   return Quat.new(self.x, self.y, self.z, self.w)
end

function Quat:testDiff(q)
   return self:equals(q) and false or true
end

function Quat:equals(q)
   return self.x == q.x and self.y == q.y and self.z == q.z and self.w == q.w
end

function Quat:toString()
   return "Quat[" ..
   string.format("%.4f", self.x) ..
   ", (" ..
   string.format("%.4f", self.y) ..
   ", " .. string.format("%.4f", self.z) .. ", " .. string.format("%.4f", self.w) .. ")]"
end

function Quat:setFromEuler(x, y, z)
   local c1 = math.cos(x * 0.5)
   local c2 = math.cos(y * 0.5)
   local c3 = math.cos(z * 0.5)
   local s1 = math.sin(x * 0.5)
   local s2 = math.sin(y * 0.5)
   local s3 = math.sin(z * 0.5)
   self.x = s1 * c2 * c3 + c1 * s2 * s3
   self.y = c1 * s2 * c3 - s1 * c2 * s3
   self.z = c1 * c2 * s3 + s1 * s2 * c3
   self.w = c1 * c2 * c3 - s1 * s2 * s3
   return self
end

function Quat:setFromAxis(axis, rad)
   axis:normalize()
   rad = rad * 0.5
   local s = math.sin(rad)
   self.x = s * axis.x
   self.y = s * axis.y
   self.z = s * axis.z
   self.w = math.cos(rad)
   return self
end

function Quat:setFromMat33(m)
   local trace = m[1] + m[5] + m[9]
   local s
   if trace > 0 then
      s = math.sqrt(trace + 1.0)
      self.w = 0.5 / s
      s = 0.5 / s
      self.x = (m[6] - m[8]) * s
      self.y = (m[7] - m[3]) * s
      self.z = (m[2] - m[4]) * s
   else
      local out = {}
      local i = 0
      if m[5] > m[1] then
         i = 1
      end
      if m[9] > m[i * 3 + i] then
         i = 2
      end
      local j = (i + 1) % 3
      local k = (i + 2) % 3
      s = math.sqrt(m[i * 3 + i] - m[j * 3 + j] - m[k * 3 + k] + 1.0)
      out[i] = 0.5 * s
      s = 0.5 / s
      self.w = (m[j * 3 + k] - m[k * 3 + j]) * s
      out[j] = (m[j * 3 + i] + m[i * 3 + j]) * s
      out[k] = (m[k * 3 + i] + m[i * 3 + k]) * s
      self.x = out[1]
      self.y = out[2]
      self.z = out[3]
   end
   return self
end

function Quat:toArray(array, offset)
   offset = offset or 0
   array[offset] = self.x
   array[offset + 1] = self.y
   array[offset + 2] = self.z
   array[offset + 3] = self.w
end

function Quat:fromArray(array, offset)
   offset = offset or 0
   self:set(array[offset], array[offset + 1], array[offset + 2], array[offset + 3])
   return self
end

function Quat:getMatrix()
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

function Quat:getEular()
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

return Quat
