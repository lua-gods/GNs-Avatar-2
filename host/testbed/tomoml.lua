local toml = require"libraries.toml"
local file = require"libraries.file"

local data = file.new("configs/tes.toml"):readString()
