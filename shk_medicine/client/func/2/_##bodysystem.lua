local spawned = false

-- controls
local s_ragDoll = 0
local s_flash = false
local s_shake = false
local s_movement = 1.0
local s_limp = false
local s_sprit = false
local s_blockW = 0
local s_blockW_a = false
local s_bleeding = false

local noClip = false

AddEventHandler("essentials:playernoclip", function(noclip)
    noClip = noclip
end)

local weapons_shot = {"WEAPON_PISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_SNSPISTOL",
                      "WEAPON_COMBATPISTOL", "WEAPON_COMPACTRIFLE", "WEAPON_MUSKET", "WEAPON_PISTOL50", "WEAPON_SMG",
                      "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_CARBINERIFLE_MK2", "WEAPON_COMBATPDW",
                      "WEAPON_PUMPSHOTGUN", "WEAPON_GUSENBERG", "WEAPON_PISTOL_MK2"}

BodyParts = {
    ['HEAD'] = {
        label = 'Cabeça',
        severity = 0,
        max_severity = 10.0,
        severity_active = false,
        severity_shot = false
    },
    ['NECK'] = {
        label = 'Pescoço',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    },
    ['SPINE'] = {
        label = 'Coluna Vertebral',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    },
    ['UPPER_BODY'] = {
        label = 'Tronco',
        severity = 0,
        max_severity = 10.0,
        severity_active = false,
        severity_shot = false
    },
    ['LOWER_BODY'] = {
        label = 'Quadril',
        severity = 0,
        max_severity = 10.0,
        severity_active = false,
        severity_shot = false
    },
    ['LARM'] = {
        label = 'Braço Esquerdo',
        severity = 0,
        max_severity = 10.0,
        severity_active = false,
        severity_shot = false
    },
    ['LHAND'] = {
        label = 'Mão esquerda',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    },
    ['LFINGER'] = {
        label = 'Dedos Mão esquerda',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    },
    ['LLEG'] = {
        label = 'Perna Esquerda',
        severity = 0,
        max_severity = 10.0,
        severity_active = false,
        severity_shot = false
    },
    ['LFOOT'] = {
        label = 'Pé Esquerdo',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    },
    ['RARM'] = {
        label = 'Braço Direito',
        severity = 0,
        max_severity = 10.0,
        severity_active = false,
        severity_shot = false
    },
    ['RHAND'] = {
        label = 'Mão direita',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    },
    ['RFINGER'] = {
        label = 'Dedos Mão direita',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    },
    ['RLEG'] = {
        label = 'Perna Direita',
        severity = 0,
        max_severity = 10.0,
        severity_active = false,
        severity_shot = false
    },
    ['RFOOT'] = {
        label = 'Pé Direito',
        severity = 0,
        max_severity = 10.0,
        severity_active = false
    }
}

Medicaments = {
    ["analgesic"] = {
        value = 0,
        rec = 0.3,
        var = 0.5
    },
    ["antibiotic"] = {
        value = 0,
        rec = 0.3,
        var = 0.5
    },
    ["antiinflammatory"] = {
        value = 0,
        rec = 0.3,
        var = 0.5
    }
}

Acessories = {
    ["orthosuperior"] = {
        rec = 0.3,
        equiped = false
    },
    ["orthoinferior"] = {
        rec = 0.3,
        equiped = false
    },
    ["orthoboot"] = {
        rec = 0.3,
        equiped = false
    },
    ["handplint"] = {
        rec = 0.3,
        equiped = false
    }
}

drugs = {
    ["drug"] = {
        severity = 0
    },
    ["alcool"] = {
        severity = 0
    }
}

Metabolism = {
    ["energy"] = {
        value = 0
    }
}

function vRPmedc.setDrugsValue(type, value)
    if drugs[type] then
        drugs[type].severity = value
    end
