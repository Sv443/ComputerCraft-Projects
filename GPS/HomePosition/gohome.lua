-- where the home coordinates are saved on the turtle
HOME_COORDS_PATH = "/home_coords.txt"
-- how many blocks to move upwards so the turtle doesn't run into anything - 0 to disable
SAFETY_HEIGHT = 2

ORIENTATIONS = { "N", "E", "S", "W" }

function run()
    print("\nTrying to go home...")
    local goHomeResult = gpsGoHome()
    if goHomeResult then
        print("\nSuccess! Turtle is home :)\n")
    else
        print("\nI couldn't find my way back home :(\n")
    end
end

function gpsGoHome()
    local homeX, homeY, homeZ, homeOrient = gpsGetHomePos()
    if homeX == nil then
        print("\nError: Home position not set!\n")
        return false
    end
    local curX, curY, curZ = gps.locate(GPS_TIMEOUT)
    local curOrient = gpsDetermineOrientation()

    if curX == nil then
        print("\nError: GPS failed to locate!\n")
        return false
    end

    if homeX == curX and homeY == curY and homeZ == curZ and homeOrient == curOrient then
        return true
    end

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

    local upHeight = SAFETY_HEIGHT
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
    end

    -- Move back down

    local downHeight = SAFETY_HEIGHT
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

-- Determines the cardinal direction the turtle is oriented in
-- by trying to move in any available direction and then back to
-- the original position without breaking any adjacent blocks
function gpsDetermineOrientation()
    local x1, y1, z1 = gps.locate(GPS_TIMEOUT)
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

run()
