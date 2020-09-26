local Poliisit 	= {}
local Lanssit 	= {}
ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--------------------------------------------------------------------------------- 
-------------------------------- LANSSIT ----------------------------------------
RegisterServerEvent('pollariblipit:LisaaLanssi')
AddEventHandler('pollariblipit:LisaaLanssi',function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.getIdentifier()
	local i = GetPlayerName(source) 
	
	if  #Lanssit > 0 then
		for k,v in pairs(Lanssit) do
			if Lanssit[k].i == i then
				table.remove(Lanssit,k)
				
			end
		end
	end
		Inffolanssista(identifier, function(data)
		table.insert(Lanssit, {i = i, name = (data.firstname..' '..data.lastname)})
		Blipit = true
		TriggerClientEvent('pollariblipit:PaivitysLans',-1, Lanssit, i, Blipit)
	end)
end)

RegisterServerEvent('pollariblipit:PoistaLanssi')
AddEventHandler('pollariblipit:PoistaLanssi',function()
	local i = GetPlayerName(source)	

	for k,v in pairs(Lanssit) do
		if Lanssit[k].i == i then
			table.remove(Lanssit,k)
		end
	end
	Blipit = false
	TriggerClientEvent('pollariblipit:PaivitysLans',-1, Lanssit, i, Blipit)
end)

--------------------------------------------------------------------------------- 
-------------------------------- POLIISI ----------------------------------------
RegisterServerEvent('pollariblipit:LisaaPoliisi')
AddEventHandler('pollariblipit:LisaaPoliisi',function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.getIdentifier()
	local i = GetPlayerName(source) 
	
	if  #Poliisit > 0 then
	
		for k,v in pairs(Poliisit) do
			if Poliisit[k].i == i then
				table.remove(Poliisit,k)
			end
		end
	end
		Inffopoliisista(identifier, function(data)
		table.insert(Poliisit, { i = i, name = (data.tunnus) })
		Blipit = true
		TriggerClientEvent('pollariblipit:PaivitysPol',-1, Poliisit, i, Blipit)
	end)
end)

RegisterServerEvent('pollariblipit:PoistaPoliisi')
AddEventHandler('pollariblipit:PoistaPoliisi',function()
	local i = GetPlayerName(source)	
	for k,v in pairs(Poliisit) do
		if Poliisit[k].i == i then
			table.remove(Poliisit,k)
		end
	end
	Blipit = false
	TriggerClientEvent('pollariblipit:PaivitysPol', -1, Poliisit, i, Blipit)
end)

---------------------------------------------------------------------------------
--------------------------------------------------------------------------------- 
TriggerEvent('es:addCommand', 'trackoff', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then
		local i = GetPlayerName(source)	
		
		for k,v in pairs(Poliisit) do
			if Poliisit[k].i == i then
				table.remove(Poliisit,k)
			end
		end
		Blipit = false
		TriggerClientEvent('pollariblipit:PaivitysPol', -1, Poliisit, i, Blipit)
	end
	if xPlayer.job.name == 'ambulance' then
		local i = GetPlayerName(source)	
		for k,v in pairs(Lanssit) do
			if Lanssit[k].i == i then
				table.remove(Lanssit,k)
			end
		end
		Blipit = false
		TriggerClientEvent('pollariblipit:PaivitysLans', -1, Lanssit, i, Blipit)
	end
end)

TriggerEvent('es:addCommand', 'trackon', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.getIdentifier()
	
	if xPlayer.job.name == 'police' then
		local i = GetPlayerName(source)	
		if  #Poliisit > 0 then
			for k,v in pairs(Poliisit) do
				if Poliisit[k].i == i then
					table.remove(Poliisit,k)
				end
			end
		end
			Inffopoliisista(identifier, function(data)
			table.insert(Poliisit, { i = i, name = (data.tunnus) })
			Blipit = true
			TriggerClientEvent('pollariblipit:PaivitysPol',-1, Poliisit, i, Blipit)
		end)
	end
	if xPlayer.job.name == 'ambulance' then
		local i = GetPlayerName(source)	
		if  #Lanssit > 0 then
			for k,v in pairs(Lanssit) do
				if Lanssit[k].i == i then
					table.remove(Lanssit, k)
				end
			end
		end
			Inffolanssista(identifier, function(data)
			table.insert(Lanssit, { i = i, name = (data.firstname..' '..data.lastname) })
			Blipit = true
			TriggerClientEvent('pollariblipit:PaivitysLans',-1, Lanssit, i, Blipit)
		end)
	end
end)

---------------------------------------------------------------------------------
--------------------------------------------------------------------------------- 

function Inffopoliisista(identifier, callback) -- Poliiseille haku luomasta tunnuksesta | Tunnus
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier", {['@identifier'] = identifier},
	function(result)
	  if result[1]['tunnus'] ~= nil then
		local data = { identifier = result[1]['identifier'], tunnus = result[1]['tunnus'] }
		callback(data)
	  else
		local data = { identifier = '', tunnus = '', }
		callback(data)
		end
	end)
end

function Inffolanssista(identifier, callback) -- Lansseille haku ingame nimestä | Etunimi - Sukunimi
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier", {['@identifier'] = identifier},
	function(result)
	  if result[1]['firstname'] ~= nil then
		local data = { identifier = result[1]['identifier'], firstname = result[1]['firstname'], lastname = result[1]['lastname']}
		callback(data)
	  else
		local data = { identifier = '', firstname = '', lastname = '', }
		callback(data)
		end
	end)
end