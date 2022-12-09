ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

local blips = {}

local AppelPris = false

local AppelCoords = nil

local tableBlip = {}

local limitCone = 0

local limittrousse = 0

local limitlit = 0

closestDistance, closestEntity = -1, nil

pris = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
     ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
    ESX.PlayerData.job = job
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

RegisterNetEvent("AppelemsGetCoordsss")

AddEventHandler("AppelemsGetCoordsss", function()

     ped = GetPlayerPed(-1)

     GetPed(ped)

	coords = GetEntityCoords(ped, true)

	idJoueur = GetPlayerServerId(PlayerId())

	print(idJoueur)

	TriggerServerEvent("Server:emsAppelllls", coords, idJoueur)

end)

RegisterNetEvent("yayyyaPapa")

AddEventHandler("yayyyaPapa", function(coords, id)

	AppelEnAttente = true

	AppelCoords = coords

	AppelID = id

	ESX.ShowAdvancedNotification("EMS", "~b~Demande des EMS", "Quelqu'un a besoin des EMS ! Allumez votre tablette pour intervenir", "CHAR_CALL911", 8)

end)


function spawnObject(name)
	local plyPed = PlayerPedId()
	local coords = GetEntityCoords(plyPed, false) + (GetEntityForwardVector(plyPed) * 1.0)

	ESX.Game.SpawnObject(name, coords, function(obj)
		SetEntityHeading(obj, GetEntityPhysicsHeading(plyPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end


AddEventHandler('KAmbulance:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job and PlayerData.job.name == 'ambulance' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)


AddEventHandler('KAmbulance:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
        'xm_prop_x17_bag_med_01a',
        'gr_prop_gr_campbed_01',
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('KAmbulance:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('KAmbulance:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'ambulance' then

				if CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end


	end
end)


reportlistesql = {}


function F6EMS()
    local F6 = RageUI.CreateMenu("~u~EMS", "Menu Intéraction...")
    local InteractionP = RageUI.CreateSubMenu(F6, "~u~EMS", "Menu Intéraction..")
    local Appel = RageUI.CreateSubMenu(F6, "~u~EMS", "Menu Intéraction..")
    local AppelKaito = RageUI.CreateSubMenu(F6, "~u~EMS", "Menu Intéraction..")
    local props = RageUI.CreateSubMenu(F6, "~u~EMS", "Menu Intéraction..")
    props:SetRectangleBanner(175, 175, 175)
    F6:SetRectangleBanner(175, 175, 175)
    AppelKaito:SetRectangleBanner(175, 175, 175)
    InteractionP:SetRectangleBanner(175, 175, 175)
    Appel:SetRectangleBanner(175, 175, 175)
    RageUI.Visible(F6, not RageUI.Visible(F6))
    while F6 do
        Citizen.Wait(0)
            RageUI.IsVisible(F6, true, true, true, function()

                RageUI.Checkbox("~h~→ Prendre son service",nil, service,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
    
                        service = Checked
    
    
                        if Checked then
                            onservice = true
                            TriggerServerEvent('webhook_emson')
                            RageUI.Popup({
                                message = "Vous avez pris votre service !"})
    
                            
                        else
                            onservice = false
                            TriggerServerEvent('webhook_emsoff')
                            RageUI.Popup({
                                message = "Vous n'etes plus en service !"})
    
                        end
                    end
                end)
    
                if onservice then

                    RageUI.ButtonWithStyle("~h~→ Intéraction Citoyen", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                        end
                    end, InteractionP) 

                    RageUI.ButtonWithStyle("~h~→ Objets", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                        end
                    end, props) 

                    RageUI.ButtonWithStyle("~h~→ Gestions Appels", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ESX.TriggerServerCallback('ems:afficheappelssss', function(keys)

                                reportlistesql = keys
                            end)
                        end
                    end, Appel) 
                end
                    
                end, function() 
                end)

                RageUI.IsVisible(InteractionP, true, true, true, function()

                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
					local searchPlayerPed = GetPlayerPed(target)

                    RageUI.ButtonWithStyle("~h~→ Faire une facture",nil, {RightBadge = RageUI.BadgeStyle.Cash}, true, function(_,_,s)
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if s then
                            local raison = ""
                            local montant = 0
                            AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result = GetOnscreenKeyboardResult()
                                if result then
                                    raison = result
                                    result = nil
                                    AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0)
                                        Wait(0)
                                    end
                                    if (GetOnscreenKeyboardResult()) then
                                        result = GetOnscreenKeyboardResult()
                                        if result then
                                            montant = result
                                            result = nil
                                            if player ~= -1 and distance <= 3.0 then
                                                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ('ambulance'), montant)
                                                TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                            else
                                                ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
        
			
					RageUI.ButtonWithStyle("~h~→ Réanimer quelqu'un", "Kit de soin requis", { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)

						if Selected then 

							revivePlayer(closestPlayer)    

						end

					end)

                    RageUI.ButtonWithStyle("~h~→ Soigner une petite blessure", "Bandage requis", { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)

						if (Selected) then 

							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 1.0 then

								ESX.ShowNotification('Aucune Personne à Proximité')

							else

								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)

									if quantity > 0 then

										local closestPlayerPed = GetPlayerPed(closestPlayer)

										local health = GetEntityHealth(closestPlayerPed)

		

										if health > 0 then

											local playerPed = PlayerPedId()

		

											IsBusy = true

											ESX.ShowNotification(_U('heal_inprogress'))

											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

											Citizen.Wait(10000)

											ClearPedTasks(playerPed)

		

											TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')

											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')

											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))

											IsBusy = false

										else

											ESX.ShowNotification(_U('player_not_conscious'))

										end

									else

										ESX.ShowNotification(_U('not_enough_bandage'))

									end

								end, 'bandage')

							end

						end

					end)


                    RageUI.ButtonWithStyle("~h~→ Soigner une plus grande blessure", "Kit de soin requis", { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)

						if (Selected) then 

							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 1.0 then

								ESX.ShowNotification('Aucune Personne à Proximité')

							else

								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)

									if quantity > 0 then

										local closestPlayerPed = GetPlayerPed(closestPlayer)

										local health = GetEntityHealth(closestPlayerPed)

		

										if health > 0 then

											local playerPed = PlayerPedId()

		

											IsBusy = true

											ESX.ShowNotification(_U('heal_inprogress'))

											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

											Citizen.Wait(10000)

											ClearPedTasks(playerPed)

		

											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')

											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')

											ESX.ShowNotification(_U('heal_complete'))

											IsBusy = false

										else

											ESX.ShowNotification(_U('player_not_conscious'))

										end

									else

										ESX.ShowNotification(_U('not_enough_medikit'))

									end

								end, 'medikit')
		
							end

						end

					end)

                end, function() 
                end)

                RageUI.IsVisible(Appel, true, true, true, function()

					for numreport = 1, #reportlistesql, 1 do

					  RageUI.ButtonWithStyle("[~b~Numéro ~s~: "..reportlistesql[numreport].id, nil, { RightLabel = "~r~En ATTENTE"}, true, function(Hovered, Active, Selected)

						  if (Selected) then

							  typereport = reportlistesql[numreport].type

							  reportjoueur = reportlistesql[numreport].reporteur

							  raisonreport = reportlistesql[numreport].raison

							  joueurreporter = reportlistesql[numreport].nomreporter

							  supprimer = reportlistesql[numreport].id

						  end

					  end, AppelKaito)

		

	end


               end, function() 
                end)

                RageUI.IsVisible(AppelKaito, true, true, true, function()

                    RageUI.Separator("~y~Type~s~ : Demande des secours")
                   
            
                    RageUI.CenterButton("~g~Prendre ~s~l'appel", nil, {}, true, function(Hovered, Active, Selected)
            
                        if Selected then
            
                            pris = true
            
                            TriggerServerEvent('EMS:PriseAppelServeurS')
            
                            TriggerServerEvent("EMS:AjoutAppelTotalServeurS")
            
                            TriggerEvent('emsAppelPrisS', AppelID, AppelCoords)
                            
                            TriggerServerEvent('ems:supprimeappelsss', supprimer)
            
                            TriggerServerEvent('Ambulance:AppelNotifs', supprimer)
            
                        end
            
                    end) 
            
                    RageUI.CenterButton("~r~Refuser ~s~l'appel~s~ ~b~N°".. supprimer, nil, {}, true, function(Hovered, Active, Selected)
            
                        if (Selected) then
            
                            pris = false
            
                            ESX.ShowAdvancedNotification("EMS", "~b~Demande des EMS", "Vous avez refuser l'appel.", "CHAR_CALL911", 8)
            
                            TriggerServerEvent('ems:supprimeappelsss', supprimer)

            
                        end
            
                    end)
                end, function() 
                end)

                
                RageUI.IsVisible(props, true, true, true, function()

		            RageUI.ButtonWithStyle("~h~→ Cône",nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            if limitCone < 10 then
                                spawnObject('prop_roadcone02a')
                                limitCone = limitCone + 1
                            else
    
                            end
        
                        end
                        end)

                        RageUI.ButtonWithStyle("~h~→ Trousse de soins",nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then 
                                if limittrousse < 5 then
                                    spawnObject('xm_prop_x17_bag_med_01a')
                                    limittrousse = limittrousse + 1
                                else
        
                                end
            
                            end
                            end)

                            RageUI.ButtonWithStyle("~h~→ Lit",nil, {}, true, function(Hovered, Active, Selected)
                                if Selected then 
                                    if limitlit < 1 then
                                        spawnObject('gr_prop_gr_campbed_01')
                                        limitlit = limitlit + 1
                                    else
            
                                    end
                
                                end
                                end)
                end, function() 
                end)
                if not RageUI.Visible(F6) and not RageUI.Visible(InteractionP) and not RageUI.Visible(Appel) and not RageUI.Visible(AppelKaito) and not RageUI.Visible(props) then
                    F6 = RMenu:DeleteType("F6", true)
                end
    end
