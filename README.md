# jSync: Server side Weather and Time system

jSync is a server-sided weather and time system that works with ESX but can be easily modified

No thread loop client side, no needs to whrite any code, just commands :slight_smile: (freezetime, freezeweather, settime, setweather)

If you want to sync jSync current Time and Weather you can use code like below (jSync set native weather and clock but its better listening to jSync itself (Only if you set time loop on server highter than 1 second)

# Usage (Client-Side)

```lua
--First method:
TriggerEvent("jSync:getSharedObject", function(obj)
	jSync = obj
end)

--Second method:
jSync = exports["jSync"]:getSharedObject()

--Best way to sync it in your resources:
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
            Wait(jSync.getConfig().Clock * 1000)
        end
    end)
end)
```

for any question join my discord:  [Discord
](https://discord.gg/DbuTNv9sqD)

for any suggestion, create a pull request.

![jSyncWeatherClass](https://user-images.githubusercontent.com/85418813/181369602-1992cf9b-196d-44e4-b84e-0bccd18cc41d.png)
