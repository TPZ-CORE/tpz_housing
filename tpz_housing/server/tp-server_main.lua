local TPZ           = {}
local TPZInv        = exports.tpz_inventory:getInventoryAPI()

ItemsList, Properties  = {}, {}

local LoadedItemsList, LoadedProperties = false, false

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)


-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

-- @GetTableLength returns the length of a table.
GetTableLength = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


local function Split(inputstr, sep)
  if sep == nil then
      sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end


LoadProperties = function()

  local length = GetTableLength(Config.Properties)
  if length > 0 then


    for _, property in pairs (Config.Properties) do

      Properties[_] = {}
      Properties[_] = property

      Properties[_].name = _

      -- If container on `containers` database does not exist, we create and register that container.
      exports["ghmattimysql"]:execute("SELECT id FROM containers WHERE name = @name", { ["@name"] = _}, function(result)
  
        if result[1] and result[1].id then
          Properties[_].containerId = tonumber(result[1].id)
        else

          local Parameters = { ['name'] = _, ['weight'] = property.defaultStorageWeight }
          exports.ghmattimysql:execute("INSERT INTO `containers` ( `name`, `weight`) VALUES ( @name, @weight)", Parameters)
          TriggerEvent("tpz_inventory:registerContainerInventory", _, property.defaultStorageWeight) -- Register the new container on tpz_inventory.
       
        end
    
      end)

      exports["ghmattimysql"]:execute("SELECT * FROM properties WHERE name = @name", { ["@name"] = _}, function(result)

        Properties[_].identifier     = nil
        Properties[_].charidentifier = 0

        Properties[_].storage        = {}
        Properties[_].wardrobe       = {}
        Properties[_].furniture      = {}
        Properties[_].keyholders     = {}

        Properties[_].ledger         = 0
        Properties[_].upgrade        = 0

        Properties[_].owned          = 0
        Properties[_].duration       = 0
        Properties[_].paid           = 0

        if result[1] and result[1].name then
          
          local res = result[1]

          Properties[_].identifier     = res.identifier
          Properties[_].charidentifier = res.charidentifier
  
          Properties[_].storage        = json.decode(res.storage)
          Properties[_].wardrobe       = json.decode(res.wardrobe)
          Properties[_].furniture      = json.decode(res.furniture)
          Properties[_].keyholders     = json.decode(res.keyholders)

          Properties[_].ledger         = res.ledger
          Properties[_].upgrade        = res.upgrade

          Properties[_].owned          = res.owned
          Properties[_].duration       = res.duration
          Properties[_].paid           = res.paid

          
        else
          exports.ghmattimysql:execute("INSERT INTO `properties` (`name`) VALUES ( @name)", { ['name'] = _ })
        end

        if not property.hasTeleportationEntrance then

          for i, doors in pairs (property.doors) do
          
            TriggerEvent("tpz_doorlocks:registerNewDoorlock", _, doors, property.canBreakIn, Properties[_].keyholders, Properties[_].charidentifier)
  
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

local Round = function(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local IsPermittedToBuy = function(charidentifier)
   
  local totalProperties = 0

  for _, property in pairs (Properties) do

    if property.owned == 1 and tonumber(property.charidentifier) == charidentifier then
      totalProperties = totalProperties + 1
    end

  end

  return (totalProperties < Config.MaxHouses)
end

local DoesPlayerHaveBankAccount = function(charidentifier)

  if Config.TaxRepoSystem.Enabled then

    exports.ghmattimysql:execute("SELECT * FROM banking WHERE charidentifier = @charidentifier", { ['charidentifier'] = charidentifier}, function(result)

      if result[1] == nil then
        return false
      end

      return true

    end)

  end

  return true

end

UpdateSelectedFurniture = function(type, charidentifier, objectHash, label)

  objectHash = tostring(objectHash)
  
  exports["ghmattimysql"]:execute("SELECT furniture FROM characters WHERE charidentifier = @charidentifier", { ['@charidentifier'] = charidentifier}, function(result)

    if result[1].furniture then
      local furnitureList = json.decode(result[1].furniture)
      local length        = GetTableLength(furnitureList)

      local finished      = false
      
      if length > 0 then

        for _, res in pairs (furnitureList) do

          local hash = tostring(_)

          furnitureList[hash]          = {}
          furnitureList[hash].label    = res.label

          furnitureList[hash].quantity = res.quantity

          if hash == objectHash then

            if type == "ADD" then
              furnitureList[hash].quantity = furnitureList[hash].quantity + 1

            elseif type == "REMOVE" then
              furnitureList[hash].quantity = furnitureList[hash].quantity - 1

              if furnitureList[hash].quantity <= 0 then
                furnitureList[hash] = nil
              end

            end
            
          end
  
          if next(furnitureList, _) == nil then
            finished = true
          end

        end

      else
        finished = true
      end

      while not finished do
        Wait(10)
      end

      if type == "ADD" and furnitureList[objectHash] == nil then
        furnitureList[objectHash]          = {}
        furnitureList[objectHash].label    = label
        furnitureList[objectHash].quantity = 1
      end

      local Parameters = { 
        ['charidentifier'] = charidentifier, 
        ['furniture'] = json.encode(furnitureList) 
      }
    
      exports.ghmattimysql:execute("UPDATE `characters` SET `furniture` = @furniture WHERE charidentifier = @charidentifier", Parameters)

    else
      print('Error: `furniture` column does not exist on `characters` database table.')
      return
    end

  end)

end

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

-- When resource starts, we load all the items from the database
-- The reason is that we want to get their data for displays such as labels.
AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  local finished = false

  exports["ghmattimysql"]:execute("SELECT * FROM items", { }, function(result)

    for _, res in pairs (result) do 

      ItemsList[res.item] = {}
      ItemsList[res.item] = res

      if next(result, _) == nil then
        finished = true
      end

    end

    while not finished do
      Wait(250)
    end

    LoadedItemsList = true
  end)

  LoadProperties()

end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Properties = nil
end)

-- When player drops and player has properties on his ownership,
-- we save the properties.
AddEventHandler('playerDropped', function (reason)
  local _source         = source
  local xPlayer         = TPZ.GetPlayer(_source)

  if not xPlayer.loaded() then
    return
  end

  if not LoadedProperties then 
    return
  end

	local charidentifier = xPlayer.getCharacterIdentifier()

  local length = GetTableLength(Properties)
  if length > 0 then
          
    for _, property in pairs (Properties) do

      if property.owned == 1 and property.charidentifier == charidentifier then

        local Parameters = { 
          ['name']            = property.name,
          ['storage']         = json.encode(property.storage),
          ['wardrobe']        = json.encode(property.wardrobe),
          ['furniture']       = json.encode(property.furniture),
          ['ledger']          = property.ledger,
          ['upgrade']         = property.upgrade,
          ['keyholders']      = json.encode(property.keyholders),
          ['duration']        = property.duration,
          ['paid']            = property.paid,
        }
  
        exports.ghmattimysql:execute("UPDATE `properties` SET `storage` = @storage, `wardrobe` = @wardrobe, `furniture` = @furniture,"
        .. " `ledger` = @ledger, `upgrade` = @upgrade, `keyholders` = @keyholders, `duration` = @duration, `paid` = @paid WHERE name = @name", Parameters)

        if Config.Debug then
          print("The following Property: " .. property.name .. " has been saved.")
        end

      end

    end

  end

end)

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_housing:requestProperties")
AddEventHandler("tpz_housing:requestProperties", function()
	local _source = source

	while not LoadedProperties or not LoadedItemsList do
		Wait(1000)
	end

	TriggerClientEvent("tpz_housing:loadProperties", _source, Properties, ItemsList)
end)

RegisterServerEvent("tpz_housing:buySelectedProperty")
AddEventHandler("tpz_housing:buySelectedProperty", function(type, propertyId, target)
  local _source = source

  if Properties[propertyId] == nil then
    return
  end

  local property        = Properties[propertyId]

  local xPlayer         = TPZ.GetPlayer(_source)
	local identifier      = xPlayer.getIdentifier()
	local charidentifier  = xPlayer.getCharacterIdentifier()
  local steamName       = GetPlayerName(_source)

  if target then

    local tPlayer   = TPZ.GetPlayer(target)

    identifier      = tPlayer.getIdentifier()
    charidentifier  = tPlayer.getCharacterIdentifier()
    steamName       = GetPlayerName(target)
  end
  
  if not IsPermittedToBuy(charidentifier) then
    SendNotification(_source, Locales['TARGET_REACHED_MAX_PROPERTIES'], "error")
    return
  end

  if not DoesPlayerHaveBankAccount(charidentifier) then

    if not target then
      SendNotification(_source, Locales['BANK_ACCOUNT_DOES_NOT_EXIST'], "error")
    else
      SendNotification(_source, Locales['BANK_ACCOUNT_DOES_NOT_EXIST_TARGET'], "error")
    end

    return

  end

  local account = 0
  local cost    = property.cost

  if type == "BUY_GOLD" then
    account = 2
    cost    = property.goldCost
  end

  local money   = xPlayer.getAccount(account)

  if money < cost then
    SendNotification(_source, Locales['NOT_ENOUGH_MONEY'], "error")
    return
  end

  xPlayer.removeAccount(account, cost)

  if target and Config.RealEstateJob.Enabled and Config.RealEstateJob.ReceivePercentage > 0 then
    local rewardAmount = cost - (cost * Config.RealEstateJob.ReceivePercentage) / 100

    rewardAmount = Round(rewardAmount, 1)
    rewardAmount = math.floor(rewardAmount)

    xPlayer.addAccount(account, rewardAmount)

    local notifyData = Locales['REAL_ESTATE_SUCCESSFULLY_SOLD']
    TriggerClientEvent("tpz_notify:sendNotification", _source, notifyData.title, string.format(notifyData.message, rewardAmount), notifyData.icon, "success", notifyData.duration)

  end

  Properties[propertyId].identifier     = identifier
  Properties[propertyId].charidentifier = charidentifier
  Properties[propertyId].owned          = 1
  Properties[propertyId].duration       = 0
  Properties[propertyId].paid           = 0

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, "BUY", { identifier, charidentifier })

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

  if Config.TaxRepoSystem.Enabled then
    TriggerEvent('tpz_society:createNewBillTo', identifier, charidentifier, 0, property.tax, propertyId, Locales['PROPERTY_BILL_ISSUER'])
  end

  if target then
    SendNotification(target, Locales['SUCCESSFULLY_BOUGHT_FROM_EMPLOYEE'], "success")
  else
    SendNotification(_source, Locales['SUCCESSFULLY_BOUGHT'], "success")
  end
  
  local webhookData = Config.Webhooking['BOUGHT']

  if webhookData.Enabled then
      local title   = "🏠` Property Bought`"
      local message = "The following property with id: **`( " .. propertyId .. ")`** has been bought from: \n\n`" .. steamName .. " (Char Id : " .. charidentifier .. ")`"
      TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
  end

end)


