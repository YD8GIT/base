Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(0) end
	for k,v in pairs(Config.Items) do
		ESX.RegisterUsableItem(k, function(source)
			TriggerClientEvent("nAccessories:useAccessories", source, k)
		end)
	end
end)

RegisterNetEvent("nAccessories:buyAccessories")
AddEventHandler("nAccessories:buyAccessories", function(name)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 100 then
		xPlayer.removeMoney(100)
		xPlayer.addInventoryItem(name, 1)
		TriggerClientEvent("esx:showNotification", source, "Vous avez payé ~g~$" ..(100).. "~s~.")
	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez d'argent")
	end
end)
