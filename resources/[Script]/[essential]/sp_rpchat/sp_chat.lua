ESX = nil

local antispam = true


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("twt", function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then    
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])        
            if namerandom ~= false then    
	        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Twitter, '', '@'..name..' : '..msg..'', 'CHAR_STRETCH', 0)
            namerandom = false
            Wait(config.AntiSpamTime)
            namerandom = true
             end
        end
    end
end, false)
RegisterCommand('fab', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do

            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomfab ~= false then 
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Facebook, '', '@'..name..' : '..msg..'', 'CHAR_DAVE', 0)
            namerandomfab = false
            Wait(config.AntiSpamTime)
            namerandomfab = true
             end
        end
    end
end, false)
RegisterCommand('amz', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomamz ~= false then 
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Amazon, '', '@'..name..' : '..msg..'', 'CHAR_BEVERLY', 0)
            namerandomamz = false
            Wait(config.AntiSpamTime)
            namerandomamz = true
             end
        end
    end
end, false)
RegisterCommand('ist', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomist ~= false then 		
                TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Instagram, '', '@'..name..' : '..msg..'', 'CHAR_BARRY', 0)
                namerandomist = false
                Wait(config.AntiSpamTime)
                namerandomist = true
                 end
            end
    end
end, false)
RegisterCommand('ano', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    local namerandom = math.random(100000, 999999)
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomano ~= false then 
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Anonymous, '', '@' .. namerandom ..' : '..msg..'', 'CHAR_LESTER_DEATHWISH', 0)
            namerandomano = false
            Wait(config.AntiSpamTime)
            namerandomano = true
             end
        end
    end
end, false)
-- JOB
RegisterCommand('lspd', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == config.jobpolice then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandompolice ~= false then 
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.LSPD, config.adLSPD, ''..msg..'', 'CHAR_ABIGAIL', 0)
            namerandompolice = false
            Wait(config.AntiSpamTime)
            namerandompolice = true
             end
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, config.LSPD, config.Averto2 , config.Averto3, 'CHAR_ABIGAIL', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, config.LSPD, config.Averto2 , config.Averto3 .. "" .. config.LSPD .. "" .. config.Averto4, 'CHAR_ABIGAIL', 0)
    end
 end, false)
 
 RegisterCommand('ems', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == config.jobems then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomems ~= false then 
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.EMS, config.adEMS, ''..msg..'', 'CHAR_MICHAEL', 0)
            namerandomems = false
            Wait(config.AntiSpamTime)
            namerandomems = true
             end
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, config.EMS, config.Averto2 , config.Averto3, 'CHAR_MICHAEL', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, config.EMS, config.Averto2 , config.Averto3 .. "" .. config.EMS .. "" .. config.Averto4, 'CHAR_MICHAEL', 0)
    end
 end, false)


 RegisterCommand('mechanic', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == config.jobmechanic then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomems ~= false then 
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Mechanic, config.adMechanic, ''..msg..'', 'CHAR_LS_CUSTOMS', 0)
            namerandomems = false
            Wait(config.AntiSpamTime)
            namerandomems = true
             end
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, config.Mechanic, config.Averto2 , config.Averto3, 'CHAR_LS_CUSTOMS', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, config.Mechanic, config.Averto2 , config.Averto3 .. "" .. config.Mechanic .. "" .. config.Averto4, 'CHAR_LS_CUSTOMS', 0)
    end
 end, false)
 

 
 RegisterCommand('bennys', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == config.jobbennys then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomems ~= false then 
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Bennys, config.adBennys, ''..msg..'', 'CHAR_CARSITE3', 0)
            namerandomems = false
            Wait(config.AntiSpamTime)
            namerandomems = true
             end
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, config.Bennys, config.Averto2 , config.Averto3, 'CHAR_CARSITE3', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, config.Bennys, config.Averto2 , config.Averto3 .. "" .. config.Bennys .. "" .. config.Averto4, 'CHAR_CARSITE3', 0)
    end
 end, false)

 RegisterCommand('unicorn', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == config.jobunicorn then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomems ~= false then 
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Unicorn, config.adUnicorn, ''..msg..'', 'CHAR_MP_STRIPCLUB_PR', 0)
            namerandomems = false
            Wait(config.AntiSpamTime)
            namerandomems = true
             end
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, config.Unicorn, config.Averto2 , config.Averto3, 'CHAR_MP_STRIPCLUB_PR', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, config.Unicorn, config.Averto2 , config.Averto3 .. "" .. config.Unicorn .. "" .. config.Averto4, 'CHAR_MP_STRIPCLUB_PR', 0)
    end
 end, false)
 
  
 RegisterCommand('taxi', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == config.jobtaxi then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if namerandomems ~= false then 
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], config.Taxi, config.adTaxi, ''..msg..'', 'CHAR_TAXI', 0)
            namerandomems = false
            Wait(config.AntiSpamTime)
            namerandomems = true
             end
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, config.Taxi, config.Averto2 , config.Averto3, 'CHAR_TAXI', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, config.Taxi, config.Averto2 , config.Averto3 .. "" .. config.Taxi .. "" .. config.Averto4, 'CHAR_TAXI', 0)
    end
 end, false)
    
    
    
