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
function VEMS()
    local VEMS = RageUI.CreateMenu("~u~Vestiaire", "Menu Intéraction..")
    VEMS:SetRectangleBanner(175, 175, 175)
        RageUI.Visible(VEMS, not RageUI.Visible(VEMS))
            while VEMS do
            Citizen.Wait(0)
            RageUI.IsVisible(VEMS, true, true, true, function()

                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Vestiaire.position.x, Ambulance.pos.Vestiaire.position.y, Ambulance.pos.Vestiaire.position.z)
                if dist3 >= 1.5 then
            RageUI.CloseAll()
                else

                RageUI.ButtonWithStyle("S'équiper de sa tenue | ~b~Civile",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                    if Selected then
                        startAnim('clothingtie', 'try_tie_positive_a')
                        Citizen.Wait(5000)
                        vcivil()
                    end
                end)
    

                RageUI.ButtonWithStyle("S'équiper de la tenue | ~p~Ambulancier",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                    if Selected then
                        startAnim('clothingtie', 'try_tie_positive_a')
                        Citizen.Wait(5000)
                        v1()
                    end
                end)
            

            if ESX.PlayerData.job.grade_name == 'doctor' or ESX.PlayerData.job.grade_name == 'chief_doctor' or ESX.PlayerData.job.grade_name == 'boss' then 
                RageUI.ButtonWithStyle("S'équiper de la tenue | ~o~Medecin",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                    if Selected then
                        startAnim('clothingtie', 'try_tie_positive_a')
                        Citizen.Wait(5000)
                        v2()
                    end
                end)
            end

            if ESX.PlayerData.job.grade_name == 'chief_doctor' or ESX.PlayerData.job.grade_name == 'boss' then 
                RageUI.ButtonWithStyle("S'équiper de la tenue | ~y~Medecin-Chef",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                    if Selected then
                        startAnim('clothingtie', 'try_tie_positive_a')
                        Citizen.Wait(5000)
                        v3()
                    end
                end)
            end

            if ESX.PlayerData.job.grade_name == 'boss' then 
                RageUI.ButtonWithStyle("S'équiper de la tenue | ~r~Patron",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                    if Selected then
                        startAnim('clothingtie', 'try_tie_positive_a')
                        Citizen.Wait(5000)
                        v4()
                    end
                end)
            end
    
        end

            end, function()
            end, 1)

            if not RageUI.Visible(VEMS) then
            VEMS = RMenu:DeleteType("VEMS", true)
        end
    end
end


    function startAnim(lib, anim)
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
        end)
    end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ambulance.pos.Vestiaire.position.x, Ambulance.pos.Vestiaire.position.y, Ambulance.pos.Vestiaire.position.z)
        if dist3 <= 1.2 and Ambulance.jeveuxmarker then
            Timer = 0
            DrawMarker(25, Ambulance.pos.Vestiaire.position.x, Ambulance.pos.Vestiaire.position.y, Ambulance.pos.Vestiaire.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 0 , 255, false, true, p19, true)
            end
            if dist3 <= 1.2 then
                Timer = 0   
                    RageUI.Text({  message = "Appuyez sur [~b~E~w~] pour ouvrir votre vestiaire", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            VEMS()    
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function v1()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 200, ['torso_2'] = 0,
                ['arms'] = 74,
                ['pants_1'] = 87, ['pants_2'] = 0,
                ['shoes_1'] = 10, ['shoes_2'] = 0,
                ['chain_1'] = 110,  ['chain_2'] = 0,
                ['bags_1'] = 51, ['bags_2'] = 0,

            }
        else
            clothesSkin = {
                ['tshirt_1'] = 31, ['tshirt_2'] = 0,
                ['torso_1'] = 203, ['torso_2'] = 1,
                ['arms'] = 55,
                ['pants_1'] = 86, ['pants_2'] = 2,
                ['shoes_1'] = 35, ['shoes_2'] = 0,
                ['chain_1'] = 23,  ['chain_2'] = 2,
                ['bags_1'] = 25, ['bags_2'] = 3,

            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end

function v2()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = 34, ['tshirt_2'] = 0,
                ['torso_1'] = 120, ['torso_2'] = 0,
                ['arms'] = 53,
                ['pants_1'] = 90, ['pants_2'] = 5,
                ['shoes_1'] = 35, ['shoes_2'] = 0,
                ['chain_1'] = 23,  ['chain_2'] = 2,
                ['bags_1'] = 26, ['bags_2'] = 3,

            }
        else
            clothesSkin = {
                ['tshirt_1'] = 31, ['tshirt_2'] = 0,
                ['torso_1'] = 203, ['torso_2'] = 1,
                ['arms'] = 55,
                ['pants_1'] = 86, ['pants_2'] = 2,
                ['shoes_1'] = 35, ['shoes_2'] = 0,
                ['chain_1'] = 23,  ['chain_2'] = 2,
                ['bags_1'] = 25, ['bags_2'] = 3,

            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end

function v3()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = 34, ['tshirt_2'] = 0,
                ['torso_1'] = 120, ['torso_2'] = 0,
                ['arms'] = 53,
                ['pants_1'] = 90, ['pants_2'] = 5,
                ['shoes_1'] = 35, ['shoes_2'] = 0,
                ['chain_1'] = 23,  ['chain_2'] = 2,
                ['bags_1'] = 26, ['bags_2'] = 3,

            }
        else
            clothesSkin = {
                ['tshirt_1'] = 31, ['tshirt_2'] = 0,
                ['torso_1'] = 203, ['torso_2'] = 1,
                ['arms'] = 55,
                ['pants_1'] = 86, ['pants_2'] = 2,
                ['shoes_1'] = 35, ['shoes_2'] = 0,
                ['chain_1'] = 23,  ['chain_2'] = 2,
                ['bags_1'] = 25, ['bags_2'] = 3,

            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end

function v4()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = 34, ['tshirt_2'] = 0,
                ['torso_1'] = 120, ['torso_2'] = 0,
                ['arms'] = 53,
                ['pants_1'] = 90, ['pants_2'] = 5,
                ['shoes_1'] = 35, ['shoes_2'] = 0,
                ['chain_1'] = 23,  ['chain_2'] = 2,
                ['bags_1'] = 26, ['bags_2'] = 3,

            }
        else
            clothesSkin = {
                ['tshirt_1'] = 31, ['tshirt_2'] = 0,
                ['torso_1'] = 203, ['torso_2'] = 1,
                ['arms'] = 55,
                ['pants_1'] = 86, ['pants_2'] = 2,
                ['shoes_1'] = 35, ['shoes_2'] = 0,
                ['chain_1'] = 23,  ['chain_2'] = 2,
                ['bags_1'] = 25, ['bags_2'] = 3,

            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end

function vcivil()
ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
TriggerEvent('skinchanger:loadSkin', skin)
end)
end