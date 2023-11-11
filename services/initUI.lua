if host:isHost() then
   local files = listFiles("services.UI",false)
   for _, script in pairs(files) do
      local success, result = pcall(require,script)
      if not success then
         print("§c"..result)
      end
   end
end