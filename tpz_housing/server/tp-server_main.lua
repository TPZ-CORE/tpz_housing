local TPZ = exports.tpz_core:getCoreAPI()

local Properties  = {}
local LoadedProperties = false

-----------------------------------------------------------
--[[ Local Functions  ]]--
-----------------------------------------------------------

local function LoadProperties()

  local length = TPZ.GetTableLength(Config.Properties)

  if length > 0 then

    for _, property in pairs (Config.Properties) do

      Properties[_] = {}
      Properties[_] = property

      Properties[_].name = _

      -- If container on `containers` database does not exist, we create and register that container.
      exports["ghmattimysql"]:execute("SELECT id FROM `containers` WHERE name = @name", { ["@name"] = _}, function(result)
  
        if result[1] and result[1].id then
          Properties[_].containerId = tonumber(result[1].id)
        else
          TriggerEvent("tpz_inventory:registerContainerInventory", _, property.defaultStorageWeight, true) -- Server side to server side.
        end
    
      end)

      exports["ghmattimysql"]:execute("SELECT * FROM `properties` WHERE name = @name", { ["@name"] = _}, function(result)

        Properties[_].identifier     = nil
        Properties[_].charidentifier = 0

        Properties[_].storage        = {}
        Properties[_].wardrobe       = {}
        Properties[_].keyholders     = {}

        Properties[_].ledger         = 0

        Properties[_].owned          = 0
        Properties[_].duration       = 0
        Properties[_].paid           = 0

        if result[1] and result[1].name then
          
          local res = result[1]

          Properties[_].identifier     = res.identifier
          Properties[_].charidentifier = res.charidentifier
  
          Properties[_].storage        = json.decode(res.storage)
          Properties[_].wardrobe       = json.decode(res.wardrobe)
          Properties[_].keyholders     = json.decode(res.keyholders)

          Properties[_].ledger         = res.ledger

          Properties[_].owned          = res.owned
          Properties[_].duration       = res.duration
          Properties[_].paid           = res.paid

          
        else
          exports.ghmattimysql:execute("INSERT INTO `properties` (`name`) VALUES ( @name)", { ['name'] = _ })
        end

        if not property.hasTeleportationEntrance then

          for i, doors in pairs (property.doors) do

            TriggerEvent("tpz_housing:server:registerNewDoorlock", _, doors, property.canBreakIn, Properties[_].keyholders, Properties[_].identifier, Properties[_].charidentifier)
  
          end

        end

      end)

    end

    print("Loaded (" .. length .. ") properties successfully.")

    LoadedProperties = true

  else
    LoadedProperties = true
  end

end

local function IsPermittedToBuy(identifier, charidentifier)
   
  local cb = 0

  for _, property in pairs (Properties) do

    if property.identifier == identifier and tostring(property.charidentifier) == tostring(charidentifier) and property.owned == 1 then
      cb = cb + 1
    end

  end

  return (cb < Config.MaxHouses)
end

local function GetPlayerData(source)
	local _source = source
  local xPlayer = TPZ.GetPlayer(_source)

	return {
		
		identifier     = xPlayer.getIdentifier(),
		charIdentifier = xPlayer.getCharacterIdentifier(),
		money          = xPlayer.getAccount(0),
		gold           = xPlayer.getAccount(1),
		job            = xPlayer.getJob(),

		group          = xPlayer.getGroup(),

		steamName      = GetPlayerName(_source),
	}

end

function GetProperties()
  return Properties
end

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  Wait(Config.StartQueryDelay)
  LoadProperties()

end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  Properties = nil
end)

RegisterServerEvent("tpz_housing:server:requestPlayerData")
AddEventHandler("tpz_housing:server:requestPlayerData", function()
	local _source = source

	while not LoadedProperties do
		Wait(1000)
	end

  local xPlayer = TPZ.GetPlayer(_source)

  if not xPlayer.loaded() then
    return
  end

  local PlayerData = GetPlayerData(_source)

  -- We are checking if the player who joined - selected a character belongs to a property as a keyholder
  -- to update the source id for the updates.
  for _, property in pairs (Properties) do 

    if property.keyholders[PlayerData.identifier .. "_" .. PlayerData.charIdentifier] then
      property.keyholders[PlayerData.identifier .. "_" .. PlayerData.charIdentifier].source = _source

      print('added source on property #' .. _)
    end

  end

  TriggerClientEvent("tpz_housing:client:updatePlayerData", _source, { PlayerData.identifier, PlayerData.charIdentifier, PlayerData.job, Properties })
end)

