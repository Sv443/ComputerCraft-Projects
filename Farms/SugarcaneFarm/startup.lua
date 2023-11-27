-- Maximum forward position, 1-indexed
-- This is the width of the farm + 1, starting from the front side of the turtle, including the refuel station
DISTANCE_X = 13
-- Maximum right position, 1-indexed
-- This is the length of the farm, starting from the right side of the turtle, including the refuel station
DISTANCE_Y = 9

-- turtle refuels until it reaches this level
-- 1 item smelted equals 10 fuel points; this means coal = 80 fuel points
TARGET_FUEL_LEVEL = 500

-- Delay between harvest cycles in seconds, has to be a multiple of 0.05 (1 game tick)
DELAY_BETWEEN_HARVESTS = 60

-- Path back to the home position using GPS after a reboot?
-- This requires an ender modem and a GPS tower to be present and in loaded chunks
-- This feature is useful for singleplayer or if a multiplayer server restarts often
-- as the turtle will just stop in the middle of a harvest cycle and not know where it is anymore
-- To reset the home position, run 'rm home_coords.txt' then 'reboot'
USE_GPS_HOME = true
-- How many blocks to move upwards while returning to the home position
-- so the turtle doesn't run into anything - 0 to disable
GPS_SAFETY_HEIGHT = 2



