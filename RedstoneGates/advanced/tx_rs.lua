-- Transmit interval in seconds, must be in an increment of 0.1 (1 redstone tick)
INTERVAL = 0.1

-- The side of the signal to transmit
INPUT_SIDE = "left"

-- Port to transmit on
TRANSMIT_PORT = 201824



local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(TRANSMIT_PORT)

local lastSig = nil

function run()
    local sig = redstone.getAnalogInput(INPUT_SIDE)

    modem.transmit(TRANSMIT_PORT, TRANSMIT_PORT, sig)
    if sig ~= lastSig then
        print("* Transmitting signal " .. sig)
        lastSig = sig
    end
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
print(b64dec("CnwgVHhScyBieSBTdjQ0Mwp8IHN2NDQzLm5ldC9yL2NjLXByb2plY3RzCg=="))

while true do
    run()
    sleep(INTERVAL)
end
