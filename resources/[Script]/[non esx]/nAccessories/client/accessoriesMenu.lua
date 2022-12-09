local function InitAccessoriesItems()
	itemCategory = {}
	itemsCategory = {}
	for k,v in pairs(Config.Items) do
		local _name, id_1, id_2 = splitArgs(k, "_")[1], tonumber(splitArgs(k, "_")[2]), tonumber(splitArgs(k, "_")[3])
		if itemCategory[_name] == nil then itemCategory[_name] = {} end
		if itemsCategory[_name] == nil then itemsCategory[_name] = {} end
		local label = splitArgs(v, "(")[1]
		local name = label:gsub("%s+", "")
		if not itemsCategory[_name][name] then
			table.insert(itemCategory[_name], {
				label = label,
				_name = _name,
				name = name,
			})
			itemsCategory[_name][name] = {}
		end
		table.insert(itemsCategory[_name][name], {
			label = v,
			item = k,
		})
	end
	for _,v in pairs(itemCategory) do
		for _, e in pairs(v) do
			e.rightLabel = #itemsCategory[e._name][e.name]
		end
	end
end

function OpenAccessoriesMenu(_name)
	InitAccessoriesItems()
	local _, _id_1, _id_2 = splitArgs(itemsCategory[_name][itemCategory[_name][1].name][1].item, "_")[1], tonumber(splitArgs(itemsCategory[_name][itemCategory[_name][1].name][1].item, "_")[2]), tonumber(splitArgs(itemsCategory[_name][itemCategory[_name][1].name][1].item, "_")[3])
	setPedAccessories(_name, _id_1, _id_2)
	RMenu.Add("acc_menu", "acc_categories", RageUI.CreateMenu("Accessoires", "INTÉRACTIONS"))
    RMenu.Add("acc_menu", "acc_list", RageUI.CreateSubMenu(RMenu:Get("acc_menu", "acc_categories"), "Accessoires", "INTÉRACTIONS"))
	RMenu:Get("acc_menu", "acc_list").Closed = function()
		setAccessories(_name, -1, 0)
    end
    RMenu:Get("acc_menu", "acc_categories").Closed = function()
		setAccessories(_name, -1, 0)
        Config.mainMenu = false
    end
    if not Config.mainMenu then
        Config.mainMenu = true
        RageUI.Visible(RMenu:Get("acc_menu", "acc_categories"), not RageUI.Visible(RMenu:Get("acc_menu", "acc_categories")))
        Citizen.CreateThread(function()
			local crtSelected = nil
            while Config.mainMenu do
                RageUI.IsVisible(RMenu:Get("acc_menu", "acc_categories"), function()
					for k,v in pairs(itemCategory[_name]) do
						RageUI.Button("~c~→~s~ "..v.label, nil, {RightLabel = v.rightLabel}, true, {
							onActive = function()
								setPedAccessories(splitArgs(itemsCategory[_name][v.name][1].item, "_")[1], tonumber(splitArgs(itemsCategory[_name][v.name][1].item, "_")[2]), tonumber(splitArgs(itemsCategory[_name][v.name][1].item, "_")[3]))
							end,
							onSelected = function()
								crtSelected = v
							end,
						}, RMenu:Get("acc_menu", "acc_list"))
					end
				end)
				RageUI.IsVisible(RMenu:Get("acc_menu", "acc_list"), function()
					if crtSelected ~= nil then
						for k,v in pairs(itemsCategory[_name][crtSelected.name]) do
							RageUI.Button(v.label, nil, {RightLabel = "~c~→ ~g~"..(100).."$"}, true, {
								onActive = function()
									setPedAccessories(splitArgs(v.item, "_")[1], tonumber(splitArgs(v.item, "_")[2]), tonumber(splitArgs(v.item, "_")[3]))
								end,
								onSelected = function()
									setAccessories(_name, -1, 0)
									TriggerServerEvent("nAccessories:buyAccessories", v.item)
								end,
							})
						end
					end
				end)
				Citizen.Wait(0)
			end
		end)
	end
end

Citizen.CreateThread(function()
	while ESX == nil and not ESX.PlayerLoaded do Citizen.Wait(0) end
	TriggerEvent("skinchanger:getSkin", function(skin)
		for k,v in pairs(Config.itemsPrefix) do
			if skin[string.lower(k) .. "_1"] > 0 then
				local found = false
				for _,i in pairs(ESX.PlayerData.inventory) do
					if i.name == v .."_".. skin[string.lower(k) .. "_1"] .."_".. skin[string.lower(k) .. "_2"] then
						found = i.count > 0
					end
				end
				if not found then
					setAccessories(v, -1, 0)
				end
			end
		end
	end)
end)