resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
description "vRP Audio"

dependency "vrp"

ui_page "html/ui.html"

server_scripts{
    "@vrp/lib/utils.lua",
    "server/*.lua",
}

client_script{
    "@vrp/lib/utils.lua",
    "client/*.lua",
}

files{
    "cfg/config.lua",
    "html/*",
    "html/js/*",
}