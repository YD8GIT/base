ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent(nClothes.Config.ESXSharedObject, function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)