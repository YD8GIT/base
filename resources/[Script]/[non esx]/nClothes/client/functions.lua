nClothes.Functions = {}

function nClothes.Functions.RegisterBlip(_blip)
	local blip = AddBlipForCoord(_blip.pos)
    SetBlipSprite(blip, _blip.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, _blip.scale)
    SetBlipColour(blip, _blip.color)
    SetBlipAsShortRange(blip, true)
    SetBlipRoute(blip, _blip.route)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_blip.label)
    EndTextCommandSetBlipName(blip)
    return blip
end

function nClothes.Functions.ShowHelpNotification(text)
	AddTextEntry("NClothesHelpNotification", text)
    DisplayHelpTextThisFrame("NClothesHelpNotification", false)
end

function nClothes.Functions.Keyboard(string_args, max)
    local string = nil
    AddTextEntry("CUSTOM_AMOUNT", "~s~"..string_args)
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", "", "", "", "", "", max or 20)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        string = GetOnscreenKeyboardResult()
        Citizen.Wait(0)
    else
        Citizen.Wait(0)
    end
    return string
end

function nClothes.Functions.Notify(text)
    AddTextEntry("Notify", "<C>"..text)
    BeginTextCommandThefeedPost("Notify")
    EndTextCommandThefeedPostTicker(false, true)
end