-- How many times the turtle has to turn from its
-- initial facing to face the output inventory
-- Positive number for clockwise, negative for counter-clockwise
OUTPUT_INVENTORY_TURNS = 0
-- How many times the turtle has to turn from its
-- initial facing to face the input inventory
-- Positive number for clockwise, negative for counter-clockwise
INPUT_INVENTORY_TURNS = 2

-- Full name including namespace of the non-budding certus block
CERTUS_BLOCK_NAME = "ae2:quartz_block"

-- Delay in seconds to wait after the block has been exhausted
-- before trying to replace it
-- Should be around 3-4 times as high as the checking interval
-- of the crystal mining turtles
DELAY_AFTER_EXHAUST = 2

-- The file where the turtle stores its current facing
FACING_FILE = "/facing.txt"
-- The file where the mining stats are stored
STATS_FILE = "/stats.txt"


-- DO NOT EDIT BELOW THIS LINE OR TURTLE GETS ANGY >:(

local curFacing = 0
local replacedBlocks = 0

-- #SECTION replacing

-- Checks if the block below is a regular certus block and returns true if so
function checkBlock()
    local hasBlock, detail = turtle.inspectDown()
    if hasBlock then
        return detail.name == CERTUS_BLOCK_NAME
    end
    return false
end

-- Digs the block below the turtle
function digBlock()
    local dug = false
    while not turtle.digDown() do
        if not dug then
            print("! Failed to replace block")
            dug = true
        end
        os.sleep(0.5)
    end
    return true
end

-- Places a block below the turtle
function placeBlock()
    local placed = false
    turtle.select(1)
    while not turtle.placeDown() do
        if not placed then
            print("! Failed to place block")
            placed = true
        end
        os.sleep(0.5)
    end
    replacedBlocks = replacedBlocks + 1
    return true
end

-- #SECTION turning

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

-- Turns in the given direction for the given amount and updates the facing file
function turn(direction, amount)
    if amount == 0 then
        return
    end
    if fs.exists(FACING_FILE) then
        fs.delete(FACING_FILE)
    end

    for i = 1, math.abs(amount) do
        if direction == "left" then
            curFacing = curFacing - 1
            local file = fs.open(FACING_FILE, "w")
            file.write(tostring(curFacing).."\n")
            file.close()
            turtle.turnLeft()
        elseif direction == "right" then
            curFacing = curFacing + 1
            local file = fs.open(FACING_FILE, "w")
            file.write(tostring(curFacing).."\n")
            file.close()
            turtle.turnRight()
        end
    end
end

-- #SECTION inventories

-- Grabs a new budding certus block from the input inventory
function grabBlock()
    -- turn to face input inventory
    turn(INPUT_INVENTORY_TURNS > 0 and "right" or "left", INPUT_INVENTORY_TURNS)

    -- grab item
    local grabbed = false
    while not turtle.suck(1) do
        if not grabbed then
            print("* Waiting for input block...")
            grabbed = true
        end
        os.sleep(0.5)
    end

    -- turn to face initial direction
    turn(INPUT_INVENTORY_TURNS < 0 and "right" or "left", INPUT_INVENTORY_TURNS)

    return true
end

-- Deposits the used up certus block into the output inventory
function depositBlock()
    -- turn to face output inventory
    turn(OUTPUT_INVENTORY_TURNS > 0 and "right" or "left", OUTPUT_INVENTORY_TURNS)

    -- drop item
    local slot = 1
    local dropped = false
    turtle.select(1)
    while not turtle.drop() do
        slot = slot + 1
        if slot > 16 then
            slot = 1
        end
        turtle.select(slot)
        if not dropped then
            print("! Output inventory full!")
            dropped = true
        end
        os.sleep(0.5)
    end

    -- turn to face initial direction
    turn(OUTPUT_INVENTORY_TURNS < 0 and "right" or "left", OUTPUT_INVENTORY_TURNS)

    return true
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
    file.close()

    replacedBlocks = tonumber(blocks)
end

-- Updates the stats file
function updateStats()
    local file = fs.open(STATS_FILE, "w")
    file.write(tostring(replacedBlocks).."\n")
    file.close()
end

-- Prints the stats to the console
function printStats()
    print("\n-> Stats:")
    print("   Total replaced blocks: "..tostring(replacedBlocks))
end

-- #SECTION run

local waitingCheck = false

function run()
    print("\n| CertusCrystalFarm by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")
    loadStats()
    restoreFacing()
    local hasBlock = turtle.inspectDown()
    if not hasBlock then
        local itemDet = turtle.getItemDetail(1)
        if itemDet == nil then
            grabBlock()
        end
        placeBlock()
    end
    while true do
        turtle.select(1)
        local itemDet = turtle.getItemDetail(1)
        if itemDet == nil then
            grabBlock()
        else
            if itemDet.count > 1 then
                print("! Started with unexpected items")
                print("* Depositing them in output...\n")
                depositBlock()
            end
        end
        if not waitingCheck then
            print("* Waiting for block to exhaust...")
            waitingCheck = true
        end
        if checkBlock() then
            waitingCheck = false
            os.sleep(DELAY_AFTER_EXHAUST)
            digBlock()
            placeBlock()
            depositBlock()
            print("* Replaced block")
            updateStats()
            printStats()
        end
        os.sleep(CHECK_INTERVAL)
    end
end

run()
