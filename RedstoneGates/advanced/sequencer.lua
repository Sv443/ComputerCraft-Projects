-- Sequence of signals to emit
-- Items are in the format {side, duration}
--   Duration is in seconds and has to be a multiple of 0.1 (1 redstone tick)
-- If side is set to nil, it will be treated as a pause
-- If side is a table of sides, all given sides will be enabled
-- 
-- For example: The following sequence will turn the right side on for 5 redstone ticks,
--   pause for 10, turn the left *and* right side on for 5, pause for 10, and repeat:
SEQUENCE = {
    { "top", 0.5 },
    { nil, 1 },
    { { "left", "right" }, 0.5 },
    { nil, 1 },
}

-- If this is set to a side, a redstone signal there will be required to enable the sequence
-- If set to nil, the sequence will run immediately and continuously
-- If a sequence is already running, it will finish first before checking for a new signal
ENABLE_SIDE = "front"
-- If set to true, the sequence will only be run once until the
-- enable signal is toggled off and back on again
ENABLE_ONCE = false

-- Set to false to invert the output signals
-- Before the very first sequence has finished, the initial output state will
-- be low (off) no matter this setting, but afterwards the signal will be remembered
-- even after a reboot
OUTPUT_ACTIVE_HIGH = true

-- Delay before starting the program *for the very first time* after a reboot
-- This is useful for SP world rejoins or MP server restarts as the
-- program will start before the enable signal can be read properly
-- Set to nil to disable
STARTUP_DELAY = 1


local lastEnabled = false
local prevEnabled = nil

function run()
    print("\n| Sequencer by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")
    if STARTUP_DELAY ~= nil then
        os.sleep(STARTUP_DELAY)
    end
    while true do
        local enabled = ENABLE_SIDE == nil and true or redstone.getInput(ENABLE_SIDE)
        if prevEnabled == nil then
            prevEnabled = enabled
        end
        if enabled ~= prevEnabled then
            print("> "..(enabled and "Enabled" or "Disabled") .. " sequencer")
            prevEnabled = enabled
        end
        if not enabled and lastEnabled then
            lastEnabled = false
        end
        if ENABLE_SIDE == nil or enabled then
            if not lastEnabled then
                if ENABLE_ONCE then
                    lastEnabled = true
                end
                for _, item in pairs(SEQUENCE) do
                    if item[1] ~= nil then
                        if type(item[1]) == "table" then
                            for _, side in pairs(item[1]) do
                                redstone.setOutput(side, OUTPUT_ACTIVE_HIGH)
                            end
                        else
                            redstone.setOutput(item[1], OUTPUT_ACTIVE_HIGH)
                        end
                    end
                    os.sleep(item[2])
                    if item[1] ~= nil then
                        if type(item[1]) == "table" then
                            for _, side in pairs(item[1]) do
                                redstone.setOutput(side, not OUTPUT_ACTIVE_HIGH)
                            end
                        else
                            redstone.setOutput(item[1], not OUTPUT_ACTIVE_HIGH)
                        end
                    end
                end
            end
        else
            os.sleep(0.05)
        end
    end
end

run()
