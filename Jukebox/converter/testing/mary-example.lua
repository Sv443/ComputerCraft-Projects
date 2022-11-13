local volume = 3.0
local bpm = 10

local spk = peripheral.find("speaker")


-- mary had a little lamb:
function maryHadALittleLamb(instr, vol)
    -- F# = 0, 12, 24
    -- C  = 6, 18
    return {
        {instr,vol,10,0}, {instr,vol,8,10}, {instr,vol,6,20}, {instr,vol,8,30}, {instr,vol,10,40}, {instr,vol,10,50}, {instr,vol,10,60},
        {instr,vol,8,80}, {instr,vol,8,90}, {instr,vol,8,100}, {instr,vol,10,120}, {instr,vol,10,130}, {instr,vol,10,140},
        {instr,vol,10,160}, {instr,vol,8,170}, {instr,vol,6,180}, {instr,vol,8,190}, {instr,vol,10,200}, {instr,vol,10,210}, {instr,vol,10,220},
        {instr,vol,10,230}, {instr,vol,8,240}, {instr,vol,8,250}, {instr,vol,10,260}, {instr,vol,8,270}, {instr,vol,6,270}
    }
end

function run()
    -- parse and play the note packets:
    local packets = maryHadALittleLamb("xylophone", volume)

    local playing = true
    local idx = 1
    local tick = 0

    while playing do
        local pk = packets[idx]

        local instr = pk[1]
        local vol = pk[2]
        local pitch = pk[3]
        local startTick = pk[4]

        if tick == startTick then
            print("tick:"..tick.." - instr:"..instr.." - vol:"..vol.." - pitch:"..pitch)
            playNote(instr, vol, pitch)
            idx = idx + 1
        end

        if idx > tableLen(packets) then
            print("finished playing")
            playing = false
            return true
        end

        tick = tick + 1
        os.sleep(0.05) -- 1 tick
    end
end

function playNote(instr, vol, pitch)
    spk.playNote(instr, vol, pitch)
end

function tableLen(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

run()
