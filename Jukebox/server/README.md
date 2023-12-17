## Jukebox
Program that plays any arbitrary music file on a ComputerCraft computer using a speaker.  
Includes a server that automatically converts music files to the correct format and presents them to the local Minecraft instance.

<br>

### Installation:
1. Before anything else you will need to modify the ComputerCraft / CC: Tweaked configuration file. If playing on multiplayer, this will need to be done on the server:
    1. Open all instances of the file `computercraft-server.toml`
    2. Under the `[http]` section, find the `[[http.rules]]` sections
    3. Locate the rule that denies access to `$private`
    4. ***Above*** that rule, add the following rule:
        ```toml
        [[http.rules]]
            host = "127.0.0.1/8"
            port = 5076
            action = "allow"
        ```
    5. Save the file and restart the server or relaunch the game if playing singleplayer
2. Craft a computer and speaker and place them next to each other
3. Run the following commands:
    ```
    label set jukebox
    pastebin get TODO startup.lua
    edit startup.lua
    ```
4. Edit the settings at the top to your liking
5. Press <kbd>Ctrl</kbd>, select `[Save]` and press <kbd>Enter</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]` and press <kbd>Enter</kbd>  
6. Run the command `reboot` to start the program
