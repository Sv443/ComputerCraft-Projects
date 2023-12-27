## Redstone Gates:
This is a collection of configurable redstone gates that run on a simple computer from ComputerCraft.  
They only take up a single block and their input and output sides and other settings can be freely configured.  

<br>

### Configuration:
All gates can be configured to your needs. After downloading the program, run `edit startup.lua` to edit it.  
If the program is running, first hold <kbd>Ctrl</kbd> + <kbd>T</kbd> to stop it first.  
  
At the top you will find variables which you can configure to your needs.  
The interval setting has to be a multiple of `0.05` (which is 1 tick or 1/20th of a second).  
  
After you've finished, press <kbd>Ctrl</kbd>, select `[Save]` and press <kbd>Enter</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]` and press <kbd>Enter</kbd>  
Afterwards, run the command `reboot` to automatically start the program.

<br>

### Basic Gates:
To install one of these gates, run one of the commands from below:

| Gate | Install command |
| --- | --- |
| AND | `pastebin get uEnJy4R8 startup.lua` |
| OR | `pastebin get CizrcGFt startup.lua` |
| NAND | `-` |
| NOR | `-` |
| XOR | `-` |
| XNOR | `-` |
| NOT | `pastebin get xeyAKMRp startup.lua` |

<br>

### Advanced Gates:
These gates are a bit more advanced as they are stateful or have special functionality beyond simple logic.  
To install one of these gates, run one of the commands from below:

| Gate | Install command | Special features |
| --- | --- | --- |
| S/R Latch | `pastebin get 1CPbvG3s startup.lua` | Configurable post-change delay |
| Sequencer | `pastebin get fzZgHDkp startup.lua` | &bull; Fully configurable redstone sequence on all sides<br>&bull; Optional single-shot mode |
| Delayer | `pastebin get L5a8CSvU startup.lua` | &bull; Fully configurable rising & falling edge delay<br>&bull; Optional invertable output signal |
| Pulse Extender | `-` | - |

<br>

### Changing to another gate:
If a gate has already been installed to a computer, run `rm startup.lua` to delete the old program.  
Now you can re-download a new gate to it.