end
-- RaceTurbo pisca a tela
-- ChopVision efeito de tela com pouca distorção
-- movimentos
-- MOVE_M@BAIL_BOND_TAZERED anda devagar com dificuldades
ped_effects = {
    ["drugs"] = {
        act = function()
            Citizen.CreateThread(function()
                playMovement("MOVE_M@BAIL_BOND_TAZERED", false)
            end)

        end,
        cancel = function()
            resetMovement()
        end,
        active = false,
        time = 0
    },
    ["alcool"] = {
        act = function()
            Citizen.CreateThread(function()
                playMovement("MOVE_M@DRUNK@VERYDRUNK", false)
            end)
        end,
        cancel = function()
            resetMovement()
        end,
        active = false,
        time = 0
    },
    ["injured"] = {
        act = function()
            Citizen.CreateThread(function()
                playMovement("move_m@injured", false)
            end)
        end,
        cancel = function()
            resetMovement()
        end,
        active = false,
        time = 0,
        priority = true
    },
    ["buzzed"] = {
        act = function()
            Citizen.CreateThread(function()
                playMovement("move_m@buzzed", false)
            end)
        end,
        cancel = function()
            resetMovement()
        end,
        active = false,
        time = 0,
        priority = true
    }
}

local function checkAllPedEffectsActive()
    for k, v in pairs(ped_effects) do
        if v.active == true then
            return true
        end
    end
    return false
end

function vRPmedc.setPedEffects(type, time)
    local ef = ped_effects[type]
    if ef then
        if (ef.priority or not checkAllPedEffectsActive()) and ef.time <= 0 then
            ef.act()
            ef.time = time
            ef.active = true
        elseif ef.active and ef.time <= 30000 then
            ef.time = ef.time + time
        end
    end
end

-- simples RaceTurbo
--
ped_screen_effects = {
    ["l"] = {
        act = function()
            StartScreenEffect("RaceTurbo", 0, true)
            -- StartScreenEffect("Rampage", 0, true)
            -- StartScreenEffect("DMT_flight", 0, true)
        end,
        cancel = function()
            StopScreenEffect("RaceTurbo")
        end,
        active = false,
        time = 0
    },
    ["m"] = {
        act = function()
            StartScreenEffect("Rampage", 0, true)
        end,
        cancel = function()
            StopScreenEffect("Rampage")
        end,
        active = false,
        time = 0
    },
    ["h"] = {
        act = function()
            StartScreenEffect("ChopVision", 0, true)
        end,
        cancel = function()
            StopScreenEffect("ChopVision")
        end,
        active = false,
        time = 0
    },
    ["vh"] = {
        act = function()
            StartScreenEffect("DMT_flight", 0, true)
        end,
        cancel = function()
            StopScreenEffect("DMT_flight")
        end,
        active = false,
        time = 0
    }
}

function vRPmedc.setPedScreenEffects(type, time)
    local ef = ped_screen_effects[type]
    if ef then
        if not ef.active and ef.time <= 0 then
            ef.act()
            ef.time = time
            ef.active = true
        elseif ef.active and ef.time <= 30000 then
            ef.time = ef.time + time
        end
    end
end

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(ped_effects) do
            if v.active and v.time > 0 then
                v.time = v.time - 1000
                if v.time <= 0 then
                    v.cancel()
                    v.active = false
                    v.time = 0
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(ped_screen_effects) do
            if v.active and v.time > 0 then
                v.time = v.time - 1000
                if v.time <= 0 then
                    v.cancel()
                    v.active = false
                    v.time = 0
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

function vRPmedc.setMedInfos(medinfo)
    if medinfo then
        Medicaments["analgesic"].value = medinfo.analgesic
        Medicaments["antibiotic"].value = medinfo.antibiotic
        Medicaments["antiinflammatory"].value = medinfo.antiinflammatory
    end
end

function vRPmedc.setAcesInfos(medinfo)
    if medinfo then
        Acessories["orthosuperior"].equiped = medinfo.orthosuperior
        Acessories["orthoinferior"].equiped = medinfo.orthoinferior
        Acessories["orthoboot"].equiped = medinfo.orthoboot
        Acessories["handplint"].equiped = medinfo.handplint
    end
end

