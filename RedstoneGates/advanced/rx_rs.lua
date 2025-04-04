-- Transmit interval in seconds, must be in an increment of 0.1 (1 redstone tick)
INTERVAL = 0.1

-- Port to receive on
RECEIVE_PORT = 1820




-- do not edit below this line or cobuder gets angry >:(

local modem = peripheral.find("modem") or error("\n> No modem attached!\n", 0)
modem.open(RECEIVE_PORT)

local lastSigStrength = nil
local lastSigTime = nil

function run()
    local event, side, channel, replyChannel, sigStrength, distance
    repeat
        event, side, channel, replyChannel, sigStrength, distance = os.pullEvent("modem_message")
    until channel == RECEIVE_PORT

    if sigStrength ~= lastSigStrength then
        local timeDelta = nil
        if lastSigStrength ~= nil and lastSigTime ~= nil then
            timeDelta = "(after " .. fmtSeconds(os.clock() - lastSigTime) .. ")"
        end
        local sigDiff = ""
        if lastSigStrength ~= nil then
            sigDiff = " (" .. (sigStrength > lastSigStrength and "+" or "-") .. math.abs(sigStrength - lastSigStrength) .. ")"
        end

        if timeDelta ~= nil then
            print("  " .. timeDelta .. "\n")
        end
        print("* " .. (lastSigStrength == nil and "Initial" or "New") .. " signal: " .. sigStrength .. sigDiff)

        lastSigStrength = sigStrength
        lastSigTime = os.clock()
    end
end

function trimString(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end

function fmtSeconds(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60

    local ret = ""
    if hours > 0 then
        ret = string.format("%2dh %2dm %2ds", hours, minutes, seconds)
    elseif minutes > 0 then
        ret = string.format("%2dm %2ds", minutes, seconds)
    else
        ret = string.format("%2ds", seconds)
    end
    return trimString(ret)
end

function b64dec(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = string.gsub(data, "[^"..b.."=]", "")

    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
        end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
end

-- cause pastebin hates links
print(b64dec("CnwgUlhfUlMgYnkgU3Y0NDMKfCBzdjQ0My5uZXQvci9jYy1wcm9qZWN0cwo="))

while true do
    run()
    sleep(INTERVAL)
end
