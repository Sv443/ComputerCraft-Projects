## Discord Player Join & Leave Message
This program sends a Discord message whenever one or more players have joined or left the game.  
Note that there is a delay of up to 10 minutes in the online detection.  
Without cheating in a command computer sadly I don't think there is another way.  
The program needs to be run on a computer in a Minecraft server's spawn chunks (or chunk-loaded chunks).

<br>

### Creating the webhook:
The first step before installing this program is to create a webhook in the Discord app:  
1. On your Discord server, edit the channel in which you want the program to send messages
2. Navigate to `Integrations` > `Webhooks` and click on the `Create Webhook` button
3. Edit settings if needed, then copy the URL

<br>

### Installing the program:
After creating a webhook and copying the URL, install the program in-game:
1. Craft and place down a computer
2. Run the following commands:
```
label set discord_join_leave_message
pastebin get 4nRg9CHU json
pastebin get xyz startup.lua
edit startup.lua
```
3. At the top, enter your server's IP and port and the Discord webhook URL
4. Press <kbd>Ctrl</kbd>, select [Save], <kbd>Return</kbd>, <kbd>Ctrl</kbd> again, select [Exit], then <kbd>Return</kbd>
5. Run the command `reboot` to automatically start the program