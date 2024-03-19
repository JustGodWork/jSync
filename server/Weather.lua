--[[
--Created Date: Tuesday July 26th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thuesday March 19th 2024 10:34:25 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

local function WeatherServiceConstructor()

    ---@class WeatherService
    local self = {};

    self.weatherTypes = {
        "CLEAR",
        "CLEARING",
        "CLOUDS",
        "EXTRASUNNY",
        "FOGGY",
        "OVERCAST",
        "RAIN",
        "SMOG",
        "THUNDER",
        "XMAS",
        "SNOWLIGHT",
        "BLIZZARD",
        "HALLOWEEN",
    };

    self.blacklist = {};
    self.currentWeather = "EXTRASUNNY";
    self.thread = Thread:new();

    ---Return actual weather synced to all players
    ---@return string
    function self.getCurrentWeather()
        return self.currentWeather;
    end

    ---Set current weather Synced to all players
    ---@param weather string
    function self.setCurrentWeather(weather)
        if not self.isBlacklisted(weather) then
            self.currentWeather = weather;
            print("^7[^1WEATHER SYSTEM^7]^3 Weather is now ^7'^4" .. weather .. "^7'^3.^7");
            self.sync();
            return true;
        end
        return false;
    end

    ---See https://gta.fandom.com/wiki/Weather for detailed list of weather types
    ---@return table Array of Weathers
    function self.getWeatherTypes()
        return self.weatherTypes;
    end

    ---List of all blacklisted weathers
    ---@return table
    function self.getBlacklist()
        return self.blacklist;
    end

    ---Return weather is blacklisted or not
    ---@param weather string
    function self.isBlacklisted(weather)
        for i = 1, #self.blacklist do
            if self.blacklist[i] == weather then
                return true;
            end
        end
        return false;
    end

    ---Choose a random weather in the list of not blacklisted weathers
    ---@param weather string
    function self.getRandomWeather()
        local weather = self.weatherTypes[math.random(1, #self.weatherTypes)];
        if not self.isBlacklisted(weather) then
            return weather;
        else
            --WEATHER BLACKLISTED SO TRY AGAIN
            return self.getRandomWeather();
        end
    end

    ---Start the weather sync thread
    ---@param cb fun(CurrentWeather: string)
    function self.start(cb)
        self.thread:loop(Config.Timers.Weather * 1000 * 60, function()
            self.setCurrentWeather(self.getRandomWeather());
            if cb then cb(self.getCurrentWeather()) end
        end);
    end

    ---Add single weather to blacklist
    ---@param weather string
    function self.addWeatherToBlacklist(weather)
        if not self.isBlacklisted(weather) then
            self.blacklist[#self.blacklist + 1] = weather;
        else
            return print("^7[^1WEATHER SYSTEM^7]^3 Weather ^7'^4" .. weather .. "^7'^3 is already blacklisted.^7");
        end
    end

    ---Add multiple weathers to blacklist
    ---@param weather string
    function self.addArrayOfBlacklistedWeathers(weathers)
        for i = 1, #weathers do
            self.addWeatherToBlacklist(weathers[i]);
        end
    end

    ---@deprecated
    --- Please use addArrayOfBlacklistedWeathers instead
    ---@param weathers string
    function self.addMultipleWeatherToBlacklist(weathers)
        self.addArrayOfBlacklistedWeathers(weathers);
    end

    ---Set a persistent weather even if it is blacklisted
    ---@param weather string
    function self.setPersistentWeather(weather)
        self.thread:stop();
        self.currentWeather = weather;
    end

    ---Stop weather sync thread and freeze current weather synced to all players
    ---@param weather string
    ---@param cb fun(active: boolean)
    function self.freezeWeather(weather, cb)
        if self.thread:isActive() then
            if cb then cb(self.thread:isActive()) end
            self.thread:stop();
            if weather then self.setCurrentWeather(weather) end
        else
            if cb then cb(self.thread:isActive()) end
            self.start();
        end
    end

    ---Sync current weather to all players
    function self.sync()
        TriggerClientEvent("jSync:setWeather", -1, self.getCurrentWeather());
    end

    self.addArrayOfBlacklistedWeathers(Config.BlacklistedWeathers);

    self.start();

    return self;

end

WeatherService = WeatherServiceConstructor();
