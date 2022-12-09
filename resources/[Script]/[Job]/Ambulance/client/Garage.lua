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


function GEMS()
    local GarageKaito = RageUI.CreateMenu("~u~Garage", "Menu Intéraction..")
    GarageKaito:SetRectangleBanner(175, 175, 175)
      RageUI.Visible(GarageKaito, not RageUI.Visible(GarageKaito))
          while GarageKaito do
              Citizen.Wait(0)
                  RageUI.IsVisible(GarageKaito, true, true, true, function()
  
                    local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                    local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Garage.position.x, Ambulance.pos.Garage.position.y, Ambulance.pos.Garage.position.z)
                    if dist3 >= 1.5 then
                RageUI.CloseAll()
                    else

                      for k,v in pairs(Vehicle) do
                      RageUI.ButtonWithStyle(v.nom, nil, {RightBadge = RageUI.BadgeStyle.Car},true, function(Hovered, Active, Selected)
                          if (Selected) then
                          Citizen.Wait(1)  
                              spawnC(v.modele)
                              RageUI.CloseAll()
                              end
                          end)
                      end

                      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'chief_doctor' or ESX.PlayerData.job.grade_name == 'boss' then 
                      for k,v in pairs(VehicleBoss) do
                        RageUI.ButtonWithStyle(v.nom, nil, {RightBadge = RageUI.BadgeStyle.Car},true, function(Hovered, Active, Selected)
                            if (Selected) then
                            Citizen.Wait(1)  
                                spawnC(v.modele)
                                RageUI.CloseAll()
                                end
                            end)
                        end
                    end

                end
                  end, function()
                  end)
              if not RageUI.Visible(GarageKaito) then
              GarageKaito = RMenu:DeleteType("Garage", true)
          end
      end
  end

---------------------------- MENU VOITURE ----------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Garage.position.x, Ambulance.pos.Garage.position.y, Ambulance.pos.Garage.position.z)
        if dist3 <= 1.5 then
            Timer = 0
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~o~E~w~] pour choisir un véhicule", time_display = 1 })
                        if IsControlJustPressed(1,51) then        
                            GEMS()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)



------------------ SUPPRIMER VOITURE ----------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.SupprimerVoiture.position.x, Ambulance.pos.SupprimerVoiture.position.y, Ambulance.pos.SupprimerVoiture.position.z)
        if dist3 <= 10.0 and Ambulance.jeveuxmarker then
            Timer = 0
            DrawMarker(22, Ambulance.pos.SupprimerVoiture.position.x, Ambulance.pos.SupprimerVoiture.position.y, Ambulance.pos.SupprimerVoiture.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour ranger ton véhicule", time_display = 1 })
                        if IsControlJustPressed(1,51) then     
                            
                            saveVeh()
                    end   
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function spawnC(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Ambulance.pos.SpawnVehicle.position.x, Ambulance.pos.SpawnVehicle.position.y, Ambulance.pos.SpawnVehicle.position.z, Ambulance.pos.SpawnVehicle.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "EMS"
    SetVehicleNumberPlateText(vehicle, plaque) 
end

function spawnH(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Ambulance.pos.SpawnHeli.position.x, Ambulance.pos.SpawnHeli.position.y, Ambulance.pos.SpawnHeli.position.z, Ambulance.pos.SpawnHeli.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "EMS"
    SetVehicleNumberPlateText(vehicle, plaque) 
end


function saveVeh()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local veh, dist = ESX.Game.GetClosestVehicle(GetEntityCoords(ped))
        if dist < 2 then
            local model = GetEntityModel(veh)
            local carname = GetDisplayNameFromVehicleModel(model)
            TaskLeaveVehicle(ped, veh, 0)
            Citizen.Wait(3000)
            NetworkFadeOutEntity(veh, false, true)
            Citizen.Wait(5000)
            DeleteVehicle(veh)
        end
    end)
end


-------- PED 

local npc2 = {
	{hash="s_m_m_doctor_01", x = -847.59, y = -1230.97, z = 6.83, a=330.29}, 
}

Citizen.CreateThread(function()
	for _, item2 in pairs(npc2) do
		local hash = GetHashKey(item2.hash)
		while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(20)
		end
		ped2 = CreatePed("PED_TYPE_CIVFEMALE", item2.hash, item2.x, item2.y, item2.z-0.92, item2.a, false, true)
		SetBlockingOfNonTemporaryEvents(ped2, true)
		FreezeEntityPosition(ped2, true)
		SetEntityInvincible(ped2, true)
	end
end)   

---------------------------------------- TP ----------------------------------------------------

--MONTER
Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.MAscenseur.position.x, Ambulance.pos.MAscenseur.position.y, Ambulance.pos.MAscenseur.position.z)
        if dist3 <= 1.2 then
            Timer = 0
            end
            if dist3 <= 1.2 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~o~E~w~] pour prendre l'ascenseur", time_display = 1 })
                        if IsControlJustPressed(1,51) then  
                            ESX.Game.Teleport(PlayerPedId(), {x = Ambulance.pos.Monter.position.x, y = Ambulance.pos.Monter.position.y, z = Ambulance.pos.Monter.position.z})       
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