-- We reset the source when player is dropped (disconnected).
AddEventHandler('playerDropped', function (reason)
  local _source = source

  for _, property in pairs (Properties) do 

    for k, keyholder in pairs (property.keyholders) do

      if tonumber(keyholder.source) == _source then
        keyholder.source = nil
      end

    end

  end

end)


-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_housing:server:buySelectedProperty")
AddEventHandler("tpz_housing:server:buySelectedProperty", function(actionType, propertyId, target)
  local _source  = source
  local _tsource = source

  if Properties[propertyId] == nil then
    return
  end

  local xPlayer        = TPZ.GetPlayer(_source)
  local tPlayer        = TPZ.GetPlayer(_tsource)

  local PlayerData     = GetPlayerData(_source)

	local identifier     = PlayerData.identifier
	local charidentifier = PlayerData.charIdentifier
  local steamName      = PlayerData.steamName

  if target then

    _tsource           = tonumber(target)
    
    local tPlayerData  = GetPlayerData(_tsource)

    identifier         = tPlayerData.identifier
    charidentifier     = tPlayerData.charIdentifier
    steamName          = tPlayerData.steamName
  end
  
  if not IsPermittedToBuy(identifier, charidentifier) then

    SendNotification(_tsource, Locales['REACHED_MAX_PROPERTIES'], "error")

    if target then
      SendNotification(_source, Locales['TARGET_REACHED_MAX_PROPERTIES'], "error")
    end

    return
  end

  local property     = Properties[propertyId]

  local currentMoney = tPlayer.getAccount(0)
  local cost         = property.purchaseMethods.dollars.cost
  local hasEnough    = cost <= currentMoney 
  
  -- We check again if the currency in gold is item instead of API Function.
  if actionType == "BUY" and property.purchaseMethods.dollars.isItem then
    currentMoney = tPlayer.getItemQuantity(property.purchaseMethods.dollars.item)
    hasEnough    = currentMoney and cost <= currentMoney 
  end

  if actionType == "BUY_GOLD" then

    currentMoney = tPlayer.getAccount(0)
    cost         = property.purchaseMethods.gold.cost
    hasEnough    = cost <= currentMoney 

    -- We check again if the currency in gold is item instead of API Function.
    if property.purchaseMethods.gold.isItem then
      currentMoney = tPlayer.getItemQuantity(property.purchaseMethods.gold.item)
      hasEnough    = currentMoney and cost <= currentMoney 
    end

  end

  if not hasEnough then

    SendNotification(_tsource, Locales['NOT_ENOUGH_MONEY'], "error")

    if target then
      SendNotification(_source, Locales['TARGET_NOT_ENOUGH_MONEY'], "error")
    end

    return
  end

  -- Give the money to the real estage job employee.
  if target and Config.RealEstateJob.Enabled and Config.RealEstateJob.Job == PlayerData.job then

    local rewardAmount = cost - (cost * Config.RealEstateJob.ReceivePercentage) / 100

    rewardAmount = TPZ.Round(rewardAmount, 1)
    rewardAmount = math.floor(rewardAmount)

    -- Total reward for the real estage job which returns the correct pecrentage.
    -- Example: 500 - 5% = 475 | 500 - 475 = 25 | 25 is the money that must be received)
    rewardAmount = cost - rewardAmount

    --xPlayer.addAccount(account, rewardAmount)

    local notifyData = ""

    if actionType == "BUY" then

      if not property.purchaseMethods.dollars.isItem then

        xPlayer.addAccount(0, rewardAmount)

      else
        xPlayer.addItem(property.purchaseMethods.dollars.item, rewardAmount)
      end

      notifyData = Locales['REAL_ESTATE_SUCCESSFULLY_SOLD_DOLLARS']

    elseif actionType == "BUY_GOLD" then
  
      if not property.purchaseMethods.gold.isItem then

        xPlayer.addAccount(1, rewardAmount)

      else
        xPlayer.addItem(property.purchaseMethods.gold.item, rewardAmount)
      end
  
      notifyData = Locales['REAL_ESTATE_SUCCESSFULLY_SOLD_GOLD']
    end

    SendNotification(_source, string.format(notifyData, rewardAmount), "success")

  end

  Properties[propertyId].identifier     = identifier
  Properties[propertyId].charidentifier = charidentifier
  
  Properties[propertyId].owned          = 1
  Properties[propertyId].duration       = 0
  Properties[propertyId].paid           = 0

  if not Properties[propertyId].hasTeleportationEntrance then
    TriggerEvent("tpz_housing:server:updateDoorlockInformation", propertyId, 'TRANSFERRED', { identifier, tostring(charidentifier) })
  end

  TriggerClientEvent("tpz_housing:client:updateProperty", -1, propertyId, "BUY", { identifier, charidentifier })

  local Parameters = { 
    ['name']            = propertyId,
    ['identifier']      = identifier,
    ['charidentifier']  = charidentifier,
    ['owned']           = 1,
    ['duration']        = 0,
    ['paid']            = 0,
  }

  exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier,"
  .. " `owned` = @owned, `duration` = @duration, `paid` = @paid WHERE name = @name", Parameters)

  --if Config.TaxRepoSystem.Enabled then
  --  TriggerEvent('tpz_society:createNewBillTo', identifier, charidentifier, 0, property.tax, propertyId, Locales['PROPERTY_BILL_ISSUER'])
  --end

  SendNotification(_tsource, Locales['SUCCESSFULLY_BOUGHT_PROPERTY'], "success")

  if actionType == "BUY" then

    if not property.purchaseMethods.dollars.isItem then

      tPlayer.removeAccount(0, cost)

    else
      tPlayer.removeItem(property.purchaseMethods.dollars.item, cost)
    end

  elseif actionType == "BUY_GOLD" then

    if not property.purchaseMethods.gold.isItem then

      tPlayer.removeAccount(1, cost)

    else
      tPlayer.removeItem(property.purchaseMethods.gold.item, cost)
    end

  end
  
  local webhookData = Config.Webhooking['BOUGHT']

  if webhookData.Enabled then
    local title   = "🏠`Property Bought`"
    local message = string.format("The following property with id: **`( %s )`** has been bought by the player with the Steam Name: `%s`.", propertyId, steamName)
    TPZ.SendToDiscord(webhookData.Url, title, message, webhookData.Color)
  end

