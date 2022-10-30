## Discord
These programs make use of the Discord API to send messages in text channels.  

<br>

### Programs:
- [PlayerJoinLeaveMessage](./PlayerJoinLeaveMessage/) - Sends a Discord message whenever players join or leave the Minecraft server
- [SendMessageExample](./SendMessageExample/) - Shows how to send a message to a Discord channel in ComputerCraft

<br>

### Creating a webhook:
The first step with each of these programs is to create a webhook in the Discord app:  
1. On your Discord server, edit the channel in which you want the program to send messages
2. Navigate to `Integrations` > `Webhooks` and click on the `Create Webhook` button
3. Edit settings if needed, then copy the URL
  
This URL now needs to be entered in the program:  
1. In the computer, run the command `edit startup.lua`  
  If a program is currently running, hold <kbd>Ctrl</kbd> and <kbd>T</kbd>
2. At the top, find the webhook URL variable, which is in full caps and enter the URL between the quotes
3. Press <kbd>Ctrl</kbd>, select [Save], <kbd>Return</kbd>, <kbd>Ctrl</kbd> again, select [Exit], then <kbd>Return</kbd>
4. Run the command `reboot` to automatically start the program

<br>
