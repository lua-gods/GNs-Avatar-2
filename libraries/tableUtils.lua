local t = {}

---Creates a proxy table for the given table, the proxy table is read only.  
---2nd parameter is a metatable.
---@param tbl table
---@param metatbl table?
---@return table
function t.makeReadOnly(tbl,metatbl)
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

return t