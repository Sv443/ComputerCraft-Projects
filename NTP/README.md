## NTP (Network Time Protocol)
I made these scripts to have an ingame modem-based NTP service that provides a uniform timestamp for passed ingame time.  
In the future the real UTC timestamp could also be provided alongside.  

<br>

## Scripts:
- [NTP Server](./NTP-Server/) - Sends out the current ingame timestamp via wireless modem. Requirement for the other scripts.
- [NTP Clock](./NTP-Clock/) - Monitor-based NTP clock and calendar for ingame time

<br><br>

## Ingame time standard:
The [NTP Server](./NTP-Server/) needs to be placed once, in always loaded chunks.  
It will send out the current ingame timestamp once per tick on port 123.  
  
### Timestamp format:  
> `timestamp = daysPassed * 100 + ccTime`  
- `daysPassed` is the amount of full ingame days that have passed  
- `ccTime` is the current time of day in ComputerCraft format (where 9.5 would equal 9:30 AM and 23.75 would be 11:45 PM)  
  
### Timestamp decoding:
```lua
local modem = peripheral.find("modem")
modem.open(123)

while true do
    local _e, _x, _y, _z, msg = os.pullEvent("modem_message")

    if msg ~= nil then
        local timestamp = msg + 0.0 -- cast to a float number

        local daysPassed = math.floor(timestamp / 100)        -- amount of passed days
        local timeOfDay = timestamp - daysPassed * 100        -- time of day in CC format - see https://www.computercraft.info/wiki/Os.time
        local formattedTime = textutils.formatTime(timeOfDay) -- see https://computercraft.info/wiki/Textutils.formatTime

        print(formattedTime..", day #"..daysPassed) -- "9:30 AM, day #420"
    end
end
```
