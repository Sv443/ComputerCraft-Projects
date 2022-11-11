local spk = peripheral.find("speaker")


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

function printTable(table)
    for k, v in pairs(table) do
        print(k .. ": " .. v)
    end
end
