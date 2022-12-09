nClothes.Config.Zones = {
    {pos = vector3(72.254,-1399.102,29.376)},
    {pos = vector3(-703.776,-152.258,37.415)},
    {pos = vector3(-167.863,-298.969,39.733)},
    {pos = vector3(428.694, -800.106,29.491)},
    {pos = vector3(-829.413,-1073.710,11.328)},
    {pos = vector3(-1447.797,-242.461,49.820)},
    {pos = vector3(11.632,6514.224,31.877)},
    {pos = vector3(123.646, -219.440,54.557)},
    {pos = vector3(1696.291,4829.312,42.063)},
    {pos = vector3(618.093, 2759.629,42.088)},
    {pos = vector3(1190.550,2713.441,38.222)},
    {pos = vector3(-1193.429,-772.262,17.324)},
    {pos = vector3(-3172.496,1048.133,20.863)},
    {pos = vector3(-1108.441,2708.923,19.107)},
}

Citizen.CreateThread(function()
    while true do
        local crtWait = 750
        for k,v in pairs(nClothes.Config.Zones) do
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.pos, true) < 10.0 then
                crtWait = 0
                DrawMarker(29, v.pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.50, 0.50, 0.50, 50, 200, 0, 255, 55555, false, true, 2, false, false, false, false)
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.pos, true) < 2.0 then
                    nClothes.Functions.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin de vêtements")
                    if IsControlJustReleased(1, 38) then
                        OpenClothesShop()
                    end
                end
            end
        end
        Citizen.Wait(crtWait)
    end
end)

for k,v in pairs(nClothes.Config.Zones) do
    nClothes.Functions.RegisterBlip({pos = v.pos, id = 73, scale = 0.6, color = 0, route = false, label = "Magasin de vêtements"})
end