-- DO NOT EDIT OR TURTLE GETS ANGY >:(
local xPos = 1
local yPos = 1
local cyclesCompleted = 0
local totalItems = 0

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

-- #SECTION gps

HOME_COORDS_PATH = "/home_coords.txt"
GPS_TIMEOUT = 5
ORIENTATIONS = { "N", "E", "S", "W" }

-- paths back to the home position using GPS
function gpsGoHome(orient)
    local homeX, homeY, homeZ, homeOrient = gpsGetHomePos()
    if homeX == nil then
        print("\n! Error: Home position not set!")
        return false
    end
    local curX, curY, curZ = gps.locate(GPS_TIMEOUT)
    local curOrient = orient and orient or gpsDetermineOrientation()

    if curX == nil then
        print("\n! Error: GPS failed to locate!")
        return false
    end

    if homeX == curX and homeY == curY and homeZ == curZ and homeOrient == curOrient then
        return true
    end

    print("\n! Starting in unexpected position.\n! Trying to return home...")

    -- print("Current: "..tostring(curX)..", "..tostring(curY)..", "..tostring(curZ)..", orient "..tostring(ORIENTATIONS[curOrient]))
    -- print("Home: "..tostring(homeX)..", "..tostring(homeY)..", "..tostring(homeZ)..", orient "..tostring(ORIENTATIONS[homeOrient]))

    local xDiff = homeX - curX
    local yDiff = homeY - curY
    local zDiff = homeZ - curZ
    local orientDiff = homeOrient - curOrient
    if orientDiff < 0 then
        orientDiff = orientDiff + 4
    end

    -- Determine the directions to move
    local xDir = xDiff < 0 and -1 or xDiff == 0 and 0 or 1 -- 1 for east, -1 for west
    local yDir = yDiff < 0 and -1 or yDiff == 0 and 0 or 1 -- 1 for up, -1 for down
    local zDir = zDiff < 0 and -1 or zDiff == 0 and 0 or 1 -- 1 for south, -1 for north

    -- print("xDir: "..tostring(xDir).." yDir: "..tostring(yDir).." zDir: "..tostring(zDir))

    -- Determine the amounts to move
    local xAmount = math.abs(xDiff)
    local yAmount = math.abs(yDiff)
    local zAmount = math.abs(zDiff)

    -- print("xAm: "..tostring(xAmount).." yAm: "..tostring(yAmount).." zAm: "..tostring(zAmount))

    -- Face towards the x axis

    local turnTimes = 0
    if curOrient == 1 then -- Facing North
        if xDir == 1 then -- Want to face East
            turnTimes = 1 -- Turn right once
        elseif xDir == -1 then -- Want to face West
            turnTimes = -1 -- Turn left once
        end
    elseif curOrient == 2 then -- Facing East
        if xDir == -1 then -- Want to face West
            turnTimes = 2 -- Turn twice
        end
    elseif curOrient == 3 then -- Facing South
        if xDir == 1 then -- Want to face East
            turnTimes = -1 -- Turn left once
        elseif xDir == -1 then -- Want to face West
            turnTimes = 1 -- Turn right once
        end
    elseif curOrient == 4 then -- Facing West
        if xDir == 1 then -- Want to face East
            turnTimes = 2 -- Turn twice
        end
    end

    for i=1, math.abs(turnTimes), 1 do
        if turnTimes > 0 then
            turtle.turnRight()
            curOrient = curOrient + 1
        elseif turnTimes < 0 then
            turtle.turnLeft()
            curOrient = curOrient - 1
        end
    end

    if curOrient > 4 then
        curOrient = curOrient - 4
    elseif curOrient < 1 then
        curOrient = curOrient + 4
    end

    -- Move up for safety

    local upHeight = GPS_SAFETY_HEIGHT
    if yDiff > 0 then
        upHeight = upHeight + yDiff
    end

    for i=1, upHeight, 1 do
        if not turtle.up() then
            return false
        end
    end

    -- Move in the x axis

    for i=1, xAmount, 1 do
        if not turtle.forward() then
            return false
        end
        goHomeTryRefuel();
    end

    -- Face towards the z axis

    turnTimes = 0
    if curOrient == 1 then -- Facing North
        if zDir == 1 then -- Want to face South
            turnTimes = 2 -- Turn twice
        end
    elseif curOrient == 2 then -- Facing East
        if zDir == 1 then -- Want to face South
            turnTimes = 1 -- Turn right once
        elseif zDir == -1 then -- Want to face North
            turnTimes = -1 -- Turn left once
        end
    elseif curOrient == 3 then -- Facing South
        if zDir == -1 then -- Want to face North
            turnTimes = 2 -- Turn twice
        end
    elseif curOrient == 4 then -- Facing West
        if zDir == 1 then -- Want to face South
            turnTimes = -1 -- Turn left once
        elseif zDir == -1 then -- Want to face North
            turnTimes = 1 -- Turn right once
        end
    end

    for i=1, math.abs(turnTimes), 1 do
        if turnTimes > 0 then
            turtle.turnRight()
            curOrient = curOrient + 1
        elseif turnTimes < 0 then
            turtle.turnLeft()
            curOrient = curOrient - 1
        end
    end

    if curOrient > 4 then
        curOrient = curOrient - 4
    elseif curOrient < 1 then
        curOrient = curOrient + 4
    end

    -- Move in the z axis

    for i=1, zAmount, 1 do
        if not turtle.forward() then
            return false
        end
        goHomeTryRefuel();
    end

    -- Move back down

    local downHeight = GPS_SAFETY_HEIGHT
    if yDiff < 0 then
        downHeight = downHeight + math.abs(yDiff)
    end

    for i=1, downHeight, 1 do
        if not turtle.down() then
            return false
        end
    end

    -- Face the home orientation

    turnTimes = curOrient - homeOrient
    if turnTimes < 0 then
        turnTimes = turnTimes + 4
    end

    for i=1, turnTimes, 1 do
        turtle.turnLeft()
    end

    return true
end

-- Tries to refuel while going home if the level is low
function goHomeTryRefuel()
    local itemDet = turtle.getItemDetail(1)
    if itemDet == nil then
        return
    end
    while turtle.getFuelLevel() < TARGET_FUEL_LEVEL do
        turtle.refuel(1)
        itemDet = turtle.getItemDetail(1)
        if itemDet == nil then
            break
        end
    end
end

-- Returns the home position of the turtle as a table
-- Contents: x, y, z, orientation
-- Returns all nil if the home position doesn't exist
function gpsGetHomePos()
    if not fs.exists(HOME_COORDS_PATH) then
        return nil, nil, nil, nil
    end
    local file = fs.open(HOME_COORDS_PATH, "r")
    local x = file.readLine()
    local y = file.readLine()
    local z = file.readLine()
    local orientation = file.readLine()
    file.close()
    return tonumber(x), tonumber(y), tonumber(z), tonumber(orientation)
end

function gpsPromptSetHomePos()
    local x, y, z = gps.locate(GPS_TIMEOUT)
    if x ~= nil then
        print("\nCurrent coords: "..tostring(x)..", "..tostring(y)..", "..tostring(z))
        term.write("Set as home position? (Y/n): ")
        local setHomePos = nil
        while true do
            setHomePos = read()
            if setHomePos ~= nil then
                break
            end
        end
        if setHomePos == "y" or setHomePos == "Y" or setHomePos == "" then
            print("\nDetermining orientation...")
            local orientation = gpsDetermineOrientation()
            if orientation == nil then
                print("\nTurtle is stuck or out of fuel!\nPlease make sure at least one adjacent block is air and enough fuel is present.\n")
                return
            end

            if fs.exists(HOME_COORDS_PATH) then
                fs.delete(HOME_COORDS_PATH)
            end

            local file = fs.open(HOME_COORDS_PATH, "w")
            file.write(tostring(x).."\n"..tostring(y).."\n"..tostring(z).."\n"..tostring(orientation).."\n")
            file.close()

            print("\nHome position set successfully!\n")
            return true
        end
        return false
    else
        print("\nError: GPS not available!\n")
        return false
    end
end

-- Determines the cardinal direction the turtle is oriented in
-- by trying to move in any available direction and then back to
-- the original position without breaking any adjacent blocks
function gpsDetermineOrientation()
    print("* Determining turtle orientation...")
    local x1, y1, z1 = gps.locate(GPS_TIMEOUT)

    if x1 == nil then
        return nil
    end

    local turns = 0
    if not turtle.forward() then
        turtle.turnRight()
        turns = turns + 1
        if not turtle.forward() then
            turtle.turnRight()
            turns = turns + 1
            if not turtle.forward() then
                turtle.turnRight()
                turns = turns + 1
                if not turtle.forward() then
                    turtle.turnRight()
                    return nil
                end
            end
        end
    end

    local x2, y2, z2 = gps.locate(GPS_TIMEOUT)
    turtle.back()

    for i=1, turns, 1 do
        turtle.turnLeft()
    end

    local orientation = nil
    if x1 == x2 then
        if z1 > z2 then
            orientation = 1
        else
            orientation = 3
        end
    else
        if x1 > x2 then
            orientation = 4
        else
            orientation = 2
        end
    end
    orientation = orientation - turns
    if orientation <= 0 then
        orientation = orientation + 4
    end
    return orientation
end

-- #SECTION run

function printStatus()
    print("")
    print("-> Turtle status:")
    print("   Current fuel level:    "..tostring(turtle.getFuelLevel()).." / "..tostring(TARGET_FUEL_LEVEL))
    print("   Harvest cycles done:   "..tostring(cyclesCompleted))
    print("   Total items offloaded: "..tostring(totalItems))
    print("")
end

function run()
    print("\n| SugarcaneFarm by Sv443\n")

    if TARGET_FUEL_LEVEL < 250 then
        print("\nWARNING: TARGET_FUEL_LEVEL is set very low, this may cause the turtle to get stuck.")
        print("Please set the value to at least 250, but ideally 500 or more.\n")
        os.sleep(5)
    end

    if USE_GPS_HOME then
        local homeX, homeY, homeZ, homeOrient = gpsGetHomePos()
        if homeX == nil then
            if not gpsPromptSetHomePos() then
                return
            end
        else
            local x, y, z = gps.locate(GPS_TIMEOUT)
            local orientation = gpsDetermineOrientation()
            if x ~= homeX or y ~= homeY or z ~= homeZ or orientation ~= homeOrient then
                if not gpsGoHome(orientation) then
                    print("\n! Couldn't return home :(\n")
                    return
                else
                    print("\n* Honey, I'm home!")
                    os.sleep(2)
                end
            end
        end
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
        print("* Waiting "..tostring(DELAY_BETWEEN_HARVESTS).."s until next harvest")
        os.sleep(DELAY_BETWEEN_HARVESTS)
    end
end

run()
