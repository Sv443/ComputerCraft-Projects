-- Traffic Light (Exit) by Sv443
-- https://re.sv443.net/cc-projects


-- CONFIGURATION:

-- Interval (in seconds) to check for incoming rednet messages (multiple of 0.05)
CHECK_INTERVAL = 0.05

-- Protocol identifier to use for rednet communication
-- Only needs to be edited on a network shared with other rednet programs
REDNET_PROTOCOL = "TL"

-- Set to true to enable debug messages
DEBUG = true


-- DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING

-- Constants for settings keys
SETTINGS = {
    DIRECTION_INDEX = "intersection.direction_index",
    SIDE_RED = "output.side_red",
    SIDE_YELLOW = "output.side_yellow",
    SIDE_GREEN = "output.side_green",
    ACTIVE_HIGH = "output.active_high",
}


-- #region showInitialPrompts()

function showInitialPrompts()
    print(">> Initial Setup for Traffic Light Exit:\n")

    -- Direction index
    local directionIndex = tonumber(read("\nEnter the direction index for this exit (1-3 or 1-4) [default: 1]: ") or "1")
    if directionIndex < 1 or directionIndex > 4 then
        print("! Invalid input, exiting. Reboot to try again.")
        return false
    end
    settings.set(SETTINGS.DIRECTION_INDEX, directionIndex)

    -- Side for red signal
    local sideRed = read("\nEnter the side the RED signal is connected to [default: left]: ") or "left"
    settings.set(SETTINGS.SIDE_RED, sideRed)

    -- Side for yellow signal
    local sideYellow = read("\nEnter the side the YELLOW signal is connected to [default: top]: ") or "top"
    settings.set(SETTINGS.SIDE_YELLOW, sideYellow)

    -- Side for green signal
    local sideGreen = read("\nEnter the side the GREEN signal is connected to [default: right]: ") or "right"
    settings.set(SETTINGS.SIDE_GREEN, sideGreen)

    -- Active high or low
    local activeHighInput = read("\nShould the lights be ACTIVE on HIGH signal (15) and INACTIVE on LOW (0)? (y/n) [default: y]: ") or "y"
    local activeHigh = (activeHighInput:lower() == "y")
    settings.set(SETTINGS.ACTIVE_HIGH, activeHigh)

    print("\n>> Initial setup complete. To re-run initial setup, run the command 'rm /.settings' and restart the computer.")
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

    settings.define("intersection.direction_index", {
        description = "The direction index of this exit (1-3 or 1-4)",
        default = 1,
        type = "number",
    })
    settings.define("output.side_red", {
        description = "The side the red signal is connected to",
        default = "left",
        type = "string",
    })
    settings.define("output.side_yellow", {
        description = "The side the yellow signal is connected to",
        default = "top",
        type = "string",
    })
    settings.define("output.side_green", {
        description = "The side the green signal is connected to",
        default = "right",
        type = "string",
    })
    settings.define("output.active_high", {
        description = "Whether the lights are active on a high redstone signal (15) and inactive on low (0)",
        default = true,
        type = "boolean",
    })

    if isFirstRun then
        showInitialPrompts()
    else
        print(">> Settings loaded. To re-run initial setup, run the command 'rm /.settings' and restart the computer.")
    end
end


-- #region parseMessage()

-- parses the message in the format `directionIndex:signalStrengthRed,signalStrengthYellow,signalStrengthGreen`
function parseMessage(message)
    local directionIndexStr, signalsStr = message:match("^(%d+):([%d,]+)$")
    if not directionIndexStr or not signalsStr then
        return nil
    end

    local directionIndex = tonumber(directionIndexStr)
    local redStr, yellowStr, greenStr = signalsStr:match("^(%d+),(%d+),(%d+)$")
    if not redStr or not yellowStr or not greenStr then
        return nil
    end

    local red = tonumber(redStr)
    local yellow = tonumber(yellowStr)
    local green = tonumber(greenStr)

    return {
        direction = directionIndex,
        red = red,
        yellow = yellow,
        green = green,
    }
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
    print(b64dec("fCBUcmFmZmljIExpZ2h0IEV4aXQgYnkgU3Y0NDMKfCBodHRwczovL3JlLnN2NDQzLm5ldC9jYy1wcm9qZWN0cwo="))

    -- initial state (red)
    redstone.setAnalogOutput(settings.get(SETTINGS.SIDE_RED), 15)
    redstone.setAnalogOutput(settings.get(SETTINGS.SIDE_YELLOW), 0)
    redstone.setAnalogOutput(settings.get(SETTINGS.SIDE_GREEN), 0)

    initialSetup()

    while true do
        local _id, message = rednet.receive("TL")

        if message ~= nil then
            local parsed = parseSignalStrengths(message)

            if parsed ~= nil and direction == parsed.direction then
                redstone.setAnalogOutput(settings.get(SETTINGS.SIDE_RED), parsed.red)
                redstone.setAnalogOutput(settings.get(SETTINGS.SIDE_YELLOW), parsed.yellow)
                redstone.setAnalogOutput(settings.get(SETTINGS.SIDE_GREEN), parsed.green)

                if DEBUG then print(("Set signals to R:%d Y:%d G:%d"):format(parsed.red, parsed.yellow, parsed.green)) end
            end
        end

        os.sleep(CHECK_INTERVAL)
    end
end

run()
