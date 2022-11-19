import * as midiMgr from "midi-file";
import fs from "fs-extra";
import { resolve } from "path";
import { IntermediaryFormat } from "./types";


export function parseMidiFile(path: string) {
    return midiMgr.parseMidi(fs.readFileSync(resolve(path)));
}

export function parseMidiFiles(paths: string[]) {
    return paths.map(p => parseMidiFile(p));
}

// export function parseIntermediary(midiData: midiMgr.MidiData): IntermediaryFormat {

// }

/**
 * Parses MIDI tempo into various useful values  
 * @param ppq Pulses per quarter note (defined in `<MThd>`)
 * @param mpb Microseconds or ticks per beat (from "set tempo" event)
 */
export function parseMidiTempo(ppq: number, mpb: number)
{
    const microsPerTick = Math.floor(mpb / ppq);
    const bpm = parseFloat((60_000_000 / mpb).toFixed(2));

    return {
        microsPerTick,
        msPerTick: microsPerTick / 1000,
        bpm,
    }
}