RegisterServerEvent("tpz_housing:setPropertyLocationByType")
AddEventHandler("tpz_housing:setPropertyLocationByType", function(propertyId, type, coords)
  if Properties[propertyId] == nil then
    return
  end

  local locationCoords = { x = coords.x, y = coords.y, z = coords.z }

  if type == 'WARDROBE' then
    Properties[propertyId].wardrobe = locationCoords

  elseif type == 'STORAGE' then
    Properties[propertyId].storage = locationCoords
  end

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, 'LOCATION', { type, locationCoords })

end)

RegisterServerEvent("tpz_housing:buySelectedFurniture")
AddEventHandler("tpz_housing:buySelectedFurniture", function(account, cost, furniture, label)
  local _source = source

  local xPlayer = TPZ.GetPlayer(_source)

  local money           = xPlayer.getAccount(account)
	local charidentifier  = xPlayer.getCharacterIdentifier()

  furniture = tostring(furniture)

  if money < cost then
    SendNotification(_source, Locales['NOT_ENOUGH_MONEY'], "error")
    TriggerClientEvent("tpz_housing:setBusy", _source, false)
    return
  end

  xPlayer.removeAccount(account, cost)

  UpdateSelectedFurniture("ADD", charidentifier, furniture, label)

  SendNotification(_source, string.format(Locales['FURNITURES_BOUGHT'], label), "success")

  Wait(1000)
  TriggerClientEvent("tpz_housing:setBusy", _source, false)

end)