--DESCENDRE
Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.DAscenseur.position.x, Ambulance.pos.DAscenseur.position.y, Ambulance.pos.DAscenseur.position.z)
        if dist3 <= 1.2 then
            Timer = 0
            end
            if dist3 <= 1.2 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~o~E~w~] pour descendre du toit", time_display = 1 })
                        if IsControlJustPressed(1,51) then  
                            ESX.Game.Teleport(PlayerPedId(), {x = Ambulance.pos.Descendre.position.x, y = Ambulance.pos.Descendre.position.y, z = Ambulance.pos.Descendre.position.z})       
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

local npc2 = {
	{hash="s_m_m_doctor_01", x = -781.73, y = -1201.63, z = 51.07, a=346.44}, 
}

Citizen.CreateThread(function()
	for _, item2 in pairs(npc2) do
		local hash = GetHashKey(item2.hash)
		while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(20)
		end
		ped2 = CreatePed("PED_TYPE_CIVFEMALE", item2.hash, item2.x, item2.y, item2.z-0.92, item2.a, false, true)
		SetBlockingOfNonTemporaryEvents(ped2, true)
		FreezeEntityPosition(ped2, true)
		SetEntityInvincible(ped2, true)
	end
end)   


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Heliport.position.x, Ambulance.pos.Heliport.position.y, Ambulance.pos.Heliport.position.z)
        if dist3 <= 1.5 then
            Timer = 0
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~o~E~w~] pour prendre un hélicoptère", time_display = 1 })
                        if IsControlJustPressed(1,51) then        
                            HeliEMS()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function HeliEMS()
    local GarageHeliEMS = RageUI.CreateMenu("~u~Garage", "Menu Intéraction..")
    GarageHeliEMS:SetRectangleBanner(175, 175, 175)
      RageUI.Visible(GarageHeliEMS, not RageUI.Visible(GarageHeliEMS))
          while GarageHeliEMS do
              Citizen.Wait(0)
                  RageUI.IsVisible(GarageHeliEMS, true, true, true, function()
  
                    local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                    local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Heliport.position.x, Ambulance.pos.Heliport.position.y, Ambulance.pos.Heliport.position.z)
                    if dist3 >= 1.5 then
                RageUI.CloseAll()
                    else


                      for k,v in pairs(Helico) do
                      RageUI.ButtonWithStyle(v.nom, nil, {RightBadge = RageUI.BadgeStyle.Car},true, function(Hovered, Active, Selected)
                          if (Selected) then
                          Citizen.Wait(1)  
                              spawnH(v.modele)
                              RageUI.CloseAll()
                              end
                          end)
                      end
                    end
                  end, function()
                  end)
              if not RageUI.Visible(GarageHeliEMS) then
              GarageHeliEMS = RMenu:DeleteType("Garage", true)
          end
      end
  end

  Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.SupprimerHeli.position.x, Ambulance.pos.SupprimerHeli.position.y, Ambulance.pos.SupprimerHeli.position.z)
        if dist3 <= 10.0 and Ambulance.jeveuxmarker then
            Timer = 0
            DrawMarker(22, Ambulance.pos.SupprimerHeli.position.x, Ambulance.pos.SupprimerHeli.position.y, Ambulance.pos.SupprimerHeli.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour ranger ton véhicule", time_display = 1 })
                        if IsControlJustPressed(1,51) then     
                                  
                    saveVeh()
                    end   
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)
