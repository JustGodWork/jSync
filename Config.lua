--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thuesday March 19th 2024 10:36:28 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

Config = {}
Config.Timers = {}

Config.debug = false
Config.Timers.Clock = 1 -- Time in seconds between each update of the clock
Config.Timers.Weather = 30 -- Time in minutes between each update of the weather

--FOR ESX
Config.UseESX = false -- Use ESX commands system

Config.BlacklistedWeathers = {
	"OVERCAST",
	"XMAS",
	"SNOWLIGHT",
	"BLIZZARD",
	"HALLOWEEN",
};

--for any question or suggestion join my discord: https://discord.gg/DbuTNv9sqD