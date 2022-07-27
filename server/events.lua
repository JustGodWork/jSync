--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday July 27th 2022 1:52:24 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

local function VERSION_CHECKER() -- DONT DELETE THIS TO BE INFORMED ABOUT NEW UPDATES
    local resource = GetInvokingResource() or GetCurrentResourceName()
    PerformHttpRequest('https://api.github.com/repos/JustGodWork/jSync/releases/latest', function(status, response)
        if status ~= 200 then return end

        response = json.decode(response)
        if response.prerelease then return end

        local currentVersion = GetResourceMetadata(resource, 'version', 0) and GetResourceMetadata(resource, 'version', 0):match('%d%.%d+%.%d+')
        if not currentVersion then print("^7[^1jSync^7]^1 No version found in fxmanifest.^7") end

        local latestVersion = response.tag_name:match('%d%.%d+%.%d+')
        if not latestVersion then return print("^7[^1jSync^7]^1 Request error: no new version was find.^7") end

        if latestVersion and not currentVersion then 
            io.open(GetResourcePath(resource) .. '/fxmanifest.lua', 'a+'):write('\n\nversion "version_must_be_here"\n--[[\nVersion must be write in fxmanifest to get updates of the script,\n Please update to: https://api.github.com/repos/JustGodWork/jSync/releases/latest\n]]--'):close() 
            return print("^7[^1jSync^7]^1 Check your fxmanifest to install newest version or visit: ^4https://api.github.com/repos/JustGodWork/jSync/releases/latest^1.^7")
        end

        if currentVersion > latestVersion then return print("\n\n^7[^1jSync^7]^3 Your version was not found on repository please update to the latest version: ^4" .. latestVersion .. "^3.\nYour version : ^4" .. currentVersion .. "^3\nDownload: ^4".. response.html_url .."^7") end
        if currentVersion == latestVersion then return end
        print("\n\n^7[^1jSync^7]^3 New version available: ^4" .. latestVersion .. "^3.\nYour version : ^4" .. currentVersion .. "^3\nDownload: ^4".. response.html_url .."^7")
    end, 'GET')
end

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
        VERSION_CHECKER()
        Weather:syncWeather()
        Time:sync()
        local hour, minute = Time:getCurrentTime()
        TriggerClientEvent("jSync:onPlayerJoined", -1, {
            hour = hour,
            minute = minute,
            weather = Weather:getCurrentWeather()
        })
    end
end)

AddEventHandler("esx:playerLoaded", function(playerSource)
    if Config.debug then
        print("^7[^1jSync^7]^3 Player ^4" .. GetPlayerName(playerSource) .. "^3 loaded.^7")
    end
    local hour, minute = Time:getCurrentTime()
    TriggerClientEvent("jSync:setWeather", playerSource, Weather:getCurrentWeather())
    TriggerClientEvent("jSync:setClockTime", playerSource, hour, minute)
    TriggerClientEvent("jSync:onPlayerJoined", playerSource, {
        hour = hour,
        minute = minute,
        weather = Weather:getCurrentWeather()
    })
end)