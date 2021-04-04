local blips 					= {}
local PlayerData                = {}
local GUI                       = {}
local sData 					= false
local Nakyvissa 				= false
local PlayerData                = {}
ESX                             = nil

Citizen.CreateThread(function()
  while ESX == nil do
   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	 PlayerData.job = job
end)

RegisterNetEvent('pollariblipit:PaivitysPol')
AddEventHandler('pollariblipit:PaivitysPol', function(Poliisit, name, Blipit)
	if name == GetPlayerName(PlayerId()) and (Blipit == true) then
		Nakyvissa = true
	elseif name ==  GetPlayerName(PlayerId()) and (Blipit == false) then
		Nakyvissa = false
	end
	if (PlayerData.job ~= nil and PlayerData.job.name == 'offpolice') or (Nakyvissa == false) then
		for i, player in ipairs(GetActivePlayers()) do
			local ped = GetPlayerPed(player)
			RemoveBlip(blips[i])
		end
	end
	if	(PlayerData.job ~= nil and PlayerData.job.name == 'police') and Nakyvissa then
		for i = 0, 255 do
			RemoveBlip(blips[i])
		end
		for i = 0, 255 do
			for k,v in pairs(Poliisit) do
				local playerPed = GetPlayerPed(i)
				local playerName = GetPlayerName(i)
				
				if playerName == Poliisit[k].i then
					local Taps = AddBlipForEntity(playerPed)
					SetBlipSprite(Taps, 137)
					SetBlipColour(Taps, 29)
					SetBlipCategory(Taps, 7)
					SetBlipScale(Taps, 0.5)
					SetBlipShowCone(Taps, true)
					BeginTextCommandSetBlipName("STRING");
					AddTextComponentString(Poliisit[k].name);
					EndTextCommandSetBlipName(Taps);
					blips[k] = Taps
				end
			end
		end
	end
end)

RegisterNetEvent('pollariblipit:PaivitysLans')
AddEventHandler('pollariblipit:PaivitysLans', function(Lanssit, name, Blipit)
	if name == GetPlayerName(PlayerId()) and (Blipit == true) then
		Nakyvissa = true
	elseif name ==  GetPlayerName(PlayerId()) and (Blipit == false) then
		Nakyvissa = false
	end
	if (PlayerData.job ~= nil and PlayerData.job.name == 'offambulance') or (Nakyvissa == false) then
		for i = 0, 255 do
			RemoveBlip(blips[i])
		end
	end
	if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') and Nakyvissa then
		for i = 0, 255 do
			RemoveBlip(blips[i])
		end
		for i = 0, 255 do
			for k,v in pairs(Lanssit) do
				local playerPed = GetPlayerPed(i)
				local playerName = GetPlayerName(i)
				if playerName == Lanssit[k].i then
					local Taps = AddBlipForEntity(playerPed)
					SetBlipSprite(Taps, 61)
					SetBlipColour(Taps, 35)
					SetBlipCategory(Taps, 7)
					SetBlipScale(Taps, 0.5)
					BeginTextCommandSetBlipName("STRING");
					AddTextComponentString(Lanssit[k].name);
					EndTextCommandSetBlipName(Taps);
					blips[k] = Taps
				end
			end
		end
	end
end)