local spk = peripheral.find("speaker")
local drv = peripheral.find("drive")

-- 1 = default, 2 = debug mode
-- setting this to 1 means the computer is busy printing
-- debug output and can't play music as fast
LOG_LVL = 2

-- in seconds, how long of a pause to add between songs
-- set to 0 to disable
DELAY_BETWEEN_SONGS = 0.5

-- #MARKER init

function init()
    -- startup disk detection (I really wish there was a better way)
    if drv.isDiskPresent() then
        local sides = { "left", "right", "back", "front", "top", "bottom" }
        for i, side in pairs(sides) do
            if peripheral.getType(side) == "drive" and peripheral.call(side, "isDiskPresent") then
                diskInserted(side)
            end
        end
    end

    while true do
        loop()
    end
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

        local albumPath = nil
        if mountPath then
            albumPath = mountPath.."/album.lua"
        end

        if not fs.exists(albumPath) then
            noDiskData(side)
            return false
        end

        if label ~= nil and label.len > 0 then
            log(">> Inserted disk #"..id..' with label "'..label..'" on '..side.." side")
            lastDiskName[side] = label
        else
            log(">> Inserted unnamed disk on "..side.." side")
        end

        stopAudio()

        if not playDiskAlbum(albumPath) then
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
        log('>> Ejected disk "'..dName..'" on '..side.." side")
    else
        log(">> Ejected unnamed disk on "..side.." side")
    end

    return true
end

function noDiskData(side)
    log()
    log("The disk inserted on the "..side.." side doesn't contain an album.")
    log("Please follow the steps on this page to download music onto it:")
    log("https://github.com/Sv443/ComputerCraft-Projects/tree/main/Jukebox")
    log()
end

-- #MARKER music

-- plays a single noteblock note
function playNote(instr, vol, pitch)
    if not spk.playNote(instr, vol, pitch) then
        log("! Couldn't play note")
    end
end

-- plays a noteblock chord
-- instr:     noteblock instrument name
-- vol:       sound volume
-- pitches:   table of index and chord pitches
-- transpose: transpose all notes by any positive or negative number of octaves and overflow automatically at <0 or >24
function playChord(instr, vol, pitches, transpose)
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
end

-- stops all audio currently playing
function stopAudio()
    spk.stop()
end

-- plays an album from the file at the given mount path
function playDiskAlbum(path)
    if fs.exists(path) then
        os.loadAPI(path)

        if type(album.JUKEBOX_ALBUM) ~= "table" then
            return false
        end

        log(">> Found and loaded the album at path '"..path.."'", 2)

        for idx=1, tableLen(album.JUKEBOX_ALBUM), 1 do
            playSongInAlbum(idx)
        end

        os.unloadAPI(path)
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
            os.sleep(0.1)
            playTracks(tracks)
            os.sleep(DELAY_BETWEEN_SONGS)
            return true
        end

        return false
    end
    return false
end

-- plays all provided tracks on the speaker
-- blocks code execution until the song ends
function playTracks(tracks)
    -- amount of ticks since the computer was started
    local curTick = 0
    local lastTick = -1
    -- amount of ticks passed since beginning playing the tracks
    local ticksPassed = 0

    -- current "playback cursor" positions for each track
    local indexes = {}
    -- the tick at which the last note was played for each track
    local lastNoteTick = {}

    -- if both of these numbers match we know all tracks have ended
    local tracksAmt = tableLen(tracks)
    local tracksFinished = {}
    local tracksFinishedAmt = 0

    -- TODO: add manual exit condition
    local stopPlayback = false

    while true do
        curTick = math.floor(os.clock() * 20)
        if curTick ~= lastTick then
            lastTick = curTick
            for trackIdx, track in pairs(tracks) do
                -- initialize tables
                if not indexes[trackIdx] then
                    indexes[trackIdx] = 1
                end

                if not lastNoteTick[trackIdx] then
                    lastNoteTick[trackIdx] = 0
                end

                if not tracksFinished[trackIdx] then
                    tracksFinished[trackIdx] = false
                end

                local instr = track[1]
                local note = track[2][indexes[trackIdx]]

                -- since the index can only ever increase, if no other note
                -- was found, we know that track must've ended
                if note then
                    -- play the note when its tickDelta has passed
                    if ticksPassed - lastNoteTick[trackIdx] == note[3] then
                        local vol = note[1]
                        local pitch = note[2]

                        lastNoteTick[trackIdx] = ticksPassed
                        indexes[trackIdx] = indexes[trackIdx] + 1

                        -- TODO: add support for chords

                        -- log("Playing "..instr.." with pitch "..pitch.." @ "..ticksPassed)
                        playNote(instr, vol, pitch)
                    end
                elseif not tracksFinished[trackIdx] then
                    tracksFinished[trackIdx] = true
                    tracksFinishedAmt = tracksFinishedAmt + 1

                    -- if all tracks finished playing, return and
                    -- end the blocking execution
                    if tracksFinished == tracksAmt then
                        stopPlayback = true
                    end
                end
            end

            if stopPlayback then
                stopAudio()
                return true
            end

            ticksPassed = ticksPassed + 1

            if ticksPassed % 10 == 0 then
                -- suppress error "too long without yielding"
                -- and allow stuff to be printed and the
                -- program to be terminated with Ctrl + T
                os.queueEvent("_yield")
                os.pullEvent("_yield")
            end
        end
    end
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
    if not padding then
        padding = 0
    end

    if table == nil then
        return false
    end

    for k, v in pairs(table) do
        local spc = ""
        for i=0, padding, 1 do
            spc = spc.." "
        end

        -- value is table, recurse
        if type(v) == "table" then
            log(spc..k..":")
            printTable(v, padding + 2)
        -- value is function, print placeholder
        elseif type(v) == "function" then
            log(spc..k..": <function>")
        -- value can be stringified
        else
            log(spc..k..": "..v)
        end
    end
end

function log(message, level)
    if not message then
        message = ""
    end
    if not level then
        level = 1
    end

    if LOG_LVL >= level then
        print(message)
    end
end

init()