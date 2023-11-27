HOME_COORDS_PATH = "/home_coords.txt"

GPS_TIMEOUT = 5
ORIENTATIONS = { "N", "E", "S", "W" }

function run()
    local homeX, homeY, homeZ, homeOrient = gpsGetHomePos()
    if homeX ~= nil then
        print("\nCurrent home: "..tostring(homeX)..", "..tostring(homeY)..", "..tostring(homeZ)..", orient "..tostring(ORIENTATIONS[homeOrient]))
    end
    local setHomeSuccess = gpsPromptSetHomePos()
    if not setHomeSuccess then
        if homeX ~= nil then
            print("\nUsing previous home position.\n")
            return;
        else
            print("\nError: Failed to set home position!\n")
            return
        end
        return
    end
    homeX, homeY, homeZ, homeOrient = gpsGetHomePos()
    print("\nNew home: "..tostring(homeX)..", "..tostring(homeY)..", "..tostring(homeZ)..", orient "..tostring(ORIENTATIONS[homeOrient]))
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
        print("\nMy coordinates: "..tostring(x)..", "..tostring(y)..", "..tostring(z))
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
