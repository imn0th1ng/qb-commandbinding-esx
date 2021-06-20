fx_version 'adamant'

game 'gta5'

version '1.0'

author 'n0thing'

ui_page "html/index.html"

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server/main.lua"
}

client_scripts {
	"client/main.lua"
}

files {
	"html/*"
}
shared_script "config.lua"