RegisterServerEvent("tpz_housing:addPropertyFurniturePlacement")
AddEventHandler("tpz_housing:addPropertyFurniturePlacement", function(propertyId, objectHash, label, coords)
  local _source = source
  local xPlayer = TPZ.GetPlayer(_source)

  if Properties[propertyId] == nil then
    return
  end

  local charidentifier  = xPlayer.getCharacterIdentifier()

  UpdateSelectedFurniture("REMOVE", charidentifier, objectHash, label)

  local id = objectHash .. "#" .. Round(coords.z, 3)

  Properties[propertyId].furniture[id]        = {}
  Properties[propertyId].furniture[id].hash   = tostring(objectHash)
  Properties[propertyId].furniture[id].label  = label

  local objectNewCoords = { x = coords.x, y = coords.y, z = coords.z, pitch = coords.pitch, roll = coords.roll, yaw = coords.yaw }

  Properties[propertyId].furniture[id].coords = objectNewCoords

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, 'ADDED_FURNITURE', { id, tostring(objectHash), label, objectNewCoords })

end)

RegisterServerEvent("tpz_housing:removeFurnitureFromProperty")
AddEventHandler("tpz_housing:removeFurnitureFromProperty", function(propertyId, furnitureId, furnitureLabel)
  local _source        = source

  local xPlayer        = TPZ.GetPlayer(_source)
  local charidentifier = xPlayer.getCharacterIdentifier()

  if Properties[propertyId] == nil then
    return
  end

  local args = Split(furnitureId, '#')

  Properties[propertyId].furniture[furnitureId] = nil

  UpdateSelectedFurniture("ADD", charidentifier, tostring(args[1]), furnitureLabel)

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, 'REMOVED_FURNITURE', { furnitureId, tostring(args[1]) })
end)


