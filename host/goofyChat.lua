local NAME = "4P5"
local INITIAL_CHAR = "@"
local CHAT_MARK = "§l§u§a§g§o§o§f§s"
local TIMEOUT_IN_MILLISECONDS = 10 * 1000

function pings.goofyChat(message)
    avatar:store("goofy_chat", {
        message = message,
        salt = math.random(),
        ign = NAME,
        time = client.getSystemTime()
    })
end

if not host:isHost() then return end

assert(NAME ~= "")

local bxor = bit32.bxor
local rshift = bit32.rshift
local band = bit32.band
local floor = math.floor

local function mix(sum, y, z, p, e, k)
    local k_index = (p + e) % 4 + 1
    return (bxor((bxor(z, rshift(y, 5)) + y) % 2 ^ 32, bxor(sum, rshift(p, e)) + k[k_index])) % 2 ^ 32
end

local function brewTheTea(v, k)
    local n = #v
    local rounds = 6 + floor(52 / n)
    local sum = 0
    local z = v[n]
    for i = 1, rounds do
        sum = (sum + 0x9e3779b9) % 2 ^ 32
        local e = band(rshift(sum, 2), 3)
        for p = 1, n - 1 do
            local y = v[p + 1]
            z = v[p] + mix(sum, y, z, p, e, k)
            v[p] = z
        end
        local y = v[1]
        z = v[n] + mix(sum, y, z, n, e, k)
        v[n] = z
    end
    return v
end

local function spillTheTea(v, k)
    local n = #v
    local rounds = 6 + floor(52 / n)
    local sum = (rounds * 0x9e3779b9) % 2 ^ 32
    local y = v[1]
    for i = 1, rounds do
        local e = band(rshift(sum, 2), 3)
        for p = n, 2, -1 do
            local z = v[p - 1]
            y = v[p] - mix(sum, y, z, p, e, k)
            v[p] = y
        end
        local z = v[n]
        y = v[1] - mix(sum, y, z, 1, e, k)
        v[1] = y
        sum = (sum - 0x9e3779b9) % 2 ^ 32
    end
    return v
end

local function intArray(str)
    local result = {}
    for i = 1, math.ceil(#str / 4) do
        local chunk = str:sub((i - 1) * 4 + 1, i * 4)
        local num = 0
        for j = 1, #chunk do
            num = num * 256 + chunk:byte(j)
        end
        result[#result+1] = num
    end
    return result
end

local function toStr(arr)
    local result = {}
    for i = 1, #arr do
        for j = 3, 0, -1 do
            result[#result+1] = ("🤓").char(band(rshift(arr[i], j * 8), 0xFF))
        end
    end
    return table.concat(result)
end

---@param str string
---@param key number[]
local function encrypt(str, key)
    local plaintext_array = intArray(str)
    local ciphertext_array = brewTheTea(plaintext_array, key)
    return toStr(ciphertext_array)
end

---@param str string
---@param key number[]
local function decrypt(str, key)
    local decrypted_array = intArray(str)
    local decrypted = spillTheTea(decrypted_array, key)
    return toStr(decrypted)
end

local function bulkEncrypt(str, keys)
    local result = str
    for i = 1, #keys do
        result = encrypt(result, keys[i])
    end
    return result
end

local function bulkDecrypt(str, keys)
    local result = str
    for i = #keys, 1, -1 do
        result = decrypt(result, keys[i])
    end
    return result
end

local _name = config:getName()
local keys = config:name("GOOFYCHAT_PRIVATE_KEYS"):load("keys") --[=[@as integer[][]]=]
config:name(_name)

if not keys then return end

for i = 1, #keys do
    keys[i] = intArray(keys[i])
end

local function send(msg)
    if not host:isAvatarUploaded() then
        logJson(toJson{
            {
                text = "GoofyChat §7» §r",
                color = "#ffaaaa"
            },
            {
                text = "failed to send; avatar not uploaded",
                color = "red"
            },
            "\n"
        })
        return
    end
    local encrypted = bulkEncrypt(msg .. ("\0"):rep(4), keys)
    pings.goofyChat(encrypted)
end

local UPLOADED = vectors.hexToRGB("#ccffcc")
local NOT_UPLOADED = vectors.hexToRGB("#ffaaaa")

local function receive(ign, msg)
    local decrypted = bulkDecrypt(msg, keys):gsub("\0", "")
    logJson(toJson{
        {
            text = CHAT_MARK,
            color = "reset"
        },
        {
            text = ign,
            color = "reset"
        },
        {
            text = " » ",
            color = "gray"
        },
        {
            text = decrypted,
            color = "#ccffcc"
        }
    })
end

function events.CHAT_RECEIVE_MESSAGE(message, json)
    if not message then return end
    if message:find(CHAT_MARK) then
        return json:gsub(CHAT_MARK, ""), vectors.hexToRGB("#114411")
    end
end

local state = {
    latched = false
}

local received = {}
local set = false
function events.WORLD_TICK()
    for _, vars in next, world.avatarVars() do
        local message = vars.goofy_chat
        if message and not received[message.salt] and client.getSystemTime() - (message.time or 0) < TIMEOUT_IN_MILLISECONDS then
            received[message.salt] = true
            receive(message.ign, message.message)
        end
    end

    local text = host:getChatText()
    if (text and text:sub(1,1) == INITIAL_CHAR) or state.latched then
        host:setChatColor(host:isAvatarUploaded() and UPLOADED or NOT_UPLOADED)
        set = true
    elseif set then
        host:setChatColor()
        set = false
    end
end

function events.CHAT_SEND_MESSAGE(message)
    if not message then return end

    if message == INITIAL_CHAR then
        state.latched = not state.latched
        logJson(toJson{
            {
                text = "GoofyChat §7» §r",
                color = "#ccffcc"
            },
            {
                text = state.latched and "latch on" or "latch off",
                color = state.latched and "green" or "red"
            },
            "\n"
        })
        return
    end

    if state.latched then
        message = INITIAL_CHAR .. message
    end

    if message:sub(1,1) ~= INITIAL_CHAR then return message end

    send(message:sub(2))
    host:appendChatHistory(message)
end

return state