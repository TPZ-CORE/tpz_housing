
--[[-------------------------------------------------------
 Basic Events
]]---------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
	local PlayerData = GetPlayerData()

    for i, v in pairs(PlayerData.Properties) do
		
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

	if Config.PropertyBlips.OnSale.DisplayPropertyId then
		title = string.format(Locales['PROPERTY_ON_SALE_BLIP_ID'], index)
	end
	
	if type == "OWNED" then
		sprite = Config.PropertyBlips.Owned
		title  = Locales['PROPERTY_OWNED_BLIP']
	end

	if type == "KEYHOLDER" then
		sprite = Config.PropertyBlips.Keyholders
		title  = Locales['PROPERTY_OWNED_KEYHOLDERS_BLIP']
	end

	local blipHandle = N_0x554d9d53f696d002(1664425300, coords)
    
	SetBlipSprite(blipHandle, sprite.Sprite, 1)
	SetBlipScale(blipHandle, 0.2)

	Citizen.InvokeNative(0x662D364ABF16DE2F, blipHandle, sprite.Color)
	Citizen.InvokeNative(0x9CB1A1623062F402, blipHandle, title)

	local PlayerData = GetPlayerData()

	PlayerData.Properties[index].blip = blipHandle
	PlayerData.Properties[index].blipType = type
end


--[[-------------------------------------------------------
 General
]]---------------------------------------------------------


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

RequestAnimation = function(anim)
	if not DoesAnimDictExist(anim) then
		return false
	end

	RequestAnimDict(anim)

	while not HasAnimDictLoaded(anim) do
		Wait(0)
	end


	return true
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

DrawTxt = function(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    Citizen.InvokeNative(0xADA9255D, 10);
    DisplayText(str, x, y)
end

DrawText3D = function(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
    local factor = (string.len(text)) / 150
    DrawSprite("generic_textures", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
end

PerformKeyAnimation = function (entity)
	local playerPed = PlayerPedId()

	ClearPedTasks(playerPed)

	TaskTurnPedToFaceEntity(playerPed, entity, -1)

	Wait(350)

	LoadModel('P_KEY02X')

	local x,y,z     = table.unpack(GetEntityCoords(playerPed, true))
	local prop      = CreateObject(joaat('P_KEY02'), x, y, z + 0.2, true, true, true)
	local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_R_Finger12")

	RequestAnimation('script_common@jail_cell@unlock@key')

	TaskPlayAnim(playerPed, 'script_common@jail_cell@unlock@key', 'action', 8.0, -8.0, 2500, 31, 0, true, 0, false, 0, false)

	AttachEntityToEntity(prop, playerPed, boneIndex, 0.02, 0.0120, -0.00850, 0.024, -160.0, 200.0, true, true, false, true, 1, true)

	Wait(1000)

	RemoveAnimDict('script_common@jail_cell@unlock@key')

	DeleteObject(prop)
	DeleteEntity(prop)
    SetEntityAsNoLongerNeeded(prop)

	ClearPedTasks(playerPed)

end