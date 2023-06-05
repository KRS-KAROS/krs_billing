ESX = exports["es_extended"]:getSharedObject()

-- 𝗞𝗥𝗦® │Development --

print('^5[𝗞𝗥𝗦® │Development] versione 1.0.0 \n ^0')
print('^8[𝗞𝗥𝗦® │Development] dipendenze: ox_lib, ox_inventory \n ^0')


ESX.RegisterServerCallback('krs_billing:prendiDati', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    local banca = xPlayer.getAccount("bank").money
    local contanti = xPlayer.getAccount("money").money
    cb(banca, contanti)
end)


RegisterServerEvent("krs_billing:inviafattura")
AddEventHandler("krs_billing:inviafattura", function(playerId, importo)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(playerId)

    
    if sourcePlayer.source == targetPlayer.source then
        TriggerClientEvent("esx:showNotification", sourcePlayer.source, "Non puoi inviarti una fattura a te stesso!")
        return
    end

    if targetPlayer then
        TriggerClientEvent("krs_billing:riceviFattura", targetPlayer.source, importo, sourcePlayer.source)
        TriggerClientEvent("esx:showNotification", sourcePlayer.source, "Fattura inviata a " .. targetPlayer.name .. "!")
        print("Fattura inviata a", targetPlayer.name, "da", sourcePlayer.name)
    else
        TriggerClientEvent("esx:showNotification", sourcePlayer.source, "Non ci sono giocatori nelle vicinanze!")
        print("Giocatore non trovato")
    end
end)


RegisterServerEvent("krs_billing:pagacontanti")
AddEventHandler("krs_billing:pagacontanti", function(playerId, importo, method)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(playerId)

    if not targetPlayer then
        print("Giocatore ricevente non trovato")
        return
    end

    if method == 'money' then
        if sourcePlayer.getMoney() >= importo then
            sourcePlayer.removeMoney(importo)
            targetPlayer.addMoney(importo)
            print("Pagamento di", importo, "$ in contanti da", sourcePlayer.name, "a", targetPlayer.name)
            print("Rimossi", importo, "$ in contanti da", sourcePlayer.name)
            print("Aggiunti", importo, "$ in contanti a", targetPlayer.name)

               
                   TriggerClientEvent('esx:showNotification', sourcePlayer.source, "Hai pagato $" .. importo .. " in contanti a " .. targetPlayer.name)
                   TriggerClientEvent('esx:showNotification', targetPlayer.source, "Hai ricevuto $" .. importo .. " in contanti da " .. sourcePlayer.name)
                   
                  
                   targetPlayer.triggerEvent('esx:addTransaction', {
                       sender = targetPlayer.name,
                       receiver = sourcePlayer.name,
                       amount = importo
                   })
               else
                   print("Fondi insufficienti per pagare la fattura")
               end
           else
               print("Metodo di pagamento non valido")
           end
       end)

RegisterServerEvent("krs_billing:pagabanca")
AddEventHandler("krs_billing:pagabanca", function(playerId, importo, method)
        local sourcePlayer = ESX.GetPlayerFromId(source)
        local targetPlayer = ESX.GetPlayerFromId(playerId)

        if not targetPlayer then
            print("Giocatore ricevente non trovato")
            return
        end

        if method == 'bank' then
            if sourcePlayer.getAccount('bank').money >= importo then
                sourcePlayer.removeAccountMoney('bank', importo)
                targetPlayer.addAccountMoney('bank', importo)
                print("Pagamento di", importo, "$ dalla banca di", sourcePlayer.name, "a", targetPlayer.name)
                print("Rimossi", importo, "$ dalla banca di", sourcePlayer.name)
                print("Aggiunti", importo, "$ alla banca di", targetPlayer.name)

              
                TriggerClientEvent('esx:showNotification', sourcePlayer.source, "Hai pagato $" .. importo .. " dalla tua banca a " .. targetPlayer.name)
                TriggerClientEvent('esx:showNotification', targetPlayer.source, "Hai ricevuto $" .. importo .. " nella tua banca da " .. sourcePlayer.name)

              
                targetPlayer.triggerEvent('esx:addTransaction', {
                    sender = targetPlayer.name,
                    receiver = sourcePlayer.name,
                    amount = importo
                })
            else
                print("Fondi insufficienti nella banca per pagare la fattura")
            end
        else
            print("Metodo di pagamento non valido")
        end
    end)


       
ESX.RegisterUsableItem("billing", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local items = exports.ox_inventory:Search(source, 'count', 'billing')

    if items > 0  then
        exports.ox_inventory:RemoveItem(source, 'billing', 1)
        TriggerClientEvent("krs_billing:item", xPlayer.source)
    else
        TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', description = 'Non hai gli oggetti necessari per creare una fattura' })
    end
end)

RegisterNetEvent('krs_billing:item')
AddEventHandler('krs_billing:item', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    exports.ox_inventory:RemoveItem(source, 'billing', 1)
end)


