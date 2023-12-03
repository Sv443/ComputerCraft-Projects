## Certus Crystal Farm
It's usually a pain in the ass to get larger amounts of certus quartz crystals and dust.  
These programs automate the process of havesting and also replacing the budding certus block.  
You will only need to provide flawed budding certus blocks and power to the crystal growth accelerator as inputs.  
  
The turtles also have the ability to keep track of their facing, making them resilient against SP world re-joins and MP server restarts.  

<br>

![example setup](./setup.png)  

<br>

### Important Notes:
- To clear the statistics, hold <kbd>Ctrl</kbd> + <kbd>T</kbd>, then enter `rm stats.txt` and `reboot`
- After moving a turtle in any way, you need to reset its facing  
  To do this, hold <kbd>Ctrl</kbd> + <kbd>T</kbd>, enter `rm facing.txt`, then mine and re-place it in its new spot or facing
- The output chests of the crystal mining turtles can be put either above or below them.

<br>

### Roadmap:
- Transmit exhaustion status to crystal miner turtles so they can harvest the crystals preemtively  
  This only applies to the full crystal miners but it would be nice to have to reduce waste

<br>

### Installation:
1. Craft three mining turtles, a crystal growth accelerator and four inventories (barrels or chests)
2. Place all blocks but the turtles as shown in the image above
3. Place the crystal mining turtles facing one of the growing crystals like shown in the image above  
  By default they are placed facing the left crystal, but this can be configured (see step 5)
4. Run the following commands in one of the crystal mining turtles:
```
label set crystal_miner
pastebin get Je4zCLGJ startup.lua
edit startup.lua
```
5. Edit the values at the top to your needs
6. Press <kbd>Ctrl</kbd>, select `[Save]` and press <kbd>Enter</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]` and press <kbd>Enter</kbd>  
7. Run the command `reboot` to start the program
8. Repeat from step 4 for the other crystal mining turtle
9. Place the certus block replacer turtle in any facing, directly above the budding certus block  
  By default it is placed facing the output inventory, but this too can be configured (see step 11)
10. Run the following commands in the certus block replacer turtle:
```
label set block_replacer
pastebin get d7EXURGa startup.lua
edit startup.lua
```
11. Edit the values at the top to your needs
12. Press <kbd>Ctrl</kbd>, select `[Save]` and press <kbd>Enter</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]` and press <kbd>Enter</kbd>  
13. Run the command `reboot` to start the program
14. Provide budding certus blocks to the input inventory and power to the crystal growth accelerator
15. Check in on the turtles every once in a while to see their stats
