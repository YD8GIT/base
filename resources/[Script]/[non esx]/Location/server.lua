ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('dobraziil:Vlocation')
AddEventHandler('dobraziil:Vlocation', function(prix)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()
	xPlayer.removeMoney(prix)
	TriggerClientEvent('esx:showNotification', source, "~g~Véhicule de location sortie.~z~ ~r~Soit prudent sur la route !")

end)