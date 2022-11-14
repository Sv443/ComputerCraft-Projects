-- general structure overview:
-- 
-- album
--  |-- song 1
--  |    |-- song name
--  |    |-- tracks
--  |         |-- track 1
--  |         |    |-- instrument name
--  |         |    |-- note tables
--  |         |         |-- { volume, pitch, tickDelta }
--  |         |         |-- ...
--  |         |-- track 2
--  |         |    |-- ...
--  |
--  |-- song 2
--  |    |-- ...


-- note table properties:
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
            {"harp", {{3, 6, 0}, {3, 6, 10}, {3, 7, 20}, {3, 7, 10},{3, 8, 5}, {3, 8, 5}}},
            -- track 2 instrument & notes:
            {"banjo", {{2, 6, 0}, {2, 6, 10},                           {3, 8, 35}, {3, 8, 5}}}
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