-- maximum forward position, 1-indexed
-- this is the width of the farm + 1, starting from the front side of the turtle, including the refuel station
DISTANCE_X = 13
-- maximum right position, 1-indexed
-- this is the length of the farm, starting from the right side of the turtle, including the refuel station
DISTANCE_Y = 9
-- turtle refuels until it reaches this level
-- 1 item smelted equals 10 fuel points; this means coal = 80 fuel points
TARGET_FUEL_LEVEL = 500
-- delay between harvest cycles in seconds, has to be a multiple of 0.05 (1 game tick)
DELAY_BETWEEN_HARVESTS = 60



-- DO NOT EDIT OR TURTLE GETS ANGY >:(
xPos = 1
yPos = 1
cyclesCompleted = 0
totalItems = 0

-- #SECTION refuel

-- grab fuel from inventory below, to fill first slot to 64
function grabFuel()
    turtle.select(1)
    local itemDet = turtle.getItemDetail(1)
    local fuelNeeded = 64
    if itemDet ~= nil then
        fuelNeeded = 64 - itemDet.count
    end
    if fuelNeeded > 0 then
        turtle.suckDown(fuelNeeded)
        print("* Restocked "..tostring(fuelNeeded).." fuel item"..(fuelNeeded == 1 and "" or "s"))
    end
end

-- refuel until target fuel level is reached
function refuel()
    grabFuel()
    local itemDet = turtle.getItemDetail(1)
    while itemDet == nil do
        print("! Waiting for fuel...")
        os.sleep(1)
        grabFuel()
        itemDet = turtle.getItemDetail(1)
    end
    while turtle.getFuelLevel() < TARGET_FUEL_LEVEL do
        turtle.refuel(1)
        local itemDet = turtle.getItemDetail(1)
        if itemDet ~= nil then
            if itemDet.count < 5 then
                grabFuel()
            end
        else
            print("! Waiting for fuel...")
            os.sleep(1)
            grabFuel()
            itemDet = turtle.getItemDetail(1)
        end
    end
    grabFuel()
end

-- move from item dropoff to refuel station
function moveRefuel()
    turtle.forward()
    yPos = yPos - 1
    turtle.turnRight()
end

-- #SECTION drop items

-- drops off all items into inventory below
function dropItems()
    local curSlot = 2
    local itemsAmt = 0;
    local slotDetail = turtle.getItemDetail(curSlot)
    while slotDetail ~= nil do
        turtle.select(curSlot)
        turtle.dropDown()
        itemsAmt = itemsAmt + slotDetail.count
        curSlot = curSlot + 1
        slotDetail = turtle.getItemDetail(curSlot)
    end
    turtle.select(1)
    print("* Dropped off "..tostring(itemsAmt).." item"..(itemsAmt == 1 and "" or "s"))
    totalItems = totalItems + itemsAmt
end

-- returns to the dropoff inventory after the harvest cycle is complete
function returnToDropoff()
    print("* Done harvesting, returning to dropoff")
    turtle.turnRight()
    turtle.turnRight()
    for x=1, DISTANCE_X - 1, 1 do
        turtle.forward()
        xPos = xPos - 1
    end
    turtle.turnRight()
    for y=1, DISTANCE_Y - 2, 1 do
        turtle.forward()
        yPos = yPos - 1
    end
    turtle.down()
end

-- #SECTION harvest

-- runs through the entire harvesting cycle, starting from the refuel station and ending up on the dropoff station
function harvest()
    turtle.up()
    turtle.forward()
    xPos = xPos + 1

    local turnCycle = 1
    local xDir = 1

    for y=1, DISTANCE_Y, 1 do
        for x=1, DISTANCE_X - 2, 1 do
            turtle.dig()
            turtle.digDown()
            turtle.forward()
            xPos = xPos + xDir
        end
        if yPos == DISTANCE_Y then
            turtle.digDown()
            returnToDropoff()
            return
        end
        if turnCycle == 1 then
            xPos = xPos + 1
            turtle.turnRight()
            turtle.dig()
            turtle.digDown()
            turtle.forward()
            turtle.turnRight()
            turtle.dig()
            turtle.digDown()
            turnCycle = 2
            xDir = -1
        else
            xPos = xPos - 1
            turtle.turnLeft()
            turtle.dig()
            turtle.digDown()
            turtle.forward()
            turtle.turnLeft()
            turtle.dig()
            turtle.digDown()
            turnCycle = 1
            xDir = 1
        end
        yPos = yPos + 1
    end

    turtle.down()
end

-- #SECTION run

function printStatus()
    print("")
    print("-> Turtle status:")
    print("   Fuel level: "..tostring(turtle.getFuelLevel()).." / "..tostring(TARGET_FUEL_LEVEL))
    print("   Harvest cycles completed: "..tostring(cyclesCompleted))
    print("   Total items dropped off: "..tostring(totalItems))
    print("")
end

function run()
    print("\n| SugarcaneFarm by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")
    os.sleep(2)
    if TARGET_FUEL_LEVEL < 250 then
        print("WARNING: TARGET_FUEL_LEVEL is set very low, this may cause the turtle to get stuck.")
        print("Please set the value to at least 250, but ideally 500 or more.")
        os.sleep(5)
        return
    end
    while true do
        print("")
        xPos = 1
        yPos = 1
        refuel()
        print("* Starting harvest cycle #"..tostring(cyclesCompleted + 1))
        harvest()
        dropItems()
        moveRefuel()
        cyclesCompleted = cyclesCompleted + 1
        printStatus()
        print("* Waiting "..tostring(DELAY_BETWEEN_HARVESTS).." seconds until next harvest")
        os.sleep(DELAY_BETWEEN_HARVESTS)
    end
end

run()