function vRPmedc.setBodyParts(parts)
    BodyParts["HEAD"].severity = parts.HEAD
    BodyParts["HEAD"].severity_shot = parts.HEAD_SH
    BodyParts["NECK"].severity = parts.NECK
    BodyParts["SPINE"].severity = parts.SPINE
    BodyParts["UPPER_BODY"].severity = parts.UPPER_BODY
    BodyParts["UPPER_BODY"].severity_shot = parts.UPPER_BODY_SH
    BodyParts["LOWER_BODY"].severity = parts.LOWER_BODY
    BodyParts["LOWER_BODY"].severity_shot = parts.LOWER_BODY_SH
    BodyParts["LARM"].severity = parts.LARM
    BodyParts["LARM"].severity_shot = parts.LARM_SH
    BodyParts["LHAND"].severity = parts.LHAND
    BodyParts["LFINGER"].severity = parts.LFINGER
    BodyParts["LLEG"].severity = parts.LLEG
    BodyParts["LLEG"].severity_shot = parts.LLEG_SH
    BodyParts["LFOOT"].severity = parts.LFOOT
    BodyParts["RARM"].severity = parts.RARM
    BodyParts["RARM"].severity_shot = parts.RARM_SH
    BodyParts["RHAND"].severity = parts.RHAND
    BodyParts["RFINGER"].severity = parts.RFINGER
    BodyParts["RLEG"].severity = parts.RLEG
    BodyParts["RLEG"].severity_shot = parts.RLEG_SH
    BodyParts["RFOOT"].severity = parts.RFOOT
end

function vRPmedc.setSpawnedPlayer()
    spawned = true
end

function vRPmedc.setMedicament(part, value, rec)
    if part then
        local med = Medicaments[part]
        if med then
            if Medicaments[part].value <= 0 then
                Medicaments[part].value = value
                if rec and rec > 0 then
                    Medicaments[part].rec = Medicaments[part].rec + rec
                end
                return true
            end
        end
        return false
    end
end

function vRPmedc.setAcessory(part, toggle)
    if part then
        local med = Acessories[part]
        if med then
            Acessories[part].equiped = toggle
        end
    end
end

function vRPmedc.getAcessoryStatus(part)
    if part then
        local med = Acessories[part]
        if med then
            return med.equiped
        end
    end
    return false
end

function vRPmedc.setBodyPartTypeShot(type, value)
    if BodyParts[type] then
        BodyParts[type].severity_shot = value
    end
end

function vRPmedc.setBodyPartType(type, value)
    if BodyParts[type] then
        BodyParts[type].severity = value
    end
end

