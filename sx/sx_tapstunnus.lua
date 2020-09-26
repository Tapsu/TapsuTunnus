ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function PoliisiTunnus(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier", { ['@identifier'] = identifier },
  function(result)
    if result[1]['tunnus'] ~= nil then
      local data = { identifier = result[1]['identifier'], tunnus = result[1]['tunnus'] }
      callback(data)
    else
      local data = { identifier = '', tunnus = '' }
      callback(data)
    end
  end)
end

function HaeTunnukset(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.fetchAll("SELECT * FROM `poliisitunnukset` WHERE `identifier` = @identifier", { ['@identifier'] = identifier },
  function(result)
    if result[1] and result[2] and result[3] then
      local data = { identifier = result[1]['identifier'], tunnus1 = result[1]['tunnus'], tunnus2 = result[2]['tunnus'], tunnus3 = result[3]['tunnus']}
      callback(data)
    elseif result[1] and result[2] and not result[3] then
      local data = { identifier = result[1]['identifier'], tunnus1 = result[1]['tunnus'], tunnus2 = result[2]['tunnus'], tunnus3 = ''}
      callback(data)
    elseif result[1] and not result[2] and not result[3] then
      local data = { identifier = result[1]['identifier'], tunnus1 = result[1]['tunnus'], tunnus2 = '', tunnus3 = ''}
      callback(data)
    else
      local data = { identifier = '', tunnus1 = '', tunnus2 = '', tunnus3 = ''}
      callback(data)
    end
  end)
end

function AsetaTunnus(identifier, data, callback)
  MySQL.Async.execute("UPDATE `users` SET `tunnus` = @tunnus WHERE identifier = @identifier", { ['@identifier'] = identifier, ['@tunnus']= data.tunnus },
  function(done)
    if callback then
      callback(true)
    end
  end)
  MySQL.Async.execute('INSERT INTO poliisitunnukset (identifier, tunnus) VALUES (@identifier, @tunnus)', { ['@identifier'] = identifier, ['@tunnus'] = data.tunnus })
end

function PaivitaTunnus(identifier, data, callback)
  MySQL.Async.execute("UPDATE `users` SET `tunnus` = @tunnus WHERE identifier = @identifier", { ['@identifier'] = identifier, ['@tunnus'] = data.tunnus },
  function(done)
    if callback then
      callback(true)
    end
  end)
end

function PoistaTunnus(identifier, data, callback)
  MySQL.Async.execute("DELETE FROM `poliisitunnukset` WHERE identifier = @identifier AND tunnus = @tunnus", { ['@identifier'] = identifier, ['@tunnus'] = data.tunnus },
  function(done)
    if callback then
      callback(true)
    end
  end)
end

RegisterServerEvent('poliisitunnus:setIdentity')
AddEventHandler('poliisitunnus:setIdentity', function(data)
  local identifier = GetPlayerIdentifiers(source)[1]
    AsetaTunnus(GetPlayerIdentifiers(source)[1], data, function(callback)
    if callback == true then
    end
  end)
end)

TriggerEvent('es:addCommand', 'luotunnus', function(source, args, user)
  HaeTunnukset(source, function(data)
    if data.tunnus3 ~= '' then
      TriggerClientEvent('chatMessage', source, '', {255, 0, 0}, "Voit luoda vain 3 tunnusta.")
    else
      TriggerClientEvent('poliisitunnus:AloitaTunnus', source, {})
    end
  end)
end) 

TriggerEvent('es:addGroupCommand', 'tunnus', "user", function(source, args, user)
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  PoliisiTunnus(source, function(data)
    if data.tunnus == ''  then
      TriggerClientEvent('chatMessage', source, '', {255, 0, 0}, "Ei aktiivista tunnusta")
    end
    if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
      TriggerClientEvent('chatMessage', source, 'Tunnus', {255, 0, 0}, " " .. data.tunnus .. " ")
    end
  end)
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Ei siul oo oikeuksia :/")
end, {help = "Näyttää aktiivisen tunnuksen"})

TriggerEvent('es:addGroupCommand', 'tunnukset', "user", function(source, args, user)
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  HaeTunnukset(source, function(data)
    if data.tunnus1 ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
      TriggerClientEvent('chatMessage', source, '[Tunnus 1]', {255, 0, 0}, "" .. data.tunnus1 )
      if data.tunnus2 ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        TriggerClientEvent('chatMessage', source, '[Tunnus 2]', {255, 0, 0}, "" .. data.tunnus2 )
        if data.tunnus3 ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
          TriggerClientEvent('chatMessage', source, '[Tunnus 3]', {255, 0, 0}, " " .. data.tunnus3 )
        end
      end
    else
    TriggerClientEvent('chatMessage', source, '', {255, 0, 0}, "Et ole tehnyt tunnusta tai et ole poliisi")
    end
  end)
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Ei siul oo oikeuksia :/")
end, {help = "Lista tunnuksistasi"})

TriggerEvent('es:addCommand', 'vaihdatunnus', function(source, args, user)
  local TunnusNUMERO = tonumber(table.concat(args, " "))
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  HaeTunnukset(source, function(data)
    if TunnusNUMERO == 1 then
      local data = { identifier = data.identifier, tunnus = data.tunnus1 }
      if data.tunnus ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        PaivitaTunnus(GetPlayerIdentifiers(source)[1], data, function(callback)
          if callback == true then
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Tunnuksesi vaihdettiin: " .. data.tunnus .. "!")
          else
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe vaihtaessa!")
          end
        end)
      else
        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Sinulla ei ole tunnusta 1 kohdalla! TAI et ole poliisi")
      end
    elseif TunnusNUMERO == 2 then
      local data = { identifier = data.identifier, tunnus = data.tunnus2 }
      if data.tunnus ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        PaivitaTunnus(GetPlayerIdentifiers(source)[1], data, function(callback)
          if callback == true then
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Tunnuksesi vaihdettiin: " .. data.tunnus .. "!")
          else
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe vaihtaessa!")
          end
        end)
      else
        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Sinulla ei ole tunnusta 2 kohdalla! TAI et ole poliisi")
      end
    elseif TunnusNUMERO == 3 then
      local data = { identifier = data.identifier, tunnus = data.tunnus3 }
      if data.tunnus ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        PaivitaTunnus(GetPlayerIdentifiers(source)[1], data, function(callback)
          if callback == true then
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Tunnuksesi vaihdettiin: " .. data.tunnus .. "!")
          else
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe vaihtaessa!")
          end
        end)
      else
        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Sinulla ei ole tunnusta 3 kohdalla! TAI et ole poliisi")
      end
    else
      TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe vaihtaessa!")
    end
  end)
end)

TriggerEvent('es:addCommand', 'poistatunnus', function(source, args, user)
  local TunnusNUMERO = tonumber(table.concat(args, " "))
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  HaeTunnukset(source, function(data)
    if TunnusNUMERO == 1 then
      local data = { identifier = data.identifier, tunnus = data.tunnus1 }
      if data.tunnus ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        PoistaTunnus(GetPlayerIdentifiers(source)[1], data, function(callback)
          if callback == true then
          TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Poistit tunnuksen: " .. data.tunnus .. "!")
          else
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe poistaessa!")
          end
        end)
      else
        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Sinulla ei ole tunnusta paikkalla [1]!")
      end
    elseif TunnusNUMERO == 2 then
      local data = { identifier = data.identifier, tunnus = data.tunnus2}
      if data.tunnus ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        PoistaTunnus(GetPlayerIdentifiers(source)[1], data, function(callback)
          if callback == true then
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Poistit tunnuksen: " .. data.tunnus .. "!")
          else
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe poistaessa!")
          end
        end)
      else
        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Sinulla ei ole tunnusta paikkalla [2]!")
      end
    elseif TunnusNUMERO == 3 then
      local data = { identifier = data.identifier, tunnus = data.tunnus3 }
      if data.tunnus ~= '' and xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        PoistaTunnus(GetPlayerIdentifiers(source)[1], data, function(callback)
          if callback == true then
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Poistit tunnuksen: " .. data.tunnus .. "!")
          else
            TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe poistaessa!")
          end
        end)
      else
        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Sinulla ei ole tunnusta paikkalla [3]!")
      end
    else
      TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "Virhe poistaessa!")
    end
  end)
end)