end


Keys.Register('F6', 'EMS', 'Ouvrir le Menu EMS', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
    	F6EMS()
	end
end)



function GetPed(ped)

    PedARevive = ped

end



RegisterNetEvent("emsAppelPrisS")

AddEventHandler("emsAppelPrisS", function(Xid, XAppelCoords)

    ESX.ShowAdvancedNotification("EMS", "~b~Demande des EMS", "Vous avez pris l'appel, ~y~Dirigez-vous là-bas ~s~via votre GPS !", "CHAR_CALL911", 2)   

    afficherTextVolant(XAppelCoords, Xid)

end)



function afficherTextVolant(XAcoords, XAid)

     emsBlip = AddBlipForCoord(XAcoords)

    --SetBlipSprite(emsBlip, 353)

    SetBlipShrink(emsBlip, true)

    SetBlipScale(emsBlip, 0.9)

    SetBlipPriority(emsBlio, 150)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("~b~[EMS] Appel en cours")

    EndTextCommandSetBlipName(emsBlip)

     SetBlipRoute(emsBlip, true)

     SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)

     table.insert(tableBlip, emsBlip)

     rea = true

     while rea do

     if GetDistanceBetweenCoords(XAcoords, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then

        ESX.ShowAdvancedNotification("EMS", "~b~GPS des EMS", "Vous êtes arrivé !", "CHAR_CALL911", 2)   

        TriggerEvent("EMS:ClearAppel5")

end

Wait(1)

end

end





RegisterNetEvent("EMS:ClearAppel5")

AddEventHandler("EMS:ClearAppel5", function()

    for k, v in pairs(tableBlip) do

        RemoveBlip(v)

    end

    rea = false

    tableBlip = {}

end)




function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)

     local px,py,pz=table.unpack(GetGameplayCamCoords())

     local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    

     local scale = (1/dist)*20

     local fov = (1/GetGameplayCamFov())*100

     local scale = scale*fov   

     SetTextScale(scaleX*scale, scaleY*scale)

     SetTextFont(fontId)

     SetTextProportional(1)

     SetTextColour(250, 250, 250, 255)		-- You can change the text color here

     SetTextDropshadow(1, 1, 1, 1, 255)

     SetTextEdge(2, 0, 0, 0, 150)

     SetTextDropShadow()

     SetTextOutline()

     SetTextEntry("STRING")

     SetTextCentre(1)

     AddTextComponentString(textInput)

     SetDrawOrigin(x,y,z+2, 0)

     DrawText(0.0, 0.0)

     ClearDrawOrigin()

