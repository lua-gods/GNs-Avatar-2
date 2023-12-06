local SERVERS_PATH = "services.servers"
local serverData = client.getServerData()
local configName = (serverData.ip and serverData.ip:gsub('^.-;', '') or serverData.name)
local files = listFiles(SERVERS_PATH,true)
for _, ip in pairs(files) do
   if ip:sub(1,#(SERVERS_PATH.."."..configName)) == SERVERS_PATH.."."..configName then
      for _, script in pairs(listFiles(SERVERS_PATH.."."..configName)) do
         require(script)
      end
   end
end