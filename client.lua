ESX = exports["es_extended"]:getSharedObject()

-- 𝗞𝗥𝗦® │Development --

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)


function apriFattura()
    ESX.TriggerServerCallback('krs_billing:prendiDati', function(banca, contanti)
        print("Soldi in banca:", banca)
        print("Soldi in contanti:", contanti)

        local input = lib.inputDialog('KRS BILLING', {
            {type = 'input', label = 'I tuoi soldi in banca', disabled = true, placeholder = banca.."$",  icon = "wallet"},
            {type = 'input', label = 'I tuoi soldi nel portafoglio', disabled = true, placeholder = contanti.."$", icon = "money-bill"},
            {type = 'number', label = 'Importo', placeholder = "100$", icon = "money-bill"},
            {type = 'number', label = 'ID del Giocatore', placeholder = "1", icon = "user"}
        })

        if not input then return end

        local playerId = tonumber(input[4])
        local importo = tonumber(input[3])

        if playerId and importo then
            TriggerServerEvent("krs_billing:inviafattura", playerId, importo)
        else
            print("Input non valido")
        end
    end)
end

RegisterNetEvent("krs_billing:riceviFattura")
AddEventHandler("krs_billing:riceviFattura", function(importo, sourcePlayerId) 
    local input = lib.inputDialog('Pagamento bancario | Pagamento Contanti', {
        {
            type = 'select',
            label = 'Fattura:  $',
            options = {
                { value = 'money', label = "Paga in contanti" },
                { value = 'bank',  label = "Paga con carta" },
            }
        },
    })

    if not input then return end

    local method = input[1]

    if not method then
        return
    end

    local lastConfirmation = lib.alertDialog({
        header = 'fattura',
        content = 'paga ' .. importo,
        centered = false,
        cancel = true
    })

    if lastConfirmation == "confirm" then
        if method == 'money' then
            if lib.progressCircle({
                duration = 2000,
                label = 'Pagamento in contanti in corso',
                useWhileDead = false,
                allowCuffed = false,
                allowFalling = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'missfam4',
                    clip = 'base'
                },
                prop = {
                    model = `p_cs_clipboard`,
                    pos = vec3(0.03, 0.03, 0.02),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
        then
            TriggerServerEvent("krs_billing:pagacontanti", sourcePlayerId, importo, 'money')
        end
        elseif method == 'bank' then
            if lib.progressCircle({
                duration = 2000,
                label = 'Pagamento in banca in corso',
                useWhileDead = false,
                allowCuffed = false,
                allowFalling = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'missfam4',
                    clip = 'base'
                },
                prop = {
                    model = `p_cs_clipboard`,
                    pos = vec3(0.03, 0.03, 0.02),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
        then
            TriggerServerEvent("krs_billing:pagabanca", sourcePlayerId, importo, 'bank')
        end
        end
    end
end)


RegisterCommand('bill', function()
    apriFattura()
end)

RegisterNetEvent('krs_billing:item')
AddEventHandler('krs_billing:item', function()
    if lib.progressCircle({
        duration = 2000,
        label = 'Preparando la fattura',
        useWhileDead = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'missfam4',
            clip = 'base'
        },
        prop = {
            model = `p_cs_clipboard`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        },
    })
then
    apriFattura()
end
end)
