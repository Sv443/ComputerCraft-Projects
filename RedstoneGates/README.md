## Redstone Gates:
This is a collection of configurable redstone gates that run on a simple computer from ComputerCraft.  
They only take up a single block and their input and output sides and other settings can be freely configured.  

<br>

### Configuration:
All gates can be configured to your needs. After downloading the program, run `edit startup.lua` to edit it.  
If the program is running, hold <kbd>Ctrl</kbd> <kbd>T</kbd> to stop it first.  
  
At the top you will find variables which you can configure to your needs.  
The interval setting has to be a multiple of `0.1` (which is 1 redstone tick).  
  
After you've finished, press <kbd>Ctrl</kbd>, select `[Save]` and press <kbd>Enter</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]` and press <kbd>Enter</kbd>  
Afterwards, run the command `reboot` to automatically start the program.

<br>

### Basic Gates:
To install one of these gates, run one of the commands from below:

| Gate | Install command |
| :-- | :-- |
| AND / NAND | `pastebin get 4KSvxN75 startup.lua` |
| OR / NOR | `pastebin get Ss10r84Z startup.lua` |
| XOR / XNOR | `pastebin get tgx2aquv startup.lua` |
| NOT | `pastebin get EsveraQn startup.lua` |

<br>

### Advanced Gates:
These gates are a bit more advanced as they are stateful or have special functionality beyond simple logic.  
To install one of these gates, run one of the commands from below:

| Gate | Install command | Features |
| :-- | :-- | :-- |
| S/R Latch | `pastebin get 1CPbvG3s startup.lua` | &bull; Configurable post-change delay |
| Sequencer | `pastebin get fzZgHDkp startup.lua` | &bull; Fully configurable redstone sequence on all sides<br>&bull; Optional single-shot mode |
| Delayer | `pastebin get L5a8CSvU startup.lua` | &bull; Fully configurable rising & falling edge delay<br>&bull; Optional invertable output signal |
| State&nbsp;Toggle | `pastebin get 2ZJEXLhp startup.lua` | &bull; Steps through a list of preconfigured states when pulsed<br>&bull; Configurable delays before and after setting signals<br>&bull; Configurable cooldown<br>&bull; Single toggle on pulse, continuous toggling on continuously high input signal |
| Wireless&nbsp;Redstone&nbsp;Transmitter | `pastebin get FWxn5jJv startup.lua` | &bull; Transmits a redstone signal (0-15) via wireless modem |
| Wireless&nbsp;Redstone&nbsp;Receiver | `pastebin get NKzz7pWW startup.lua` | &bull; Receives a wireless redstone signal and prints it to the console<br>&bull; Integrated time measurement between signal changes<br>&bull; Designed to fit on a pocket computer screen |
| Pulse&nbsp;Extender | TODO | TODO |

<br>

### Changing to another gate:
If a gate has already been installed to a computer, run `rm startup.lua` to delete the old program.  
Now you can re-download a new gate to it.
