
--[[-------------------------------------------------------
 Basic Events
]]---------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    for i, v in pairs(ClientData.Properties) do
		
        if v.blip then
            RemoveBlip(v.blip)
        end

    end

end)

--[[-------------------------------------------------------
 Prompts
]]---------------------------------------------------------

Prompts, MenuPrompts, TeleportPrompts, FurniturePrompts = GetRandomIntInRange(0, 0xffffff), GetRandomIntInRange(0, 0xffffff), GetRandomIntInRange(0, 0xffffff), GetRandomIntInRange(0, 0xffffff)
PromptsList, MenuPromptsList, TeleportPromptsList, FurniturePromptsList = {}, {}, {}, {}

RegisterPrompts = function()

    for index, tprompt in pairs (Config.PromptKeys) do

		if tprompt.type == "PROPERTY_BUY_ACTIONS" then

			local str = tprompt.label
			local keyPress = Keys[tprompt.key]
		
			local _prompt = PromptRegisterBegin()
			PromptSetControlAction(_prompt, keyPress)
			str = CreateVarString(10, 'LITERAL_STRING', str)
			PromptSetText(_prompt, str)
			PromptSetEnabled(_prompt, 1)
			PromptSetVisible(_prompt, 0)
			PromptSetStandardMode(_prompt, 1)
			PromptSetHoldMode(_prompt, tprompt.hold)

			PromptSetGroup(_prompt, Prompts)

			Citizen.InvokeNative(0xC5F428EE08FA7F2C, _prompt, true)
			PromptRegisterEnd(_prompt)
		
			table.insert(PromptsList, {prompt = _prompt, type = index })

		end
    end

end

RegisterMenuPrompts = function()

    for index, tprompt in pairs (Config.PromptKeys) do

		if tprompt.type == "MENU_ACTIONS" then

			local str = tprompt.label
			local keyPress = Keys[tprompt.key]
		
			local _prompt = PromptRegisterBegin()
			PromptSetControlAction(_prompt, keyPress)
			str = CreateVarString(10, 'LITERAL_STRING', str)
			PromptSetText(_prompt, str)
			PromptSetEnabled(_prompt, 1)
			PromptSetVisible(_prompt, 0)
			PromptSetStandardMode(_prompt, 1)
			PromptSetHoldMode(_prompt, tprompt.hold)

			PromptSetGroup(_prompt, MenuPrompts)

			Citizen.InvokeNative(0xC5F428EE08FA7F2C, _prompt, true)
			PromptRegisterEnd(_prompt)

			table.insert(MenuPromptsList, {prompt = _prompt, type = index })

		end
    end

end

RegisterTeleportPrompts = function()

	local keyPress = Keys[Config.PromptKeys['TELEPORT'].key]

	local _prompt = PromptRegisterBegin()
	PromptSetControlAction(_prompt, keyPress)

	PromptSetEnabled(_prompt, 1)
	PromptSetVisible(_prompt, 1)
	PromptSetStandardMode(_prompt, 1)
	PromptSetHoldMode(_prompt, 1500)
	PromptSetGroup(_prompt, TeleportPrompts)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C, _prompt, true)
	PromptRegisterEnd(_prompt)

	TeleportPromptsList = _prompt
end

RegisterFurniturePrompts = function()

	for index, tprompt in pairs (Furnitures.PromptKeys) do
	
		local str = tprompt.label
        local keyPress = tprompt.key1
        local keyPress2 = tprompt.key2

        local dPrompt = PromptRegisterBegin()
        PromptSetControlAction(dPrompt, Keys[keyPress])

        if keyPress2 then
            PromptSetControlAction(dPrompt, Keys[keyPress2])
        end
        
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(dPrompt, str)
        PromptSetEnabled(dPrompt, 1)
        PromptSetVisible(dPrompt, 1)
        PromptSetStandardMode(dPrompt, 0)
        PromptSetHoldMode(dPrompt, false)
        PromptSetGroup(dPrompt, FurniturePrompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, dPrompt, true)
        PromptRegisterEnd(dPrompt)
    
        table.insert(FurniturePromptsList, {prompt = dPrompt, type = index})
	end

