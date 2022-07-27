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


--LISTENERS
local currentWeather;
RegisterNetEvent("jSync:setWeather", function(weather)
    if currentWeather ~= weather then
        SetWeatherTypeOvertimePersist(weather, 15.0)
        Wait(15000)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(weather)
        SetWeatherTypeNow(weather)
        SetWeatherTypeNowPersist(weather)
        currentWeather = weather
    end
end)

local currentHour;
local currentMinute;
RegisterNetEvent("jSync:setClockTime", function(hour, minute)
    if Config.debug then
        print("[Time] Setting time to " .. GetClockHours() .. ":" .. GetClockMinutes())
    end
    NetworkOverrideClockTime(hour, minute, 0)
    currentHour = hour
    currentMinute = minute
end)

--FUNCTIONS
function jSync.getCurrentWeather()
    return currentWeather
end

function jSync.getCurrentHour()
    return currentHour
end

function jSync.getCurrentMinute()
    return currentMinute
end

--EXPORTS THINGS

AddEventHandler("jSync:getSharedObject", function(cb)
    cb(jSync)
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