local spk = peripheral.find("speaker")

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

        spk.playNote(instr, vol, math.floor(p))
        pitchesStr = pitchesStr..math.floor(p).." "
    end
    print("> chord: "..pitchesStr.."("..instr..")")
end

function playChords(instr, transpose)
    local pitches = nil

    if transpose == nil then
        transpose = 0
    end

    pitches = {6, 10, 13}
    playNotes(instr, 3, pitches, transpose)
    os.sleep(0.5)

    pitches = {8, 12, 15}
    playNotes(instr, 3, pitches, transpose)
    os.sleep(0.5)

    pitches = {10, 14, 17}
    playNotes(instr, 3, pitches, transpose)
    os.sleep(0.5)

    print()
end


playChords("harp")
os.sleep(1)
playChords("harp", 1)
os.sleep(2)

playChords("bell")
os.sleep(1)
playChords("bell", -1)

