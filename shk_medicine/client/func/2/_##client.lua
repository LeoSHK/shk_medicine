closestObject = {}

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

-- props de macas, informar seu id
objModelList = {-1091386327, 2117668672, 1631638868, -1519439119, -289946279}

ModelList = {"4193282"}

inbedCoords = false
-- macas que não são objetos, informar coord x, y, z, heading onde o personagem vai deitar.
bedCoords = {
    [1] = {337.06,-575.13,44.19, 160.0},
    [2] = {348.42,-579.43,44.2, 160.0},
}

inBed = false
inCure = false
inCureTime = 0
local msg_a = false
local msg = ""
local s_bed = false

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '\n[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local function IsPointInSphere(x, y, z, cx, cy, cz, radius)
    local tx = (x - cx) ^ 2
    local ty = (y - cy) ^ 2
    local tz = (z - cz) ^ 2
    return (tx + ty + tz) <= radius ^ 2
end

function GetObject(radius)
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < radius and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
        end

        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function setInBed(entity, x, y, z, cHeading)
    Citizen.CreateThread(function()
        local player = GetPlayerPed(-1)
        local heading = 0
        if cHeading then
            heading = cHeading
        else
            heading = GetEntityHeading(entity) + 170
        end

        if not inBed then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            SetEntityHeading(player, heading)
            SetEntityCoords(player, x, y, z + 0.1)
            vRP._playAnim(false, {{"mini@cpr@char_b@cpr_str", "cpr_kol_idle", 1}}, true)
            -- FreezeEntityPosition(player, true)
            Citizen.Wait(1000)
            DoScreenFadeIn(500)
            inBed = true
        else
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            -- SetEntityCoords(player,x,y-2.0,z)
            vRP._stopAnim()
            -- FreezeEntityPosition(player, false)
            Citizen.Wait(1000)
            DoScreenFadeIn(500)
            inBed = false
        end
    end)
end

function vRPmedc.setClosestObject(obj)
    if DoesObjectOfTypeExistAtCoords(323.12911987305, -584.93566894531, 43.284004211426, 5.0, obj, true) then
        local uObj = GetClosestObjectOfType(323.12911987305, -584.93566894531, 43.284004211426, 5.9, obj, false, false,
                         false)

        if uObj ~= nil then
            local pos = GetEntityCoords(uObj)
            setInBed(uObj, pos["x"], pos["y"], pos["z"] + 1)
        end
    end
end

function vRPmedc.getStatusInBed()
    return inBed
end

local typeCure = {
    ["bag_blood"] = {
        act = function(time)
            vRPmedc.openUiTransBagBlood(time)
        end,
        cancel = function()
            vRPmedc.closeUiTransBagBlood()
        end
    },
    ["bag_soro"] = {
        act = function(time)
            vRPmedc.openUiTransBagSoro(time)
        end
    },
    ["bag_soroleoerd"] = {
        act = function(time)
            vRPmedc.openUiTransBagSoroLeoerd(time)
        end
    }
}

function vRPmedc.setTimeCure(time, type)
    if type then
        typeCure[type].act(time)
    end
    inCure = true
    vRP._setDisableControls(true)
    inCureTime = time
    TriggerEvent("essentials:playerincure", inCure)
end

function vRPmedc.getStatusCure()
    return inCure
end

function vRPmedc.setPedModelLegs()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 4, 84, 9, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 4, 86, 9, 2)
    end
end

function vRPmedc.removePedModelLegs()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 4, 14, 1, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 4, 16, 1, 2)
    end
end

function vRPmedc.setPedModelBoots()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 6, 47, 7, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 6, 48, 7, 2)
    end
end

function vRPmedc.removePedModelBoots()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 6, 5, 1, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 6, 5, 1, 2)
    end
end

function vRPmedc.setPedModelTop()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 11, 186, 9, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 11, 188, 9, 2)
    end
end

function vRPmedc.removePedModelTop()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 11, 188, 0, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 11, 190, 0, 2)
    end
end

function vRPmedc.setPedModelHands()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 3, 167, 0, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 3, 208, 0, 2)
    end
end

function vRPmedc.removePedModelHands()
    local ped = GetPlayerPed(-1)
    if IsPedModel(ped, "mp_m_freemode_01") then
        SetPedComponentVariation(ped, 3, 15, 0, 2)
    elseif IsPedModel(ped, "mp_f_freemode_01") then
        SetPedComponentVariation(ped, 3, 15, 0, 2)
    end
