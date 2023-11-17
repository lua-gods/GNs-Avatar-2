if host:isHost() then
   local files = listFiles("services.host",false)
   for _, script in pairs(files) do
      local success, result = pcall(require,script)
      if not success then
         print("§c"..result)
      end
   end

   files = listFiles("services.wip",false)
   for _, script in pairs(files) do
      require(script)
   end
end