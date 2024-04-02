--[[
--Created Date: Thursday July 28th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thuesday March 19th 2024 10:22:39 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

commands = {};

if (Config.UseESX) then
    ESX = exports["es_extended"]:getSharedObject();
end

---@param source number | boolean
---@param message string
local function notify(source, message)
    if (source) then
        TriggerClientEvent("jSync:showNotification", source, message);
    else
        print("^3" .. message .. "^7");
    end
end

---@class ICommandArg
---@field name string
---@field help string

---@class ICommandInfo
---@field arguments ICommandArg[]
---@field help string

---@param source number
---@param cb fun(source: number, args: table, showError: fun(message: string): void): void
---@param args string[]
---@param showError fun(message: string): void
local function exec_command(source, cb, args, showError)
    if (Config.UseESX) then
        local xPlayer = ESX.GetPlayerFromId(source);
        if (xPlayer) then
            cb(source, args, showError);
        else
            showError("~r~An error occured while executing command.");
        end
    else
        cb(source, args, showError);
    end
end

---@param commandName string
---@param cb fun(source: number, args: table, showError: fun(message: string): void): void
---@param source number
---@param args string[]
---@param showError fun(message: string): void
local function command_handler(commandName, cb, source, args, showError)
    local success, result = pcall(cb, source, args, function(message)
        notify(source, message);
    end);
    if not success then
        if (type(showError) == "function") then
            showError("~r~An error occured while executing command.");
        end
        print("^7[^1WEATHER SYSTEM^7]^1  An error occured while executing command ^7'^4" .. commandName .. "^7'^1: " .. result .. "^7");
    end
end

---@param commandName string
---@param group string
---@param cb fun(source: number | boolean, args: table, showError: fun(message: string): void): void
---@param options ICommandInfo
local function _RegisterCommand(commandName, group, cb, options)
    RegisterCommand(commandName, function(source, args)
        command_handler(commandName, function(source, args, showError)
            if (source == 0) then cb(false, args, showError); return; end
            exec_command(source, cb, args, showError);
        end, source, args)
    end, true);
    if (type(group) == "string") then
        ExecuteCommand(("add_ace group.%s command.%s allow"):format(group, commandName));
    end
    commands[#commands + 1] = {
        name = ("/%s"):format(commandName),
        help = options and options.help or "No help provided",
        params = (options and options.arguments) or {};
    };
end

_RegisterCommand("setweather", "admin", function(source, args, showError)
    if (not args[1]) then showError("Usage: /setweather <weather>"); return; end
    if (WeatherService.setCurrentWeather((args[1]):upper())) then
        notify(source, "Weather is now '" .. (args[1]):upper() .. "'.");
    else
        notify(source, "This weather is blacklisted.");
    end
end, {
    arguments = {
        {name = 'weather', help = "Weather to set. Types: CLEAR, CLEARING, CLOUDS, EXTRASUNNY, FOGGY, OVERCAST, RAIN, SMOG, THUNDER, XMAS, SNOWLIGHT, BLIZZARD, HALLOWEEN"},
    },
    help = "Change current weather"
});

_RegisterCommand("freezeweather", "admin", function(source, args, showError)
    WeatherService.freezeWeather(nil, function(active)
        if (active) then
            notify(source, "Weather sync thread is now INACTIVE and weather has been frozen.");
        else
            notify(source, "Weather sync thread is now ACTIVE and weather has been unfrozen.");
        end
    end);
end, {
    arguments = {},
    help = "Freeze weather to current weather"
});

_RegisterCommand("settime", "admin", function(source, args, showError)
    if (not args[1] or not args[2]) then showError("Usage: /settime <hour, minute>"); return; end
    TimeService.setCurrentTime(tonumber(args[1]), tonumber(args[2]));
    notify(source, "Time is now '" .. args[1] .. ":" .. args[2] .. "'.");
end, {
    arguments = {
        {name = 'hour', help = "Hour to set (0, 23)", type = 'number'},
        {name = 'minute', help = "minute to set (0, 59)", type = 'number'}
    },
    help = "Change current time"
});

_RegisterCommand("freezetime", "admin", function(source, args, showError)
    TimeService.freezeTime(nil, nil, function(active)
        if (active) then
            notify(source, "Time sync thread is now INACTIVE and time has been frozen.");
        else
            notify(source, "Time sync thread is now ACTIVE and time has been unfrozen.");
        end
    end);
end, {
    arguments = {},
    help = "Freeze time to current time"
});