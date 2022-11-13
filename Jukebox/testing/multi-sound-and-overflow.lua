local spk = peripheral.find("speaker")

-- instr:     noteblock instrument name
-- vol:       sound volume
-- pitches:   table of index and chord pitches
-- transpose: transpose all notes by any positive or negative number of octaves and overflow automatically at <0 or >24
function playNotes(instr, vol, pitches, transpose)
    if transpose == nil then
        transpose = 0
    end
    for i, pitch in pairs(pitches) do
        local p = pitch + transpose * 12
        if p > 24 then
            p = p % 24
        end
        if p < 0 then
            p = 24 - math.abs(p) % 24
        end

        print(p)
        spk.playNote(instr, vol, math.floor(p))
    end
end

local pitches = {6, 10, 13}
playNotes("harp", 3, pitches, 0)
