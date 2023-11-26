-- Interval in seconds between each check
-- Has to be a multiple of 0.05 (1 game tick / 0.5 redstone ticks)
CHECK_INTERVAL = 0.05
-- Delay to wait after a change in output state (in seconds, has to be a multiple of 0.05)
-- While the delay is active, any inputs will be ignored
-- Set to nil to disable
POST_CHANGE_DELAY = 5

-- Which side the redstone signal comes from that should activate the S/R latch
SET_INPUT_SIDE = "left"
-- Whether the redstone signal should be active high or active low (inverted)
SET_ACTIVE_HIGH = true

-- Which side the redstone signal comes from that should deactivate the S/R latch
RESET_INPUT_SIDE = "back"
-- Whether the redstone signal should be active high or active low (inverted)
RESET_ACTIVE_HIGH = true

-- Which side the output signal should be sent to
OUTPUT_SIDE = "right"
-- The initial state of the output
INITIAL_STATE = false



-- DO NOT EDIT OR S/R LATCH GETS ANGY >:(
prevState = nil
state = INITIAL_STATE

function check()
    local set = redstone.getInput(SET_INPUT_SIDE)
    local reset = redstone.getInput(RESET_INPUT_SIDE)

    local setEn = ((set and SET_ACTIVE_HIGH) or (not set and not SET_ACTIVE_HIGH))
    local resetEn = ((reset and RESET_ACTIVE_HIGH) or (not reset and not RESET_ACTIVE_HIGH))

    if not state and setEn then
        state = true
    elseif state and resetEn then
        state = false
    end

    if state ~= prevState then
        print(">> "..(state and "Enabling" or "Disabling"))
        redstone.setOutput(OUTPUT_SIDE, state)
        if POST_CHANGE_DELAY ~= nil and prevState ~= nil then
            print("   Delaying by "..tostring(POST_CHANGE_DELAY).." seconds...")
            os.sleep(POST_CHANGE_DELAY)
            print("   Delay over")
        end
        prevState = state
    end

    os.sleep(CHECK_INTERVAL)
end

print("\n| S/R Latch by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")
while true do
    check()
end
