local NAME = "GN" -- any name
local IGN = "GNamimates" -- must be your IGN for DMs to work
local INITIAL_CHAR = "@"
local CHAT_MARK = "§l§u§a§g§o§o§f§s"
local DM_MARK = "§l§u§a§g§o§o§f§y"
local INCOMING_MESSAGE_MARK = "G!"
local TIMEOUT_IN_MILLISECONDS = 10 * 1000

local tableUtils = require("libraries.tableUtils")
function pings.goofyChat(message)
    avatar:store("goofy_chat", {
        message = message,
        salt = math.random(),
        ign = IGN,
        name = NAME,
        time = client.getSystemTime()
    })
end

avatar:store("goofy_chat_recipient", IGN)

function events.ENTITY_INIT()
    avatar:store("goofy_chat_recipient", player:getName())
end

if not host:isHost() then return end

local function encode(text)
    local buffer = data:createBuffer() ---@diagnostic disable-line: deprecated
    buffer:writeByteArray(text)
    buffer:setPosition(0)
    local output = buffer:readBase64()
    buffer:close()
    return output
end

local function decode(base64)
    local buffer = data:createBuffer() ---@diagnostic disable-line: deprecated
    buffer:writeBase64(base64)
    buffer:setPosition(0)
    local output = buffer:readByteArray()
    buffer:close()
    return output
end

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

local UPLOADED = vectors.hexToRGB("#ccffcc")
local NOT_UPLOADED = vectors.hexToRGB("#ccffff")
local emojis = {}
local readEmojis = false
local emojisRaw

local function sendReceived(name, msg, isDm, hasEmojis)

end

local function receive(name, msg, isDm)
    local decrypted = bulkDecrypt(msg, keys):gsub("\0", "")
    -- readEmojis = true
    -- host:sendChatCommand('figura emojis all')
    -- print(emojisRaw)
    logJson(toJson{
        {
            text = isDm and DM_MARK or CHAT_MARK,
            color = "reset"
        },
        {
            text = name,
            color = "reset"
        },
        {
            text = " » ",
            color = "gray"
        },
        {
            text = decrypted,
            color = isDm and "#ccffff" or "#ccffcc"
        },
        "\n"
    })
end

local function send(msg)
    local encrypted = bulkEncrypt(msg .. ("\0"):rep(4), keys)
    if host:isAvatarUploaded() then
        pings.goofyChat(encrypted)
        return
    end
    local recipients = {}
    for _, vars in next, world.avatarVars() do
        if vars.goofy_chat_recipient then
            recipients[#recipients+1] = vars.goofy_chat_recipient
        end
    end

    if #recipients == 0 then
        logJson(toJson{
            {
                text = "GoofyChat §7» §r",
                color = "#ffaaaa"
            },
            {
                text = "no recipients found",
                color = "red"
            },
            "\n"
        })
        return
    end

    local b64 = encode(encrypted)

    local message = INCOMING_MESSAGE_MARK .. b64

    for i = 1, #recipients do
        local recipient = recipients[i]
        if recipient == IGN then
            receive(NAME, encrypted, true)
        else
            host:sendChatCommand("/w " .. recipient .. " " .. message)
        end
    end
end

function events.CHAT_RECEIVE_MESSAGE(message, json)
    if not message then return end
    -- if readEmojis then
    --     readEmojis = false
    --     emojisRaw = json
    -- end

    if message:find(CHAT_MARK) then
        return json:gsub(CHAT_MARK, ""), vectors.hexToRGB("#114411")
    elseif message:find(DM_MARK) then
        return json:gsub(DM_MARK, ""), vectors.hexToRGB("#114444")
    end

    if message:find("whispers to you:") and message:find(INCOMING_MESSAGE_MARK) then
        local ign, msg = message:match("^(.-) whispers to you: (.+)$")
        if ign and msg then
            msg = msg:sub(#INCOMING_MESSAGE_MARK + 1)
            receive(ign, decode(msg), true)
            return false
        end
    elseif message:find('%[PM ← ') and message:find(INCOMING_MESSAGE_MARK) then
        local ign, msg = message:match("^%[PM ← (.-)] » (.+)$")
        if ign and msg then
            msg = msg:sub(#INCOMING_MESSAGE_MARK + 1)
            receive(ign, decode(msg), true)
            return false
        end
    elseif (message:find("You whisper to") or message:find('%[PM → ')) and message:find(INCOMING_MESSAGE_MARK) then
        return false
    end
end

local state = {
    latched = false
}

local received = {}
local set = false
function events.TICK()
    for _, vars in next, world.avatarVars() do
        local message = vars.goofy_chat
        if message and not received[message.salt] and client.getSystemTime() - (message.time or 0) < TIMEOUT_IN_MILLISECONDS then
            received[message.salt] = true
            receive(message.name, message.message)
        end
    end

    local text = host:getChatText()
    if (text and text:sub(1,#INITIAL_CHAR) == INITIAL_CHAR) or state.latched then
        host:setChatColor(host:isAvatarUploaded() and UPLOADED or NOT_UPLOADED)
        set = true
    elseif set then
        host:setChatColor(1, 1, 1)
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

    if message:sub(1,#INITIAL_CHAR) ~= INITIAL_CHAR then return message end

    send(message:sub(#INITIAL_CHAR + 1))
    host:appendChatHistory(message)
end

return state