RegisterServerEvent("tpz_housing:addPropertyKeyholder")
AddEventHandler("tpz_housing:addPropertyKeyholder", function(propertyId, playerId)
  local _source = source

  if Properties[propertyId] == nil then
    return
  end

  if GetPlayerName(tonumber(playerId)) == nil then
    SendNotification(_source, Locales['PLAYER_NOT_VALID'], "error")
    return
  end
  

  local tPlayer        = TPZ.GetPlayer(tonumber(playerId))
  local charidentifier = tPlayer.getCharacterIdentifier()

  charidentifier       = tostring(charidentifier)

  if Properties[propertyId].keyholders[charidentifier] then
    SendNotification(_source, Locales['MENU_KEYHOLDERS_ALREADY_EXISTS'], "error")
    return
  end

  local property = Properties[propertyId]

  local username = tPlayer.getFirstName() .. " " .. tPlayer.getLastName()

  Properties[propertyId].keyholders[charidentifier]           = {}
  Properties[propertyId].keyholders[charidentifier].username  = username

  SendNotification(_source, string.format(Locales['MENU_KEYHOLDERS_ADDED'], username), "success")

  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not property.hasTeleportationEntrance then
    TriggerEvent("tpz_doorlocks:updateDoorlockInformation", propertyId, 'REGISTER_KEYHOLDER', { charidentifier, username })
  end

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, 'ADDED_KEYHOLDER', { charidentifier, username })

