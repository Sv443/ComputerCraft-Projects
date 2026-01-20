
-- Traffic Light Controller by Sv443
-- https://re.sv443.net/cc-projects


-- CONFIGURATION:

-- Protocol identifier to use for rednet communication
-- Only needs to be edited on a network shared with other rednet programs
REDNET_PROTOCOL = "TL"

-- Where to store stats on the computer
STATS_FILE_PATH = "stats.txt"

-- Set to true to enable debug messages
DEBUG = true



-- DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING

-- Interval in seconds to check for phase changes (should be a multiple of 0.1)
CHECK_INTERVAL = 0.2 -- every 2 redstone ticks

-- Constants for settings keys
SETTINGS = {
    DIRECTIONS = "intersection.directions",
    DURATION_GREEN = "phase.duration_green",
    DURATION_YELLOW = "phase.duration_yellow",
    DRUATION_GRACE = "phase.duration_grace",
    HEADS_UP = "phase.red_and_yellow_heads_up",
}

-- Definition of traffic light phases when using red+yellow heads up
PHASES_HEADS_UP = {
    [1] = { 15, 0, 0 },   -- Red
    [2] = { 15, 15, 0 },  -- Red + Yellow
    [3] = { 0, 0, 15 },   -- Green
    [4] = { 0, 15, 0 },   -- Yellow
}

-- Definition of traffic light phases when NOT using red+yellow heads up
PHASES_NO_HEADS_UP = {
    [1] = { 15, 0, 0 },   -- Red
    [2] = { 0, 15, 0 },   -- Yellow
    [3] = { 0, 0, 15 },   -- Green
    [4] = { 0, 15, 0 },   -- Yellow
}

-- note: phases above need to line up since they share the same duration per index
-- red is always 1, yellow is always 2 and 4, green is always 3

peripheral.find("modem", rednet.open) -- open connection on any side


-- #region showInitialPrompts()

function showInitialPrompts()
    print(">> Initial Setup for Traffic Light Controller:\n")

    -- Intersection directions
    local directions = tonumber(read("\nEnter amount of intersection directions (3 or 4) [default: 4]: ") or "4")
    if directions ~= 3 and directions ~= 4 then
        directions = 4
        print("! Invalid input, defaulting to 4 directions. Hold Ctrl+T to stop and re-run for different settings.")
    end
    settings.set(SETTINGS.DIRECTIONS, directions)

    -- Phase durations
    local yellow_duration = tonumber(read("\nEnter yellow light duration in seconds (multiple of 0.1) [default: 1.5]: ") or "1.5")
    if yellow_duration < 0.1 then
        yellow_duration = 1.5
        print("! Invalid input, defaulting to 1.5 seconds. Hold Ctrl+T to stop and re-run for different settings.")
    end
    settings.set(SETTINGS.DURATION_YELLOW, yellow_duration)

    local green_duration = tonumber(read("\nEnter green light duration in seconds (multiple of 0.1) [default: 20]: ") or "20")
    if green_duration < 0.1 then
        green_duration = 20
        print("! Invalid input, defaulting to 20 seconds. Hold Ctrl+T to stop and re-run for different settings.")
    end
    settings.set(SETTINGS.DURATION_GREEN, green_duration)

    -- Red and yellow heads up
    local heads_up_input = read("\nEnable red and yellow lights simultaneously as a heads-up before green? (y/n) [default: y]: ") or "y"
    if heads_up_input:lower() ~= "y" and heads_up_input:lower() ~= "n" then
        heads_up_input = "y"
        print("! Invalid input, defaulting to 'y'. Hold Ctrl+T to stop and re-run for different settings.")
    end
    local heads_up = (heads_up_input:lower() == "y")
    settings.set(SETTINGS.HEADS_UP, heads_up)

    -- Grace period between direction switches
    local grace_duration = tonumber(read("\nEnter grace period duration in seconds between direction switches (multiple of 0.1) [default: 0]: ") or "0")
    if grace_duration < 0 then
        grace_duration = 1.5
        print("! Invalid input, defaulting to 1.5 seconds. Hold Ctrl+T to stop and re-run for different settings.")
    end
    settings.set(SETTINGS.DRUATION_GRACE, grace_duration)

    -- Redstone output sides
    local output_sides = read("\nEnter redstone output sides for red,yellow,green lights (format: red,yellow,green) [default: left,top,right]: ") or "left,top,right"
    if not output_sides:match("^(top|bottom|left|right|front|back),(top|bottom|left|right|front|back),(top|bottom|left|right|front|back)$") then
        output_sides = "left,top,right"
        print("! Invalid input, defaulting to 'left,top,right'. Hold Ctrl+T to stop and re-run for different settings.")
    end
    settings.set(SETTINGS.OUTPUT_SIDES, output_sides)

    print("\n>> Initial setup complete. Settings have been saved.")
    read("Press Enter to continue...")
