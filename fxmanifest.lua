--[[
--Created Date: Wednesday July 27th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday July 27th 2022 1:33:26 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

fx_version('cerulean')
game('gta5')

lua54 'yes'

shared_script "Config.lua"

server_scripts {
    '@es_extended/imports.lua',
    "server/Thread.lua",
    "server/Weather.lua",
    "server/Time.lua"
}

client_script "client/listener.lua"