end)


RegisterServerEvent("tpz_housing:removePropertyKeyholder")
AddEventHandler("tpz_housing:removePropertyKeyholder", function(propertyId, characterId, username)
  local _source = source

  if Properties[propertyId] == nil then
    return
  end

  if Properties[propertyId].keyholders[characterId] == nil then
    SendNotification(_source, Locales['MENU_KEYHOLDERS_DOES_NOT_EXISTS'], "error")
    return
  end

  local property = Properties[propertyId]

  Properties[propertyId].keyholders[characterId] = nil

  SendNotification(_source, string.format(Locales['MENU_KEYHOLDERS_REMOVED'], username), "error")

  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not property.hasTeleportationEntrance then
    TriggerEvent("tpz_doorlocks:updateDoorlockInformation", propertyId, 'UNREGISTER_KEYHOLDER', { tostring(characterId) })
  end

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, 'REMOVED_KEYHOLDER', { characterId })

end)


RegisterServerEvent("tpz_housing:transferOwnedProperty")
AddEventHandler("tpz_housing:transferOwnedProperty", function(propertyId, characterId)
  local _source        = source

  characterId          = tonumber(characterId)

  local tPlayer        = TPZ.GetPlayer(characterId)
  local identifier     = tPlayer.getIdentifier()
  local charidentifier = tPlayer.getCharacterIdentifier()
  local targetName     = GetPlayerName(characterId)

  if Properties[propertyId] == nil then
    return
  end

  if Config.TaxRepoSystem.Enabled and Properties[propertyId].paid == 0 then
    SendNotification(_source, Locales['CANNOT_TRANSFER_UNPAID'], "error")
    return
  end

  if not IsPermittedToBuy(charidentifier) then
    SendNotification(_source, Locales['TARGET_REACHED_MAX_PROPERTIES'], "error")
    return
  end
  
  if not DoesPlayerHaveBankAccount(charidentifier) then
    SendNotification(_source, Locales['BANK_ACCOUNT_DOES_NOT_EXIST_TARGET'], "error")
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

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, 'TRANSFERRED', { identifier, charidentifier })

  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not Properties[propertyId].hasTeleportationEntrance then
    TriggerEvent("tpz_doorlocks:updateDoorlockInformation", propertyId, 'TRANSFERRED', { tostring(charidentifier) })
  end

  SendNotification(_source, Locales['TRANSFERRED_PROPERTY'], "success")
  SendNotification(characterId, Locales['TRANSFERRED_PROPERTY_TO'], "info")

  local webhookData = Config.Webhooking['TRANSFERRED']

  if webhookData.Enabled then
      local title   = "🏠` Property Transferred`"
      local message = "The following property with id: **`( " .. propertyId .. ")`** has been transferred to: \n\n`" .. targetName .. " (Char Id : " .. charidentifier .. ")`"
      TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
  end
  
end)