end



local AppelTotal = 0

local NomAppel = "~r~personne"

local enService = false



RegisterNetEvent("EMS:AjoutUnAppelS")

AddEventHandler("EMS:AjoutUnAppelS", function(Appel)

    AppelTotal = Appel

end)





RegisterNetEvent("EMS:PriseDeService")

AddEventHandler("EMS:PriseDeService", function(service)

    enService = service

end)



RegisterNetEvent("EMS:DernierAppel")

AddEventHandler("EMS:DernierAppel", function(Appel)

    NomAppel = Appel

end)



function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)

    SetTextFont(font)

    SetTextProportional(0)

    SetTextScale(sc, sc)

    N_0x4e096588b13ffeca(jus)

    SetTextColour(r, g, b, a)

    SetTextDropShadow(0, 0, 0, 0,255)

    SetTextEdge(1, 0, 0, 0, 255)

    SetTextDropShadow()

    SetTextOutline()

    SetTextEntry("STRING")

    AddTextComponentString(text)

    DrawText(x - 0.1+w, y - 0.02+h)

end



Citizen.CreateThread( function()	

    while true do

        Wait(1)

        if enService then

            DrawRect(0.888, 0.254, 0.196, 0.116, 0, 0, 0, 50)

            DrawAdvancedText(0.984, 0.214, 0.008, 0.0028, 0.4, "Dernière prise d'appel:", 0, 191, 255, 255, 6, 0)

            DrawAdvancedText(0.988, 0.236, 0.005, 0.0028, 0.4, "~b~"..NomAppel.." ~w~à pris le dernier appel EMS", 255, 255, 255, 255, 6, 0)

            DrawAdvancedText(0.984, 0.274, 0.008, 0.0028, 0.4, "Total d'appel prise en compte", 0, 191, 255, 255, 6, 0)

            DrawAdvancedText(0.988, 0.294, 0.005, 0.0028, 0.4, AppelTotal, 255, 255, 255, 255, 6, 0)

        end

    end

end)


