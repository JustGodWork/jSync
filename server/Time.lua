--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thuesday March 19th 2024 10:25:46 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

local function TimeServiceConstructor()

    ---@class TimeService
    local self = {};

    self.currentHour = math.random(0, 23);
    self.currentMinute = math.random(0, 59);
    self.frozen = false;
    self.thread = Thread:new();

    ---Set current time
    ---@param hour number
    ---@param minute number
    function self.setCurrentTime(hour, minute)
        if type(hour) ~= "number" or type(minute) ~= "number" then
            return print("^7[^1TIME SYSTEM^7]^3 Invalid time format.^7");
        end
        self.currentHour = (hour and math.floor(hour)) or self.currentHour;
        self.currentMinute = (minute and math.floor(minute)) or self.currentMinute;
        self.sync();
    end

    ---@return number hour, number minute --current hour and current minute
    function self.getCurrentTime()
        return self.currentHour, self.currentMinute;
    end

    function self.start()
        self.thread:loop(Config.Timers.Clock * 1000, function()
            if not self.frozen then
                self.currentMinute = self.currentMinute + 1;
                if self.currentMinute > 59 then self.currentMinute = 0;
                    self.currentHour = self.currentHour + 1;
                    if self.currentHour > 23 then self.currentHour = 0 end
                end
            end
            self.sync();
        end);
    end

    ---Freeze time
    ---@param hour number
    ---@param minutes number
    ---@param cb fun(active:boolean)
    function self.freezeTime(hour, minutes, cb)
        if not self.frozen then
            if (type(cb) == "function") then cb(true) end
            self.frozen = true;
            self.setCurrentTime(
                (hour and tonumber(hour)) or self.currentHour,
                (minutes and tonumber(minutes)) or self.currentMinute
            );
        else
            if (type(cb) == "function") then cb(false) end
            self.frozen = false;
        end
    end

    function self.sync()
        TriggerClientEvent("jSync:setClockTime", -1, self.currentHour, self.currentMinute);
    end

    self.start();

    return self;

end

TimeService = TimeServiceConstructor();