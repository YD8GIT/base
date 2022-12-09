ESX = nil

local playersHealing, deadPlayers = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:revive', target)
	else
		print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	else
		print(('esx_ambulancejob: %s attempted to heal!'):format(xPlayer.identifier))
	end
end)


ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end

	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= -1 then
		count = xItem.limit - xItem.count
	end

	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)

TriggerEvent('es:addGroupCommand', 'revive', 'admin', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			print(('esx_ambulancejob: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]))
		end
	else
		TriggerClientEvent('esx_ambulancejob:revive', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

ESX.RegisterUsableItem('medikit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('medikit', 1)

	TriggerClientEvent('esx_ambulancejob:heal2', _source, 'big')
	TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
end)

ESX.RegisterUsableItem('bandage', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('bandage', 1)

	TriggerClientEvent('esx_ambulancejob:heal2', _source, 'small')
	TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then
			print(('esx_ambulancejob: %s attempted combat logging!'):format(identifier))
		end

		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead']     = isDead
	})
end)

RegisterNetEvent('esx:onPlayerDeath')

AddEventHandler('esx:onPlayerDeath', function(data)

	deadPlayers[source] = 'dead'

	TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)

end)



RegisterNetEvent('esx_ambulancejob:onPlayerDistress')

AddEventHandler('esx_ambulancejob:onPlayerDistress', function()

	if deadPlayers[source] then

		deadPlayers[source] = 'distress'

		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)

	end

end)


RegisterNetEvent('esx:onPlayerSpawn')

AddEventHandler('esx:onPlayerSpawn', function()

	if deadPlayers[source] then

		deadPlayers[source] = nil

		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)

	end

end)


---- Appel EMS
RegisterServerEvent('Ambulance:AppelNotifsss')

AddEventHandler('Ambulance:AppelNotifsss', function(supprimer)

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	local xPlayers = ESX.GetPlayers()

	local name = xPlayer.getName(_source)



	for i = 1, #xPlayers, 1 do

		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])

		if thePlayer.job.name == 'ambulance' then

			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Information', 'L\'ambulancier ~b~'..name..'~s~ a pris l\'appel ~b~N°'..supprimer, 'CHAR_CALL911', 2)

		end

	end

end)

-------------


RegisterServerEvent('Pharmacy:giveItem')

AddEventHandler('Pharmacy:giveItem', function(itemName, itemLabel)

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	local qtty = xPlayer.getInventoryItem(itemName).count



		if qtty < 25 then

			xPlayer.addInventoryItem(itemName, 5)

			TriggerClientEvent('esx:showAdvancedNotification', _source, '~g~Ambulance\n~w~Tu as recu des bandages ~o~(25 Maximum)')

		else

			TriggerClientEvent('esx:showAdvancedNotification', _source, '~g~Ambulance\n~r~Maximum de bandages Atteints')

		end

	end)



RegisterServerEvent('Pharmacy:giveItemm')

AddEventHandler('Pharmacy:giveItemm', function(itemName, itemLabel)

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	local qtty = xPlayer.getInventoryItem(itemName).count



		if qtty < 10 then

			xPlayer.addInventoryItem(itemName, 1)

			TriggerClientEvent('esx:showAdvancedNotification', _source, '~g~Ambulance\n~w~Tu as reçu des Medikit ~o~(10 Maximum)')

		else

			TriggerClientEvent('esx:showAdvancedNotification', _source, '~g~Ambulance\n~r~Maximum de Medikit Atteints')

		end

	end)


	ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)

		local xPlayer = ESX.GetPlayerFromId(source)
	
	
	
		MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
	
			['@identifier'] = xPlayer.identifier
	
		}, function(isDead)
	
					
	
			if isDead then
	
			end
	
	
	
			cb(isDead)
	
		end)
	
	end)

	RegisterNetEvent('esx_ambulancejob:setDeathStatus')

AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)

	local xPlayer = ESX.GetPlayerFromId(source)



	if type(isDead) == 'boolean' then

		MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {

			['@identifier'] = xPlayer.identifier,

			['@isDead'] = isDead

		})

	end

end)

ESX.RegisterServerCallback('ems:afficheappelssss', function(source, cb, plate)

    local xPlayer = ESX.GetPlayerFromId(source)

    local keys = {}



    MySQL.Async.fetchAll('SELECT * FROM appels_ems', {}, 

        function(result)

        for numreport = 1, #result, 1 do

            table.insert(keys, {

                id = result[numreport].id,

                type = result[numreport].type,

                reporteur = result[numreport].reporteur,

                nomreporter = result[numreport].nomreporter,

                raison = result[numreport].raison

            })

        end

        cb(keys)



    end)

end)


RegisterServerEvent('ems:ajoutappelssss')

AddEventHandler('ems:ajoutappelssss', function(typereport, reporteur, nomreporter, raison)

    MySQL.Async.execute('INSERT INTO appels_ems (type, reporteur, nomreporter, raison) VALUES (@type, @reporteur, @nomreporter, @raison)', {

        ['@type'] = typereport,

        ['@reporteur'] = reporteur,

        ['@nomreporter'] = nomreporter,

        ['@raison'] = raison

    })

end)



RegisterServerEvent('ems:supprimeappelsss')

AddEventHandler('ems:supprimeappelsss', function(supprimer)

    MySQL.Async.execute('DELETE FROM appels_ems WHERE id = @id', {

            ['@id'] = supprimer

    })

end)

RegisterServerEvent("Server:emsAppelllls")

AddEventHandler("Server:emsAppelllls", function(coords, id)



	local _id = id

	local _coords = coords

	local xPlayers	= ESX.GetPlayers()



	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'ambulance' then

			TriggerClientEvent("yayyyaPapa", xPlayers[i], _coords, _id)

		end

end

end)

