local function GetIdentifierClothes(id)
    local clothes = {}
    local data = MySQL.Sync.fetchAll("SELECT * FROM nclothes WHERE identifier=@identifier", {
        ["@identifier"] = id
    })
    for k,v in pairs(data) do
        clothes[#clothes+1] = {label = v.label, id = v.id, skin = json.decode(v.skin)}
    end
    return clothes
end

RegisterServerEvent("nClothes:GetClothes")
AddEventHandler("nClothes:GetClothes", function()
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local clothes = GetIdentifierClothes(xPlayer.identifier)
    TriggerClientEvent("nClothes:OnRefreshClothes", source, clothes)
end)

RegisterServerEvent("nClothes:SetSkin")
AddEventHandler("nClothes:SetSkin", function(skin)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE users SET `skin`=@skin WHERE identifier = @identifier", {
		["@skin"] = json.encode(skin),
		["@identifier"] = xPlayer.identifier
	}, function()
        TriggerClientEvent("nClothes:Notify", source, "~g~Vous avez mis une nouvelle tenue.")
    end)
end)

RegisterServerEvent("nClothes:SaveClothes")
AddEventHandler("nClothes:SaveClothes", function(label, skin)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.getMoney() >= nClothes.Config.Price) then
        MySQL.Async.insert("INSERT INTO nclothes (`identifier`, `label`, `skin`) VALUES ('"..xPlayer.identifier.."', '"..label.."', '"..json.encode(skin).."')", {
        }, function()
            TriggerClientEvent("nClothes:Notify", source, "~g~Vous avez sauvegardé une nouvelle tenue.")
            local clothes = GetIdentifierClothes(xPlayer.identifier)
            TriggerClientEvent("nClothes:OnRefreshClothes", source, clothes)
            xPlayer.removeMoney(nClothes.Config.Price)
        end)
    else
        TriggerClientEvent("nClothes:Notify", source, "~r~Vous n'avez pas assez d'argent.")
    end
end)

RegisterServerEvent("nClothes:GiveOutfit")
AddEventHandler("nClothes:GiveOutfit", function(id, target)
    local source = source
    local xTarget = ESX.GetPlayerFromId(target)
	MySQL.Async.execute("UPDATE nclothes SET `identifier`=@identifier WHERE id=@id", {
		["@id"] = id,
        ["@identifier"] = xTarget.identifier,
	}, function()
        TriggerClientEvent("nClothes:Notify", xTarget.source, "~g~Vous avez reçu une tenue.")
        TriggerClientEvent("nClothes:Notify", source, "~g~Vous avez donné une tenue.")
    end)
end)

RegisterServerEvent("nClothes:DeleteOutfit")
AddEventHandler("nClothes:DeleteOutfit", function(id)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("DELETE FROM nclothes WHERE id=@id", {
        ["@id"] = id
    }, function()
        TriggerClientEvent("nClothes:Notify", source, "~r~Vous avez supprimé une tenue.")
        local clothes = GetIdentifierClothes(xPlayer.identifier)
        TriggerClientEvent("nClothes:OnRefreshClothes", source, clothes)
    end)
end)