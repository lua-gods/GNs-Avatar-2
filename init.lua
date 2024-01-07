
-- services are called first, as they are potentially used by programs, but they use libraries
for key, script in pairs(listFiles("services")) do
   require(script)
end

-- programs are the lowest level scripts, they use services and libraries
for key, script in pairs(listFiles("programs")) do
   require(script)
end