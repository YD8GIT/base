local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false
local spawnedVehicles, isInShopMenu = {}, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

RegisterNetEvent('esx_ambulancejob:heal2')
AddEventHandler('esx_ambulancejob:heal2', function(healType)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		local playerPed = PlayerPedId()
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		Citizen.Wait(10000)
		ClearPedTasks(playerPed)
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		local playerPed = PlayerPedId()
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		Citizen.Wait(10000)
		ClearPedTasks(playerPed)
		SetEntityHealth(playerPed, maxHealth)
	end

	ESX.ShowNotification(_U('healed'))
end)


RegisterNetEvent('esx_ambulancejob:heal')

AddEventHandler('esx_ambulancejob:heal', function(healType)

	local playerPed = PlayerPedId()

	local maxHealth = GetEntityMaxHealth(playerPed)



	if healType == 'small' then

		local health = GetEntityHealth(playerPed)

		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))

		SetEntityHealth(playerPed, newHealth)

	elseif healType == 'big' then

		SetEntityHealth(playerPed, maxHealth)

	end



	ESX.ShowNotification(_U('healed'))

end)


