---@diagnostic disable: undefined-global
local function dump()
   local a = 0
   while true do
      local name, value = debug.getlocal(1, a)
      if not name then break end
      print(name, value)
      a = a + 1
   end
end

return dump