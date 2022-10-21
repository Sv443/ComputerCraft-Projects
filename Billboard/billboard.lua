-- in seconds - how often to update display & switch colors
UPDATE_INTERVAL = 2
-- side of the PC that touches the monitor
MONITOR_SIDE = "right"

-- TODO: make this a table - nil = empty line & transparent bg
-- LINES = { nil, "line1", "line2", nil }

-- 14 character limit per line with TEXT_SCALE = 3 and monitor width = 4 blocks
LINE_1 = "Hello, I'm un-"
LINE_2 = "der the water "

-- text size, has to be a multiple of 0.5
TEXT_SCALE = 3
-- horizontal starting position of text
TEXT_X_POS = 1
-- text color
TEXT_COLOR = colors.gray
-- color of background of text lines, set to nil to also cycle this color
TEXT_BG_COLOR = colors.white

-- background colors to cycle through
BG_COLORS = {
    colors.orange,
    colors.red,
    colors.purple,
    colors.blue,
    colors.cyan,
    colors.green,
    colors.lime,
    colors.yellow
}

bgcIdx = 1

-- updates the monitor
function update(monitor)
    local bgCol = BG_COLORS[bgcIdx]
    bgcIdx = bgcIdx + 1

    if bgcIdx > tableLength(BG_COLORS) then
        bgcIdx = 1
    end

    monitor.clear()
    monitor.setTextScale(TEXT_SCALE)
    monitor.setCursorPos(TEXT_X_POS, 2)
    monitor.setBackgroundColor(bgCol)

    monitor.setTextColor(TEXT_COLOR)
    if TEXT_BG_COLOR ~= nil then
        monitor.setBackgroundColor(TEXT_BG_COLOR)
    end

    monitor.write(LINE_1)
    monitor.setBackgroundColor(bgCol)

    monitor.setTextColor(TEXT_COLOR)
    if TEXT_BG_COLOR ~= nil then
        monitor.setBackgroundColor(TEXT_BG_COLOR)
    end

    monitor.setCursorPos(TEXT_X_POS, 3)
    monitor.write(LINE_2)
    monitor.setBackgroundColor(bgCol)
end

-- returns the length of a table
function tableLength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- main program loop
function run()
    local monitor = peripheral.wrap(MONITOR_SIDE)

    while true do
        update(monitor)
        os.sleep(UPDATE_INTERVAL)
    end
end

run()
