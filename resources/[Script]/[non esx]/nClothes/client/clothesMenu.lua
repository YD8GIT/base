nClothes.Config.mainMenu = false
nClothes.Config.currentSkin = nil
nClothes.Config.currentIndex = nil
nClothes.Config.skinSelectedIndexName = nil
nClothes.Config.mainIndex = 1
nClothes.Config.componentsList = {'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2', 'decals_1', 'decals_2', 'arms', 'pants_1', 'pants_2', 'shoes_1', 'shoes_2', 'chain_1', 'chain_2', 'helmet_1', 'helmet_2', 'glasses_1', 'glasses_2'}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

local function RefreshSkinValues()
    nClothes.Config.skinComponents = {}
    nClothes.Config.skinValues = {}
    TriggerEvent("skinchanger:getData", function(components, values)
        nClothes.Config.skinComponents = components
        nClothes.Config.skinValues = values
    end)
end

local function HasValueCompenents(value)
    for k,v in pairs(nClothes.Config.componentsList) do
        if value == v then
            return true
        end
    end
    return false
end

function OpenClothesShop()
    if not nClothes.Config.mainMenu then
        RMenu.Add("clothes", "main_menu", RageUI.CreateMenu("Vêtements", "INTÉRACTIONS"))
        RMenu.Add("clothes", "skin", RageUI.CreateSubMenu(RMenu:Get("clothes", "main_menu"), "Vêtements", "INTÉRACTIONS"))
        RMenu.Add("clothes", "save", RageUI.CreateSubMenu(RMenu:Get("clothes", "main_menu"), "Vêtements", "INTÉRACTIONS"))
        RMenu.Add("clothes", "list", RageUI.CreateSubMenu(RMenu:Get("clothes", "skin"), "Vêtements", "INTÉRACTIONS"))
        RMenu:Get("clothes", "list").Closed = function()
            RefreshSkinValues()
        end
        RMenu:Get("clothes", "main_menu").Closed = function()
            if nClothes.Config.currentSkin ~= nil then
                TriggerEvent("skinchanger:loadSkin", nClothes.Config.currentSkin)
            end 
            nClothes.Config.currentSkin = nil
            nClothes.Config.mainMenu = false
        end
        nClothes.Config.mainMenu = true
        RageUI.Visible(RMenu:Get("clothes", "main_menu"), not RageUI.Visible(RMenu:Get("clothes", "main_menu")))
        TriggerEvent("skinchanger:getSkin", function(skin) nClothes.Config.currentSkin = skin end)
        TriggerServerEvent("nClothes:GetClothes")
        Citizen.CreateThread(function()
            while nClothes.Config.mainMenu do
                RageUI.IsVisible(RMenu:Get("clothes", "main_menu"), function()
                    RageUI.Button("~c~→~s~ Enregistrée une tenue", nil, {RightLabel = "~g~"..(nClothes.Config.Price).."$"}, true, {
                        onSelected = function()
                            if (ESX.PlayerData.money >= nClothes.Config.Price) then 
                                local name = nClothes.Functions.Keyboard("Nom de la tenue", 25)
                                if name ~= nil then
                                    TriggerEvent("skinchanger:getSkin", function(skin)
                                        TriggerServerEvent("nClothes:SaveClothes", name, skin)
                                        nClothes.Config.currentSkin = skin
                                    end)
                                end
                            else
                                nClothes.Functions.Notify("~r~Vous n'avez pas assez d'argent.")
                            end
                        end,
                    })
                    RageUI.Button("~c~→~s~ Créer une tenue", nil, {}, true, {
                        onSelected = function()
                            RefreshSkinValues()
                        end,
                    }, RMenu:Get("clothes", "skin"))
                    RageUI.Button("~c~→~s~ Gestion des tenues", nil, {}, true, {
                    }, RMenu:Get("clothes", "save"))
                end)
                RageUI.IsVisible(RMenu:Get("clothes", "skin"), function()
                    for k,v in pairs(nClothes.Config.skinComponents) do
                        if HasValueCompenents(v.name) then
                            RageUI.Button("~c~→~s~ "..v.label, nil, {RightLabel = nClothes.Config.skinValues[v.name]}, true, {
                                onSelected = function()
                                    nClothes.Config.currentIndex = nil
                                    nClothes.Config.skinSelectedIndexName = v.name
                                end,
                            }, RMenu:Get("clothes", "list"))
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get("clothes", "list"), function()
                    if nClothes.Config.skinSelectedIndexName ~= nil and nClothes.Config.skinValues[nClothes.Config.skinSelectedIndexName] ~= nil then
                        for i=1, nClothes.Config.skinValues[nClothes.Config.skinSelectedIndexName] do
                            RageUI.Button("Article", nil, {RightLabel = "#"..i}, true, {
                                onActive = function()
                                    if nClothes.Config.currentIndex ~= i then
                                        TriggerEvent("skinchanger:change", nClothes.Config.skinSelectedIndexName, i-1)
                                        nClothes.Config.currentIndex = i
                                    end
                                end,
                            })
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get("clothes", "save"), function()
                    for k,v in pairs(nClothes.Config.myOutfits) do
                        RageUI.List("~c~→~s~ "..v.label, {"Mettre", "Donner", "Supprimer"}, nClothes.Config.mainIndex, nil, {}, true, {
                            onListChange = function(Index)
                                nClothes.Config.mainIndex = Index
                            end,
                            onSelected = function()
                                if nClothes.Config.mainIndex == 1 then
                                    TriggerEvent("skinchanger:getSkin", function(skin)
                                        TriggerEvent("skinchanger:loadClothes", skin, v.skin)
                                        TriggerEvent("skinchanger:getSkin", function(skin)
                                            TriggerServerEvent("nClothes:SetSkin", skin)
                                            nClothes.Config.currentSkin = skin
                                        end)
                                    end)
                                elseif nClothes.Config.mainIndex == 2 then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer ~= -1 and closestDistance <= 2.0 then
                                        TriggerServerEvent("nClothes:GiveOutfit", v.id, GetPlayerServerId(closestPlayer))
                                    else
                                        nClothes.Functions.Notify("~r~Aucun(e) individu(s) à proximité.")
                                    end
                                elseif nClothes.Config.mainIndex == 3 then
                                    TriggerServerEvent("nClothes:DeleteOutfit", v.id)
                                end
                            end,
                        })
                    end
                end)
                Citizen.Wait(0)
            end
        end)
    end
end