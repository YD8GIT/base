ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local AmbulanceBoss = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

local pos = vector3(-803.54, -1210.54, 6.35)
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(pos)

    SetBlipSprite (blip, 61)
    SetBlipScale  (blip, 0.7)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Hopital')
    EndTextCommandSetBlipName(blip)
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


function AmbulanceBoss()
    local PatronBoss = RageUI.CreateMenu("~u~Management", "Menu Intéraction..")
    PatronBoss:SetRectangleBanner(175, 175, 175)
      RageUI.Visible(PatronBoss, not RageUI.Visible(PatronBoss))
  
              while PatronBoss do
                  Citizen.Wait(0)
                      RageUI.IsVisible(PatronBoss, true, true, true, function()
  
                        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Boss.position.x, Ambulance.pos.Boss.position.y, Ambulance.pos.Boss.position.z)
                        if dist3 >= 1.5 then
                    RageUI.CloseAll()
                        else


            RageUI.ButtonWithStyle("→ Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:withdrawMoney', 'ambulance', amount)
                    end
                end
            end)

            RageUI.ButtonWithStyle("→ Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:depositMoney', 'ambulance', amount)
                    end
                end
            end) 

           RageUI.ButtonWithStyle("→ Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    aboss()
                    RageUI.CloseAll()
                end
            end)
        end

        end, function()
        end)
        if not RageUI.Visible(PatronBoss) then
        PatronBoss = RMenu:DeleteType("PatronBoss", true)
    end
end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' then 
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Boss.position.x, Ambulance.pos.Boss.position.y, Ambulance.pos.Boss.position.z)
        if dist3 <= 1.2 and Ambulance.jeveuxmarker then
            Timer = 0
            end
            if dist3 <= 1.2 then
                DrawMarker(25, Ambulance.pos.Boss.position.x, Ambulance.pos.Boss.position.y, Ambulance.pos.Boss.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, false, true, p19, true)
                Timer = 0   
                    RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour ouvrir votre panel", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            AmbulanceBoss()  
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)



function UpdateAmbulanceBoss(money)
    AmbulanceBoss = ESX.Math.GroupDigits(money)
end

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
        menu.close()
    end, {wash = false})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

