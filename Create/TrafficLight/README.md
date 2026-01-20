[🚧 WORK IN PROGRESS]

<br>

## Traffic Light (for [Create Trains](https://create.fandom.com/wiki/Train))
This project implements a simple traffic light controller for intersections with 3 or 4 exits.  
The traffic light cycles through three states: Green, Yellow, and Red, with configurable durations for each state, and an optional red+yellow state before turning green.  
It is to be used in conjunction with lamps and/or [Create Train Signals](https://create.fandom.com/wiki/Train_Signal) to visually and functionally implement traffic lights in Minecraft.  
Concurrency is not used, the program just cycles through all traffic lights in sequence.

<br>

### Requirements
- 1 computer per exit plus 1 computer as the main controller (e.g., 4 exits = 5 computers)
- Wired modems and network cables that connect all 4 or 5 computers together (make sure to click the modems once to activate)
- 3 redstone outputs per exit computer to connect to the traffic light lamps and/or Create Train Signals (red, yellow, green)

### Setup
1. Build a [Train Track](https://create.fandom.com/wiki/Train_Track) intersection with 3 or 4 exits and a [Train Signal](https://create.fandom.com/wiki/Train_Signal) at each entrance.
2. Place the main controller computer somewhere close to the intersection.
3. Place the 3 or 4 exit computers next to each exit of the intersection.
4. Connect all computers with wired modems.  
  (You can also use one large network for multiple intersections, as long as the `REDNET_PROTOCOL` variable is unique per intersection.)
5. Use [Create Redstone Links](https://create.fandom.com/wiki/Redstone_Link), [AE2 Redstone P2P Tunnels](https://guide.appliedenergistics.org/1.21.1/items-blocks-machines/p2p_tunnels) or just plain redstone wires to transmit 3 redstone signals (red, yellow, green) from each exit computer to the respective traffic light lamps and/or Create Train Signals.  
  Make sure to route both red and yellow signals to the Train Signal, so trains stop on both red and yellow.

<br>

### Installation
Main Controller Computer Setup (only once):
1. On the main controller computer, run these commands:
  ```
  label set TL-C
  pastebin get TODO startup.lua
  edit startup.lua
  ```
2. Edit the variables at the top to your liking
3. Press <kbd>Ctrl</kbd>, select `[Save]`, then <kbd>Return</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]`, then <kbd>Return</kbd>
4. Run `reboot` to start the program once all exit computers are set up

Exit Computer Setup (repeat for each exit):
1. On each exit computer, run these commands (replace `1` with an incrementing number for each exit, e.g., `1`, `2`, `3`, `4`):
  ```
  label set TL-1
  pastebin get TODO startup.lua
  edit startup.lua
  ```
2. Edit the variables at the top to your liking
3. Press <kbd>Ctrl</kbd>, select `[Save]`, then <kbd>Return</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]`, then <kbd>Return</kbd>
4. Run `reboot` to start the program
