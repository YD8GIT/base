fx_version "adamant"
games {"gta5"}

client_scripts {
    "ui/RMenu.lua",
    "ui/menu/RageUI.lua",
    "ui/menu/Menu.lua",
    "ui/menu/MenuController.lua",
    "ui/components/*.lua",
    "ui/menu/elements/*.lua",
    "ui/menu/items/*.lua",
    "ui/menu/panels/*.lua",
    "ui/menu/windows/*.lua",
}

shared_scripts {
    "shared/*.lua"
}

client_scripts {
    "client/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
}