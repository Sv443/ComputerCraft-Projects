## Sugarcane Farm
This program controls a mining turtle to automatically harvest sugarcane and deposit it into a chest or barrel.  
It also refuels itself automatically.  
You can even use this same script for a cactus farm as they behave identically.  
Additionally, the program has a feature to return to the refueling station using GPS if it gets stuck somewhere (which happens if the world is rejoined on SP or the server restarts on MP).  

<br>

<img alt="example setup" src="./example_setup.png" height="400" />

<br>

### Important info:

- The farm can be of any size, as long as it's a rectangle
- The sugarcane (or cacti) can be in any pattern
- After relogging in singleplayer or restarting the server the turtle will restart, making it lose all sense of position.  
  For this reason the auto-home feature exists. It will make the turtle move back to the refueling station and restart the harvesting cycle if it is in an unexpected position.
- To reset the home position, hold <kbd>Ctrl</kbd> + <kbd>T</kbd> and use the command `rm home_coords.txt`
  Then just place the turtle in its new home position and open it to confirm.
- The turtle will break every block in the farm above and including a height of 2 blocks, so make sure there are no blocks there you don't want broken
- Always keep the refueling station stocked or the turtle will eventually get stuck in the middle of a harvesting cycle
- Make sure the entire row of the y axis that the barrels/chests are on is empty, as the turtle will move there to deposit the sugarcane
- Also make sure there is enough air above the farm if you are using the auto-home feature.
  The exact height can be changed in the settings, but 1 block air above the sugarcane is the minimum and default setting.

### Less important info:
- When the auto-home feature is triggered, the turtle will move up (2 blocks by default) so it doesn't get stuck, then move in an L-shape to the refueling station, starting with the x-axis.  
  If any block is in the way, you will need to manually re-place the turtle on the refueling station.
- You may open the turtle every now and again to see its stats, which it will print every time it refuels after finishing a harvesting cycle

<br>

### Installation:
1. If you intend on using the auto-home feature you will need to set up some GPS servers in always loaded chunks first, see [this guide](https://tweaked.cc/guide/gps_setup.html)  
  If you don't want to use this feature, make sure to disable it (see step 5)
2. Craft a mining turtle (pickaxe) and two chests or barrels and place them like shown in the image above  
  The positioning of the chests/barrels is important! The turtle will always assume the farm is in front of it and to the right, from its initial position.  
  When using the auto-home feature, the turtle will also need an ender modem equipped in its other slot.
3. Place the mining turtle above the refueling station in the corner, facing along the left edge of the farm (X axis)
4. Run these commands:
```
label set sugarcane_farm
pastebin get 1G6qAMMt startup.lua
edit startup.lua
```
5. Change the settings at the top of the file to match your farm size, fuel item and growing speed (if you have a mod that changes the growing speed of sugarcane, like PneumaticCraft, which I used in the screenshot above)
  Just make sure the sugarcane doesn't grow faster than the turtle takes to move the full length in the X axis or it will get stuck!
6. Press <kbd>Ctrl</kbd>, select `[Save]` and press <kbd>Enter</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]` and press <kbd>Enter</kbd>  
7. Run the command `reboot` to start the program
8. Confirm setting the home position with <kbd>Enter</kbd> once it is placed on the refueling station in the correct orientation
