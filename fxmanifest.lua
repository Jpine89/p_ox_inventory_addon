fx_version 'cerulean'
game 'gta5'
lua54 'yes'
 
name 'p_ox_inventory_addon'
description 'In-house Inventory Addon for ox_inventory'
author 'ARPCity Dev Team'
version '1.0.0'

dependencies {
    'ox_lib',
    'ox_inventory',
    --'ox_doorlock'
}

shared_scripts {
    '@ox_lib/init.lua',
    'magazine/config/*.lua'
}

client_scripts {
    'magazine/client.lua'
}

server_scripts {
    'magazine/server.lua'
}
