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