-- medicaments cure
Citizen.CreateThread(function()
    while true do
        if spawned then
            local rec_pill = 0

            if Medicaments["analgesic"].value > 0 then

                rec_pill = rec_pill + Medicaments["analgesic"].rec
                Medicaments["analgesic"].value = Medicaments["analgesic"].value - Medicaments["analgesic"].var
                if Medicaments["analgesic"].value < 0 then
                    Medicaments["analgesic"].value = 0
                end
                if Medicaments["analgesic"].value == 0 then
                    Medicaments["analgesic"].rec = 0.3
                end

            elseif Medicaments["antibiotic"].value > 0 then

                rec_pill = rec_pill + Medicaments["antibiotic"].rec
                Medicaments["antibiotic"].value = Medicaments["antibiotic"].value - Medicaments["antibiotic"].var
                if Medicaments["antibiotic"].value < 0 then
                    Medicaments["antibiotic"].value = 0
                end

            elseif Medicaments["antiinflammatory"].value > 0 then

                rec_pill = rec_pill + Medicaments["antiinflammatory"].rec
                Medicaments["antiinflammatory"].value = Medicaments["antiinflammatory"].value -
                                                            Medicaments["antiinflammatory"].var
                if Medicaments["antiinflammatory"].value < 0 then
                    Medicaments["antiinflammatory"].value = 0
                end
            end

            local rec_osup = 0

            if rec_pill > 0 then
                rec_osup = rec_osup + rec_pill
            end

            if Acessories["orthosuperior"].equiped == true then
                rec_osup = rec_osup + Acessories["orthosuperior"].rec
                vRPmedc.setPedModelTop()
            end

            if BodyParts["HEAD"].severity > 0 and rec_osup > 0 then
                BodyParts["HEAD"].severity = BodyParts["HEAD"].severity - rec_osup
                if BodyParts["HEAD"].severity < 0 then
                    BodyParts["HEAD"].severity = 0
                end
            end

            if BodyParts["NECK"].severity > 0 and rec_osup > 0 then
                BodyParts["NECK"].severity = BodyParts["NECK"].severity - rec_osup
                if BodyParts["NECK"].severity < 0 then
                    BodyParts["NECK"].severity = 0
                end
            end

            if BodyParts["SPINE"].severity > 0 and rec_osup > 0 then
                BodyParts["SPINE"].severity = BodyParts["SPINE"].severity - rec_osup
                if BodyParts["SPINE"].severity < 0 then
                    BodyParts["SPINE"].severity = 0
                end
            end

            if BodyParts["UPPER_BODY"].severity > 0 and rec_osup > 0 then
                BodyParts["UPPER_BODY"].severity = BodyParts["UPPER_BODY"].severity - rec_osup
                if BodyParts["UPPER_BODY"].severity < 0 then
                    BodyParts["UPPER_BODY"].severity = 0
                end
            end

            if BodyParts["LARM"].severity > 0 and rec_osup > 0 then
                BodyParts["LARM"].severity = BodyParts["LARM"].severity - rec_osup
                if BodyParts["LARM"].severity < 0 then
                    BodyParts["LARM"].severity = 0
                end
            end

            if BodyParts["RARM"].severity > 0 and rec_osup > 0 then
                BodyParts["RARM"].severity = BodyParts["RARM"].severity - rec_osup
                if BodyParts["RARM"].severity < 0 then
                    BodyParts["RARM"].severity = 0
                end
            end

            local rec_oinf = 0
            if rec_pill > 0 then
                rec_oinf = rec_oinf + rec_pill
            end

            if Acessories["orthoinferior"].equiped == true then
                rec_oinf = rec_oinf + Acessories["orthoinferior"].rec
                vRPmedc.setPedModelLegs()
            end

            if BodyParts["LOWER_BODY"].severity > 0 and rec_oinf > 0 then
                BodyParts["LOWER_BODY"].severity = BodyParts["LOWER_BODY"].severity - rec_oinf
                if BodyParts["LOWER_BODY"].severity < 0 then
                    BodyParts["LOWER_BODY"].severity = 0
                end
            end

            if BodyParts["LLEG"].severity > 0 and rec_oinf > 0 then
                BodyParts["LLEG"].severity = BodyParts["LLEG"].severity - rec_oinf
                if BodyParts["LLEG"].severity < 0 then
                    BodyParts["LLEG"].severity = 0
                end
            end

            if BodyParts["RLEG"].severity > 0 and rec_oinf > 0 then
                BodyParts["RLEG"].severity = BodyParts["RLEG"].severity - rec_oinf
                if BodyParts["RLEG"].severity < 0 then
                    BodyParts["RLEG"].severity = 0
                end
            end

            local rec_oboot = 0

            if rec_pill > 0 then
                rec_oboot = rec_oboot + rec_pill
            end

            if Acessories["orthoboot"].equiped == true then
                rec_oboot = rec_oboot + Acessories["orthoboot"].rec
                vRPmedc.setPedModelBoots()
            end

            if BodyParts["LFOOT"].severity > 0 and rec_oboot > 0 then
                BodyParts["LFOOT"].severity = BodyParts["LFOOT"].severity - rec_oboot
                if BodyParts["LFOOT"].severity < 0 then
                    BodyParts["LFOOT"].severity = 0
                end
            end

            if BodyParts["RFOOT"].severity > 0 and rec_oboot > 0 then
                BodyParts["RFOOT"].severity = BodyParts["RFOOT"].severity - rec_oboot
                if BodyParts["RFOOT"].severity < 0 then
                    BodyParts["RFOOT"].severity = 0
                end
            end

            local rec_ohand = 0

            if rec_pill > 0 then
                rec_ohand = rec_ohand + rec_pill
            end

            if Acessories["handplint"].equiped == true then
                rec_ohand = rec_ohand + Acessories["handplint"].rec
                vRPmedc.setPedModelHands()
            end

            if BodyParts["LHAND"].severity > 0 and rec_ohand > 0 then
                BodyParts["LHAND"].severity = BodyParts["LHAND"].severity - rec_ohand
                if BodyParts["LHAND"].severity < 0 then
                    BodyParts["LHAND"].severity = 0
                end
            end

            if BodyParts["LFINGER"].severity > 0 and rec_ohand > 0 then
                BodyParts["LFINGER"].severity = BodyParts["LFINGER"].severity - rec_ohand
                if BodyParts["LFINGER"].severity < 0 then
                    BodyParts["LFINGER"].severity = 0
                end
            end

            if BodyParts["RHAND"].severity > 0 and rec_ohand > 0 then
                BodyParts["RHAND"].severity = BodyParts["RHAND"].severity - rec_ohand
                if BodyParts["RHAND"].severity < 0 then
                    BodyParts["RHAND"].severity = 0
                end
            end

            if BodyParts["RFINGER"].severity > 0 and rec_ohand > 0 then
                BodyParts["RFINGER"].severity = BodyParts["RFINGER"].severity - rec_ohand
                if BodyParts["RFINGER"].severity < 0 then
                    BodyParts["RFINGER"].severity = 0
                end
            end

        end

        Citizen.Wait(60000)
    end

end)

