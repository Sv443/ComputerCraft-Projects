-- Redstone input side
INPUT = "left"

-- Redstone output side
OUTPUT = "back"

-- How often to check for changes, in seconds
-- Has to be a multiple of 0.05 (1 game tick)
CHECK_INTERVAL = 0.05

function run()
    print("\n| NOT gate by Sv443")
    print("| https://github.com/Sv443/ComputerCraft-Projects\n")
    local outVal
    while true do
        local a = redstone.getInput(INPUT)

        if a then
            outVal = false
        else
            outVal = true
        end

        redstone.setOutput(OUTPUT, outVal)
        os.sleep(CHECK_INTERVAL)
    end
end

run()