end)

RegisterServerEvent("tpz_housing:server:sell")
AddEventHandler("tpz_housing:server:sell", function(propertyId)
  local _source = source
  local xPlayer = TPZ.GetPlayer(_source)

  if Properties[propertyId] == nil then
    return
  end

  local PlayerData     = GetPlayerData(_source)
  local identifier     = PlayerData.identifier
  local charidentifier = PlayerData.charIdentifier
  local steamName      = PlayerData.steamName

  Properties[propertyId].identifier     = nil
  Properties[propertyId].charidentifier = 0
  Properties[propertyId].duration       = 0
  Properties[propertyId].paid           = 0
  Properties[propertyId].owned          = 0

  Properties[propertyId].keyholders     = nil
  Properties[propertyId].keyholders     = {}

  if Config.ResetPropertyLedger then
    Properties[propertyId].ledger = 0
  end

  local Parameters = { 
    ['name']           = propertyId, 
    ['identifier']     = nil,
    ['charidentifier'] = 0,
    ['keyholders']     = "[]",
    ['ledger']         = Properties[propertyId].ledger,
    ['duration']       = 0,
    ['paid']           = 0,
    ['owned']          = 0,
  }

  exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `keyholders` = @keyholders, `ledger` = @ledger, `duration` = @duration, `paid` = @paid, `owned` = @owned WHERE name = @name", Parameters)

  TriggerClientEvent("tpz_housing:client:updateProperty", -1, propertyId, 'SOLD' )

  local property = Properties[propertyId]

  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not property.hasTeleportationEntrance then
    TriggerEvent("tpz_housing:server:updateDoorlockInformation", propertyId, 'RESET', { 1 } )
  end

  local receiveAmount = property.sell.receive

  if receiveAmount > 0  then

    if not property.sell.isItem then
    
      if property.sell.account == 'dollars' then
        xPlayer.addAccount(0, receiveAmount)
  
      elseif property.sell.account == 'gold' then
        xPlayer.addAccount(1, receiveAmount)
      end
  
    else
      xPlayer.addItem(property.sell.item, receiveAmount)
    end

    SendNotification(_source, string.format(Locales['SOLD_PROPERTY_RECEIVED_' .. string.upper(property.sell.account) ], receiveAmount), "success")
  else

    SendNotification(_source, Locales['SOLD_PROPERTY'], "success")
  end

  local webhookData = Config.Webhooking['SOLD']

  if webhookData.Enabled then
    local title   = "🏠`Property Sold`"
    local message = string.format("The following property with id: **`( %s )`** has been placed for sale.\n\nThe player with the Steam Name: `%s` received: %s %s.", propertyId, steamName, receiveAmount, property.sell.account)
    TPZ.SendToDiscord(webhookData.Url, title, message, webhookData.Color)
  end

end)