-- Citizen.CreateThread(function()
--     while true do
--         if spawned then
--             for k, v in pairs(BodyParts) do
--                 vRP._notify(v.label .. "/" .. v.severity)
--             end
--         end
--         Citizen.Wait(4000)
--     end
-- end)
-- SetPlayerSprint(PlayerId(), true) arrancada? correr?
local parts = {
    [0] = 'NONE',
    [31085] = 'HEAD',
    [31086] = 'HEAD',
    [39317] = 'NECK',
    [57597] = 'SPINE',
    [23553] = 'SPINE',
    [24816] = 'SPINE',
    [24817] = 'SPINE',
    [24818] = 'SPINE',
    [10706] = 'UPPER_BODY',
    [64729] = 'UPPER_BODY',
    [11816] = 'LOWER_BODY',
    [45509] = 'LARM',
    [61163] = 'LARM',
    [18905] = 'LHAND',
    [4089] = 'LFINGER',
    [4090] = 'LFINGER',
    [4137] = 'LFINGER',
    [4138] = 'LFINGER',
    [4153] = 'LFINGER',
    [4154] = 'LFINGER',
    [4169] = 'LFINGER',
    [4170] = 'LFINGER',
    [4185] = 'LFINGER',
    [4186] = 'LFINGER',
    [26610] = 'LFINGER',
    [26611] = 'LFINGER',
    [26612] = 'LFINGER',
    [26613] = 'LFINGER',
    [26614] = 'LFINGER',
    [58271] = 'LLEG',
    [63931] = 'LLEG',
    [2108] = 'LFOOT',
    [14201] = 'LFOOT',
    [40269] = 'RARM',
    [28252] = 'RARM',
    [57005] = 'RHAND',
    [58866] = 'RFINGER',
    [58867] = 'RFINGER',
    [58868] = 'RFINGER',
    [58869] = 'RFINGER',
    [58870] = 'RFINGER',
    [64016] = 'RFINGER',
    [64017] = 'RFINGER',
    [64064] = 'RFINGER',
    [64065] = 'RFINGER',
    [64080] = 'RFINGER',
    [64081] = 'RFINGER',
    [64096] = 'RFINGER',
    [64097] = 'RFINGER',
    [64112] = 'RFINGER',
    [64113] = 'RFINGER',
    [36864] = 'RLEG',
    [51826] = 'RLEG',
    [20781] = 'RFOOT',
    [52301] = 'RFOOT'
}

function GetDamagingWeapon(ped)

    for _, v in pairs(weapons_shot) do
        if HasPedBeenDamagedByWeapon(ped, v, 0) then
            ClearEntityLastDamageEntity(ped)
            return true
        end
    end

    return false
end

