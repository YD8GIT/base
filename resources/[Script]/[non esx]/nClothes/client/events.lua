nClothes.Config.myOutfits = {}

RegisterNetEvent("nClothes:Notify")
AddEventHandler("nClothes:Notify", function(text)
    nClothes.Functions.Notify(text)
end)

RegisterNetEvent("nClothes:OnRefreshClothes")
AddEventHandler("nClothes:OnRefreshClothes", function(clothes)
    nClothes.Config.myOutfits = clothes
end)