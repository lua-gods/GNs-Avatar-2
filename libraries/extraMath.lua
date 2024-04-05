local meth = {}

---Returns a multi stacked sine wave.  
---
---**Depth** is the amount of waves being stacked  
---**Presistence** is the contribution factor of the different waves.  
---A persistence value of 1 means all the octaves have the same contribution,  
---a value of 0.5 means each octave contributes half as much as the previous one.  
---**Lacunarity** is the difference in frequency between waves, higher value = more noiser the next wave goes.
---@param value number
---@param seed number
---@param depth integer
---@param presistence number?
---@param lacunarity number?
---@return unknown
function meth.superSine(value,seed,depth,presistence,lacunarity)
   presistence = presistence or 0.5
   math.randomseed(seed)
   local max = 0 -- used to normalize the value
   local result = 0
   local w = 1
   local lun = 1 
   for _ = 1, depth, 1 do
      max = max + 1 * w
      result = result + math.sin(value * lun * (math.random() * math.pi * depth) + math.random() * math.pi * depth) * w
      lun = lun * (lacunarity or 1.5)
      w = w * (presistence or 0.75)
   end
   math.randomseed(client.getSystemTime())
   return result / depth / max
end

return meth