ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local guiEnabled = false
local myIdentity = {}
local PlayerData = {}

function UI_Ruutu(enable)
    SetNuiFocus(enable)
    guiEnabled = enable
    SendNUIMessage({ type = "enableui", enable = enable })
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function OonksMiePomppulla()
    if PlayerData ~= nil then
        local OonksMiePomppulla = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
            OonksMiePomppulla = true
        end
        return OonksMiePomppulla
    end
end

RegisterNetEvent("poliisitunnus:AloitaTunnus")
AddEventHandler("poliisitunnus:AloitaTunnus", function()
	if not IsPedDeadOrDying(GetPlayerPed(-1), 1) and OonksMiePomppulla() then
		UI_Ruutu(true)
	else
		ESX.ShowNotification('Sinun täytyy olla poliisi')
	end
end)

RegisterNUICallback('tapsu', function(data, cb)
    UI_Ruutu(false)
end)

RegisterNUICallback('Luodaantunnus', function(data, cb)
  myIdentity = data
  TriggerServerEvent('poliisitunnus:setIdentity', data)
  UI_Ruutu(false)
end)

Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, guiEnabled) DisableControlAction(0, 2, guiEnabled) DisableControlAction(0, 142, guiEnabled) DisableControlAction(0, 18, guiEnabled) DisableControlAction(0, 106, guiEnabled)      
            if IsDisabledControlJustReleased(0, 142) then -- [Hiiri vas]
                SendNUIMessage({ type = "click" })
            end
        end
        Citizen.Wait(0)
    end
end)