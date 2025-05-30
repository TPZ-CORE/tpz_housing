local TPZ = exports.tpz_core:getCoreAPI()

local DoorData = { Loaded = false, DoorsList = {} }

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local IsAuthorized = function(doorID, owned)

	local data = DoorData.DoorsList[doorID]
	local PlayerData = GetPlayerData()

	-- Allowing real estate job to open doors while the house is not owned.
	if data.owned == 0 and Config.RealEstateJob.Job == PlayerData.Job then
		return true
	end

	-- If not owned and not real estate job, we don't allow.
	if data.owned == 0 then
		return false
	end

	local found  = false

	if data.identifier == PlayerData.Identifier and tostring(data.charidentifier) == tostring(PlayerData.CharIdentifier) then
		return true
	end

	local length = TPZ.GetTableLength(data.keyholders)

	if length > 0 then
 
	   for _, keyholder in pairs (data.keyholders) do
		  
		  if _ == PlayerData.Identifier .. "_" .. tostring(PlayerData.CharIdentifier) then
			found = true
		  end
	   end
 
	end
 
	return found

end


function GetDoorData()
	return DoorData
end

-----------------------------------------------------------
--[[ Base Events & Threads ]]--
-----------------------------------------------------------

-- Gets the player job when character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()
    TriggerServerEvent("tpz_housing:server:requestDoorlocks")
end)

-- Gets the player job when devmode set to true.
if Config.DevMode then
    Citizen.CreateThread(function () TriggerServerEvent("tpz_housing:server:requestDoorlocks") end)
end

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

RegisterNetEvent("tpz_housing:client:loadDoorsList")
AddEventHandler("tpz_housing:client:loadDoorsList", function(data)
	DoorData.DoorsList = data

	DoorData.Loaded = true
end)


RegisterNetEvent("tpz_housing:client:setState")
AddEventHandler("tpz_housing:client:setState", function(doorId, state)
	DoorData.DoorsList[doorId].locked = state
end)


-- Register new doorlock based on its parameters.
RegisterNetEvent("tpz_housing:client:registerNewDoorlock")
AddEventHandler('tpz_housing:client:registerNewDoorlock', function(doorID, doors, canBreakIn, keyholders, owned, identifier, charidentifier)

	DoorData.DoorsList[doorID]                = {}

	DoorData.DoorsList[doorID].index          = doorID
	
	DoorData.DoorsList[doorID].authorizedJobs = { 'none' }
	DoorData.DoorsList[doorID].doors          = doors
	DoorData.DoorsList[doorID].textCoords     = doors[1].textCoords
	DoorData.DoorsList[doorID].locked         = true

	DoorData.DoorsList[doorID].distance       = 2.0

	DoorData.DoorsList[doorID].canBreakIn     = canBreakIn

	DoorData.DoorsList[doorID].keyholders     = keyholders

	DoorData.DoorsList[doorID].owned          = owned

	DoorData.DoorsList[doorID].identifier     = identifier
	DoorData.DoorsList[doorID].charidentifier = charidentifier
end)

RegisterNetEvent("tpz_housing:client:doors:update")
AddEventHandler("tpz_housing:client:doors:update", function(locationId, actionType, data)

	for _, door in pairs (DoorData.DoorsList) do

		if door.locationId == locationId then

			if actionType == 'TRANSFERRED' then

				DoorData.DoorsList[_].identifier     = data[1]
				DoorData.DoorsList[_].charidentifier = data[2]
				DoorData.DoorsList[_].owned          = 1

			elseif actionType == 'RESET' then
			
				DoorData.DoorsList[_].identifier     = nil
				DoorData.DoorsList[_].charidentifier = 0

				DoorData.DoorsList[_].keyholders     = nil
				DoorData.DoorsList[_].keyholders     = {}

				DoorData.DoorsList[_].owned          = 0

			elseif actionType == 'REGISTER_KEYHOLDER' then

				DoorData.DoorsList[_].keyholders[data[1] .. "_" .. data[2]]           = {}
				DoorData.DoorsList[_].keyholders[data[1] .. "_" .. data[2]].username  = data[2]

			elseif actionType == 'UNREGISTER_KEYHOLDER' then

				DoorData.DoorsList[_].keyholders[data[1]] = nil

			end

		end

	end

end)

--[[-------------------------------------------------------
 Threads
]]---------------------------------------------------------


-- Get objects every second, instead of every frame by checking DOOR_HASHES file for getting the correct
-- object and its hashes.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		for _, location in ipairs(DoorData.DoorsList) do

			for k, door in ipairs(location.doors) do

				if door ~= false and not door.object then

					local distance = #(coords - door.objCoords)

					if distance <= Config.RenderDoorStateDistance then

						local shapeTest = StartShapeTestBox(door.objCoords, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, true, 16)
						local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
	
						if DoesEntityExist(entityHit) then
	
							local model = GetEntityModel(entityHit)
	
							for _,v in pairs(DOOR_HASHES) do 
	
								if model == v[2] then

									local doorcoords = vector3(v[4],v[5], v[6])
									local distance = #(doorcoords - door.objCoords)

									if distance <= 1.2 then
										door.object = v[1] -- hash
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

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
        local isDead    = IsEntityDead(playerPed)

		local sleep     = true

		if not isDead and DoorData.Loaded then

			for k, v in ipairs(DoorData.DoorsList) do

				for _, door in ipairs(v.doors) do

					if door ~= false and door.object then

						local distance = #(coords - door.objCoords)
						local maxDistance, displayText = 1.25, Locales['UNLOCKED']
		
						if v.distance then
							maxDistance = v.distance
						end
		
						if distance < Config.RenderDoorStateDistance then

							if v.locked then

								if DoorSystemGetOpenRatio(door.object) ~= 0.0 then
									DoorSystemSetOpenRatio(door.object, 0.0, true)
	
									local object = Citizen.InvokeNative(0xF7424890E4A094C0, door.object, 0)
									SetEntityRotation(object, 0.0, 0.0, door.objYaw, 2, true)
								
								end

								if DoorSystemGetDoorState(door.object) ~= 3 then
									Citizen.CreateThread(function()
										Citizen.InvokeNative(0xD99229FE93B46286,door.object,1,1,0,0,0,0)
									end)
									
									local object = Citizen.InvokeNative(0xF7424890E4A094C0, door.object, 0)
									
									Citizen.InvokeNative(0x6BAB9442830C7F53, door.object, 3)
									SetEntityRotation(object, 0.0, 0.0, door.objYaw, 2, true)
									
								end
							else
	
								if DoorSystemGetDoorState(door.object) ~= 0 then
									Citizen.CreateThread(function()
										Citizen.InvokeNative(0xD99229FE93B46286,door.object,1,1,0,0,0,0)
									end)
									Citizen.InvokeNative(0x6BAB9442830C7F53,door.object, 0)
									
								end
							end

						end


						if distance < maxDistance then
							sleep = false
		
							if v.locked then
								displayText = Locales['LOCKED']
							end
			
							DrawText3D(v.textCoords.x, v.textCoords.y, v.textCoords.z, displayText)
			
							if IsControlJustReleased(1, Config.DoorKey) and IsAuthorized(k, v.owned) then
		
								local entity = Citizen.InvokeNative(0xF7424890E4A094C0, v.doors[1].object, 0)
		
								PerformKeyAnimation(entity)
		
								TriggerServerEvent('tpz_housing:server:updateState', k, (not v.locked) )
								
								Wait(500)
							end
					
						end

					end

				end
	
			end

		end

		if sleep then
			Citizen.Wait(1000)
		end
	end
end)