end

--[[-------------------------------------------------------
 Blips
]]---------------------------------------------------------

CreatePropertyBlip = function(index, type, coords)
	local sprite = Config.PropertyBlips.OnSale
	local title  = Locales['PROPERTY_ON_SALE_BLIP']

	if type == "OWNED" then
		sprite = Config.PropertyBlips.Owned
		title  = Locales['PROPERTY_OWNED_BLIP']
	end

	local blipHandle = N_0x554d9d53f696d002(1664425300, coords)
    
	SetBlipSprite(blipHandle, sprite.Sprite, 1)
	SetBlipScale(blipHandle, 0.2)

	Citizen.InvokeNative(0x662D364ABF16DE2F, blipHandle, sprite.Color)
	Citizen.InvokeNative(0x9CB1A1623062F402, blipHandle, title)

	ClientData.Properties[index].blip = blipHandle
	ClientData.Properties[index].blipType = type
end


--[[-------------------------------------------------------
 General
]]---------------------------------------------------------

-- @GetTableLength returns the length of a table.
GetTableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

Round = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

GetNearestPlayers = function(distance)
	local closestDistance = distance
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local closestPlayers = {}

	for _, player in pairs(GetActivePlayers()) do
		local target = GetPlayerPed(player)

		if target ~= playerPed then
			local targetCoords = GetEntityCoords(target, true, true)
			local distance = #(targetCoords - coords)

			if distance < closestDistance then
				table.insert(closestPlayers, player)
			end
		end
	end
	return closestPlayers
end

LoadModel = function(inputModel)
   local model = joaat(inputModel)

   RequestModel(model)

   while not HasModelLoaded(model) do RequestModel(model)
       Citizen.Wait(10)
   end
end


LoadHashModel = function(model)
    RequestModel(model)

    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(10)
    end
end


RemoveEntityProperly = function(entity, objectHash)
	DeleteEntity(entity)
	DeletePed(entity)
	SetEntityAsNoLongerNeeded( entity )

	if objectHash then
		SetModelAsNoLongerNeeded(objectHash)
	end
end


PlayAnimation = function(ped, anim)
	if not DoesAnimDictExist(anim.dict) then
		return false
	end

	RequestAnimDict(anim.dict)

	while not HasAnimDictLoaded(anim.dict) do
		Wait(0)
	end

	TaskPlayAnim(ped, anim.dict, anim.base, 1.0, 1.0, -1, 1, 0.0, false, false, false, '', false)

	RemoveAnimDict(anim.dict)

	return true
end

StartCam = function(x, y, z, rotx, roty, rotz, fov)

	Citizen.InvokeNative(0x17E0198B3882C2CB, PlayerPedId())
	DestroyAllCams(true)

    local cameraHandler = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, rotx, roty, rotz, fov, true, 0)
    
	SetCamActive(cameraHandler, true)

	RenderScriptCams(true, true, 500, true, true)

end

DrawTxt = function(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    Citizen.InvokeNative(0xADA9255D, 10);
    DisplayText(str, x, y)
end

DrawText3D = function(x, y, z, text, color)
    local r, g, b, a = 255, 255, 255, 255
    if color then
        r, g, b, a = table.unpack(color)
    end
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
        SetTextScale(0.4, 0.4)
        SetTextFontForCurrentCommand(25) -- font style
        SetTextColor(r, g, b, a)
        SetTextCentre(1)
        DisplayText(str, _x, _y)
        local factor = (string.len(text)) / 100 -- draw sprite size
        DrawSprite("feeds", "toast_bg", _x, _y + 0.0125, 0.015 + factor, 0.03, 0.1, 0, 0, 0, 200, false)
    end
end

RayCastGamePlayCamera = function(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, hit, coords, d, entity = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    if #(coords - GetEntityCoords(PlayerPedId())) < distance + 0.0 then
        return hit, coords, entity
    else
        return 0, vector3(0, 0, 0), 0
    end
end

RotationToDirection = function(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end