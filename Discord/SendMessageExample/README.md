## Discord Send Message Example
This program shows how to send a message in a Discord channel by using the webhook feature.  
[Click here to view the code](./send-message-example.lua)

<br>

### Installation
First, create a new webhook in Discord:
1. Edit the channel which you want to send messages to
2. Under Integrations > Webhooks, click the "Create Webhook" button
3. Give it a name and copy its URL
  
Now install the program in Minecraft:
1. Craft and place a computer and attach a button to it
2. Run these commands:
```
label set discord_webhook
pastebin get TGrUD56w startup.lua
edit startup.lua
```
3. Enter the webhook URL at the top, change the message content below and set the side at which the button is attached.  
  The message content also supports regular Discord markdown (`**text**` becomes **text**, etc.)
4. Press <kbd>Ctrl</kbd>, select `[Save]` and press <kbd>Enter</kbd>, then press <kbd>Ctrl</kbd> again, select `[Exit]` and press <kbd>Enter</kbd>  
5. Now run the command `reboot` to automatically start the program.  
  Every time you click the button, the message will be sent to the Discord channel.
