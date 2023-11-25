-- Interval in seconds between each check
-- Has to be a multiple of 0.05 (1 game tick / 0.5 redstone ticks)
CHECK_INTERVAL = 1

-- Which side the redstone signal comes from that should activate the reactor
SET_INPUT_SIDE = "bottom"
-- Whether the redstone signal should be active high or active low (inverted)
SET_ACTIVE_HIGH = false

-- Which side the redstone signal comes from that should deactivate the reactor
RESET_INPUT_SIDE = "left"
-- Whether the redstone signal should be active high or active low (inverted)
RESET_ACTIVE_HIGH = false

-- Which side the output signal should be sent to
OUTPUT_SIDE = "right"



-- DO NOT EDIT OR REACTOR GETS ANGY >:(
prevState = nil
state = false

function check()
    local set = redstone.getInput(SET_INPUT_SIDE)
    local reset = redstone.getInput(RESET_INPUT_SIDE)

    local setEn = ((set and SET_ACTIVE_HIGH) or (not set and not SET_ACTIVE_HIGH))
    local resetEn = ((reset and RESET_ACTIVE_HIGH) or (not reset and not RESET_ACTIVE_HIGH))

    -- print("state: "..tostring(state).." set: "..tostring(setEn).." reset: "..tostring(resetEn))

    if not state and setEn then
        state = true
        os.sleep(1)
    elseif state and resetEn then
        state = false
        os.sleep(1)
    end

    if state ~= prevState then
        print(">> "..(state and "Enabling" or "Disabling").." reactor")
        redstone.setOutput(OUTPUT_SIDE, state)
        prevState = state
    end

    os.sleep(CHECK_INTERVAL)
end

print("\n| ReactorControl by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")
while true do
    check()
end
