resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
description "vrp_i9_medicine"

dependency "vrp"

ui_page "html/ui.html"

server_scripts{
    "@vrp/lib/utils.lua",
    "server/**/1/*.lua",
    "server/**/2/*.lua",
}

client_script{
    "@vrp/lib/utils.lua",
    "lib/enumerates.lua",
    "client/**/1/*.lua",
    "client/**/2/*.lua",
}

files{
    "cfg/*",
    "html/*",
    "html/css/*",
    "html/images/raiox/*",
    "html/images/bloods/*",
    "html/js/*",

    "sounds/*",
    -- "sounds/x-ray.mp3",
    -- "sounds/x-ray2.mp3",
    -- "sounds/x-ray3.mp3",
    -- "sounds/centrifuger.mp3"
}
