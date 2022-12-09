for k,v in pairs(Config.Zones) do
    for o,p in pairs(v) do
        RegisterZone("acc_"..k.."_"..o, {
            {
                pos = p,
                marker = {id = 6, color = {r = 0, g = 175, b = 255, a = 255}, dst = 10.0},
                dst = 1.5,
                action = function()
                    OpenAccessoriesMenu(Config.itemsPrefix[k])
                end,
                key = 38,
                text = "Appuyez sur [~b~E~s~] pour accéder au ~b~magasin",
            },
        })
    end
end

Citizen.CreateThread(function()
    while true do
        local crtWait = 750
        for k in pairs(Config._Zones) do
            for i,v in pairs(Config._Zones[k]) do
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.pos, true) < v.marker.dst then
                    crtWait = 0
                    DrawMarker(v.marker.id, vector3(v.pos.x, v.pos.y, v.pos.z-1), 0.0, 0.0, 360.0, 0.0, 0.0, 0.0, 1.0, 0.5, 1.0, v.marker.color.r, v.marker.color.g, v.marker.color.b, v.marker.color.a, false, false, 2, nil, nil, false)
                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.pos, true) < v.dst then
                        DrawText3D(v.pos, v.text)
                        if IsControlJustReleased(1, v.key) then
                            v.action()
                        end
                    end
                end
            end
        end
        Citizen.Wait(crtWait)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-1336.6, -1279.3, 3.9)
    SetBlipSprite(blip, 362)
    SetBlipDisplay(blip, 4)
    SetBlipScale (blip, 0.6)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Magasin d\'accessoires')
    EndTextCommandSetBlipName(blip)
end)