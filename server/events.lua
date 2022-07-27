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

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
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