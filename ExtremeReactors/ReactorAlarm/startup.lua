-- Side of the reactor redstone port
-- Signal high means reactor fuel low
INPUT_SIDE = "back"
-- Side of the mute lever
-- Signal high means speaker is muted
MUTE_SIDE = "front"

-- Sequence of notes to play
-- Format: {instrument, pitch, duration}
--   `instrument` can be the name of any noteblock instrument (check the Minecraft wiki)
--   `pitch` goes from 1 to 24, with 1 being an F#
--   `duration` is in seconds, has to be a multiple of 0.05 (1 game tick)
NOTES_SEQUENCE = {
    {"pling", 17, 0.25}, {"pling", 13, 0.25}
}
-- Delay between playing the sequence of notes
DELAY_BETWEEN = 4
-- Volume of the speaker
VOLUME = 1.5




speaker = peripheral.find("speaker")

function check()
    if redstone.getInput(INPUT_SIDE) then
        if redstone.getInput(MUTE_SIDE) then
            speaker.stop()
        else
            for i, noteInfo in pairs(NOTES_SEQUENCE) do
                if redstone.getInput(MUTE_SIDE) then
                    speaker.stop()
                    break
                end
                speaker.playNote(noteInfo[1], VOLUME, noteInfo[2])
                os.sleep(noteInfo[3])
            end
            os.sleep(DELAY_BETWEEN)
        end
    else
        speaker.stop()
    end
end

function run()
    print("\n| ReactorAlarm by Sv443\n| https://github.com/Sv443/ComputerCraft-Projects\n")

    if not speaker then
        print("No speaker found")
        return
    end

    while true do
        check()
        os.sleep(0.05)
    end
end

run()
