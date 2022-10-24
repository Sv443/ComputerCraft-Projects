TIME_FORMAT_24H = true

local mon = peripheral.find("monitor")
local modem = peripheral.find("modem")

modem.open(123)

WEEK_DAYS = {
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
}

function update(ts)
    mon.clear()
    mon.setTextScale(2)

    local day = math.floor(ts / 100)
    local time = ts - day * 100
    local timeFmt = textutils.formatTime(time, TIME_FORMAT_24H)

    local weekDay = day % 7
    local dayOfWeek = WEEK_DAYS[weekDay + 1]

    if time < 5.5 or time >= 18 then
        mon.setBackgroundColor(colors.blue)
        mon.setTextColor(colors.white)
    else
        mon.setBackgroundColor(colors.yellow)
        mon.setTextColor(colors.black)
    end

    local timeOffset = 4

    if TIME_FORMAT_24H then
        timeOffset = 5
    end

    mon.setCursorPos(timeOffset, 1)
    mon.write(timeFmt)

    mon.setCursorPos(1, 2)
    mon.write(dayOfWeek .. ", day " .. day)
end

while true do
    local ev, x, y, z, msg = os.pullEvent("modem_message")

    if msg ~= nil then
        local ts = msg + 0.0
        update(ts)
    end
    os.sleep(0.1)
end
