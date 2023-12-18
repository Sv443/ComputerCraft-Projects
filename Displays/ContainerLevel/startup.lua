-- Redstone signal input side
INPUT_SIDE = "left"

-- Update interval in seconds
-- Has to be a multiple of 0.05 (1 game tick)
UPDATE_INTERVAL = 0.5

-- Colors for the tank level display
-- The first value is the tank level in percent, above which the color (second value) is used
-- Has to be sorted in descending order
-- If you only want a single solid color, set the first entry to 0 and only it will be used
LEVEL_COLORS = {
    { 80, colors.red },
    { 50, colors.yellow },
    { 0,  colors.green },
}

-- Text that's displayed above the tank level
-- Can be 4 lines max, but up to 3 are recommended
-- When using 1 or 2 lines, they will be vertically centered
-- Use empty lines to offset the text
-- Whitespaces will use the FG color, missing characters will use the BG color
-- Each line can have 7 characters max
DISPLAY_TEXT = {
    " Water ",
    " Level ",
}
-- Background color of the text display
DISPLAY_TEXT_BG = colors.blue
-- Foreground (text) color of the text display
DISPLAY_TEXT_FG = colors.white

-- Default background color (behind the tank level bar)
DEFAULT_BG = colors.gray
-- Background color of the unfilled part of the tank level bar
UNFILLED_BAR_BG = colors.lightGray



-- DON'T EDIT BELOW THIS LINE --

local lastValue = nil

function updateDisplay()
    local monitor = peripheral.find("monitor")
    local value = redstone.getAnalogInput(INPUT_SIDE)
    if value ~= lastValue then
        -- #SECTION draw text
        lastValue = value

        monitor.setBackgroundColor(DEFAULT_BG)
        monitor.clear()
        monitor.setBackgroundColor(DISPLAY_TEXT_BG)
        monitor.setTextColor(DISPLAY_TEXT_FG)

        local yPos = 1
        monitor.setCursorPos(1, yPos)

        if tableLength(DISPLAY_TEXT) < 3 then
            monitor.write("       ")
            yPos = yPos + 1
            monitor.setCursorPos(1, yPos)
        end

        for _, line in pairs(DISPLAY_TEXT) do
            monitor.write(line)
            yPos = yPos + 1
            monitor.setCursorPos(1, yPos)
        end

        if tableLength(DISPLAY_TEXT) < 4 then
            monitor.write("       ")
            yPos = yPos + 1
            monitor.setCursorPos(1, yPos)
        end

        if tableLength(DISPLAY_TEXT) < 2 then
            monitor.write("       ")
            yPos = yPos + 1
            monitor.setCursorPos(1, yPos)
        end

        local level = math.floor(redstoneToPercent(value))
        local spaces = level < 10 and "  " or level < 100 and " " or ""
        local percText = " "..spaces..level.." % "
        monitor.setCursorPos(1, 5)
        monitor.write(percText)

        monitor.setCursorPos(1, 6)
        monitor.write("       ")

        -- #SECTION draw level bar

        local barHeight = math.floor(value * (12 / 15))
        local barColor = colors.black
        for i, colData in ipairs(LEVEL_COLORS) do
            local percent, col = colData[1], colData[2]
            if level >= percent then
                barColor = col
                break
            end
        end

        local filledIdx = 1
        for i = 19, 8, -1 do
            if filledIdx > barHeight then
                monitor.setBackgroundColor(UNFILLED_BAR_BG)
            else
                monitor.setBackgroundColor(barColor)
            end
            monitor.setCursorPos(2, i)
            monitor.write("     ")
            filledIdx = filledIdx + 1
        end
    end
end

-- Converts a 0-15 redstone signal to a 0-100 percent value
-- Magnitude is the number of decimal places, as a power of 10
-- (1 = 1 decimal place, 10 = 2 decimal places, 100 = 3 decimal places, etc.)
function redstoneToPercent(value, magnitude)
    if magnitude == nil then magnitude = 1 end
    return math.floor(value * (100 / 15) * magnitude) / magnitude
end

function tableLength(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

function run()
    print("\n| Tank Level Display by Sv443")
    print("| https://github.com/Sv443/ComputerCraft-Projects\n")
    while true do
        updateDisplay()
        os.sleep(UPDATE_INTERVAL)
    end
end

run()
