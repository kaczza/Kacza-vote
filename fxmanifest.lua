-- __| |____________________________________________| |__
--(__   ____________________________________________   __)
 --  | |                                            | |
---  | |                                            | |
   --| |                                            | |
   --| |            Script BY.: Kacza               | |
   --| |                                            | |
   --| |                                            | |
   --| |                                            | |
 --__| |____________________________________________| |__
--(__   ____________________________________________   __)
--   | |                                            | |
fx_version 'cerulean'
file "@SecureServe/secureserve.key"
game 'gta5'
author 'Kacza'
lua54 'yes'
description 'Kz-eventsystem'

shared_script 'config.lua'
client_script 'client/*.lua'
client_script '@ox_lib/init.lua'
server_script 'server/*.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css'
}

escrow_ignore 'config.lua'

