local RSGCore = exports['rsg-core']:GetCoreObject()

TriggerEvent('RSGCore:getObject', function(obj) RSGCore = obj end)

Citizen.CreateThread(function()
    while true do
        Wait(Config.Time) -- 2 hours (7200000 ms)
        TriggerServerEvent('rsg-taxing:server:paytaxes')
		TriggerEvent('rNotify:NotifyLeft', "YOU HAVE PAID YOUR TAXES", "To Governor Mack Black", "generic_textures", "tick", 4000)
	end
end)

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded')
AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("rsg-taxing:server:Display") 
end)

RegisterCommand('bracket', function()
    TriggerServerEvent("rsg-taxing:server:Display")    
end)

