function vRPmeds.getStatusCure()
    local player = source
    return Medclient.getStatusCure(player)
end

function vRPmeds.setAudioSource(name, url, x, y, z, vol, time, radius)
    Audioclient._setAudioSource(-1, name, url, vol, x, y, z, radius)
end

function vRPmeds.removeAudioSource(name)
    Audioclient._removeAudioSource(-1, name)
end

function vRPmeds.execExame(exame, coordid)
    local user_id = vRP.getUserId(source)
    if user_id then
        local ex = cfg.exames[exame]
        if ex then
            local perm = true

            if ex.permission and not vRP.hasPermission(user_id, ex.permission) then
                perm = false
            end

            if perm then
                ex.action(exame, coordid)
            end
        end
    end
end

function vRPmeds.choice_menuxray(exame, coordid)
    MEclient._openUiRayMenu(source)
end

function vRPmeds.choice_colectBagBlood(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        if nplayer then
            if vRP.tryGetInventoryItem(user_id, "bolsasanguevazia", 1, true) then
                TriggerClientEvent("Notify", player, "sucesso", "Coleta de sangue iniciou.")
                MEclient._createObj(player, "p_syringe_01_s", 20, 0.12, -0.008, 0.018, 20.0, -58.0, 0)
                MEclient._openUiBagBlood(nplayer)
                SetTimeout(60000, function()
                    vRP.giveInventoryItem(user_id, "bolsasangue", 1, true)
                    TriggerClientEvent("Notify", player, "sucesso", "Coleta de sangue Finalizou.")
                end)
            else
                TriggerClientEvent("Notify", player, "negado", "Faltou a Btolsa de Sangue Vazia.")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum paciente proximo.")
        end
    end
end

function vRPmeds.choice_cure(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id then
            -- check in bed
            if MEclient.getStatusInBed(nplayer) then
                -- check in cure
                if not MEclient.getStatusCure(nplayer) then
                    local reg = vRP.prompt(player, "Qual o tipo de tratamento?", "")
                    local time = vRP.prompt(player, "Qual o tempo em minutos do tratamento?", "")
                    if time == "" then
                        time = 0
                    end
                    if time and tonumber(time) > 0 then
                        MEclient._setTimeCure(nplayer, tonumber(time) * 60)
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)
                        TriggerEvent("shk:sendLogMessageUserID", user_id, nuser_id, "emecure",
                            "**Iniciou um Tratamento:** " .. reg .. " | **Duração:** __" .. time .. "Minuto(s)__")
                    else
                        TriggerClientEvent("Notify", player, "negado", "Valor incorreto, informe no minimo 1 minuto.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado", "O cidadão já está em tratamento.")
                end

            else
                TriggerClientEvent("Notify", player, "negado", "O cidadão não está deitado em uma maca, informe-o.")
                TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão proximo", 8000)
        end
    end
end

function vRPmeds.choice_cancelcure(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)

        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id then
            if MEclient.getStatusCure(nplayer) then
                MEclient._setCancelCure(nplayer)
                TriggerClientEvent("Notify", player, "negado", "O tratamento do Paciente foi cancelado.")
                TriggerClientEvent("Notify", nplayer, "negado", "Seu tratamento foi cancelado.")
                TriggerEvent("shk:sendLogMessageUserID", user_id, nuser_id, "emecure", "**Tratamento Cancelado**")
            else
                TriggerClientEvent("Notify", player, "negado", "O cidadão não está em Tratamento.")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.choice_transf_cure(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nuser_id = 1
        -- nplayer = player
        if nuser_id then
            -- check in bed
            if MEclient.getStatusInBed(nplayer) then
                -- check in cure
                if not MEclient.getStatusCure(nplayer) then
                    local time = vRP.prompt(player, "Qual o tempo em minutos do tratamento?", "")
                    if time == "" then
                        time = 0
                    end
                    if time and tonumber(time) > 0 then
                        if vRP.tryGetInventoryItem(user_id, "bolsasangue", 1, true) then
                            local reg = vRP.prompt(player, "Qual o tipo de tratamento?", "")
                            MEclient._setTimeCure(nplayer, time * 60, "bag_blood")
                            vRPclient._playAnim(player, true,
                                {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}}, false)
                            TriggerEvent("shk:sendLogMessageUserID", user_id, nuser_id, "emecirurgia",
                                "**Iniciou um Tratamento:** " .. reg .. " | **Duração:** __" .. time .. "Minuto(s)__")
                        else
                            TriggerClientEvent("Notify", player, "negado",
                                " Bolsa de sangue indisponivel para iniciar o tratamento.")
                        end
                    else
                        TriggerClientEvent("Notify", player, "negado", "Valor incorreto, informe no minimo 1 minuto.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado", "O cidadão já está em tratamento.")
                end

            else
                TriggerClientEvent("Notify", player, "negado", "O cidadão não está deitado em uma maca, informe-o.")
                TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.choice_apply_moanfina(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id then
            if MEclient.getStatusInBed(nplayer) then
                if not MEclient.getStatusCure(nplayer) then
                    local time = vRP.prompt(player, "Qual o tempo em minutos do tratamento?", "")
                    if time == "" then
                        time = 0
                    end
                    if time and tonumber(time) > 0 then
                        if vRP.tryGetInventoryItem(user_id, "morfina", 1, true) then
                            local reg = vRP.prompt(player, "Qual o tipo de tratamento?", "")
                            MEclient._setMedicament(nplayer, "analgesic", 10, 20)
                            MEclient._setTimeCure(nplayer, time * 60)
                            vRPclient._playAnim(player, true,
                                {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}}, false)
                            TriggerEvent("shk:sendLogMessageUserID", user_id, nuser_id, "emecirurgia",
                                "**Iniciou um Tratamento Morfina:** " .. reg .. " | **Duração:** __" .. time ..
                                    "Minuto(s)__")
                        end
                    else
                        TriggerClientEvent("Notify", player, "negado", "Valor incorreto, informe no minimo 1 minuto.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado", "O cidadão já está em tratamento.")
                end

            else
                TriggerClientEvent("Notify", player, "negado", "O cidadão não está deitado em uma maca, informe-o.")
                TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

-- choices
-- local choice_cure = {function(player, choice)
--     vRPmeds.choice_cure(player)
-- end, lang.emergency.menu.cure.description()}
function vRPmeds.choice_cancel_transf_cure(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nuser_id = 1
        -- nplayer = player
        if nuser_id then
            if MEclient.getStatusCure(nplayer) then
                MEclient._setCancelCure(nplayer, "bag_blood")
                TriggerClientEvent("Notify", player, "negado", "O tratamento do Paciente foi cancelado")
                TriggerClientEvent("Notify", nplayer, "negado", "Seu tratamento foi cancelado.")
                TriggerEvent("shk:sendLogMessageUserID", user_id, nuser_id, "emecirurgia", "**Tratamento Cancelado**")
            else
                TriggerClientEvent("Notify", player, "negado", "O cidadão não está em Tratamento.")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.choice_remove_projectile(player, type)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nuser_id = 1
        -- nplayer = player
        if nuser_id then
            -- check in bed
            if MEclient.getStatusInBed(nplayer) then
                -- check in cure
                if MEclient.getStatusCure(nplayer) then
                    vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}}, false)
                    MEclient._setBodyPartTypeShot(nplayer, type, false)
                else
                    TriggerClientEvent("Notify", player, "negado", "Precisa de uma Transfusão Ativa.")
                end

            else
                TriggerClientEvent("Notify", player, "negado", "O cidadão não está deitado em uma maca, informe-o.")
                TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

