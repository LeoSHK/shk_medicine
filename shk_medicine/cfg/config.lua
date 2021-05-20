local cfg = {}

cfg.exames = {
    ["raio-x"] = {
        btn = 49,
        msg = "Pressione ~g~F ~w~para fazer Raio-X",
        permission = "paramedico.permissao",
        audio = {
            -- url, cords x, y, z, vol, time, radius
            -- spot de audio, onde vai sair o audio do equipamento ao usar
            [1] = {"nui://shk_medicine/sounds/x-ray.mp3", 337.95,-573.02,43.85, 0.5, 19, 18},
            [2] = {"nui://shk_medicine/sounds/x-ray2.mp3", 349.42,-579.32,43.34, 0.5, 20, 21},
        },
        coords = {
            -- coordenadas do raio-x
            [1] = {341.77,-577.09,43.29},
            [2] = {344.18,-577.1,43.29},
        },
        action = function(exame, coordid)
          vRPmeds.choice_xray(exame, coordid)
        end,
    },
    ["atendimento"] = {
        btn = 49,
        msg = "Pressione ~g~F ~w~para Registrar Atendimento.",
        coords = {
            [1] = {306.99,-595.17,43.29},
        },
        action = function(exame, coordid)
            vRPmeds.registerReception()
        end,
    },
}


return cfg
