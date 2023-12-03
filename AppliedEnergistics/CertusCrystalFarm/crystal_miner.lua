-- Whether to mine only fully grown certus quartz crystals
-- If set to false, the tiny crystals will be harvested instantly
-- thus giving certus dust instead of crystals
MINE_FULLY_GROWN = true

-- Delay between mining attempts and turning in seconds
-- Has to be a multiple of 0.05 (1 game tick)
DELAY = 0.5

-- The initial direction the turtle should turn after mining
-- the crystal it is already facing
-- 1 = clockwise, -1 = counter-clockwise
INITIAL_TURN_DIRECTION = 1
-- The file where the turtle stores its current facing
FACING_FILE = "/facing.txt"

-- After how many times of turning the
-- current stats should be printed
STATS_PRINT_AFTER = 50
-- The file where the mining stats are stored
STATS_FILE = "/stats.txt"

-- The *vertical* position where the turtle should drop off
-- all items it has collected (can be "top" or "bottom")
DROPOFF_POS = "top"

-- Which blocks are allowed to be mined
-- This only needs to be changed in case you are using an older
-- (or newer for that matter) version of AE2
MINABLE_BLOCK_NAMES = MINE_FULLY_GROWN and { "ae2:quartz_cluster" } or { "ae2:small_quartz_bud", "ae2:medium_quartz_bud", "ae2:large_quartz_bud", "ae2:quartz_cluster" }


-- DO NOT EDIT BELOW THIS LINE OR TURTLE GETS ANGY >:(

local curFacing = 0
local turnCycle = INITIAL_TURN_DIRECTION
local minedBlocks = 0
local itemsDeposited = 0
local loopCount = 0

-- #SECTION mining

function loop()
    -- mine
    local hasBlock, detail = turtle.inspect()
    if hasBlock then
        for i = 1, #MINABLE_BLOCK_NAMES do
            if detail.name == MINABLE_BLOCK_NAMES[i] then
                if turtle.dig() then
                    minedBlocks = minedBlocks + 1
                end
                break
            end
        end
    end
    -- deposit items
    local itemDet = turtle.getItemDetail(1)
    if itemDet ~= nil then
        if itemDet.count > 0 then
            depositItems()
            itemsDeposited = itemsDeposited + itemDet.count
        end
    end

    -- turn
    turn(turnCycle == 1 and "right" or "left")
    turnCycle = turnCycle * -1

    -- update & print stats
    updateStats()
    if loopCount % STATS_PRINT_AFTER == 0 then
        printStats()
    end

    -- update loop count
    loopCount = loopCount + 1
end

-- Drops all items from the first slot
function depositItems()
    turtle.select(1)
    if DROPOFF_POS == "top" then
        turtle.dropUp()
    elseif DROPOFF_POS == "bottom" then
        turtle.dropDown()
    end
end

-- #SECTION facing

-- Restores the facing from file
function restoreFacing()
    if not fs.exists(FACING_FILE) then
        local file = fs.open(FACING_FILE, "w")
        file.write("0\n")
        file.close()
    end
    local file = fs.open(FACING_FILE, "r")
    local facing = tonumber(file.readLine())
    file.close()
    if facing ~= 0 then
        print("* Restoring facing...")
    end
    for i = 1, math.abs(facing) do
        if facing > 0 then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
    end
end

-- Turns in the given direction and updates the facing file
function turn(direction)
    local file = fs.open(FACING_FILE, "w")
    if direction == "left" then
        curFacing = curFacing - 1
        file.write(tostring(curFacing).."\n")
        turtle.turnLeft()
        file.close()
    elseif direction == "right" then
        curFacing = curFacing + 1
        file.write(tostring(curFacing).."\n")
        turtle.turnRight()
        file.close()
    end
end

-- #SECTION stats

-- Loads the stats from file
function loadStats()
    if not fs.exists(STATS_FILE) then
        updateStats()
        return
    end
    local file = fs.open(STATS_FILE, "r")
    local blocks = file.readLine()
    local items = file.readLine()
    file.close()

    minedBlocks = tonumber(blocks)
    itemsDeposited = tonumber(items)
end

-- Updates the stats file
function updateStats()
    local file = fs.open(STATS_FILE, "w")
    file.write(tostring(minedBlocks).."\n"..tostring(itemsDeposited).."\n")
    file.close()
end

-- Prints the stats to the console
function printStats()
    print("\n-> Stats:")
    print("   Total mined blocks: "..tostring(minedBlocks))
    print("   Total gained items: "..tostring(itemsDeposited))
end

-- #SECTION run

function run()
    print("\n| CertusCrystalFarm by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")
    loadStats()
    restoreFacing()
    while true do
        loop()
        os.sleep(DELAY)
    end
end

run()
