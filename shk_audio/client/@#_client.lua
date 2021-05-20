Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

Audio = {}
Tunnel.bindInterface("shk_audio", Audio)
Proxy.addInterface("shk_audio", Audio)
Audioserver = Tunnel.getInterface("shk_audio")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cfg = module("shk_audio", "cfg/config")


function Audio.getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(GetPlayerPed(-1))
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    -- normalize
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end


-- AUDIO vRP
-- play audio source (once)
--- url: valid audio HTML url (ex: .ogg/.wav/direct ogg-stream url)
--- volume: 0-1
--- x,y,z: position (omit for unspatialized)
--- max_dist  (omit for unspatialized)

function Audio.playAudioSource(url, volume, x, y, z, max_dist)
    SendNUIMessage({act = "play_audio_source", url = url, x = x, y = y, z = z, volume = volume, max_dist = max_dist})
end

-- set named audio source (looping)
--- name: source name
--- url: valid audio HTML url (ex: .ogg/.wav/direct ogg-stream url)
--- volume: 0-1
--- x,y,z: position (omit for unspatialized)
--- max_dist  (omit for unspatialized)
function Audio.setAudioSource(name, url, volume, x, y, z, max_dist)
    SendNUIMessage({act = "set_audio_source", name = name, url = url, x = x, y = y, z = z, volume = volume, max_dist = max_dist})
end

-- remove named audio source
function Audio.removeAudioSource(name)
    SendNUIMessage({act = "remove_audio_source", name = name})
end

local listener_wait = math.ceil(1 / cfg.audio_listener_rate * 1000)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(listener_wait)
        
        local x, y, z
        if cfg.audio_listener_on_player then
            local ped = GetPlayerPed(PlayerId())
            x, y, z = table.unpack(GetPedBoneCoords(ped, 31086, 0, 0, 0))-- head pos
        else
            x, y, z = table.unpack(GetGameplayCamCoord())
        end
        
        local fx, fy, fz = Audio.getCamDirection()
        if x ~= nil and y ~= nil and z ~= nil and fx ~= nil and fy ~= nil and fz ~= nil then
            SendNUIMessage({act = "audio_listener", x = x, y = y, z = z, fx = fx, fy = fy, fz = fz})
        end
    end
end)