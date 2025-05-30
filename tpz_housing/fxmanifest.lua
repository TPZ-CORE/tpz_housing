fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Nosmakos'
description 'TPZ-CORE - Housing'
version '1.0.0'

shared_scripts { 'config.lua', 'locales.lua'}
client_scripts { 'doorhashes.lua', 'client/*.lua' }
server_scripts { 'server/*.lua' }

lua54 'yes'