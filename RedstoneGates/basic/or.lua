-- Redstone input sides
INPUT_A = "left"
INPUT_B = "right"

-- Redstone output side
OUTPUT = "back"

-- Set to true to turn this OR gate into a NOR gate
OUTPUT_INVERTED = false

-- How often to check for changes, in seconds
-- Has to be a multiple of 0.05 (1 game tick)
CHECK_INTERVAL = 0.05

function run()
    print("\n| OR / NOR gate by Sv443")
    print("| https://github.com/Sv443/ComputerCraft-Projects\n")
    local outVal
    while true do
        local a = redstone.getInput(INPUT_A)
        local b = redstone.getInput(INPUT_B)

        if a or b then
            outVal = not OUTPUT_INVERTED
        else
            outVal = OUTPUT_INVERTED
        end

        redstone.setOutput(OUTPUT, outVal)
        os.sleep(CHECK_INTERVAL)
    end
end

run()
