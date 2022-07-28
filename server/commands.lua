--[[
--Created Date: Thursday July 28th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday July 28th 2022 1:58:37 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

if Config.UseESX then

    TriggerEvent(Config.ESXEvent, function(obj)
        ESX = obj
    end)

    if ESX then
        --WEATHER SYSTEM
        ESX.RegisterCommand("setweather", "superadmin", function(xPlayer, args, showError)
            if Weather:setCurrentWeather((args.weather):upper()) then
                if xPlayer then 
                    xPlayer.showNotification("~c~Weather is now ~s~'~b~" .. (args.weather):upper() .. "~s~'~c~.")
                end
            else
                if xPlayer then 
                    xPlayer.showNotification("~c~This weather is ~r~blacklisted~c~.") 
                else
                    print("^7[^1WEATHER SYSTEM^7]^3 This weather is ^1blacklisted^3.^7")
                end
            end
        end, true, {arguments = {
            {name = 'weather', help = "Weather to set. Types: CLEAR, CLEARING, CLOUDS, EXTRASUNNY, FOGGY, OVERCAST, RAIN, SMOG, THUNDER, XMAS, SNOWLIGHT, BLIZZARD, HALLOWEEN", type = 'string'},
        }, help = "Change current weather"})

        ESX.RegisterCommand("freezeweather", "superadmin", function(xPlayer, args, showError)
            Weather:freezeWeather(nil, function(active)
                if active then
                    if xPlayer then
                        xPlayer.showNotification("Weather sync thread is now ~r~INACTIVE~s~ and weather has been frozen.^7")
                    else
                        print("^7[^1WEATHER SYSTEM^7]^3 Weather sync thread is now ^1INACTIVE^3 and weather has been frozen.^7")
                    end
                else
                    if xPlayer then
                        xPlayer.showNotification("Weather sync thread is now ~g~ACTIVE~s~ and weather has been unfrozen.^7") 
                    else
                        print("^7[^1WEATHER SYSTEM^7]^3 Weather sync thread is now ^4ACTIVE^3 and weather has been unfrozen.^7")
                    end
                end
            end) 
        end, true, {arguments = {}, help = "Freeze weather to current weather"})

        --TIME
        ESX.RegisterCommand("settime", "admin", function(xPlayer, args, showError)
            Time:setCurrentTime(args.hour, args.minute)
            if xPlayer then 
                xPlayer.showNotification("~c~Time is now ~s~'~b~" .. args.hour .. ":" .. args.minute .. "~s~'~c~.")
            else
                print("^7[^1TIME SYSTEM^7]^3 Time is now ^7'^4" .. args.hour .. ":" .. args.minute .. "^7'^3.^7")
            end
        end, true, {arguments = {
            {name = 'hour', help = "Hour to set (0, 23)", type = 'number'},
            {name = 'minute', help = "minute to set (0, 59)", type = 'number'}
        }, help = "Change current time"})

        ESX.RegisterCommand("freezetime", "admin", function(xPlayer, args, showError)
            Time:freezeTime(nil, nil, function(active)
                if active then
                    if xPlayer then
                        xPlayer.showNotification("Time sync thread is now ~r~INACTIVE~s~ and time has been frozen.")
                    else
                        print("^7[^1TIME SYSTEM^7]^3 Time sync thread is now ^1INACTIVE^3 and time has been frozen.^7")
                    end
                else
                    if xPlayer then
                        xPlayer.showNotification("Time sync thread is now ~g~ACTIVE~s~ and time has been unfrozen.") 
                    else
                        print("^7[^1TIME SYSTEM^7]^3 Time sync thread is now ^4ACTIVE^3 and time has been unfrozen.^7")
                    end
                end
            end) 
        end, true, {arguments = {}, help = "Freeze time to current time"})
    else
        print("^7[^1WEATHER SYSTEM^7]^1 ESX was not found, please check your server and config files.^7")
    end

else

    --WEATHER SYSTEM
    RegisterCommand("setweather", function(source, args)
        if not args[1] then return print("^7[^1WEATHER SYSTEM^7]^3 Usage: /setweather <weather>") end
        if Weather:setCurrentWeather((args[1]):upper()) then
            if source ~= 0 then 
                TriggerClientEvent("jSync:showNotification", source, "~c~Weather is now ~s~'~b~" .. (args[1]):upper() .. "~s~'~c~.")
            end
        else
            if source ~= 0 then 
                TriggerClientEvent("jSync:showNotification", source, "~c~This weather is ~r~blacklisted~c~.") 
            else
                print("^7[^1WEATHER SYSTEM^7]^3 This weather is ^1blacklisted^3.^7")
            end
        end
    end)

    RegisterCommand("freezeweather", function(source)
        Weather:freezeWeather(nil, function(active)
            if active then
                if source ~= 0 then
                    TriggerClientEvent("jSync:showNotification", source, "Weather sync thread is now ~r~INACTIVE~s~ and weather has been frozen.")
                else
                    print("^7[^1WEATHER SYSTEM^7]^3 Weather sync thread is now ^1INACTIVE^3 and weather has been frozen.^7")
                end
            else
                if source ~= 0 then
                    TriggerClientEvent("jSync:showNotification", source, "Weather sync thread is now ~g~ACTIVE~s~ and weather has been unfrozen.") 
                else
                    print("^7[^1WEATHER SYSTEM^7]^3 Weather sync thread is now ^4ACTIVE^3 and weather has been unfrozen.^7")
                end
            end
        end) 
    end)

    --TIME SYSTEM
    RegisterCommand("settime", function(source, args)
        if not args[1] or not args[2] then 
            return print("^7[^1TIME SYSTEM^7]^3 Usage: /settime <hour, minute>") 
        end
        Time:setCurrentTime(tonumber(args[1]), tonumber(args[2]))
        if source ~= 0 then 
            TriggerClientEvent("jSync:showNotification", source, "~c~Time is now ~s~'~b~" .. args[1] .. ":" .. args[2] .. "~s~'~c~.")
        else
            print("^7[^1TIME SYSTEM^7]^3 Time is now ^7'^4" .. args[1] .. ":" .. args[2] .. "^7'^3.^7")
        end
    end)

    RegisterCommand("freezetime", function(source)
        Time:freezeTime(nil, nil, function(active)
            if active then
                if source ~= 0 then
                    TriggerClientEvent("jSync:showNotification", source, "Time sync thread is now ~r~INACTIVE~s~ and time has been frozen.")
                else
                    print("^7[^1TIME SYSTEM^7]^3 Time sync thread is now ^1INACTIVE^3 and time has been frozen.^7")
                end
            else
                if source ~= 0 then
                    TriggerClientEvent("jSync:showNotification", source, "Time sync thread is now ~g~ACTIVE~s~ and time has been unfrozen.") 
                else
                    print("^7[^1TIME SYSTEM^7]^3 Time sync thread is now ^4ACTIVE^3 and time has been unfrozen.^7")
                end
            end
        end) 
    end)

end