end


-- #region initialSetup()

function initialSetup()
    local isFirstRun = settings.get("__init") == nil

    settings.define("__init", {
        description = "Can be ignored",
        default = true,
        type = "boolean",
    })

    settings.define("intersection.directions", {
        description = "Amount of different directions at the intersection (3 or 4)",
        default = 4,
        type = "number",
    })
    settings.define("phase.duration_green", {
        description = "Duration of green light phase in seconds (multiple of 0.1)",
        default = 20,
        type = "number",
    })
    settings.define("phase.duration_yellow", {
        description = "Duration of yellow light phase in seconds (multiple of 0.1)",
        default = 1.5,
        type = "number",
    })
    settings.define("phase.red_and_yellow_heads_up", {
        description = "Enable red and yellow lights simultaneously before green",
        default = true,
        type = "boolean",
    })
    settings.define("phase.duration_grace", {
        description = "Duration of grace period between direction switches in seconds (multiple of 0.1)",
        default = 0,
        type = "number",
    })

    if isFirstRun then
        showInitialPrompts()
    else
        print(">> Settings loaded. To re-run initial setup, run the command 'rm /.settings' and restart the computer.")
    end
end


-- #region recordStats()

-- Call each full cycle to record stats
function recordStats()
    local stats = {
        completed_cycles = 0
    }

    -- read existing stats
    if fs.exists(STATS_FILE_PATH) then
        local file = fs.open(STATS_FILE_PATH, "r")
        local content = file.readAll()
        file.close()
        for line in content:gmatch("[^\r\n]+") do
            local key, value = line:match("^(%w+)=(%d+)$")
            if key and value then
                stats[key] = tonumber(value)
            end
        end
    end

    stats.completed_cycles = (stats.completed_cycles or 0) + 1

    -- write new stats to file
    local file = fs.open(STATS_FILE_PATH, "w")
    for key, value in pairs(stats) do
        file.writeLine(key .. "=" .. tostring(value))
    end
    file.close()

    if DEBUG then print(("Recorded stats: completed_cycles=%d"):format(stats.completed_cycles)) end
end


-- #region sendStatePacket()

-- Sends the given phase state to the given output computer ID via rednet
function sendStatePacket(directionIndex, phaseIndex)
    local phases = settings.get(SETTINGS.HEADS_UP) and PHASES_HEADS_UP or PHASES_NO_HEADS_UP
    local phase = phases[phaseIndex]

    rednet.broadcast(("%d:%d,%d,%d"):format(directionIndex, phase[1], phase[2], phase[3]), REDNET_PROTOCOL)

    if DEBUG then print(("Sent state packet for direction %d, phase %d"):format(directionIndex, phaseIndex)) end
end


-- #region getIter()

-- Returns the index of when to perform an action based on the current iteration tick (continuous) and given timeout in seconds
function getIter(curIterTick, timeout)
    local intervalTicks = math.floor(timeout / CHECK_INTERVAL)
    if intervalTicks <= 0 then intervalTicks = 1 end

    return (curIterTick % intervalTicks) == 0
end


-- #region cycleLights()

local curDirection = 1
local curPhase = 1

function cycleLights(iter)
    local directions = settings.get(SETTINGS.DIRECTIONS)
    local greenDuration = settings.get(SETTINGS.DURATION_GREEN)
    local yellowDuration = settings.get(SETTINGS.DURATION_YELLOW)
    local graceDuration = settings.get(SETTINGS.DRUATION_GRACE)

    -- TODO:
    -- 1. loop over directions and phases
    -- 2. non-blocking pause using getIter() before continuing iteration
    -- 3. sendStatePacket() on phase change
    -- 4. recordStats() on full cycle completion
end


-- #region b64dec()

-- decodes a base64-encoded string
function b64dec(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = string.gsub(data, "[^"..b.."=]", "")
 
    return (
        data:gsub(".", function(x)
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
        end)
    )
end


-- #region run()

function run()
    -- pastebin hates my domain and I hate pastebin
    print(b64dec("fCBUcmFmZmljIExpZ2h0IENvbnRyb2xsZXIgYnkgU3Y0NDMKfCBodHRwczovL3JlLnN2NDQzLm5ldC9jYy1wcm9qZWN0cwo="))

    initialSetup()

    local i = 1
    while true do
        cycleLights(i)
        i = i + 1
        os.sleep(CHECK_INTERVAL)
    end
end

run()
