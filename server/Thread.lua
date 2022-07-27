--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday July 27th 2022 1:47:48 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Thread
Thread = {}

function Thread:new(...)
    local self = {}
    setmetatable(self, {__index = Thread})

    self.looping = false

    function self:isActive()
        return self.looping
    end

    function self:loopWithCondition(condition, time, cb)
        if not self:isActive() then
            self.id = CreateThread(function()
                while condition do
                    cb()
                    Wait(time)
                end
            end)
        end
    end

    function self:loop(time, cb)
        if not self:isActive() then
            self.looping = true
            self.id = CreateThread(function()
                while self.looping do
                    cb()
                    Wait(time)
                end
            end)
        end
    end

    function self:create(cb)
        self.id = CreateThread(cb)
    end

    function self:timeout(time, cb)
        self.id = SetTimeout(time, cb)
    end

    function self:stop(cb)
        self.looping = false
        if cb then cb(self.looping) end
    end

    return self
end