-- Transfer the owned property to another player.
RegisterServerEvent("tpz_housing:server:transferOwnedProperty")
AddEventHandler("tpz_housing:server:transferOwnedProperty", function(propertyId, characterId)
  local _source  = source

  characterId    = tonumber(characterId)

  if Properties[propertyId] == nil then
    return
  end

  local tPlayerData    = GetPlayerData(characterId)
  local identifier     = tPlayerData.identifier
  local charidentifier = tPlayerData.charIdentifier
  local targetName     = tPlayerData.steamName

  -- Checking if target player has maximum owned properties / not.
  if not IsPermittedToBuy(identifier, charidentifier) then

    SendNotification(_source, Locales['TARGET_REACHED_MAX_PROPERTIES'], "error")
    SendNotification(characterId, Locales['REACHED_MAX_PROPERTIES'], "error")

    return
  end

  Properties[propertyId].identifier     = identifier
  Properties[propertyId].charidentifier = charidentifier

  local Parameters = { 
    ['name']           = propertyId, 
    ['identifier']     = identifier,
    ['charidentifier'] = charidentifier,
  }

  exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier WHERE name = @name", Parameters)

  -- We AVOID updating the transfer update to whole server, the specified update is enough for the previous and new owners.
  TriggerClientEvent("tpz_housing:client:updateProperty", _source, propertyId, 'TRANSFERRED', { identifier, charidentifier })
  TriggerClientEvent("tpz_housing:client:updateProperty", characterId, propertyId, 'TRANSFERRED', { identifier, charidentifier })

  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not Properties[propertyId].hasTeleportationEntrance then
    TriggerEvent("tpz_housing:server:updateDoorlockInformation", propertyId, 'TRANSFERRED', { identifier, tostring(charidentifier) })
  end

  SendNotification(_source, Locales['TRANSFERRED_PROPERTY'], "success")
  SendNotification(characterId, Locales['TRANSFERRED_PROPERTY_TO_SELF'], "success")

  local webhookData = Config.Webhooking['TRANSFERRED']

  if webhookData.Enabled then
    local title   = "🏠`Property Transferred`"
    local message = string.format("The following property with id: **`( %s )`** has been transferred to the player with the Steam Name: `%s`.", propertyId, targetName)

    TPZ.SendToDiscord(webhookData.Url, title, message, webhookData.Color)
  end
  
end)