RegisterNetEvent('openappels')

AddEventHandler('openappels', function()

    ESX.TriggerServerCallback('ems:afficheappelssss', function(keys)

        reportlistesql = keys

        end)

      RageUI.Visible(RMenu:Get('appels', 'main'), not RageUI.Visible(RMenu:Get('appels', 'main')))

end)





function revivePlayer(closestPlayer)

local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

if closestPlayer == -1 or closestDistance > 3.0 then

  ESX.ShowNotification(_U('no_players'))

else

ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)

if qtty > 0 then

local closestPlayerPed = GetPlayerPed(closestPlayer)

local health = GetEntityHealth(closestPlayerPed)

if health == 0 then

local playerPed = GetPlayerPed(-1)

Citizen.CreateThread(function()

ESX.ShowNotification(_U('revive_inprogress'))

TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

Wait(10000)

ClearPedTasks(playerPed)

if GetEntityHealth(closestPlayerPed) == 0 then

TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')

TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))

else

ESX.ShowNotification(_U('isdead'))

end

end)

else

    ESX.ShowNotification(_U('unconscious'))

end

 else

ESX.ShowNotification(_U('not_enough_medikit'))

end

end, 'medikit')

end

end



AddEventHandler("onResourceStart", function()

TriggerServerEvent('emssapl:deleteallappelsS', supprimer)

end)


