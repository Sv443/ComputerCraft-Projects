-- If this side receives a pulse, the computer switches to the next state
TOGGLE_SIDE = "right"

-- Cooldown between accepting pulses
-- Set to 0 to disable
-- Has to be a multiple of 0.1 (1 redstone tick)
TOGGLE_COOLDOWN = 1

-- All redstone states that can be toggled between
-- First layer is what gets switched between when TOGGLE_SIDE receives a pulse
-- Second layer is a list of {"side", value, beforeDelay, afterDelay} pairs (delays are optional, multiple of 0.1)
-- The example below is perfect for using two regular pistons pointing at each other to swap two blocks:
STATES = {
    {
        {"right", 0, nil, 0.1},
        {"left", 15}
    },
    {
        {"left", 0, nil, 0.1},
        {"right", 15}
    },
}

-- Whether the computer goes down the list of states (1) or up (-1)
-- Other values are also valid, though when wrapping around, the state will always be set to the first or last
STATE_INCREMENT = 1

-- Whether to save the state between reboots, MP server restarts, SP world rejoins, etc.
PERSIST_STATE = true

-- Whether to add a delay between receiving the pulse and toggling the state
-- Set to 0 to disable
STATE_TOGGLE_DELAY = 0

-- Which number state in the STATES list the computer starts with
INITIAL_STATE_INDEX = 1

-- The initial signal to set on all sides when the computer starts (0-15)
INITIAL_SIGNAL = 0




-- Do not edit below or cobuder gets angry >:(




-- #region loop

-- current state index, used when calling applyState()
local stateIdx = INITIAL_STATE_INDEX
local lastToggleTime = 0

function loop()
    local toggleState = redstone.getInput(TOGGLE_SIDE)
    local currentTime = os.clock()

    if toggleState and currentTime - lastToggleTime > TOGGLE_COOLDOWN then
        lastToggleTime = currentTime

        if STATE_TOGGLE_DELAY > 0 then
            sleep(STATE_TOGGLE_DELAY)
        end

        stateIdx = stateIdx + STATE_INCREMENT
        if stateIdx > #STATES then
            stateIdx = 1
        elseif stateIdx < 1 then
            stateIdx = #STATES
        end

        applyState()
        print("* Applied state " .. stateIdx)
    end
end

function applyState()
    for _, sideVal in ipairs(STATES[stateIdx]) do
        if sideVal[3] ~= nil and sideVal[3] > 0 then
            sleep(sideVal[3])
        end
        redstone.setAnalogOutput(sideVal[1], sideVal[2])
        if sideVal[4] ~= nil and sideVal[4] > 0 then
            sleep(sideVal[4])
        end
    end
    if PERSIST_STATE then
        settings.set("stateIdx", stateIdx)
        settings.save()
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

--#region run

function run()
    -- cause pastebin hates links
    print(b64dec("CnwgU3RhdGVUb2dnbGUgYnkgU3Y0NDMKfCBzdjQ0My5uZXQvci9jYy1wcm9qZWN0cwo="))

    for _, side in pairs({"left", "right", "top", "bottom", "front", "back"}) do
        redstone.setAnalogOutput(side, INITIAL_SIGNAL or 0)
    end

    stateIdx = settings.get("stateIdx") or INITIAL_STATE_INDEX
    applyState()
    print("* Applied initial state " .. stateIdx)

    while true do
        loop()
        sleep(0.1)
    end
end

run()
