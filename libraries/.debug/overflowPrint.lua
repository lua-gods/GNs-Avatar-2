local i = 0
---@param count integer
---@param ... any
local function p(count,...)
   i = i + 1
   if i >= count then
      print(...)
      error("^^^")
   end
end

return p