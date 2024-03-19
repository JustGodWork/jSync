--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thuesday March 19th 2024 10:35:02 am
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

-- local function PauseClock(bool) -- ---todo PauseClock This native is not working properly.
--     return Citizen.InvokeNative(0x4055E40BD2DBEC1D, bool)
-- end

CreateThread(function()
	while true do
		Wait(0);
		if (NetworkIsPlayerActive(PlayerId())) then
			TriggerServerEvent('jSync:onPlayerJoined');
			break;
		end
	end
end);

--LISTENERS
RegisterNetEvent("jSync:onPlayerJoined", function(data)
    if (Config.debug) then
        print(json.encode(data));
    end
    jSync.currentHour = data.hour;
    jSync.currentMinute = data.minute;
    jSync.currentWeather = data.weather;
end);

RegisterNetEvent("jSync:setWeather", function(weather)
    if (jSync.currentWeather ~= weather) then
        SetWeatherTypeOvertimePersist(weather, 15.0);
        Wait(15000);
        ClearOverrideWeather();
        ClearWeatherTypePersist();
        SetWeatherTypePersist(weather);
        SetWeatherTypeNow(weather);
        SetWeatherTypeNowPersist(weather);
        jSync.currentWeather = weather;
    end
end);

RegisterNetEvent("jSync:setClockTime", function(hour, minute)
    --PauseClock(true) ---todo PauseClock This native is not working properly.
    NetworkOverrideClockTime(hour, minute, 0)
    SetClockTime(hour, minute, 0);
    jSync.currentHour = hour;
    jSync.currentMinute = minute;
    if (Config.debug) then
        print("[Time] Setting time to " .. GetClockHours() .. ":" .. GetClockMinutes());
    end
end);

--FUNCTIONS

---@param msg string
function jSync.showNotification(msg)
	BeginTextCommandThefeedPost('STRING');
	AddTextComponentSubstringPlayerName(msg);
	EndTextCommandThefeedPostTicker(0,1);
end

function jSync.getCurrentWeather()
    return jSync.currentWeather;
end

function jSync.getCurrentHour()
    return jSync.currentHour;
end

function jSync.getCurrentMinute()
    return jSync.currentMinute;
end

function jSync.getConfig()
    return Config;
end

--EXPORTS THINGS

---@param cb fun(obj: table)
AddEventHandler("jSync:getSharedObject", function(cb)
    cb(jSync);
end);

RegisterNetEvent("jSync:showNotification", jSync.showNotification);

RegisterNetEvent("jSync:getCurrentWeather", function(cb)
    cb(jSync.currentWeather);
end);

---@param cb fun(hour: number, minute: number)
RegisterNetEvent("jSync:getCurrentTime", function(cb)
    cb(jSync.currentHour, jSync.currentMinute);
end);

exports('getSharedObject', function()
	return jSync;
end);

--Export usage:

-- TriggerEvent("jSync:getSharedObject", function(obj)
--     jSync = obj
-- end)

--OR

--jSync = exports["jSync"]:getSharedObject()

--Now you can use jSync.getCurrentWeather(), jSync.getCurrentHour(), jSync.getCurrentMinute() on your own script