RegisterServerEvent("tpz_housing:sellOwnedProperty")
AddEventHandler("tpz_housing:sellOwnedProperty", function(propertyId)
  local _source        = source

  local xPlayer        = TPZ.GetPlayer(_source)
  local charidentifier = xPlayer.getCharacterIdentifier()
  local targetName     = GetPlayerName(_source)

  if Properties[propertyId] == nil then
    return
  end

  Properties[propertyId].identifier     = nil
  Properties[propertyId].charidentifier = 0
  Properties[propertyId].duration       = 0
  Properties[propertyId].paid           = 0
  Properties[propertyId].owned          = 0

  Properties[propertyId].keyholders     = nil
  Properties[propertyId].keyholders     = {}

  if Config.ResetUpgrades then
    Properties[propertyId].upgrade = 0
  end

  local Parameters = { 
    ['name']           = propertyId, 
    ['identifier']     = nil,
    ['charidentifier'] = 0,
    ['keyholders']     = "[]",
    ['upgrade']        = Properties[propertyId].upgrade,
    ['duration']       = 0,
    ['paid']           = 0,
    ['owned']          = 0,
  }

  exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `keyholders` = @keyholders, `upgrade` = @upgrade, `duration` = @duration, `paid` = @paid, `owned` = @owned WHERE name = @name", Parameters)

  TriggerClientEvent("tpz_housing:updateProperty", -1, propertyId, 'SOLD' )
  
  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not Properties[propertyId].hasTeleportationEntrance then
    TriggerEvent("tpz_doorlocks:updateDoorlockInformation", propertyId, 'RESET' )
  end

  local receiveAmount = 0
  
  if Config.SellPercentage > 0 then
    receiveAmount = Properties[propertyId].cost - (Properties[propertyId].cost * Config.SellPercentage) / 100

    receiveAmount = Round(receiveAmount, 1)
    receiveAmount = math.floor(receiveAmount)

    xPlayer.addAccount(0, ( Properties[propertyId].cost - receiveAmount) )
    SendNotification(_source, string.format(Locales['SOLD_PROPERTY_RECEIVED'], ( Properties[propertyId].cost - receiveAmount)), "success")

  else
    SendNotification(_source, Locales['SOLD_PROPERTY'], "success")
  end

  local webhookData = Config.Webhooking['SOLD']

  if webhookData.Enabled then
      local title   = "🏠` Property Sold (Owned)`"
      local message = "The following property with id: **`( " .. propertyId .. ")`** has been placed for sale and sold for ( " .. receiveAmount .. "dollars ) by: \n\n`" .. targetName .. " (Char Id : " .. charidentifier .. ")`"
      TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
  end

end)


RegisterServerEvent("tpz_housing:upgradeOwnedProperty")
AddEventHandler("tpz_housing:upgradeOwnedProperty", function(propertyId, upgrade)
  local _source        = source

  local xPlayer        = TPZ.GetPlayer(_source)
  local charidentifier = xPlayer.getCharacterIdentifier()
  local targetName     = GetPlayerName(_source)
  
  if Properties[propertyId] == nil then
    return
  end

  local money       = xPlayer.getAccount(0)

  local property    = Properties[propertyId]
  local upgradeData = Upgrades[tonumber(upgrade)]

  if upgradeData.Cost and money < upgradeData.Cost then
    SendNotification(_source, Locales['NOT_ENOUGH_MONEY'], "error")
    TriggerClientEvent("tpz_housing:setBusy", _source, false)
    return
  end

  local hasMaterials = upgradeData.HasMaterials

  local contains     = true
  local finished     = false

  if hasMaterials then

    for item, quantity in pairs(upgradeData.Materials) do

      local itemQuantity = TPZInv.getContainerItemQuantity(property.containerId, item)
  
      if itemQuantity == nil or itemQuantity == 0 or itemQuantity < quantity then
        contains = false
      end
  
      if next(upgradeData.Materials, item) == nil then
        finished = true
      end
    end

  else
    finished = true
  end

  while not finished do
    Wait(50)
  end

  if contains then

    if upgradeData.Cost and upgradeData.Cost > 0 then
      xPlayer.removeAccount(0, upgradeData.Cost)
    end

    if hasMaterials then

      for item, quantity in pairs(upgradeData.Materials) do
        TPZInv.removeContainerItem(_source, item, quantity)
      end

    end

    Properties[propertyId].upgrade = upgrade

    TriggerEvent("tpz_inventory:upgradeContainerInventoryWeight", property.containerId, upgradeData.ExtraStorageWeight)

    SendNotification(_source, string.format(Locales['SUCCESSFULLY_UPGRADED'], upgrade), 'success')

    TriggerClientEvent("tpz_housing:updateProperty", _source, propertyId, 'UPGRADE' )
    TriggerClientEvent("tpz_housing:setBusy", _source, false)

    local webhookData = Config.Webhooking['UPGRADE']

    if webhookData.Enabled then
        local title   = "🏠` Property Upgraded`"
        local message = "The following property with id: **`( " .. propertyId .. ")`** has been upgraded to : ( No. " .. upgrade .. "dollars ) by: \n\n`" .. targetName .. " (Char Id : " .. charidentifier .. ")`"
        TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
    end

  else
    SendNotification(_source, Locales['NOT_ENOUGH_MATERIALS'], 'error')
    TriggerClientEvent("tpz_housing:setBusy", _source, false)
  end

end)

