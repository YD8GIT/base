ESX = nil



TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



local PlayerData = {}



RegisterNetEvent('esx:playerLoaded')

AddEventHandler('esx:playerLoaded', function(xPlayer)

     PlayerData = xPlayer
     ESX.PlayerData = xPlayer


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

RegisterNetEvent('esx:setJob')

AddEventHandler('esx:setJob', function(job)

	ESX.PlayerData.job = job

end)





function coffreAmbulance()

    local CAmbulance = RageUI.CreateMenu("~u~Coffre", "Menu Intéraction..")

    CAmbulance:SetRectangleBanner(175, 175, 175)

        RageUI.Visible(CAmbulance, not RageUI.Visible(CAmbulance))

            while CAmbulance do

            Citizen.Wait(0)

            RageUI.IsVisible(CAmbulance, true, true, true, function()


                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.coffre.position.x, Ambulance.pos.coffre.position.y, Ambulance.pos.coffre.position.z)
                if dist3 >= 1.5 then
            RageUI.CloseAll()
                else

                    RageUI.ButtonWithStyle("Retirer un objet(s)",nil, {RightBadge = RageUI.BadgeStyle.Package}, true, function(Hovered, Active, Selected)

                        if Selected then

                            AmbulanceRetirerobjet()

                            RageUI.CloseAll()

                        end

                    end)

                    

                    RageUI.ButtonWithStyle("Déposer un objet(s)",nil, {RightBadge = RageUI.BadgeStyle.Package}, true, function(Hovered, Active, Selected)

                        if Selected then

                            AmbulanceDeposerobjet()

                            RageUI.CloseAll()

                        end

                    end)
                end


                end, function()

                end)

            if not RageUI.Visible(CAmbulance) then
            CAmbulance = RMenu:DeleteType("CAmbulance", true)

        end

    end

end



Citizen.CreateThread(function()

        while true do

            local Timer = 500

            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)

            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Ambulance.pos.coffre.position.x, Ambulance.pos.coffre.position.y, Ambulance.pos.coffre.position.z)

            if jobdist <= 2.0 and Ambulance.jeveuxmarker then

                Timer = 0


                DrawMarker(25, Ambulance.pos.coffre.position.x, Ambulance.pos.coffre.position.y, Ambulance.pos.coffre.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 0, 255, false, true, p19, true)
                end

                if jobdist <= 1.5 then

                    Timer = 0

                        RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder au coffre", time_display = 1 })

                        if IsControlJustPressed(1,51) then
                        coffreAmbulance()


                    end   

                end

            end 

        Citizen.Wait(Timer)   

    end

end)





itemstock = {}

function AmbulanceRetirerobjet()

    local StockAmbulance = RageUI.CreateMenu("~u~Coffre", "Menu Intéraction..")

    StockAmbulance:SetRectangleBanner(175, 175, 175)

    ESX.TriggerServerCallback('KAmbulance:getStockItems', function(items) 

    itemstock = items

    RageUI.Visible(StockAmbulance, not RageUI.Visible(StockAmbulance))

        while StockAmbulance do

            Citizen.Wait(0)

                RageUI.IsVisible(StockAmbulance, true, true, true, function()
                    local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                    local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.coffre.position.x, Ambulance.pos.coffre.position.y, Ambulance.pos.coffre.position.z)
                    if dist3 >= 1.5 then
                RageUI.CloseAll()
                    else
                        for k,v in pairs(itemstock) do 

                            if v.count ~= 0 then

                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    local count = KeyboardInput("Combien ?", '' , 8)

                                    TriggerServerEvent('KAmbulance:getStockItem', v.name, tonumber(count))

                                    AmbulanceRetirerobjet()

                                end

                            end)

                        end
                    end
                    end

                end, function()

                end)

            if not RageUI.Visible(StockAmbulance) then
            StockAmbulance = RMenu:DeleteType("Coffre", true)

        end

    end

end)

end



local PlayersItem = {}

function AmbulanceDeposerobjet()

    local DepositAmbulance = RageUI.CreateMenu("~u~Coffre", "Menu Intéraction..")

    DepositAmbulance:SetRectangleBanner(175, 175, 175)

    ESX.TriggerServerCallback('KAmbulance:getPlayerInventory', function(inventory)

        RageUI.Visible(DepositAmbulance, not RageUI.Visible(DepositAmbulance))

    while DepositAmbulance do

        Citizen.Wait(0)

            RageUI.IsVisible(DepositAmbulance, true, true, true, function()
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.coffre.position.x, Ambulance.pos.coffre.position.y, Ambulance.pos.coffre.position.z)
                if dist3 >= 1.5 then
            RageUI.CloseAll()
                else
                for i=1, #inventory.items, 1 do

                    if inventory ~= nil then

                            local item = inventory.items[i]

                            if item.count > 0 then

                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)

                                            if Selected then

                                            local count = KeyboardInput("Combien ?", '' , 8)

                                            TriggerServerEvent('KAmbulance:putStockItems', item.name, tonumber(count))

                                            AmbulanceDeposerobjet()

                                        end

                                    end)

                                end

                            else

                                RageUI.Separator('Chargement en cours')

                            end

                        end
                    end

                    end, function()

                    end)

                if not RageUI.Visible(DepositAmbulance) then
                DepositAmbulance = RMenu:DeleteType("Coffre", true)

            end

        end

    end)

end





function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)





    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)

    blockinput = true



    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 

        Citizen.Wait(0)

    end

        

    if UpdateOnscreenKeyboard() ~= 2 then

        local result = GetOnscreenKeyboardResult() 

        Citizen.Wait(500) 

        blockinput = false

        return result 

    else

        Citizen.Wait(500) 

        blockinput = false 

        return nil 

    end

end