end

local function getNearObjects()
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    for v = 1, #objModelList, 1 do
        local getObj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 4.0, objModelList[v], false, false, false)
        if getObj ~= 0 then
            local objectCoords = GetEntityCoords(getObj)
            local distance = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)
            if distance < 2.3 then
                return true, getObj, objectCoords
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        -- local getObj = GetObjects()
        local coords = GetEntityCoords(player)

        local ok, obj, objCoords = getNearObjects()

        if not inbedCoords then
            if ok and not inCure then
                s_bed = true
                closestObject.obj = obj
                closestObject.x = objCoords["x"]
                closestObject.y = objCoords["y"]
                closestObject.z = objCoords["z"] + 1
                msg_a = true
            else
                s_bed = false
                msg_a = false
                closestObject = {}
            end
        end
        Citizen.Wait(2000)
    end
end)

local button_action = false
local button_actived = false

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        if s_bed then
            button_action = IsControlJustPressed(0, 75)
            if button_action then
                button_actived = true
                button_action = false
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if closestObject.obj ~= nil then
            if button_actived and not inbedCoords then
                if not inCure then
                    setInBed(closestObject.obj, closestObject.x, closestObject.y, closestObject.z)
                else
                    vRP._notify("Você está ~r~em tratamento, ~w~aguarde finalizar.")
                end
                button_actived = false
            end
            if not inCure then
                if inBed then
                    msg = "Pressione ~g~F ~w~para levantar"
                else
                    msg = "Pressione ~g~F ~w~para deitar"
                end
            end
        end
        Citizen.Wait(500)
    end
end)

inBedControl = {}

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(bedCoords) do
            local player = GetPlayerPed(-1)
            local px, py, pz = table.unpack(GetEntityCoords(player, false))

            local p_in = IsPointInSphere(px, py, pz, v[1], v[2], v[3], 2.0)

            if not v.p_in and p_in then
                inbedCoords = true
                v.p_in = true
            end

            if v.p_in and p_in then
                s_bed = true
                closestObject.obj = -1
                closestObject.x = v[1]
                closestObject.y = v[2]
                closestObject.z = v[3]
                msg_a = true
                if button_actived then
                    button_actived = false
                    setInBed(closestObject.obj, closestObject.x, closestObject.y, closestObject.z, v[4])
                end
            end

            if v.p_in and not p_in then
                s_bed = false
                msg_a = false

                closestObject = {}
                inbedCoords = false
                v.p_in = false
            end
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if msg_a then
            drawTxt(msg, 4, 0.5, 0.95, 0.40, 255, 255, 255, 200)
            Citizen.Wait(10)
        else
            Citizen.Wait(1000)
        end
    end
end)

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

function curePlayer()
    Citizen.CreateThread(function()
        vRP._setHealth(400)        
        TriggerEvent("Notify","sucesso","Seu tratamento foi finalizado, você está bem agora.")
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if inCure then
            inCureTime = inCureTime - 1
            if inCureTime <= 0 then
                inCureTime = 0
                inCure = false
                curePlayer()
                vRP._setDisableControls(false)
                TriggerEvent("essentials:playerincure", inCure)
            end
        end
    end
end)

function vRPmedc.setCancelCure(type)
    if type then
        typeCure[type].cancel()
    end
    inCure = false
    inCureTime = 0
    vRP._setDisableControls(false)
    TriggerEvent("essentials:playerincure", inCure)
end

Citizen.CreateThread(function()
    while true do
        if inCureTime > 0 then
            -- drawTxt(0.66,1.462,1.0,1.0,0.40 , "~w~Você está em tratamento, restando ~o~"..secondsToClock(inCureTime).." ~w~ para finalizar.")
            drawTxt(
                "~w~Você está em tratamento, restando ~o~" .. secondsToClock(inCureTime) .. " ~w~ para finalizar.", 6,
                0.5, 0.97, 0.30, 255, 255, 255, 200)
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end

    end
end)

-- drawTxt("PRINCIPAL", 4, 0.5, 0.95, 0.40, 255, 255, 255, 200)
-- drawTxt("SUBTEXTO", 6, 0.5, 0.97, 0.30, 255, 255, 255, 200)
function drawTxt(text, font, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- customs
function secondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds / 3600));
        mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
        secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
        return hours .. ":" .. mins .. ":" .. secs
    end
end

function vRPmedc.openUiRay(tbody, pasc, doctor)
    SetNuiFocus(true, true)
    SendNUIMessage({
        act = "xray-menu",
        body = tbody,
        pasc = pasc,
        doctor = doctor
    })
