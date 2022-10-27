INPUT = "left"

OUTPUT = "right"

INTERVAL = 0.05

function run()
    local outVal
    while true do
        local a = redstone.getInput(INPUT)

        if a then
            outVal = false
        else
            outVal = true
        end

        redstone.setOutput(OUTPUT, outVal)
        os.sleep(INTERVAL)
    end
end

run()
