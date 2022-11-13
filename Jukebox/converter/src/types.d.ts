export type IntermediaryFormat = Track[];

export interface Track {
    instrument: NoteblockInstrument;
    notes: Note[];
}

export interface Note {
    /**
     * In semitones. Can go from 0 to 24:  
     * F# = 0, 12, 24
     * C  = 6, 18  
     */
    pitch: number;
    /** Minecraft volume (rather sound distance than loudness), same as with /playsound */
    volume: number;
    /** Time in ticks (20t = 1s) between the last note and this one */
    deltaTime: number;
}