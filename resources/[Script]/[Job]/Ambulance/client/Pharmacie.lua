ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
     ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

---------------------------
function PEMS()
    local PEMS = RageUI.CreateMenu("~u~Pharmacie", "Menu Intéraction..")
    PEMS:SetRectangleBanner(175, 175, 175)
        RageUI.Visible(PEMS, not RageUI.Visible(PEMS))
            while PEMS do
            Citizen.Wait(0)
            RageUI.IsVisible(PEMS, true, true, true, function()
    
        
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Pharmacie.position.x, Ambulance.pos.Pharmacie.position.y, Ambulance.pos.Pharmacie.position.z)
                if dist3 >= 1.5 then
            RageUI.CloseAll()
                else
                    
			RageUI.ButtonWithStyle("Bandage (x5)", "Maximum ~r~25~w~ bandages!", {RightBadge = RageUI.BadgeStyle.Package}, true, function(Hovered, Active, Selected)

			if (Selected) then


                TriggerServerEvent('Pharmacy:giveItem', 'bandage')

			end

			end)

            RageUI.ButtonWithStyle("Kit de soin (x1)", "Maximum ~r~10~w~ Medikit(s)!", {RightBadge = RageUI.BadgeStyle.Package}, true, function(Hovered, Active, Selected)

                if (Selected) then
    

                    TriggerServerEvent('Pharmacy:giveItemm', 'medikit')
    
                end
    
                end)
            end

            end, function()
            end)

            if not RageUI.Visible(PEMS) then
            PEMS = RMenu:DeleteType("PEMS", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Pharmacie.position.x, Ambulance.pos.Pharmacie.position.y, Ambulance.pos.Pharmacie.position.z)
        if dist3 <= 1.2 and Ambulance.jeveuxmarker then
            Timer = 0
            DrawMarker(25, Ambulance.pos.Pharmacie.position.x, Ambulance.pos.Pharmacie.position.y, Ambulance.pos.Pharmacie.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 0 , 255, false, true, p19, true)
            end
            if dist3 <= 1.2 then
                FreezeEntityPosition(PlayerPedId(), false)
                Timer = 0   
                    RageUI.Text({  message = "Appuyez sur [~b~E~w~] pour ouvrir la pharmacie", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            PEMS()    
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)