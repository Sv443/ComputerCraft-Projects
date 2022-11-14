-- general structure overview:
-- 
-- album
--  |-- song 1
--  |    |-- song name
--  |    |-- tracks
--  |         |-- track 1
--  |         |    |-- instrument name
--  |         |    |-- notes
--  |         |         |-- chord 1
--  |         |         |    |-- { volume, pitch, tickDelta }
--  |         |         |    |-- { volume, pitch, tickDelta }
--  |         |         |    |-- ...
--  |         |         |-- chord 2
--  |         |              |-- ...
--  |         |-- track 2
--  |              |-- ...
--  |
--  |-- song 2
--       |-- ...


-- there can only be one album per floppy disk
-- there's 1 to n songs per album
-- a song can have 1 to n tracks, which each have a designated instrument and a list of chords
-- the chords are made up of 1 to n note tables
-- each note table looks like this:
-- 
-- { volume: float, pitch: int, tickDelta: int }
-- 
-- volume    = note volume or velocity
-- pitch     = pitch value in semitones from 0 to 24
-- tickDelta = time in ticks (20t = 1s) between the last note and this one


-- example album:

JUKEBOX_ALBUM = {
    -- song 1
    {
        "song 1 name",
        {
            -- track 1 instrument & notes:
            {"harp", {{{3, 6, 0}, {3, 6, 10}}, {{3, 7, 20}}, {{3, 7, 10}}, {{3, 8, 5}}, {{3, 8, 5}}}},
            -- track 2 instrument & notes:
            {"banjo", {{{2, 6, 0}}}}
        }
    },
    -- song 2
    {
        "song 2 name",
        {
            -- track 1 instrument & notes:
            {"xylophone", {{3, 6, 0}, {3, 6, 10}, {3, 6, 20}, {3, 6, 30}, {3, 6, 35}, {3, 6, 45}}}
        }
    }
}