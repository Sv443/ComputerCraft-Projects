local spk = peripheral.find("speaker")
local drv = peripheral.find("drive")

-- #MARKER init

while true do
    loop()
end

function loop()
    local ev, side = os.pullEvent()

    if ev == "disk" then
        diskInserted(side)
    elseif ev == "disk_eject" then
        diskEjected(side)
    end
end

-- #MARKER disk drive

lastDiskName = {}

-- called whenever a disk is inserted
function diskInserted(side)
    if drv.hasData(side) then
        local mountPath = drv.getMountPath(side)
        local label = drv.getDiskLabel(side)
        local id = drv.getDiskID(side)

        if label ~= nil and label.len > 0 then
            print(">> Inserted disk #"..id..' with label "'..label..'" on '..side.." side")
            lastDiskName[side] = label
        else
            print(">> Inserted unnamed disk on "..side.." side")
        end

        stopAudio()

        if not playDiskAlbum(mountPath) then
            noDiskData(side)
            return false
        end

        return true
    else
        noDiskData(side)
        return false
    end
end

-- called whenever a disk is ejected
function diskEjected(side)
    local dName = lastDiskName[side]
    if dName ~= nil then
        print('>> Ejected disk "'..dName..'" on '..side.." side")
    else
        print(">> Ejected unnamed disk on "..side.." side")
    end

    return true
end

function noDiskData(side)
    print()
    print("The disk inserted on the "..side.." side doesn't contain an album.")
    print("Please follow the steps on this page to download music onto it:")
    print("https://github.com/Sv443/ComputerCraft-Projects/tree/main/Jukebox")
    print()
end

-- #MARKER music

-- plays a single noteblock note
function playNote(instr, vol, pitch)
    spk.playNote(instr, vol, pitch)
end

-- plays a noteblock chord
-- instr:     noteblock instrument name
-- vol:       sound volume
-- pitches:   table of index and chord pitches
-- transpose: transpose all notes by any positive or negative number of octaves and overflow automatically at <0 or >24
function playNotes(instr, vol, pitches, transpose)
    if transpose == nil then
        transpose = 0
    end
    local pitchesStr = ""
    for i, pitch in pairs(pitches) do
        local p = pitch + transpose * 12
        if p > 24 then
            p = p % 24
        end
        if p < 0 then
            p = 24 - math.abs(p) % 24
        end

        p = math.floor(p)

        playNote(instr, vol, p)
        pitchesStr = pitchesStr..p.." "
    end
    print("> chord: "..pitchesStr.."("..instr..")")
end

-- stops all audio currently playing
function stopAudio()
    spk.stop()
end

-- plays an album from the disk at the given mount path
function playDiskAlbum(path)
    apiPath = path.."/album.lua"
    if fs.exists(apiPath) then
        os.loadAPI(apiPath)

        if type(album.JUKEBOX_ALBUM) ~= "table" then
            return false
        end

        print(">> Found and loaded the album")

        for idx=1, tableLen(album.JUKEBOX_ALBUM), 1 do
            playSongInAlbum(idx)
        end

        return true
    else
        return false
    end
end

-- plays the song at the provided index of the currently loaded album
function playSongInAlbum(idx)
    if type(album.JUKEBOX_ALBUM) ~= "table" then
        return false
    end

    local song = album.JUKEBOX_ALBUM[idx]
    if type(song) == "table" then
        local songName = song[1]
        local tracks = song[2]

        if type(tracks) == "table" then
            playTracks(tracks)
            return true
        end

        return false
    end
    return false
end

-- plays all provided tracks on the speaker
-- blocks code execution until the album ends
-- TODO: add exit condition
function playTracks(tracks)

end

-- #MARKER utils

-- returns the length of a passed table, 0 if empty, nil if value isn't a table
function tableLen(table)
    if type(table) ~= "table" then
        return nil
    end

    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- prints out a table's key/value pairs on one line each
-- also works recursively
function printTable(table, padding)
    if padding == nil then
        padding = 0
    end

    for k, v in pairs(table) do
        local spc = ""
        for i=0, padding, 1 do
            spc = spc.." "
        end

        -- value is table, recurse
        if type(v) == "table" then
            print(spc..k .. ":")
            printTable(v, padding + 2)
        elseif type(v) == "function" then
            print(spc..k..": <function>")
        else
            print(spc..k .. ": " .. v)
        end
    end
end
