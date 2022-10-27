INPUT_A = "left"
INPUT_B = "right"

OUTPUT = "back"

INTERVAL = 0.05

function run()
    local outVal
    while true do
        local a = redstone.getInput(INPUT_A)
        local b = redstone.getInput(INPUT_B)

        if a and b then
            outVal = true
        else
            outVal = false
        end

        redstone.setOutput(OUTPUT, outVal)
        os.sleep(INTERVAL)
    end
end

run()
