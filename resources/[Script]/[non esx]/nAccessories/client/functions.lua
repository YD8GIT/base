function setAccessories(_type, id_1, id_2)
	local zoneType = "NULL"
	for k,v in pairs(Config.itemsPrefix) do
		if v == _type then
			zoneType = k 
			break
		end
	end
	TriggerEvent("skinchanger:getSkin", function(skin)
		ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(playerSkin, jailSkin)
			local clothes = {}
			clothes[string.lower(zoneType) .. "_1"] = id_1
			clothes[string.lower(zoneType) .. "_2"] = id_2
			if _type == "imask" then
				if id_1 == -1 then
					skin["face"] = playerSkin["face"]
				else
					skin["face"] = 0
				end
			end
			TriggerEvent("skinchanger:loadClothes", skin, clothes)
		end)
	end)
end

function splitArgs(string, name)
	if name == nil then 
		name = "%s" 
	end
	local _table = {}
	for k in string.gmatch(string, "([^"..name.."]+)") do
		table.insert(_table, k)
	end
	return _table
end

function setPedAccessories(_type, id_1, id_2)
    if _type == "imask" then
        SetPedComponentVariation(PlayerPedId(), 1, id_1, id_2, 2)
    elseif _type == "iears" then
        if id_1 <= 0 then
            ClearPedProp(PlayerPedId(), 2)
        else
            SetPedPropIndex(PlayerPedId(), 2, id_1, id_2, 2)
        end
    elseif _type == "ihelmet" then
        if id_1 <= 0 then
            ClearPedProp(PlayerPedId(), 0)
        else
            SetPedPropIndex(PlayerPedId(), 0, id_1, id_2, 2)
        end
    elseif _type == "iglass" then
        if id_1 <= 0 then
            ClearPedProp(PlayerPedId(), 1)
        else
            SetPedPropIndex(PlayerPedId(), 1, id_1, id_2, 2)
        end
    elseif _type == "ibag" then
        SetPedComponentVariation(PlayerPedId(), 5, id_1, id_2, 2)
    end
end

function RegisterZone(name, action)
    Config._Zones[name] = action
end

function DrawText3D(coords, text, size, font)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	local camCoords = GetGameplayCamCoords()
	local distance = #(vector - camCoords)
	if not size then size = 1 end
	if not font then font = 0 end
	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov
	SetTextScale(0.3, 0.3)
	SetTextProportional(1)
	SetTextDropshadow(100, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	SetDrawOrigin(vector.xyz, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function TakeAnim(lib, anim)
	Citizen.CreateThread(function()
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 8.0, -1, 49, 0, false, false, false)
			Citizen.Wait(GetAnimDuration(lib, anim) * 1000)
			ClearPedTasks(PlayerPedId())
			RemoveAnimDict(lib)
		end)
	end)
end