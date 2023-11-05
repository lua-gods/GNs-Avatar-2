if host:isHost() then
   local files = listFiles("services.UI",false)
   for _, script in pairs(files) do
      require(script)
   end
end