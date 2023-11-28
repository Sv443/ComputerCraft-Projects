-- How many times the turtle has to turn clockwise
-- until it faces the input inventory
-- Use negative numbers for counterclockwise turns
INPUT_TURNS = -1
-- How many times the turtle has to turn clockwise
-- until it faces the output inventory
-- Use negative numbers for counterclockwise turns
OUTPUT_TURNS = 1

-- Delay to wait after placing a block - nil for no delay
PLACE_DELAY = nil
-- Delay to wait after breaking a block - nil for no delay
BREAK_DELAY = nil




function run()
    print("\n| ConcreteConverter by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")
    local itemDet = turtle.getItemDetail(1)
    if itemDet ~= nil and itemDet.count > 0 then
        print("! Started with items in inventory!")
        print("! Automatically ejecting them...\n")
        depositItems()
    end
    while true do
        local itemDet = turtle.getItemDetail(1)
        if itemDet == nil then
            grabItems()
        end
        itemDet = turtle.getItemDetail(1)
        turtle.select(1)
        if itemDet ~= nil and itemDet.count > 1 then
            print("> Converting "..itemDet.count.." block"..(itemDet.count > 1 and "s" or ""))
        end
        for i = 1, itemDet.count do
            turtle.place()
            if PLACE_DELAY ~= nil then
                os.sleep(PLACE_DELAY)
            end
            turtle.dig()
            if BREAK_DELAY ~= nil then
                os.sleep(BREAK_DELAY)
            end
        end
        depositItems()
    end
end

-- Grabs new items from the first occupied slot in the input inventory
-- Returns true if items could be grabbed, false otherwise
function grabItems()
    local waiting = false
    turtle.select(1)
    for t = 1, math.abs(INPUT_TURNS) do
        if INPUT_TURNS > 0 then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
    end
    while not turtle.suck() do
        if not waiting then
            print("* Waiting for blocks...")
            waiting = true
        end
        os.sleep(0.5)
    end
    for t = 1, math.abs(INPUT_TURNS) do
        if INPUT_TURNS > 0 then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
    end
    return result
end

-- Iterates over all slots, depositing items into the output inventory
function depositItems()
    turtle.select(1)
    for t = 1, math.abs(OUTPUT_TURNS) do
        if OUTPUT_TURNS > 0 then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
    end
    for i = 1, 16 do
        local itemDet = turtle.getItemDetail(i)
        if itemDet == nil or itemDet.count == 0 then
            break
        end
        turtle.select(i)
        turtle.drop()
    end
    for t = 1, math.abs(OUTPUT_TURNS) do
        if OUTPUT_TURNS > 0 then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
    end
end

run()
