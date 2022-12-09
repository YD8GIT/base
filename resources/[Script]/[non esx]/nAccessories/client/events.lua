RegisterNetEvent("esx:removeInventoryItem")
AddEventHandler("esx:removeInventoryItem", function(item, count)
	if count > 0 then return end
	for k,v in pairs(Config.itemsPrefix) do
		if string.sub(v, 1, string.len(v)) == v then
			setAccessories(v, -1, 0)
		end
	end
end)

RegisterNetEvent("nAccessories:useAccessories")
AddEventHandler("nAccessories:useAccessories", function(item)
	local _name, id_1, id_2 = splitArgs(item, "_")[1], tonumber(splitArgs(item, "_")[2]), tonumber(splitArgs(item, "_")[3])
	local _type = "NULL"
	for k,v in pairs(Config.itemsPrefix) do
		if v == _name then
			_type = k 
			break
		end
	end
	TriggerEvent("skinchanger:getSkin", function(skin)
		if skin[string.lower(_type) .. "_1"] > 0 then
			if _name == Config.itemsPrefix["Mask"] then
				TakeAnim("missfbi4", "takeoff_mask")
			elseif _name == Config.itemsPrefix["Ears"] then
				TakeAnim("mini@ears_defenders", "takeoff_earsdefenders_idle")
			elseif _name == Config.itemsPrefix["Helmet"] then
				TakeAnim("missfbi4", "takeoff_mask")
			elseif _name == Config.itemsPrefix["Glasses"] then
				TakeAnim("clothingspecs", "try_glasses_positive_a")
			elseif _name == Config.itemsPrefix["Bags"] then
				TakeAnim("missfbi4", "takeoff_mask")
			end
			Citizen.Wait(850)
			setAccessories(_name, -1, 0)
		else
			if _name == Config.itemsPrefix["Mask"] then
				TakeAnim("mp_masks@on_foot", "put_on_mask")
			elseif _name == Config.itemsPrefix["Ears"] then
				TakeAnim("mini@ears_defenders", "takeoff_earsdefenders_idle")
			elseif _name == Config.itemsPrefix["Helmet"] then
				TakeAnim("mp_masks@on_foot", "put_on_mask")
			elseif _name == Config.itemsPrefix["Glasses"] then
				TakeAnim("clothingspecs", "try_glasses_positive_a")
			elseif _name == Config.itemsPrefix["Bags"] then
				TakeAnim("mp_masks@on_foot", "put_on_mask")
			end
			Citizen.Wait(500)
			setAccessories(_name, id_1, id_2)
		end
	end)
end)
