# jSync: Server side Weather and Time system

jSync is a server-side weather and time system that works with ESX but can be easily modified


# Usage (Client-Side)

```lua
--You have two options for exporting jSync in your resources
--First method:
TriggerEvent("jSync:getSharedObject", function(obj)
	jSync = obj
end)

--Second method:
jSync = exports["jSync"]:getSharedObject()

--Best way to sync into it in your resources:
jSync = exports["jSync"]:getSharedObject()

RegisterNetEvent("jSync:onPlayerJoined", function(data)
    print(json.encode(data))
    jSync.currentHour = data.hour
    jSync.currentMinute = data.minute
    jSync.currentWeather = data.weather
    
    CreateThread(function()
        while true do
            TriggerEvent("jSync:getCurrentWeather", function(jSyncCurrentWeather)
                jSync.currentWeather = jSyncCurrentWeather
                print(jSync.currentWeather)
            end)
            TriggerEvent("jSync:getCurrentTime", function(jSyncCurrentHour, jSyncCurrentMinute)
                jSync.currentHour, jSync.currentMinute = jSyncCurrentHour, jSyncCurrentMinute
                print(jSync.currentHour, jSync.currentMinute)
            end)
            print(jSync.getCurrentHour(), jSync.getCurrentMinute(), jSync.getCurrentWeather())
            Wait(Config.Timers.Clock * 1000)
        end
    end)
end)

```

for any question join my discord:  [Discord
](https://discord.gg/DbuTNv9sqD)

for any suggestion, create a pull request.
