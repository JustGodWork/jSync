--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday July 27th 2022 12:51:46 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Time
local _Time = {}

function _Time:new()
    local self = {}
    setmetatable(self, { __index = _Time })
    self.currentHour = math.random(0, 23)
    self.currentMinute = math.random(0, 59)
    self.frozen = false
    self.thread = Thread:new()

    function self:setCurrentTime(hour, minute)
        if type(hour) ~= "number" or type(minute) ~= "number" then
            return print("^7[^1TIME SYSTEM^7]^3 Invalid time format.^7")
        end  
        self.currentHour = (hour and math.floor(hour)) or self.currentHour
        self.currentMinute = (minute and math.floor(minute)) or self.currentMinute
        self:sync()
    end

    ---Return current hour and current minute
    ---@return number, number
    function self:getCurrentTime()
        return self.currentHour, self.currentMinute
    end

    function self:start()
        self.thread:loop(Config.Timers.Clock * 1000, function()
            if not self.frozen then
                self.currentMinute = self.currentMinute + 1
                if self.currentMinute > 59 then self.currentMinute = 0 
                    self.currentHour = self.currentHour + 1
                    if self.currentHour > 23 then self.currentHour = 0 end
                end
            end
            self:sync()
        end)
    end

    ---@param cb fun(active:boolean)
    function self:freezeTime(hour, minutes, cb)
        if not self.frozen then
            if cb then cb(true) end
            self.frozen = true
            self:setCurrentTime(
                (hour and tonumber(hour)) or self.currentHour,
                (minutes and tonumber(minutes)) or self.currentMinute
            )
        else
            if cb then cb(false) end
            self.frozen = false
        end
    end

    function self:sync()
        TriggerClientEvent("jSync:setClockTime", -1, self.currentHour, self.currentMinute)
    end

    return self
end

Time = _Time:new()

Time:start()