RegisterServerEvent('EMS:PriseAppelServeurS')

AddEventHandler('EMS:PriseAppelServeurS', function()

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	local name = xPlayer.getName(source)

	local xPlayers = ESX.GetPlayers()



	for i = 1, #xPlayers, 1 do

		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])

            TriggerClientEvent('EMS:AppelDejaPris', xPlayers[i], name)

    end

end)

ESX.RegisterServerCallback('EMS:GetID', function(source, cb)

	local idJoueur = source

	cb(idJoueur)

end)


local AppelTotal = 0

RegisterServerEvent('EMS:AjoutAppelTotalServeurS')

AddEventHandler('EMS:AjoutAppelTotalServeurS', function()

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	local name = xPlayer.getName(source)

	local xPlayers = ESX.GetPlayers()

	AppelTotal = AppelTotal + 1



	for i = 1, #xPlayers, 1 do

		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])

			TriggerClientEvent('EMS:AjoutUnAppel', xPlayers[i], AppelTotal)

	end

end)

RegisterServerEvent('emssapl:deleteallappels')

AddEventHandler('emssapl:deleteallappels', function()

    MySQL.Async.execute('DELETE FROM appels_ems', {

    })

end)

RegisterServerEvent('KAmbulance:getStockItem')

AddEventHandler('KAmbulance:getStockItem', function(itemName, count)

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	local sourceItem = xPlayer.getInventoryItem(itemName)



	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then

			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then

				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))

			else

				inventory.removeItem(itemName, count)

				xPlayer.addInventoryItem(itemName, count)

				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))

			end

		else

			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))

		end

	end)

end)


ESX.RegisterServerCallback('KAmbulance:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

		cb(inventory.items)

	end)

end)


ESX.RegisterServerCallback('KAmbulance:getPlayerInventory', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	local items   = xPlayer.inventory



	cb( { items = items } )

end)


RegisterServerEvent('KAmbulance:putStockItems')

AddEventHandler('KAmbulance:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	local sourceItem = xPlayer.getInventoryItem(itemName)



	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if sourceItem.count >= count and count > 0 then

			xPlayer.removeInventoryItem(itemName, count)

			inventory.addItem(itemName, count)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))

		else

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))

		end

	end)

end)

ESX.RegisterServerCallback('KAmbulance:getPlayerInventory', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	local items   = xPlayer.inventory



	cb( { items = items } )

end)


RegisterServerEvent('webhook_emson')
AddEventHandler('webhook_emson', function (target)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
	local name = GetPlayerName(source)
	sendToDiscord(255, "EMS", name .. " a pris son service EMS")
    end)

RegisterServerEvent('webhook_emsoff')
AddEventHandler('webhook_emsoff', function (target)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
	local name = GetPlayerName(source)
	sendToDiscordoff(255, "EMS", name .. " a retiré son service EMS")
    end)


	function sendToDiscord(color, name, message, footer)
		local embed = {
			  {
				  ["color"] = color,
				  ["title"] = "**".. name .."**",
				  ["description"] = message,
				  ["footer"] = {
					  ["text"] = footer,
				  },
			  }
		  }-- WEBHOOK A CHANGER EN DESSOUS
		PerformHttpRequest('https://discord.com/api/webhooks/954020849520877629/w669Tcp18eprUO-rtfoDbGi8Pt0jYhtb6fsuec-erzA_S4b7MGo7p-bNl_XZGdBlYHxX', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
	  end
	
	  function sendToDiscordoff(color, name, message, footer)
		local embed = {
			  {
				  ["color"] = color,
				  ["title"] = "**".. name .."**",
				  ["description"] = message,
				  ["footer"] = {
					  ["text"] = footer,
				  },
			  }
		  }-- WEBHOOK A CHANGER EN DESSOUS
		PerformHttpRequest('https://discord.com/api/webhooks/954020849520877629/w669Tcp18eprUO-rtfoDbGi8Pt0jYhtb6fsuec-erzA_S4b7MGo7p-bNl_XZGdBlYHxX', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
	  end
	


	  local function sendToDiscordWithSpecialURL(Color, Title, Description)
		local Content = {
				{
					["color"] = Color,
					["title"] = Title,
					["description"] = Description,
					["footer"] = {
					["text"] = "Rendez-vous EMS",
					["icon_url"] = nil,
					},
				}
			}-- WEBHOOK A CHANGER EN DESSOUS
		PerformHttpRequest("https://discord.com/api/webhooks/954020849520877629/w669Tcp18eprUO-rtfoDbGi8Pt0jYhtb6fsuec-erzA_S4b7MGo7p-bNl_XZGdBlYHxX", function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
	end
	
	RegisterServerEvent("rdv_kaito")
	AddEventHandler("rdv_kaito", function(nomprenom, numero, heurerdv, rdvmotif)
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local ident = xPlayer.getIdentifier()
		local date = os.date('*t')
	
		if date.day < 10 then date.day = '' .. tostring(date.day) end
		if date.month < 10 then date.month = '' .. tostring(date.month) end
		if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
		if date.min < 10 then date.min = '' .. tostring(date.min) end
		if date.sec < 10 then date.sec = '' .. tostring(date.sec) end
	
		if ident == 'steam:11' then
		else 
			sendToDiscordWithSpecialURL(16744192, "```RENDEZ-VOUS```\n\nIdentité : "..nomprenom.."\n\nNuméro de Téléphone: "..numero.."\n\nHeure du rendez-vous : " ..heurerdv.."\n\nRaison du rendez-vous : " ..rdvmotif.. "\n\nDate : " .. date.day .. "." .. date.month .. "." .. date.year .. " | " .. date.hour .. " h " .. date.min .. " min " .. date.sec.. "s")
		end
	end)
	