-- local choice_revive = {function(player, choice)
--     vRPmeds.choice_revive(player)
-- end, lang.emergency.menu.revive.description()}
function vRPmeds.choice_boots(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)
        -- nplayer = 1
        -- nuser_id = 1
        if nuser_id then
            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.BodyParts then
                if data.BodyParts.RFOOT >= 5 or data.BodyParts.LFOOT >= 5 then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)

                        SetTimeout(3000, function()
                            MEclient._setPedModelBoots(nplayer)
                            MEclient._setAcessory(nplayer, "orthoboot", true)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado", "O paciente não tem lesões nas pernas.")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo")
        end
    end
end

function vRPmeds.remove_choice_boots(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)
        -- nplayer = 1
        -- nuser_id = 1
        if nuser_id then

            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.Acessories then
                if data.Acessories.orthoboot == true then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)

                        SetTimeout(3000, function()
                            MEclient._removePedModelBoots(nplayer)
                            MEclient._setAcessory(nplayer, "orthoboot", false)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado",
                        "O paciente não está com Bota ortopédica para remover.")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

-- local choice_boots = {function(player, choice)
--     vRPmeds.choice_boots(player)
-- end, lang.emergency.menu.application.boots.description()}
function vRPmeds.choice_tops(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nplayer = 1
        -- nuser_id = 1
        if nuser_id then
            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.BodyParts then
                if data.BodyParts.HEAD >= 2 or data.BodyParts.NECK >= 2 or data.BodyParts.SPINE >= 3 or data.BodyParts.UPPER_BODY >= 3 then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)
                        SetTimeout(3000, function()
                            MEclient._setPedModelTop(nplayer)
                            MEclient._setAcessory(nplayer, "orthosuperior", true)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado",
                        "Não possui ferimentos na Cabeça, Pescoço, Coluna ou Tronco.")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.remove_choice_tops(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nplayer = 1
        -- nuser_id = 1
        if nuser_id then
            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.Acessories then
                if data.Acessories.orthosuperior == true then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)
                        SetTimeout(3000, function()
                            MEclient._removePedModelTop(nplayer)
                            MEclient._setAcessory(nplayer, "orthosuperior", false)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    vRPclient._notify(player, "O Paciente não possui Gesso Superior para remover")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

-- local choice_tops = {function(player, choice)
--     vRPmeds.choice_tops(player)
-- end, lang.emergency.menu.application.tops.description()}
function vRPmeds.choice_legs(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nplayer = player
        -- nuser_id = 1
        if nuser_id then
            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.BodyParts then
                if data.BodyParts.LLEG >= 5 or data.BodyParts.RLEG >= 5 or data.BodyParts.LOWER_BODY >= 3 then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)
                        SetTimeout(3000, function()
                            MEclient.setPedModelLegs(nplayer)
                            MEclient._setAcessory(nplayer, "orthoinferior", true)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado",
                        "Paciente não possui ferimentos nas Pernas ou Quadril.")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.remove_choice_legs(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nplayer = player
        -- nuser_id = 1
        if nuser_id then
            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.Acessories then
                if data.Acessories.orthoinferior == true then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)
                        SetTimeout(3000, function()
                            MEclient.removePedModelLegs(nplayer)
                            MEclient._setAcessory(nplayer, "orthoinferior", false)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado",
                        "Paciente não possui Gesso nas Pernas/Quadril para remover.")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.choice_hands(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nplayer = player
        -- nuser_id = 1
        if nuser_id then
            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.BodyParts then
                if data.BodyParts.LHAND >= 5 or data.BodyParts.LFINGER >= 5 or data.BodyParts.RHAND >= 5 or data.BodyParts.RFINGER >= 5 then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)
                        SetTimeout(3000, function()
                            MEclient._setPedModelHands(nplayer)
                            MEclient._setAcessory(nplayer, "handplint", true)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado", "Paciente não possui ferimentos nas Mãos ou Dedos")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.remove_choice_hands(player)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 5)
        local nuser_id = vRP.getUserId(nplayer)

        -- nplayer = player
        -- nuser_id = 1
        if nuser_id then
            local data_db = vRP.getUData(nuser_id, "BodySystem")
            local data = json.decode(data_db) or {}
            if data and data.Acessories then
                if data.Acessories.handplint == true then
                    if MEclient.getStatusInBed(nplayer) then
                        vRPclient._playAnim(player, true, {{"amb@prop_human_parking_meter@male@idle_a", "idle_a", 2}},
                            false)
                        SetTimeout(3000, function()
                            MEclient._removePedModelHands(nplayer)
                            MEclient._setAcessory(nplayer, "handplint", false)
                        end)
                    else
                        TriggerClientEvent("Notify", player, "negado",
                            "O cidadão não está deitado em uma maca, informe-o.")
                        TriggerClientEvent("Notify", nplayer, "negado", "Você deve estar deitado na maca.")
                    end
                else
                    TriggerClientEvent("Notify", player, "negado", "Paciente não possui Talas nas Mãos ou Dedos")
                end
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
        end
    end
end

function vRPmeds.choice_xray(exame, coordid)
    local user_id = vRP.getUserId(source)
    if user_id then
        local player = vRP.getUserSource(user_id)
        local nuser_id = vRP.prompt(player, "Informe o Passaporte do Paciente:", "")

        nuser_id = tonumber(nuser_id)
        if user_id ~= nuser_id then
            local nplayer = vRP.getUserSource(nuser_id)
            if nplayer then

                vRPclient._playAnim(player, false, {{"anim@heists@prison_heistig1_p1_guard_checks_bus", "loop"}}, true)
                local data_db = vRP.getUData(nuser_id, "BodySystem")

                local data = json.decode(data_db)

                local head = false
                local neck = false
                local spine = false
                local upper_body = false
                local lower_body = false
                local larm = false
                local lhand = false
                local lfinger = false
                local lleg = false
                local lfoot = false
                local rarm = false
                local rhand = false
                local rfinger = false
                local rleg = false
                local rfoot = false

                if data and data.BodyParts then

                    if data.BodyParts.HEAD >= 5 then
                        head = true
                    end

                    if data.BodyParts.NECK >= 5 then
                        neck = true
                    end

                    if data.BodyParts.SPINE >= 5 then
                        spine = true
                    end

                    if data.BodyParts.UPPER_BODY >= 5 then
                        upper_body = true
                    end

                    if data.BodyParts.LOWER_BODY >= 5 then
                        lower_body = true
                    end

                    if data.BodyParts.LARM >= 5 then
                        larm = true
                    end

                    if data.BodyParts.LHAND >= 5 then
                        lhand = true
                    end

                    if data.BodyParts.LFINGER >= 5 then
                        lfinger = true
                    end

                    if data.BodyParts.LLEG >= 5 then
                        lleg = true
                    end

                    if data.BodyParts.LFOOT >= 5 then
                        lfoot = true
                    end

                    if data.BodyParts.RARM >= 5 then
                        rarm = true
                    end

                    if data.BodyParts.RHAND >= 5 then
                        rhand = true
                    end

                    if data.BodyParts.RFINGER >= 5 then
                        rfinger = true
                    end

                    if data.BodyParts.RLEG >= 5 then
                        rleg = true
                    end

                    if data.BodyParts.RFOOT >= 5 then
                        rfoot = true
                    end

                    if exame and coordid then
                        local ex = cfg.exames[exame]
                        if ex and ex.audio then
                            local aud = ex.audio[coordid]
                            if aud then
                                local name = exame .. ":" .. coordid
                                local time = aud[7]
                                vRPmeds.setAudioSource(name, aud[1], aud[2], aud[3], aud[4], aud[5], aud[6], time)

                                SetTimeout(time * 1000, function()
                                    vRPmeds.removeAudioSource(name)
                                end)
                            end
                        end
                    end

                    local nid = vRP.getUserIdentity(nuser_id)
                    local pasc = {}
                    if nid then
                        pasc.name = nid.firstname .. " " .. nid.name
                        pasc.age = nid.age
                        pasc.rg = nid.registration
                        pasc.phone = nid.phone
                        pasc.passp = nuser_id
                    end

                    local did = vRP.getUserIdentity(user_id)
                    local doctor = {}
                    if did then
                        local djob = vRP.getUserGroupByType(user_id, 'job')
                        doctor.name = did.firstname .. " " .. did.name
                        doctor.passp = user_id
                        doctor.job = djob
                    end

                    local tbody = {
                        head = head,
                        head_sh = data.BodyParts.HEAD_SH,
                        neck = neck,
                        spine = spine,
                        upper_body = upper_body,
                        upper_body_sh = data.BodyParts.UPPER_BODY_SH,
                        lower_body = lower_body,
                        lower_body_sh = data.BodyParts.LOWER_BODY_SH,
                        larm = larm,
                        larm_sh = data.BodyParts.LARM_SH,
                        lhand = lhand,
                        lfinger = lfinger,
                        lleg = lleg,
                        lleg_sh = data.BodyParts.LLEG_SH,
                        lfoot = lfoot,
                        rarm = rarm,
                        rarm_sh = data.BodyParts.RARM_SH,
                        rhand = rhand,
                        rfinger = rfinger,
                        rleg = rleg,
                        rleg_sh = data.BodyParts.RLEG_SH,
                        rfoot = rfoot
                    }

                    MEclient._openUiRay(player, tbody, pasc, doctor)
                end
            else
                TriggerClientEvent("Notify", player, "negado", "Nenhum cidadão próximo..")
            end
        else
            TriggerClientEvent("Notify", player, "negado", "Não pode tirar Raio-X de você mesmo.")
        end
    end
end

function vRPmeds.sendBodyInfos(BodyParts, Medicaments, Acessories)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local db_infos = vRP.getUData(user_id, "BodySystem")
        local dec_infos = json.decode(db_infos) or {}
        dec_infos["BodyParts"] = BodyParts
        dec_infos["Medicaments"] = Medicaments
        dec_infos["Acessories"] = Acessories
        vRP.setUData(user_id, "BodySystem", json.encode(dec_infos))
    end
end

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then -- first spawn, build homes
        if user_id then
            local db_infos = vRP.getUData(user_id, "BodySystem")
            local dec_infos = json.decode(db_infos) or {}

            if dec_infos["BodyParts"] then
                MEclient._setBodyParts(source, dec_infos["BodyParts"])
            end

            if dec_infos["Medicaments"] then
                MEclient._setMedInfos(source, dec_infos["Medicaments"])
            end

            if dec_infos["Acessories"] then
                MEclient._setAcesInfos(source, dec_infos["Acessories"])
            end
            SetTimeout(5000, function()
                MEclient._setSpawnedPlayer(source)
            end)
        end
    end
end)

-- commands
RegisterCommand("tratamento", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "paramedico.permissao") then
            if args[1] then
                if args[1] == "iniciar" then
                    vRPmeds.choice_cure(source)
                elseif args[1] == "cancelar" then
                    vRPmeds.choice_cancelcure(source)
                elseif args[1] == "morfina" then
                    vRPmeds.choice_apply_moanfina(source)
                end
            end
        end
    end
end)

