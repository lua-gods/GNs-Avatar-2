local lib = {}

local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

---@type table<string, number>
local char_to_val_cache = {}
---@param char string
---@return number
local function charToValue(char)
    if not char_to_val_cache[char] then
        char_to_val_cache[char] = string.find(chars, char, 1, true) - 1
    end
    return char_to_val_cache[char]
end

---@type table<number, string>
local val_to_char_cache = {}
---@param val number
---@return string
local function valueToChar(val)
    if not val_to_char_cache[val] then
        val_to_char_cache[val] = string.sub(chars, val + 1, val + 1)
    end
    return val_to_char_cache[val]
end

local function validate(str)
    return #str % 4 == 0 and str:match("^[A-Za-z0-9+/]*=?=?$")
end

---@type table<string, string>
local decode_cache = {}
---@param base64 string?
---@return string?
function lib.decode(base64)
    if not base64 then return end
    if not validate(base64) then return end
    if decode_cache[base64] then return decode_cache[base64] end
    local result = {}
    local value = 0
    local bits = 0
    for i = 1, #base64 do
        local char = string.sub(base64, i, i)
        if char == "=" then break end
        local char_value = charToValue(char)
        if char_value then
            value = bit32.bor(bit32.lshift(value, 6), char_value)
            bits = bits + 6
            while bits >= 8 do
                local byte_value = bit32.band(bit32.rshift(value, bits - 8), 0xFF)
                result[#result+1] = string.char(byte_value)
                bits = bits - 8
            end
        end
    end
    decode_cache[base64] = table.concat(result)
    return decode_cache[base64]
end

---@type table<string, string>
local encode_cache = {}
---@param str string?
---@return string? base64
function lib.encode(str)
    if not str then return end
    if encode_cache[str] then return encode_cache[str] end
    local result = {}
    local value = 0
    local bits = 0
    for i = 1, #str do
        local byte_value = string.byte(str, i, i)
        value = bit32.bor(bit32.lshift(value, 8), byte_value)
        bits = bits + 8
        while bits >= 6 do
            local char_value = bit32.band(bit32.rshift(value, bits - 6), 0x3F)
            result[#result+1] = valueToChar(char_value)
            bits = bits - 6
        end
    end
    if bits > 0 then
        local char_value = bit32.band(bit32.lshift(value, 6 - bits), 0x3F)
        result[#result+1] = valueToChar(char_value)
    end
    local padding = #str % 3
    if padding == 1 then
        result[#result+1] = "=="
    elseif padding == 2 then
        result[#result+1] = "="
    end
    encode_cache[str] = table.concat(result)
    return encode_cache[str]
end

if data then
    function lib.encode(text)
        if not text then return end
        local buffer = data:createBuffer()
        buffer:writeByteArray(text)
        buffer:setPosition(0)
        local output = buffer:readBase64()
        buffer:close()
        return output
    end

    function lib.decode(base64)
        if not base64 then return end
        if not validate(base64) then return end
        local buffer = data:createBuffer()
        buffer:writeBase64(base64)
        buffer:setPosition(0)
        local output = buffer:readByteArray()
        buffer:close()
        return output
    end
end

return lib