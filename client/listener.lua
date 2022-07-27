--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday July 27th 2022 1:35:54 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

jSync = {}
jSync.currentHour = 0
jSync.currentMinute = 0
jSync.currentWeather = ""

--LISTENERS
RegisterNetEvent("jSync:onPlayerJoined", function(data)
    print(json.encode(data))
    jSync.currentHour = data.hour
    jSync.currentMinute = data.minute
    jSync.currentWeather = data.weather
end)

RegisterNetEvent("jSync:setWeather", function(weather)
    if jSync.currentWeather ~= weather then
        SetWeatherTypeOvertimePersist(weather, 15.0)
        Wait(15000)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(weather)
        SetWeatherTypeNow(weather)
        SetWeatherTypeNowPersist(weather)
        jSync.currentWeather = weather
    end
end)

RegisterNetEvent("jSync:setClockTime", function(hour, minute)
    if Config.debug then
        print("[Time] Setting time to " .. GetClockHours() .. ":" .. GetClockMinutes())
    end
    NetworkOverrideClockTime(hour, minute, 0)
    jSync.currentHour = hour
    jSync.currentMinute = minute
end)

--FUNCTIONS
function jSync.getCurrentWeather()
    return jSync.currentWeather
end

function jSync.getCurrentHour()
    return jSync.currentHour
end

function jSync.getCurrentMinute()
    return jSync.currentMinute
end

--EXPORTS THINGS

AddEventHandler("jSync:getSharedObject", function(cb)
    cb(jSync)
end)

RegisterNetEvent("jSync:getCurrentWeather", function(cb)
    cb(jSync.currentWeather)
end)

RegisterNetEvent("jSync:getCurrentTime", function(cb)
    cb(jSync.currentHour, jSync.currentMinute)
end)

exports('getSharedObject', function()
	return jSync
end)

--Export usage:

-- TriggerEvent("jSync:getSharedObject", function(obj)
--     jSync = obj
-- end)

--OR

--jSync = exports["jSync"]:getSharedObject()

--Now you can use jSync.getCurrentWeather(), jSync.getCurrentHour(), jSync.getCurrentMinute() on your own script