--[[
--Created Date: Tuesday July 26th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday July 26th 2022 11:34:38 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Weather 
local _Weather = {}

---@return Weather
function _Weather:new()
    local self = {}
    setmetatable(self, { __index = _Weather })

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
    }
    self.blacklist = {}
    self.currentWeather = "EXTRASUNNY"
    self.thread = Thread:new()

    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            self:syncWeather()
        end
    end)

    AddEventHandler("esx:playerLoaded", function(playerSource)
        if Config.debug then
            print("[Weather] Player " .. GetPlayerName(playerSource) .. " loaded.")
        end
        TriggerClientEvent("jSync:setWeather", playerSource, self:getCurrentWeather())
    end)

    ---Return actual weather synced to all players
    ---@return string
    function self:getCurrentWeather()
        return self.currentWeather
    end

    ---Set current weather Synced to all players
    ---@param weather string
    function self:setCurrentWeather(weather)
        if not self:isBlacklisted(weather) then
            self.currentWeather = weather
            print("^7[^1WEATHER SYSTEM^7]^3 Weather is now ^7'^4" .. weather .. "^7'^3.^7")
            self:syncWeather()
            return true
        end
        return false
    end

    ---See https://gta.fandom.com/wiki/Weather for detailed list of weather types
    ---@return table Array of Weathers
    function self:getWeatherTypes()
        return self.weatherTypes
    end

    ---List of all blacklisted weathers
    ---@return table
    function self:getBlacklist()
        return self.blacklist
    end

    ---Return weather is blacklisted or not
    ---@param weather string
    function self:isBlacklisted(weather)
        for i = 1, #self.blacklist do
            if self.blacklist[i] == weather then
                return true
            end
        end
        return false
    end

    ---Choose a random weather in the list of not blacklisted weathers
    ---@param weather string
    function self:getRandomWeather()
        local weather = self.weatherTypes[math.random(1, #self.weatherTypes)]
        if not self:isBlacklisted(weather) then
            return weather
        else
            --WEATHER BLACKLISTED SO TRY AGAIN
            return self:getRandomWeather()
        end
    end

    ---Start the weather sync thread
    ---@param cb fun(CurrentWeather: string)
    function self:start(cb)
        self.thread:loop(Config.Timers.Weather * 1000 * 60, function()
            self:setCurrentWeather(self:getRandomWeather())
            if cb then cb(self:getCurrentWeather()) end
        end)
    end

    ---Add single weather to blacklist
    ---@param weather string
    function self:addWeatherToBlacklist(weather)
        if not self:isBlacklisted(weather) then
            self.blacklist[#self.blacklist + 1] = weather
        else
            return print("^7[^1WEATHER SYSTEM^7]^3 Weather ^7'^4" .. weather .. "^7'^3 is already blacklisted.^7")
        end
    end

    ---Add multiple weathers to blacklist
    ---@param weather string
    function self:addMultipleWeatherToBlacklist(weathers)
        for i = 1, #weathers do
            self:addWeatherToBlacklist(weathers[i])
        end
    end

    ---Stop weather sync thread and freeze current weather synced to all players
    ---@param weather string
    ---@param cb fun(active: boolean)
    function self:freezeWeather(weather, cb)
        if self.thread:isActive() then
            if cb then cb(self.thread:isActive()) end
            self.thread:stop()
            if weather then self:setCurrentWeather(weather) end
        else
            if cb then cb(self.thread:isActive()) end
            self:start()
        end
    end

    ---Sync current weather to all players
    function self:syncWeather()
        TriggerClientEvent("jSync:setWeather", -1, self:getCurrentWeather())
    end

    print("^7[^1WEATHER SYSTEM^7]^3 Weather is now ^7'^4" .. self:getCurrentWeather() .. "^7'^3.^7")

    return self
end

Weather = _Weather:new()

Weather:addMultipleWeatherToBlacklist({
    "OVERCAST",
    "XMAS",
    "SNOWLIGHT",
    "BLIZZARD",
    "HALLOWEEN",
})

Weather:start()

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