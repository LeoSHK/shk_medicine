local lang = {
    emergency = {
        menu = {
            revive = {
                title = "03-Reanimar",
                description = "Reanimar cidadão mais proximo.",
                not_in_coma = "~r~O cidadão nao está em COMA."
            },
            cure = {
                title = "01-Iniciar Tratamento",
                canceltitle = "02-Cancelar tratamento",
                description = "Aplica um Tratamento para o jogador mais próximo no tempo informado. Após este tempo finalizado, o paciente estará curado.",
                cdescription = "Cancela o tratamento do jogador mais próximo.",
                no_inbed = "~r~O cidadão não está deitado em uma maca, informe-o.",
                np_no_inbed = "Você deve estar ~r~deitado na maca.",
                in_cure = "~r~O cidadão já está em tratamento.",
                noin_cure = "~r~O cidadão não está em Tratamento.",
                reg_cure = "Qual o tipo de tratamento?",
                time_cure = "Qual o tempo em minutos do tratamento?",
                time_incorrect = "Valor incorreto, informe no minimo 1 minuto.",
                cancel_cure = "~r~O tratamento do Paciente foi cancelado",
                ncancel_cure = "~r~Seu tratamento foi cancelado."
            },
            observation = {
                title = "Ficar em Repouso/Observação",
                description = "Deixa o paciente em observação por 2 minutos antes de ser curado."
            },
            application = {
                boots = {
                    title = "04-Bota Ortopédica",
                    description = "Aplica uma bota ortopédica no Paciênte mais próximo."
                },
                legs = {
                    title = "04-Engessar Pernas",
                    description = "Aplica uma tala nas pernas do Paciênte mais próximo."
                },
                tops = {
                    title = "05-Engessar Braços",
                    description = "Aplica uma tala no tronco do Paciênte mais próximo.."
                }
            }
        }
    }
}

return lang
