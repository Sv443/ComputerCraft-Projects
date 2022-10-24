PORT = 123

local modem = peripheral.find("modem")

modem.open(PORT)

function run()
    while true do
        local val = os.day() * 100 + os.time()

        print("")
        print("--- NTP Server ---")
        print("Day:       " .. os.day())
        print("Time:      " .. textutils.formatTime(os.time()) .. " (" .. os.time() .. ")")
        print("Timestamp: " .. val)
        print("Port:      " .. PORT)

        modem.transmit(PORT, PORT, val)

        -- send every tick
        os.sleep(0.05)
    end
end

run()
