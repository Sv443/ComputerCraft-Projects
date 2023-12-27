-- Redstone signal input side
INPUT_SIDE = "left"
-- Redstone signal output side
OUTPUT_SIDE = "right"

-- Delay in seconds when going from low to high
-- Has to be a multiple of 0.05 (1 game tick)
-- 0 or nil to instantly go high
HIGH_DELAY = 2
-- Delay in seconds when going from high to low
-- Has to be a multiple of 0.05 (1 game tick)
-- 0 or nil to instantly go low
LOW_DELAY = 0

-- Set to false to invert the output signal
OUTPUT_ACTIVE_HIGH = true

-- Initial state of the input signal
-- true = high, false = low
INITIAL_STATE = false

-- Checking interval in seconds
-- Has to be a multiple of 0.05 (1 game tick)
CHECK_INTERVAL = 0.05

function run()
    local prevState = INITIAL_STATE
    print("\n| Delayer by Sv443")
    print("| https://github.com/Sv443/ComputerCraft-Projects\n")

    while true do
        state = redstone.getInput(INPUT_SIDE)
        if state ~= prevState then
            prevState = state

            if state then
                print("> State changed to HIGH, delaying "..tostring(HIGH_DELAY or 0).."s")
                if HIGH_DELAY ~= nil then
                    os.sleep(HIGH_DELAY)
                end
                redstone.setOutput(OUTPUT_SIDE, OUTPUT_ACTIVE_HIGH)
            else
                print("> State changed to LOW, delaying "..tostring(LOW_DELAY or 0).."s")
                if LOW_DELAY ~= nil then
                    os.sleep(LOW_DELAY)
                end
                redstone.setOutput(OUTPUT_SIDE, not OUTPUT_ACTIVE_HIGH)
            end
        end

        os.sleep(CHECK_INTERVAL)
    end
end

run()
