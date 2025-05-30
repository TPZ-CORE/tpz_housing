local TPZ = exports.tpz_core:getCoreAPI()

local DoorsList = {}

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DoorsList = nil
end)

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_housing:server:requestDoorlocks")
AddEventHandler("tpz_housing:server:requestDoorlocks", function()
	local _source = source

	if TPZ.GetTableLength(DoorsList) <= 0 then
		return
	end

	TriggerClientEvent("tpz_housing:client:loadDoorsList", _source, DoorsList)
end)


-- @locationId : Where or what property (name of property) the new door will be registered to.
RegisterServerEvent("tpz_housing:server:registerNewDoorlock")
AddEventHandler("tpz_housing:server:registerNewDoorlock", function(locationId, doors, canBreakIn, keyholders, identifier, charidentifier)

	local length = TPZ.GetTableLength(DoorsList)
	local doorId = length + 1

	DoorsList[doorId]                = {}

	DoorsList[doorId].index          = doorId
	
	DoorsList[doorId].doors          = doors
	DoorsList[doorId].textCoords     = doors[1].textCoords
	DoorsList[doorId].locked         = true

	DoorsList[doorId].distance       = 2.0

	DoorsList[doorId].canBreakIn     = canBreakIn
	DoorsList[doorId].locationId     = locationId

	DoorsList[doorId].keyholders     = keyholders

	local isPropertyOwned = (not identifier or not charidentifier) and 0 or 1

	DoorsList[doorId].owned          = isPropertyOwned
	DoorsList[doorId].identifier     = identifier
	DoorsList[doorId].charidentifier = charidentifier

	TriggerClientEvent("tpz_housing:client:registerNewDoorlock", -1, doorId, doors, canBreakIn, keyholders, isPropertyOwned, identifier, charidentifier)
	
end)

RegisterServerEvent("tpz_housing:server:updateDoorlockInformation")
AddEventHandler("tpz_housing:server:updateDoorlockInformation", function(locationId, actionType, data )

	for _, door in pairs (DoorsList) do

		if door.locationId == locationId then

			if actionType == 'TRANSFERRED' then

				DoorsList[_].identifier     = data[1]
				DoorsList[_].charidentifier = data[2]
				DoorsList[_].owned          = 1

			elseif actionType == 'RESET' then

				DoorsList[_].identifier     = nil
				DoorsList[_].charidentifier = 0

				DoorsList[_].keyholders     = nil
				DoorsList[_].keyholders     = {}

				DoorsList[_].owned          = 0

				-- Data[1] returns 0 - 1 which is for unlocking all property doors / not.
				if tonumber(data[1]) then
					TriggerClientEvent('tpz_housing:client:setState', -1, _, false)
				end

			elseif actionType == 'REGISTER_KEYHOLDER' then

				DoorsList[_].keyholders[data[1] .. "_" .. data[2]]           = {}
				DoorsList[_].keyholders[data[1] .. "_" .. data[2]].username  = data[3]

			elseif actionType == 'UNREGISTER_KEYHOLDER' then

				DoorsList[_].keyholders[data[1]] = nil

			end

		end

	end

	-- We update and do client triggers outside from looping to avoid multiple calls.
	TriggerClientEvent("tpz_housing:client:doors:update", -1, locationId, actionType, data )

end)


RegisterServerEvent('tpz_housing:server:updateState')
AddEventHandler('tpz_housing:server:updateState', function(doorID, state)

	if type(doorID) ~= 'number' then
		return
	end

	TriggerClientEvent('tpz_housing:client:setState', -1, doorID, state)
end)
