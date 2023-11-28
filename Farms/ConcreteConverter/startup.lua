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



ORIENTATION_PATH = "/orientation.txt"
curOrient = 0

function run()
    print("\n| ConcreteConverter by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")

    correctOrientation()

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
        if itemDet ~= nil and itemDet.count > 0 then
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

-- Turns right or left
function turn(direction)
    local file = fs.open(ORIENTATION_PATH, "w")
    if direction == "right" then
        curOrient = curOrient + 1
        file.write(tostring(curOrient).."\n")
        file.close()
        turtle.turnRight()
    elseif direction == "left" then
        curOrient = curOrient - 1
        file.write(tostring(curOrient).."\n")
        file.close()
        turtle.turnLeft()
    end
end

-- Corrects the orientation on reboot
function correctOrientation()
    if not fs.exists(ORIENTATION_PATH) then
        local file = fs.open(ORIENTATION_PATH, "w")
        file.write("0\n")
        file.close()
    end
    local file = fs.open(ORIENTATION_PATH, "r")
    local correctOrient = tonumber(file.readLine())
    if correctOrient ~= 0 then
        if correctOrient > 0 then
            for t = 1, correctOrient do
                turtle.turnLeft()
            end
        else
            for t = 1, math.abs(correctOrient) do
                turtle.turnRight()
            end
        end
    end
    file.close()
end

-- Grabs new items from the first occupied slot in the input inventory
-- Returns true if items could be grabbed, false otherwise
function grabItems()
    local waiting = false
    turtle.select(1)
    for t = 1, math.abs(INPUT_TURNS) do
        if INPUT_TURNS > 0 then
            turn("right")
        else
            turn("left")
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
            turn("left")
        else
            turn("right")
        end
    end
    return result
end

-- Iterates over all slots, depositing items into the output inventory
function depositItems()
    turtle.select(1)
    for t = 1, math.abs(OUTPUT_TURNS) do
        if OUTPUT_TURNS > 0 then
            turn("right")
        else
            turn("left")
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
            turn("left")
        else
            turn("right")
        end
    end
end

run()
