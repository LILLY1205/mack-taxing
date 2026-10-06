fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'

author 'phil'
description 'A tax script'
version '1.0.2'

server_script {
    'server/main.lua',
	'@oxmysql/lib/MySQL.lua'
}
client_script {
    'client/main.lua',
}
shared_scripts {
    'config.lua',
    '@rsg-core/shared/jobs.lua',
}
