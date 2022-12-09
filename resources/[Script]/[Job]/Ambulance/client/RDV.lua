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


function RdvKaito()
    local RdvKaito = RageUI.CreateMenu("~u~RDV", "Menu Intéraction..")
    nomprenom = nil
    numero = nil
    heurerdv = nil
    rdvmotif = nil
    RdvKaito:SetRectangleBanner(175, 175, 175)
        RageUI.Visible(RdvKaito, not RageUI.Visible(RdvKaito))
            while RdvKaito do
            Citizen.Wait(0)
            RageUI.IsVisible(RdvKaito, true, true, true, function()

                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.RDV.position.x, Ambulance.pos.RDV.position.y, Ambulance.pos.RDV.position.z)
                if dist3 >= 2.4 then
            RageUI.CloseAll()
                else

    
                    RageUI.ButtonWithStyle("~h~→ Nom & Prénom",nil, {RightLabel = nomprenom}, true, function(Hovered, Active, Selected)
                        if Selected then
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                               Citizen.Wait(1)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                nomprenom = GetOnscreenKeyboardResult() 
                            end
                        end
                    end)


                    RageUI.ButtonWithStyle("~h~→ Numéro de Téléphone",nil, {RightLabel = numero}, true, function(Hovered, Active, Selected)
                        if Selected then
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                               Citizen.Wait(1)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                numero = GetOnscreenKeyboardResult()  
                            end
                        end
                    end)

                    
                    RageUI.ButtonWithStyle("~h~→ Heure du Rendez-vous",nil, {RightLabel = heurerdv}, true, function(Hovered, Active, Selected)
                        if Selected then
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "15h40", "15h40", "", "", "", 10)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                               Citizen.Wait(1)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                heurerdv = GetOnscreenKeyboardResult()  
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("~h~→ Motif du Rendez-vous",nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 120)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                               Citizen.Wait(1)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                rdvmotif = GetOnscreenKeyboardResult()  
                            end
                        end
                    end)


                    RageUI.ButtonWithStyle("~h~→ Envoyer votre demande",nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if (nomprenom == nil or nomprenom == '') then
                                ESX.ShowNotification('~r~Vous n\'avez pas rempli votre Nom/Prénom')
                            elseif (numero == nil or numero == '') then
                                ESX.ShowNotification('~r~Vous n\'avez pas rempli votre Numéro')
                            elseif (heurerdv == nil or heurerdv == '') then
                                ESX.ShowNotification('~r~Vous n\'avez pas rempli l\'heure du Rendez-vous')
                            elseif (rdvmotif == nil or rdvmotif == '' or rdvmotif == "Motif") then
                                ESX.ShowNotification('~r~Vous n\'avez pas rempli le motif du rendez-vous')
                        else
                            RageUI.CloseAll()
                            TriggerServerEvent("rdv_kaito", nomprenom, numero, heurerdv, rdvmotif)
                            ESX.ShowAdvancedNotification("EMS", "Votre demande a bien été envoyé.", "", "CHAR_SOCIAL_CLUB", 1)
                            nomprenom = nil
                            numero = nil
                            heurerdv = nil
                            rdvmotif = nil
                        end
                    end
                    end)
    

                end

            end, function()
            end)

            if not RageUI.Visible(RdvKaito) then
            RdvKaito = RMenu:DeleteType("RdvKaito", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.RDV.position.x, Ambulance.pos.RDV.position.y, Ambulance.pos.RDV.position.z)
        if dist3 <= 2.0 and Ambulance.jeveuxmarker then
            Timer = 0
        
            end
            if dist3 <= 2.0 then
                Timer = 0   
                    RageUI.Text({  message = "Appuyez sur [~b~E~w~] pour prendre rendez-vous", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            RdvKaito()    
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)


local leped = {
	{hash="s_m_m_doctor_01", x = -816.37, y = -1237.55, z = 7.30, a=49.11}, 
}

Citizen.CreateThread(function()
	for _, item2 in pairs(leped) do
		local hash = GetHashKey(item2.hash)
		while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(20)
		end
		ped2 = CreatePed("PED_TYPE_CIVFEMALE", item2.hash, item2.x, item2.y, item2.z-0.92, item2.a, false, true)
        local playerPed        = GetPlayerPed(-1)
        TaskStartScenarioInPlace(ped2, 'WORLD_HUMAN_CLIPBOARD_FACILITY', 0, true)
		SetBlockingOfNonTemporaryEvents(ped2, true)
		FreezeEntityPosition(ped2, true)
		SetEntityInvincible(ped2, true)
	end
end)
