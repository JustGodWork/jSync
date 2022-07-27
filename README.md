# jSync: Server side Weather and Time system

jSync is a server-side weather and time system that works with ESX but can be easily modified


# Usage (Client-Side)

```lua
--You have two options for exporting jSync in your resources
--First method:
TriggerEvent("jSync:getSharedObject", function(obj)
	jSync = obj
end)

print(jSync.getCurrentHour(), jSync.getCurrentMinute())

--Second method:
jSync = exports["jSync"]:getSharedObject()

print(jSync.getCurrentHour(), jSync.getCurrentMinute())

--You can also use it like this:
local currentHour, currentMinute, currentWeather = 0, 0, ""
CreateThread(function()
	Wait(5000)
	while true do
        TriggerEvent("jSync:getCurrentWeather", function(jSyncCurrentWeather)
            currentWeather = jSyncCurrentWeather
            print(currentWeather)
        end)
        TriggerEvent("jSync:getCurrentTime", function(jSyncCurrentHour, jSyncCurrentMinute)
            currentHour, currentMinute = jSyncCurrentHour, jSyncCurrentMinute
            print(currentHour, currentMinute)
        end)
        Wait(2000)
    end
end)

```

for any question join my discord:  [Discord
](https://discord.gg/DbuTNv9sqD)
for any suggestion, create a pull request.