-- Deposit or withdraw money from or to the property ledger.
RegisterServerEvent('tpz_housing:server:updateAccountLedgerById')
AddEventHandler('tpz_housing:server:updateAccountLedgerById', function(propertyId, transactionType, amount)
	local _source = source
  local xPlayer = TPZ.GetPlayer(_source)

  if Properties[propertyId] == nil then
    return
  end

  local propertyData = Properties[propertyId]

  local currentMoney = xPlayer.getAccount(0)

  if propertyData.purchaseMethods.dollars.isItem then
    currentMoney = xPlayer.getItemQuantity(propertyData.purchaseMethods.dollars.item)
  end

  if transactionType == 'DEPOSIT' and currentMoney < amount then
    SendNotification(_source, Locales['NOT_ENOUGH_MONEY_LEDGER_DEPOSIT'], "error")
    return
  end

  if transactionType == 'DEPOSIT' and propertyData.ledgerLimit ~= nil then

    if (propertyData.ledger + amount) > propertyData.ledgerLimit then
      SendNotification(_source, Locales['MONEY_LEDGER_DEPOSIT_LIMIT'], "error")
      return
    end

  end

  if transactionType == 'WITHDRAW' and propertyData.ledger < amount then
    SendNotification(_source, Locales['NOT_ENOUGH_MONEY_LEDGER_WITHDRAW'], "error")
    return
  end

  if transactionType == 'DEPOSIT' then

    if not propertyData.purchaseMethods.dollars.isItem then
      xPlayer.removeAccount(0, amount)
  
    else
      xPlayer.removeItem(propertyData.purchaseMethods.dollars.item, amount)
    end

    Properties[propertyId].ledger = Properties[propertyId].ledger + amount

    SendNotification(_source, string.format(Locales['LEDGER_DEPOSITED_ACCOUNT_MONEY'], amount), "success")

  else

    if not propertyData.purchaseMethods.dollars.isItem then
      xPlayer.addAccount(0, amount)
  
    else
      xPlayer.addItem(propertyData.purchaseMethods.dollars.item, tonumber(amount))
    end

    Properties[propertyId].ledger = Properties[propertyId].ledger - amount

    SendNotification(_source, string.format(Locales['LEDGER_WITHDREW_ACCOUNT_MONEY'], amount), "success")

  end

  Wait(500)
  TriggerClientEvent("tpz_housing:client:updateProperty", _source, propertyId, 'LEDGER', { Properties[propertyId].ledger } )

  -- UPDATE ON KEYHOLDERS - CHANGES DOES NOT NEED TO BE UPDATED FOR THE WHOLE SERVER.
  if TPZ.GetTableLength(Properties[propertyId].keyholders) > 0 then

    for index, keyholder in pairs (Properties[propertyId].keyholders) do

      -- We are checking if the keyholder is online (has valid source)
      if keyholder.source ~= nil and tonumber(keyholder.source) ~= 0 and GetPlayerName(tonumber(keyholder.source)) ~= nil and tonumber(keyholder.source) ~= _source then
        TriggerClientEvent("tpz_housing:client:updateProperty", tonumber(keyholder.source), propertyId, 'LEDGER', { Properties[propertyId].ledger } )
      end

    end

  end

end)

-- Set property locations for performing actions such as wardrobe or storages.
RegisterServerEvent("tpz_housing:server:setPropertyLocationByType")
AddEventHandler("tpz_housing:server:setPropertyLocationByType", function(propertyId, actionType, coords)
  if Properties[propertyId] == nil then
    return
  end

  local locationCoords = { x = coords.x, y = coords.y, z = coords.z }

  if actionType == 'MENU_WARDROBE_LOCATION' then
    Properties[propertyId].wardrobe = locationCoords

  elseif actionType == 'MENU_STORAGE_LOCATION' then
    Properties[propertyId].storage = locationCoords
  end

  TriggerClientEvent("tpz_housing:client:updateProperty", -1, propertyId, 'LOCATION', { actionType, locationCoords })

end)


-----------------------------------------------------------
--[[ Threads  ]]--
-----------------------------------------------------------

local CurrentTime = 0