Citizen.CreateThread(function()
    local player = PlayerPedId()

    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armour = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmour then
            playerArmour = armour
        end

        if player ~= ped then
            player = ped
            playerHealth = health
            playerArmour = armour
        end

        local armourDamaged =
            (playerArmour ~= armour and armour < playerArmour and armour > 0) -- Players armour was damaged
            -- Players armour was damaged
        local healthDamaged = (playerHealth ~= health and health < playerHealth) -- Players health was damaged
        -- Players health was damaged

        if armourDamaged or healthDamaged and not noClip then
            local hit, bone = GetPedLastDamageBone(player)
            local bodypart = parts[bone]

            if hit and bodypart ~= 'NONE' then
                local dm = GetDamagingWeapon(player)
                if dm then
                    if BodyParts[bodypart].severity_shot ~= nil and BodyParts[bodypart].severity_shot == false then
                        local r = math.random(1, 10)
                        if r == 5 then
                            BodyParts[bodypart].severity_shot = true
                        end
                    end
                end

                BodyParts[bodypart].severity = BodyParts[bodypart].severity + 1.0

                -- define max severity
                if BodyParts[bodypart].severity > BodyParts[bodypart].max_severity then
                    BodyParts[bodypart].severity = BodyParts[bodypart].max_severity
                end
            end
        end

        playerHealth = health
        playerArmour = armour
        Citizen.Wait(300)
    end
end)

Citizen.CreateThread(function()
    while true do
        if s_ragDoll > 0 and not inBed and not Acessories["orthoinferior"].equiped then
            local ped = PlayerPedId()
            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                SetPedToRagdollWithFall(ped, 5000, 12000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.0)
            end
            Citizen.Wait(30000)
        else
            Citizen.Wait(1000)
        end
    end
end)

function vRPmedc.varyMovement(value)

    if value then
        s_movement = s_movement + value
    end

    local min_mov = 0.6
    local normal_mov = 1.0
    local max_mov = 1.4

    if s_movement < min_mov then
        s_movement = min_mov
    elseif s_movement > max_mov then
        s_movement = max_mov
    end

    if s_movement < 0.9 then
        s_movement = s_movement + 0.01
    elseif s_movement > 1.1 then
        s_movement = s_movement - 0.01
    else
        s_movement = normal_mov
    end
end

Citizen.CreateThread(function()
    while true do

        if s_movement > 1.0 or s_movement < 1.0 then
            if s_movement > 1.0 then
                StatSetInt("MP0_STAMINA", 100, true)
            end
            vRPmedc.varyMovement()
        end

        if s_ragDoll > 0 then
            s_ragDoll = s_ragDoll - 1000
            if s_ragDoll < 0 then
                s_ragDoll = 0
            end
        end

        if s_blockW > 0 then
            s_blockW = s_blockW - 1000
            if s_blockW < 0 then
                s_blockW = 0
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        SetPedMoveRateOverride(ped, s_movement)
        Citizen.Wait(0)
    end
end)

local function setInjuredAnimation(ped, toggle)
    s_limp = toggle
    if ped and s_limp then
        RequestAnimSet("move_m@injured")
        while not HasAnimSetLoaded("move_m@injured") do
            Citizen.Wait(0)
        end
        SetPedMovementClipset(ped, "move_m@injured", 1)
        Citizen.Wait(500)
    else
        ResetPedMovementClipset(ped, 0)
    end
end