end

function vRPmedc.openUiBottleBlood()
    SendNUIMessage({
        act = "blood_bottle_display"
    })
end

function vRPmedc.openUiBagBlood()
    SendNUIMessage({
        act = "blood_bag_display"
    })
end

function vRPmedc.openUiTransBagSoro(time)
    SendNUIMessage({
        act = "soro_bag_display",
        time = time
    })
end

function vRPmedc.openUiTransBagSoroLeoerd(time)
    SendNUIMessage({
        act = "soro_leoerd_bag_display",
        time = time
    })
end

function vRPmedc.openUiTransBagBlood(time)
    SendNUIMessage({
        act = "trans_blood_bag_display",
        time = time
    })
end

function vRPmedc.closeUiTransBagBlood()
    SendNUIMessage({
        act = "trans_blood_bag_cancel"
    })
end

function vRPmedc.closeUiRay()
    SetNuiFocus(false)
    vRP._stopAnim()
    SendNUIMessage({
        act = "close"
    })
end

function vRPmedc.sendBloodCountInfos(pasc, doctor)
    SetNuiFocus(true, true)
    SendNUIMessage({
        act = "info_blood_count",
        pasc = pasc,
        doctor = doctor
    })
end

function vRPmedc.openUIReceptions(receptions)
    SetNuiFocus(true, true)
    SendNUIMessage({
        act = "reception_list",
        receptions = receptions
    })
end

function vRPmedc.sendToxicCountInfos(pasc, doctor)
    SetNuiFocus(true, true)
    SendNUIMessage({
        act = "info_toxic_count",
        pasc = pasc,
        doctor = doctor
    })
end

RegisterNUICallback('close', function(data, cb)
    vRPmedc.closeUiRay()
    cb('ok')
end)

RegisterNUICallback('recepctionAccept', function(data, cb)
    MEserver.registerDoutorReception(data.user)
    cb('ok')
end)

RegisterNUICallback('recepctionAcceptBip', function(data, cb)
    MEserver.sendBipMessage(data.user)
    cb('ok')
end)

RegisterNUICallback('recepctionExit', function(data, cb)
    MEserver.cleanReceptionUser(data.user)
    cb('ok')
end)


local function checkCoord()
    for k, v in pairs(cfg.exames) do
        for id, coord in pairs(v.coords) do
            local player = GetPlayerPed(-1)
            local x, y, z = table.unpack(GetEntityCoords(player, true))
            local dist = GetDistanceBetweenCoords(x, y, z, coord[1], coord[2], coord[3], true)
            if dist <= 0.8 then
                return true, k, id
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local ok, spoot, coordid = checkCoord()
        if ok and spoot then
            local exame = cfg.exames[spoot]
            if exame then
                drawTxt(exame.msg, 6, 0.5, 0.97, 0.30, 255, 255, 255, 200)
                if exame.btn and IsControlJustPressed(0, exame.btn) then

                    MEserver._execExame(spoot, coordid)
                end
            end
        end
        Citizen.Wait(0)
    end

end)

-- drawTxt("PRINCIPAL", 4, 0.5, 0.95, 0.40, 255, 255, 255, 200)
-- drawTxt("SUBTEXTO", 6, 0.5, 0.97, 0.30, 255, 255, 255, 200)
function drawTxt(text, font, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local function removeClosestObj(prop_name)
    local playerPedPos = GetEntityCoords(GetPlayerPed(-1), true)
    local obj = GetClosestObjectOfType(playerPedPos, 10.0, GetHashKey(prop_name), false, false, false)

    if (IsPedActiveInScenario(GetPlayerPed(-1)) == false) then
        SetEntityAsMissionEntity(obj, 1, 1)
        DeleteEntity(obj)
    end
end
--
function vRPmedc.createObj(prop_name, time, xPos, yPos, zPos, xRot, yRot, zRot)
    local player = PlayerPedId()

    if (DoesEntityExist(player) and not IsEntityDead(player)) then
        removeClosestObj(prop_name)
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
        local x, y, z = table.unpack(GetEntityCoords(player))
        prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
        AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 18905), xPos, yPos, zPos, xRot, yRot, zRot, true,
            true, false, true, 1, true)
        SetTimeout(time * 1000, function()
            DetachEntity(prop, 1, 1)
            DeleteObject(prop)
            DeleteEntity(prop)
        end)
    end
end