RegisterCommand("transfusao", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "paramedico.permissao") then
            if args[1] then
                if args[1] == "iniciar" then
                    vRPmeds.choice_transf_cure(source)
                elseif args[1] == "cancelar" then
                    vRPmeds.choice_cancel_transf_cure(source)
                end
            end
        end
    end
end)

RegisterCommand("doarsangue", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "paramedico.permissao") then
            vRPmeds.choice_colectBagBlood(source)
        end
    end
end)

RegisterCommand("orto", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "paramedico.permissao") then
            if args[1] then
                if args[1] == "superior" then
                    if args[2] then
                        if args[2] == "adicionar" then
                            vRPmeds.choice_tops(source)
                        elseif args[2] == "remover" then
                            vRPmeds.remove_choice_tops(source)
                        end
                    end
                elseif args[1] == "inferior" then
                    if args[2] then
                        if args[2] == "adicionar" then
                            vRPmeds.choice_legs(source)
                        elseif args[2] == "remover" then
                            vRPmeds.remove_choice_legs(source)
                        end
                    end
                elseif args[1] == "bota" then
                    if args[2] then
                        if args[2] == "adicionar" then
                            vRPmeds.choice_boots(source)
                        elseif args[2] == "remover" then
                            vRPmeds.remove_choice_boots(source)
                        end
                    end
                elseif args[1] == "tala" then
                    if args[2] then
                        if args[2] == "adicionar" then
                            vRPmeds.choice_hands(source)
                        elseif args[2] == "remover" then
                            vRPmeds.remove_choice_hands(source)
                        end
                    end
                end
            end
        end
    end
