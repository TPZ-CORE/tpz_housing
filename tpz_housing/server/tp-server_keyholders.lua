local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Local Functions  ]]--
-----------------------------------------------------------

local function GetPlayerData(source)
	local _source = source
  local xPlayer = TPZ.GetPlayer(_source)

	return {
		
		identifier     = xPlayer.getIdentifier(),
		charIdentifier = xPlayer.getCharacterIdentifier(),
		money          = xPlayer.getAccount(0),
		gold           = xPlayer.getAccount(1),
		job            = xPlayer.getJob(),
    firstname      = xPlayer.getFirstName(),
    lastname       = xPlayer.getLastName(),
		group          = xPlayer.getGroup(),

		steamName      = GetPlayerName(_source),
	}

end

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_housing:server:addPropertyKeyholder")
AddEventHandler("tpz_housing:server:addPropertyKeyholder", function(propertyId, playerId)
  local _source  = source
  local _tsource = tonumber(playerId)

  local Properties = GetProperties()

  if Properties[propertyId] == nil or _tsource == nil then
    return
  end

  if GetPlayerName(_tsource) == nil then
    SendNotification(_source, Locales['PLAYER_NOT_VALID'], "error")
    return
  end

  if _tsource == _source then
    SendNotification(_source, Locales['MENU_KEYHOLDERS_ADD_NEW_TO_SELF'], "error")
    return
  end

  local property       = Properties[propertyId]

  local PlayerData     = GetPlayerData(_tsource)
  local identifier     = PlayerData.identifier
  local charidentifier = PlayerData.charIdentifier

  if Properties[propertyId].keyholders[identifier .. "_" .. charidentifier] then
    SendNotification(_source, Locales['MENU_KEYHOLDERS_ALREADY_EXISTS'], "error")
    return
  end

  local username = PlayerData.firstname .. " " .. PlayerData.lastname

  Properties[propertyId].keyholders[identifier .. "_" .. charidentifier]             = {}

  Properties[propertyId].keyholders[identifier .. "_" .. charidentifier].username    = username
  Properties[propertyId].keyholders[identifier .. "_" .. charidentifier].identifier  = identifier
  Properties[propertyId].keyholders[identifier .. "_" .. charidentifier].char        = charidentifier

  Properties[propertyId].keyholders[identifier .. "_" .. charidentifier].permissions = {}

  local permissions = {

    ['ledger_deposit']        = 0,
    ['ledger_withdraw']       = 0,
    ['keyholders']            = 0,
    ['set_wardrobe']          = 0,
    ['set_storage']           = 0,
    ['storage_access']        = 0,

  } -- sell & transfer will be never permitted, only owner will be having those perms.

  Properties[propertyId].keyholders[identifier .. "_" .. charidentifier].permissions = permissions

  SendNotification(_source, string.format(Locales['MENU_KEYHOLDERS_ADDED'], username), "success")

  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not property.hasTeleportationEntrance then
    TriggerEvent("tpz_housing:server:updateDoorlockInformation", propertyId, 'REGISTER_KEYHOLDER', { identifier, charidentifier, username })
  end

  -- tpz_housing:server:updateDoorlockInformation is updating to -1 instead.
  TriggerClientEvent("tpz_housing:client:updateProperty", -1, propertyId, 'ADDED_KEYHOLDER', { identifier, charidentifier, username }) -- IS SYNCED AT THE MOMENT
end)


RegisterServerEvent("tpz_housing:server:removePropertyKeyholder")
AddEventHandler("tpz_housing:server:removePropertyKeyholder", function(propertyId, identifier, char, username)
  local _source = source

  local Properties = GetProperties()

  if Properties[propertyId] == nil then
    return
  end

  local characterId = identifier .. '_' .. char

  if Properties[propertyId].keyholders[characterId] == nil then
    SendNotification(_source, Locales['MENU_KEYHOLDERS_DOES_NOT_EXISTS'], "error")
    return
  end

  local property = Properties[propertyId]

  SendNotification(_source, string.format(Locales['MENU_KEYHOLDERS_REMOVED'], username), "error")
 
  -- DOOR LOCKS SUPPORT ONLY IF PROPERTY HAS NOT TELEPORTATION ENTRANCE
  if not property.hasTeleportationEntrance then
    TriggerEvent("tpz_housing:server:updateDoorlockInformation", propertyId, 'UNREGISTER_KEYHOLDER', { tostring(characterId) })
  end

  -- tpz_housing:server:updateDoorlockInformation is updating to -1 instead.
  TriggerClientEvent("tpz_housing:client:updateProperty", _source, propertyId, 'REMOVED_KEYHOLDER', { characterId })

  if Properties[propertyId].keyholders[characterId].source then
    TriggerClientEvent("tpz_housing:client:updateProperty", tonumber(Properties[propertyId].keyholders[characterId].source), propertyId, 'REMOVED_KEYHOLDER', { characterId })
  end
		
  Properties[propertyId].keyholders[characterId] = nil

  -- UPDATE ON KEYHOLDERS -  CHANGES DOES NOT NEED TO BE UPDATED FOR THE WHOLE SERVER.
  if TPZ.GetTableLength(property.keyholders) > 0 then

    for index, keyholder in pairs (property.keyholders) do

      -- We are checking if the keyholder is online (has valid source)
      if keyholder.source and tonumber(keyholder.source) and tonumber(keyholder.source) ~= _source then
					
        TriggerClientEvent("tpz_housing:client:updateProperty", tonumber(keyholder.source), propertyId, 'REMOVED_KEYHOLDER', { characterId})

      end
    
    end
  
  end

end)


RegisterServerEvent('tpz_housing:server:onMembersPermissionUpdate')
AddEventHandler('tpz_housing:server:onMembersPermissionUpdate', function(propertyId, identifier, char, permission)
	local _source    = source
	--local StoresList = GetStoresList()
	--local PlayerData = GetPlayerData(_source)

  local Properties = GetProperties()

  if Properties[propertyId] == nil then
    return
  end

  local Property = Properties[propertyId]

  if Property.keyholders[identifier .. "_" .. char] == nil then
    return
  end

  local KeyholderData = Property.keyholders[identifier .. "_" .. char]

  KeyholderData.permissions[permission] = KeyholderData.permissions[permission] == 0 and 1 or 0

  local coords = vector3(Property.Locations.PrimaryEntrance.x, Property.Locations.PrimaryEntrance.y, Property.Locations.PrimaryEntrance.z)

  -- UPDATE ON THE ONE WHO DID THE CHANGE (IT CAN BE OWNER, OWNER DOES NOT EXIST ON KEYHOLDERS)
  TriggerClientEvent("tpz_housing:client:updateProperty", _source, propertyId, 'UPDATE_KEYHOLDER_PERMISSION', { 
    identifier, 
    char,
    permission,
    KeyholderData.permissions[permission] 
  })

  -- UPDATE ON KEYHOLDERS - PERMISSION CHANGES DOES NOT NEED TO BE UPDATED FOR THE WHOLE SERVER.
  if TPZ.GetTableLength(Property.keyholders) > 0 then

    for index, keyholder in pairs (Property.keyholders) do

      -- We are checking if the keyholder is online (has valid source)
      if keyholder.source and tonumber(keyholder.source) and tonumber(keyholder.source) ~= _source then

        TriggerClientEvent("tpz_housing:client:updateProperty", tonumber(keyholder.source), propertyId, 'UPDATE_KEYHOLDER_PERMISSION', { 
          identifier, 
          char,
          permission,
          KeyholderData.permissions[permission] 
        })
        
      end

    end

  end

end)
