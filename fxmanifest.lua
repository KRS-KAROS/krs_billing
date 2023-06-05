fx_version 'cerulean'
game 'gta5'
lua54 'yes'

Name 'krs_billing'
Author '𝗞𝗥𝗦®'
version "1.0.0"

Discord 'https://discord.gg/wM4XDaXfU8' -- 𝗞𝗥𝗦® --

shared_script {
    "@es_extended/imports.lua",
    "@ox_lib/init.lua"
}


client_script {
    'client.lua',
}

server_script {

    'server.lua'
}

dependencies {
    'ox_target',
    'ox_lib',
    'ox_inventory'
}