end)
-- remoção dos projeteis
RegisterCommand("cirurgia", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "paramedico.permissao") then
            if args[1] then
                if args[1] == "cabeca" then
                    vRPmeds.choice_remove_projectile(source, "HEAD")
                elseif args[1] == "bracoesq" then
                    vRPmeds.choice_remove_projectile(source, "LARM")
                elseif args[1] == "bracodir" then
                    vRPmeds.choice_remove_projectile(source, "RARM")
                elseif args[1] == "pernaesq" then
                    vRPmeds.choice_remove_projectile(source, "LLEG")
                elseif args[1] == "pernadir" then
                    vRPmeds.choice_remove_projectile(source, "RLEG")
                elseif args[1] == "tronco" then
                    vRPmeds.choice_remove_projectile(source, "UPPER_BODY")
                elseif args[1] == "quadril" then
                    vRPmeds.choice_remove_projectile(source, "LOWER_BODY")
                end
            end
        end
    end
end)

RegisterCommand('re',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			if vRPclient.isInComa(nplayer) then
				local identity_user = vRP.getUserIdentity(user_id)
				local nuser_id = vRP.getUserId(nplayer)
				local identity_coma = vRP.getUserIdentity(nuser_id)
				local set_user = "Policia"
				if vRP.hasPermission(user_id,"paramedico.permissao") then
					set_user = "Paramedico"
				end
				TriggerClientEvent('cancelando',source,true)
				vRPclient._playAnim(source,false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
				TriggerClientEvent("progress",source,30000,"reanimando")
				SetTimeout(30000,function()
					vRPclient.killGod(nplayer)
					vRPclient._stopAnim(source,false)
					TriggerClientEvent("resetBleeding",nplayer)
					TriggerClientEvent('cancelando',source,false)
				end)
			else
				TriggerClientEvent("Notify",source,"importante",'Importante',"A pessoa precisa estar em coma para prosseguir.")
			end
		end
	end
end)
