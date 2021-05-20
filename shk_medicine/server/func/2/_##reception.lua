local receptions = {}
local bips = {}
fila = 0

-- user_id,
--- identidade completa
-- caso
-- custo?

local function checkUserId(user_id)
    for k, v in pairs(receptions) do
        if v.passaport == user_id then
            return true
        end
    end
    return false
end

function vRPmeds.sendBipMessage(index)
    local user_id = vRP.getUserId(source)
    if user_id then
        local player = vRP.getUserSource(user_id)
        if index and receptions[index] then
            if not bips[index] or (bips[index] and bips[index] <= os.time()) then

                local pacient = receptions[index]

                local puser_id = pacient.passaport
                local psource = vRP.getUserSource(puser_id)
                if psource then

                    bips[index] = os.time() + 30

                    vRPclient._notify(psource, "~g~Dirija-se a Emergência.")

                    local urlb = "nui://shk_medicine/sounds/bip.mp3"
                    local url = string.format(
                                    "https://translate.google.com/translate_tts?ie=UTF-8&q=%s&tl=%s&total=1&idx=0&client=tw-ob",
                                    pacient.name .. ", Dirija-se a Emergência.", "pt-BR")

                    --sala 1
                    Audioclient._playAudioSource(-1, urlb, 1.0, 308.86, -592.79, 44.89, 50)
                    Citizen.Wait(5000)
                    Audioclient._playAudioSource(-1, url, 1.0, 308.86, -592.79, 44.89, 50)
                    Citizen.Wait(6000)
                    -- sala2
                    Audioclient._playAudioSource(-1, urlb, 1.0, 324.61, -597.07, 44.34, 50)
                    Citizen.Wait(5000)                    
                    Audioclient._playAudioSource(-1, url, 1.0, 324.61, -597.07, 44.34, 50)

                else
                    vRPclient._notify(player, "~r~ Paciênte Indisponivel no momento.")
                end
            else
                vRPclient._notify(player, "~r~ Aguarde ~y~30 segundos~r~ para chamar novamente.")
            end
        end
    end
end

function vRPmeds.registerReception()
    local user_id = vRP.getUserId(source)
    if user_id then
        local player = vRP.getUserSource(user_id)
        local cause = vRP.prompt(player, "Informe a causa do seu Atendimento:", "")
        if cause ~= "" then
            -- if not receptions[index .. user_id] then
            if not checkUserId(user_id) then
                fila = fila + 1
                local identities = vRP.getUserIdentity(user_id)

                local insert = {
                    fila = fila,
                    passaport = user_id,
                    cause = cause,
                    name = identities.name .. " " .. identities.firstname
                }
                table.insert(receptions, insert)
                -- vRPmeds.sendNumberReceptions()
            else
                vRPclient._notify(player, "Você ja tem uma consulta registrada, aguarde atendimento.")
            end
        else
            vRPclient._notify(player, "~r~Informe a causa do Problema.")
        end
    end
end

function vRPmeds.registerDoutorReception(index)
    if index then
        local duser_id = vRP.getUserId(source)
        if duser_id then
            local dplayer = vRP.getUserSource(duser_id)

            if receptions[index] then
                local pacient = receptions[index]
                local user_id = pacient.passaport
                if user_id then
                    local player = vRP.getUserSource(user_id)
                    if player then
                        -- registra o doutor
                        local identities = vRP.getUserIdentity(duser_id)
                        receptions[index].doctor = duser_id
                        receptions[index].doctorname = identities.firstname .. " " .. identities.name
                        receptions[index].active = true

                        vRPmeds.sendListReceptions(dplayer)

                        vRPclient._notify(dplayer, "Você pegou o atendimento, informe o Paciente.")

                    else
                        vRPclient._notify(dplayer, "~r~Paciente não está disponível na cidade")
                        receptions[index] = nil
                        vRPmeds.sendListReceptions(dplayer)
                        -- vRPmeds.sendNumberReceptions()
                    end
                end
            end
        end
    end
end

function vRPmeds.cleanReceptionUser(index)
    local user_id = vRP.getUserId(source)
    if user_id then
        local player = vRP.getUserSource(user_id)
        if receptions[index] then
            receptions[index] = nil
            -- vRPmeds.sendNumberReceptions()
            vRPmeds.sendListReceptions(player)
        end
    end
end

local tblength = function(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function vRPmeds.sendListReceptions(player)
    MEclient._openUIReceptions(player, receptions)
end

RegisterCommand("recepcao", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "paramedico.permissao") then
            vRPmeds.sendListReceptions(source)
        end
    end
end)

-- function vRPmeds.sendNumberReceptions()

--     local medics = vRP.getUsersByPermission("paramedico.permissao")

--     for k, v in pairs(medics) do
--         local user_id = v
--         if user_id then
--             local player = vRP.getUserSource(user_id)
--             UIclient._setReceptionStatus(player, tblength(receptions))
--         end
--     end
-- end

-- -- TriggerEvent("vRP:playerLeaveGroup", user_id, group, gtype)
-- AddEventHandler("vRP:playerLeaveGroup", function(user_id, group, gtype)
--     if group == "hospital" then
--         -- clear ui reception
--         local player = vRP.getUserSource(user_id)
--         if player then
--             UIclient._setReceptionStatus(player, 0)
--         end
--     end

-- end)

-- AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
--     if group == "hospital" then
--         -- clear ui reception
--         local player = vRP.getUserSource(user_id)
--         if player then
--             UIclient._setReceptionStatus(player, tblength(receptions))
--         end
--     end
-- end)