local function setpedSprit(toggle)
    s_sprit = toggle
    SetPlayerSprint(PlayerId(), s_sprit)
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        -- print(IsPedArmed(ped, 7))
        if s_blockW > 0 then
            BlockWeaponWheelThisFrame()
            DisableControlAction(0, 25, true)
        end
        if ped_effects["buzzed"].active then
            DisableControlAction(0, 21, true) -- sprint
            DisableControlAction(0, 22, true) -- jump
        end
        if s_bleeding then
            -- ApplyPedBlood(GetPlayerPed(-1), 3, 0.0, 0.0, 0.0, "wound_sheet")
            ApplyPedDamagePack(ped, "HOSPITAL_4", 50.0, 100.0)
            ApplyPedDamagePack(ped, "SCR_Torture", 80.0, 100.0)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if not IsEntityDead(ped) and health > 120.0 and spawned then

            -- drugs effects
            local drug = drugs["drug"].severity
            if drug > 5.4 and drug <= 5.8 then
                vRPmedc.setPedScreenEffects("l", 60000)
            elseif drug >= 6.8 and drug < 9.4 then
                vRPmedc.setPedScreenEffects("l", 60000)
                vRPmedc.setPedScreenEffects("vh", 60000)
                vRPmedc.setPedEffects("drugs", 60000)
            elseif drug > 9.4 then
                vRPmedc.setPedScreenEffects("l", 60000)
                vRPmedc.setPedScreenEffects("vh", 60000)
                vRPmedc.setPedScreenEffects("h", 60000)
                vRPmedc.setPedEffects("drugs", 60000)
            end

            local alcool = drugs["alcool"].severity

            if alcool >= 0.4 and alcool <= 0.6 then
                vRPmedc.setPedEffects("alcool", 60000)
            elseif alcool > 0.8 then
                vRPmedc.setPedScreenEffects("l", 60000)
                vRPmedc.setPedScreenEffects("vh", 60000)
                vRPmedc.setPedEffects("alcool", 60000)
            end

            for k, v in pairs(BodyParts) do

                if (k == "RLEG" and v.severity >= 5.0) or (k == "LLEG" and v.severity >= 5.0) then
                    vRPmedc.setPedEffects("injured", 60000)
                    s_ragDoll = 60000
                    vRPmedc.varyMovement(-0.4)
                end

                if (k == "RARM" and v.severity >= 5.0) or (k == "LARM" and v.severity >= 5.0) then
                    s_blockW = 60000
                end

                if GetEntityHealth(ped) <= 130 then
                    vRPmedc.setPedEffects("injured", 60000)
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local tb_body = {
            HEAD = BodyParts["HEAD"].severity,
            HEAD_SH = BodyParts["HEAD"].severity_shot,
            NECK = BodyParts["NECK"].severity,
            SPINE = BodyParts["SPINE"].severity,
            UPPER_BODY = BodyParts["UPPER_BODY"].severity,
            UPPER_BODY_SH = BodyParts["UPPER_BODY"].severity_shot,
            LOWER_BODY = BodyParts["LOWER_BODY"].severity,
            LOWER_BODY_SH = BodyParts["LOWER_BODY"].severity_shot,
            LARM = BodyParts["LARM"].severity,
            LARM_SH = BodyParts["LARM"].severity_shot,
            LHAND = BodyParts["LHAND"].severity,
            LFINGER = BodyParts["LFINGER"].severity,
            LLEG = BodyParts["LLEG"].severity,
            LLEG_SH = BodyParts["LLEG"].severity_shot,
            LFOOT = BodyParts["LFOOT"].severity,
            RARM = BodyParts["RARM"].severity,
            RARM_SH = BodyParts["RARM"].severity_shot,
            RHAND = BodyParts["RHAND"].severity,
            RFINGER = BodyParts["RFINGER"].severity,
            RLEG = BodyParts["RLEG"].severity,
            RLEG_SH = BodyParts["RLEG"].severity_shot,
            RFOOT = BodyParts["RFOOT"].severity,
        }

        local tb_medicaments = {
            analgesic = Medicaments["analgesic"].value,
            antibiotic = Medicaments["antibiotic"].value,
            antiinflammatory = Medicaments["antiinflammatory"].value
        }

        local tb_acessories = {
            orthosuperior = Acessories["orthosuperior"].equiped,
            orthoinferior = Acessories["orthoinferior"].equiped,
            orthoboot = Acessories["orthoboot"].equiped,
            handplint = Acessories["handplint"].equiped
        }

        if spawned and (GetEntityHealth(PlayerPedId()) > 120.0) then
            MEserver._sendBodyInfos(tb_body, tb_medicaments, tb_acessories)            
        end
        
        Citizen.Wait(10000)
    end
end)

exports('checkBodyStatus', checkAllPedEffectsActive)
