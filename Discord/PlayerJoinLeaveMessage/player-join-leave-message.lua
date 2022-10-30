-- connection info of your minecraft server
SERVER_IP = ""
SERVER_PORT = "25565"

-- create a webhook in the Discord channel
-- settings then copy its URL and enter it here
DISCORD_WH_URL = ""

-- interval in seconds at which to check
-- if players joined or left
-- the API updates roughly every 10 mins (600s)
-- so this shouldn't be too high or too low
INTERVAL = 120

os.loadAPI("json")

local prevPlayers = {}
local curPlayers = {}
local initial = true

while true do
    loop()
    os.sleep(INTERVAL)
end

-- main loop
function loop()
    local url = "https://mcapi.us/server/status?ip=" .. SERVER_IP .. "&port=" .. SERVER_PORT
    local headers = {}
    headers["cache-control"] = "no-cache"

    local str = http.get(url, headers).readAll()

    if str == nil then
        print("Couldn't reach mcapi.us")
        return
    end

    local obj = json.decode(str)

    if obj.status ~= "success" or not obj.online then
        print("The server is not online. Which is weird, considering this program is currently running on the server.")
        return
    end

    -- extract the players from an object into a "string array"
    local players = obj.players.sample
    local playerNames = {}

    for i = 1, #players do
        local name = players[i]["name"]
        playerNames[i] = name
    end

    curPlayers = playerNames

    -- so the program doesn't send a message about every
    -- currently online player joining, every time the
    -- computer gets rebooted
    if not initial then
        checkPlayersChanged(prevPlayers, curPlayers)
    else
        initial = false
    end

    prevPlayers = curPlayers

    -- print("#")
end

-- prints a table to the console, 1 line per item
function printTable(table)
    for k, v in pairs(table) do
        print(k .. ": " .. v)
    end
end

-- checks if a table contains a value
function tableHasVal(table, val)
    for k, v in pairs(table) do
        if v == val then
            return true
        end
    end
    return false
end

-- checks if a table contains a key
function tableHasKey(table, key)
    for k, v in pairs(table) do
        if k == key then
            return true
        end
    end
    return false
end

-- gets called when a player joins or leaves
function checkPlayersChanged(prev, cur)
    -- figure out which players joined or left and
    -- add them to the respective table
    local left = {}
    local joined = {}

    if tableLen(cur) > tableLen(prev) then
        for i, player in pairs(cur) do
            if not tableHasVal(prev, player) then
                joined[tableLen(joined) + 1] = player
            end
        end
    elseif tableLen(cur) < tableLen(prev) then
        for i, player in pairs(prev) do
            if not tableHasVal(cur, player) then
                left[tableLen(left) + 1] = player
            end
        end
    end

    -- if anyone joined or left, construct a
    -- message string out of it
    if tableLen(joined) > 0 or tableLen(left) > 0 then
        local msg = ""

        print()
        print("Players:")
        print(getUsernames(cur))

        if tableLen(joined) > 0 and tableLen(left) > 0 then
            -- people joined & left
            msg = getUsernames(joined)
            msg = msg .. " joined the game and\n"
            msg = msg .. getUserNames(left) .. " left the game"
        elseif tableLen(joined) > 0 then
            -- people joined
            msg = getUsernames(joined)
            msg = msg .. " joined the game"
        elseif tableLen(left) > 0 then
            -- people left
            msg = getUsernames(left)
            msg = msg .. " left the game"
        end

        -- send the Discord message
        if msg ~= nil then
            print("> " .. msg)
            sendMsg(msg)
        end

        print()
    end
end

-- joins a table of index & username into a string
function getUsernames(names)
    local val = ""
    for k, player in pairs(names) do
        if k > 1 then
            val = val .. ", "
        end

        val = val .. player
    end
    return val
end

-- returns the length of a table
function tableLen(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- sends a message using the discord webhook
function sendMsg(content)
    local data = '{"content":"' .. content .. '"}'
    local headers = {}
    headers["content-type"] = "application/json"

    http.request(DISCORD_WH_URL, data, headers)

    while true do
        local ev, url, body = os.pullEvent()

        if ev == "http_succes" then
            return body
        elseif ev == "http_failure" then
            return nil
        end
    end
end
