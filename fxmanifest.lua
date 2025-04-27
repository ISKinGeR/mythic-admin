fx_version 'cerulean'
game 'gta5'
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"
server_script "@oxmysql/lib/MySQL.lua"

client_scripts {
    'client/client.lua',
    'client/attach.lua',
    'client/noclip/*.lua',
    'client/nui.lua',
    'client/ids.lua',
    'client/nuke.lua',
    'client/cl_commands.lua'
}

server_scripts {
    'server/*.lua',
}

ui_page 'ui/dist/index.html'

files {"ui/dist/index.html", 'ui/dist/*.js', "data/favlist.json", "db.json"}