## Jukebox
Converts real audio files into ComputerCraft programs, to be played in-game on a speaker.  

<br>  

### Installation:
First, craft and place down a computer, and then a speaker and disk drive, which both touch the computer.  
Then craft a floppy disk and place it inside the disk drive.  
  
Now generate the album programs by following [this section](#converter), then return here.  
  
After generating the program(s), run the generated `pastebin get` command on the computer, but only once per inserted floppy disk.  
Running it again with the same disk will overwrite the previously saved album.  
  
Now, to install the main jukebox program.  
Go back to the computer you have placed down and run the command `pastebin get TODO jukebox` to download it.  
After inserting a disk, you can run the command `jukebox` to play the songs stored on it.  
To stop playback hold down <kbd>Ctrl</kbd> and <kbd>T</kbd>

<br>

### Converter:
(coming soon)  
  
This converter script takes in one or more .midi files to convert into a computercraft jukebox album program.  
The resulting program can be downloaded onto a floppy disk and then run on the main jukebox computer.  
  
You can download it [from here.](TODO: GH/releases/latest)

<br>

### Example:
You can find an example of how a series of noteblock sounds can be played in ComputerCraft [by clicking here.](./example.lua)  
Install and run the example by running these commands in a computer that has a speaker attached to it:
```
pastebin get 78LBsvJe mary
mary
```

<br>

### Pre-converted albums:
These are some albums I have already rearranged and converted:
| Album | Pastebin code |
| :-- | :-- |
| Mary had a Little Computer | `TODO` |
| DELTARUNE OST - My Castle Town | `TODO` |

<br>

### Notes format:  
The notes that make up the song are all defined in a 2D table.  
The first dimension defines the order in which the notes are played, as well as the notes and their info in the second dimension.  
The second dimension of the notes table contains the `instrument`, `volume`, `pitch` and `startTick` in that order.  
  
Instrument can be any noteblock instrument. Take the name from after the last `.` of the "sound event names" on [the wiki page.](https://minecraft.fandom.com/wiki/Note_Block#Instruments) (for example `bass`)  
Volume I think is the same as when using the /playsound command.  
Pitch goes from 0 to 24 semitones, starting at an F#.  
StartTick is the number of ticks that need to pass until this note plays. All notes in the table need to be ordered by this number.  