-- Saving (Updating) Property Locations Data before server restart.
Citizen.CreateThread(function()
	while true do
		Wait(60000)

    local time        = os.date("*t") 
    local currentTime = table.concat({time.hour, time.min}, ":")

    local finished    = false
    local shouldSave  = false

    for index, restartHour in pairs (Config.RestartHours) do

        if currentTime == restartHour then
            shouldSave = true
        end

        if next(Config.RestartHours, index) == nil then
            finished = true
        end
    end

    while not finished do
      Wait(1000)
    end

    CurrentTime = CurrentTime + 1

    if Config.SaveDataRepeatingTimer.Enabled and CurrentTime == Config.SaveDataRepeatingTimer.Duration then
      CurrentTime = 0
      shouldSave  = true
    end

    if shouldSave then

      local length = TPZ.GetTableLength(Properties)

      if length > 0 then
          
          for _, property in pairs (Properties) do

            local newKeyholdersList = property.keyholders

            -- We clear the keyholders sources but through a new list call, otherwise it will destroy the real keyholders list.

            if TPZ.GetTableLength(newKeyholdersList) > 0 then

              for index, keyholder in pairs (newKeyholdersList) do
                keyholder.source = nil
              end

            end

            local Parameters = { 
              ['name']            = property.name,
              ['identifier']      = property.identifier,
              ['charidentifier']  = property.charidentifier,
              ['storage']         = json.encode(property.storage),
              ['wardrobe']        = json.encode(property.wardrobe),
              ['ledger']          = property.ledger,
              ['keyholders']      = json.encode(newKeyholdersList),
              ['owned']           = property.owned,
              ['duration']        = property.duration,
              ['paid']            = property.paid,
          }
      
          exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `storage` = @storage,"
              .. " `wardrobe` = @wardrobe, `ledger` = @ledger, `keyholders` = @keyholders, `owned` = @owned, `duration` = @duration, `paid` = @paid WHERE name = @name", 
          Parameters)

        end

        if Config.Debug then
          print("Successfully saved " .. length .. ' properties.')
        end

      end
        
    end

  end

end)

if Config.TaxRepoSystem then

  Citizen.CreateThread(function()
    while true do

      Wait(60000 * Config.TaxRepoSystem.UpdateDuration)

      local length = TPZ.GetTableLength(Properties)

      if length > 0 then
          
        for _, property in pairs (Properties) do

          if property.owned == 1 then

            property.duration = property.duration + Config.TaxRepoSystem.UpdateDuration

            local maxDuration = (Config.TaxRepoSystem.PaymentDuration * 1440)
  
            if property.duration >= maxDuration then
  
              Properties[_].duration = 0

              if property.ledger < property.tax then

                Properties[_].identifier     = nil
                Properties[_].charidentifier = 0
                Properties[_].owned          = 0

                Properties[_].keyholders     = {}
              
                if Config.ResetPropertyLedger then
                  Properties[_].ledger = 0
                end

                local Parameters = { 
                  ['name']           = _, 
                  ['identifier']     = nil,
                  ['charidentifier'] = 0,
                  ['keyholders']     = "[]",
                  ['ledger']         = Properties[_].ledger,
                  ['duration']       = 0,
                  ['owned']          = 0,
                }
              
                exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `keyholders` = @keyholders, `ledger` = @ledger, `duration` = @duration, `owned` = @owned WHERE name = @name", Parameters)
              
                TriggerClientEvent("tpz_housing:client:updateProperty", -1, _, 'SOLD' )

                -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
                if not Properties[_].hasTeleportationEntrance then
                  TriggerEvent("tpz_housing:server:updateDoorlockInformation", _, 'RESET', { 0 } )
                end

              else

                Properties[_].ledger = property.ledger - property.tax

                -- UPDATE ON KEYHOLDERS - CHANGES DOES NOT NEED TO BE UPDATED FOR THE WHOLE SERVER.
                if TPZ.GetTableLength(property.keyholders) > 0 then

                  for index, keyholder in pairs (property.keyholders) do
                
                    -- We are checking if the keyholder is online (has valid source)
                    if keyholder.source ~= nil and tonumber(keyholder.source) ~= 0 and GetPlayerName(tonumber(keyholder.source)) ~= nil then
                      TriggerClientEvent("tpz_housing:client:updateProperty", tonumber(keyholder.source), _, 'LEDGER', { Properties[_].ledger } )
                    end
                
                  end
                
                end
                
              end

            end

          end

        end

      end

    end

  end)

end