AddEventHandler('tpz_society:onPaidBill', function(data)

  if Properties[data.reason] == nil then
    return
  end

  Properties[data.reason].paid = 1

  TriggerClientEvent("tpz_housing:updateProperty", -1, data.reason, 'PAID', { 1 } )

end)

-----------------------------------------------------------
--[[ Threads  ]]--
-----------------------------------------------------------

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

    if shouldSave then

      local length = GetTableLength(Properties)

      if length > 0 then
          
          for _, property in pairs (Properties) do

            local Parameters = { 
              ['name']            = property.name,
              ['identifier']      = property.identifier,
              ['charidentifier']  = property.charidentifier,
              ['storage']         = json.encode(property.storage),
              ['wardrobe']        = json.encode(property.wardrobe),
              ['furniture']       = json.encode(property.furniture),
              ['ledger']          = property.ledger,
              ['upgrade']         = property.upgrade,
              ['keyholders']      = json.encode(property.keyholders),
              ['owned']           = property.owned,
              ['duration']        = property.duration,
              ['paid']            = property.paid,
          }
      
          exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `storage` = @storage,"
              .. " `wardrobe` = @wardrobe, `furniture` = @furniture, `ledger` = @ledger, `upgrade` = @upgrade, `keyholders` = @keyholders, `owned` = @owned, `duration` = @duration, `paid` = @paid WHERE name = @name", 
          Parameters)

          if Config.Debug then
            print("The following Property: " .. property.name .. " has been saved.")
          end

        end

      end
        
    end

  end

end)

if Config.TaxRepoSystem then

  Citizen.CreateThread(function()
    while true do

      Wait(60000 * Config.TaxRepoSystem.UpdateDuration)

      local length = GetTableLength(Properties)

      if length > 0 then
          
        for _, property in pairs (Properties) do

          if property.owned == 1 then

            property.duration = property.duration + Config.TaxRepoSystem.UpdateDuration

            local maxDuration = (Config.TaxRepoSystem.PaymentDuration * 1440)
  
            if property.duration >= maxDuration then
  
              property.duration = 0
  
              -- If the duration reaches the limit and the property bill has not been paid, we remove the ownership.
              if property.paid == 0 then
                
                -- REMOVE EXISTING BILL

                Properties[_].identifier     = nil
                Properties[_].charidentifier = 0
                Properties[_].owned          = 0

                Properties[_].keyholders     = nil
                Properties[_].keyholders     = {}
              
                if Config.ResetUpgrades then
                  Properties[_].upgrade = 0
                end
  
                local Parameters = { 
                  ['name']           = _, 
                  ['identifier']     = nil,
                  ['charidentifier'] = 0,
                  ['keyholders']     = "[]",
                  ['upgrade']        = Properties[_].upgrade,
                  ['owned']          = 0,
                }
              
                exports.ghmattimysql:execute("UPDATE `properties` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `keyholders` = @keyholders, `upgrade` = @upgrade, `owned` = @owned WHERE name = @name", Parameters)
              
                TriggerClientEvent("tpz_housing:updateProperty", -1, _, 'SOLD' )
                
                -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
                if not Properties[_].hasTeleportationEntrance then
                  TriggerEvent("tpz_doorlocks:updateDoorlockInformation", _, 'RESET' )
                end
  
              else
                
                TriggerEvent('tpz_society:createNewBillTo', property.identifier, property.charidentifier, 0, property.tax, property.name, Locales['PROPERTY_BILL_ISSUER'])

              end
  
            end

          end

        end

      end

    end

  end)

end
