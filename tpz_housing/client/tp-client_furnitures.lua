

CurrentZoom = Furnitures.CameraHandlers.MinZoom


Builder = { IsPlacing = false, CurrentZ = nil, CurrentPitch = nil, CurrentRoll = nil, CurrentYaw = nil}

--[[ ------------------------------------------------
   Functions
]]---------------------------------------------------

local function AddBlip(Store)

    Furnitures.Locations[Store].BlipHandle = N_0x554d9d53f696d002(1664425300, Furnitures.Locations[Store].Coords.x, Furnitures.Locations[Store].Coords.y, Furnitures.Locations[Store].Coords.z)

    SetBlipSprite(Furnitures.Locations[Store].BlipHandle, Furnitures.Locations[Store].BlipData.Sprite, 1)
    SetBlipScale(Furnitures.Locations[Store].BlipHandle, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, Furnitures.Locations[Store].BlipHandle, Furnitures.Locations[Store].BlipData.Name)

end

local function SpawnNPC(Store)
    local v = Furnitures.Locations[Store].NPCData

	LoadModel(v.Model)

	local npc = CreatePed(v.Model, v.Coords.x, v.Coords.y, v.Coords.z, v.Coords.h, false, true, true, true)

	Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation

	SetEntityCanBeDamaged(npc, false)
	SetEntityInvincible(npc, true)
	Wait(1000)
	FreezeEntityPosition(npc, true) -- NPC can't escape
	SetBlockingOfNonTemporaryEvents(npc, true) -- NPC can't be scared

	Furnitures.Locations[Store].NPC = npc
end

function StartSelectedFurniturePlacement(propertyId, objectHash, label)

    local property = ClientData.Properties[propertyId]

    LoadHashModel(tonumber(objectHash))

    local playerCoords = GetEntityCoords(PlayerPedId())

    local object = CreateObject(tonumber(objectHash), playerCoords.x, playerCoords.y, playerCoords.z, false, false, false, false, false)
    
    SetEntityVisible(object, true)
    
    SetEntityCollision(object, false)

    Builder.IsPlacing = true

    local pitch, roll, yaw = table.unpack(GetEntityRotation(object, 2))

    Builder.CurrentPitch = pitch
    Builder.CurrentRoll  = roll
    Builder.CurrentYaw   = yaw

    Citizen.CreateThread(function ()

        while Builder.IsPlacing do
            Wait(0)


            local hit, coords, entity = RayCastGamePlayCamera(20)

            if Builder.CurrentZ == nil then
                Builder.CurrentZ = coords.z
            end

            SetEntityCoords(object, coords.x, coords.y, Builder.CurrentZ)
            SetEntityRotation(object, Builder.CurrentPitch, Builder.CurrentRoll, Builder.CurrentYaw, 2)

            DrawTxt(Locales['FURNITURE_PLACE_1'], 0.20, 0.30, 0.3, 0.3, true, 255, 255, 255, 255, true)
            DrawTxt(Locales['FURNITURE_PLACE_2'], 0.20, 0.33, 0.3, 0.3, true, 255, 255, 255, 255, true)
            DrawTxt(Locales['FURNITURE_PLACE_3'], 0.20, 0.36, 0.3, 0.3, true, 255, 255, 255, 255, true)
            DrawTxt(Locales['FURNITURE_PLACE_4'], 0.20, 0.39, 0.3, 0.3, true, 255, 255, 255, 255, true)
            DrawTxt(Locales['FURNITURE_PLACE_5'], 0.20, 0.42, 0.3, 0.3, true, 255, 255, 255, 255, true)

            if IsControlPressed(2, 0xA65EBAB4) then -- Arrow Left
                --SetEntityHeading(object, GetEntityHeading(object) - 2.5)
                Builder.CurrentYaw = Builder.CurrentYaw - 1.0
            end

            if IsControlPressed(2, 0xDEB34313) then -- Arrow Right
               -- SetEntityHeading(object, GetEntityHeading(object) + 2.5)

               Builder.CurrentYaw = Builder.CurrentYaw + 1.0
            end

            if IsControlPressed(2, 0x05CA7C52) then -- Arrow Down
                Builder.CurrentZ = Builder.CurrentZ - 0.01
            end
    
            if IsControlPressed(2, 0x6319DB71) then -- Arrow Up
                Builder.CurrentZ = Builder.CurrentZ + 0.01
            end

            if IsControlPressed(2, 0x446258B6) then -- PAGE UP
                Builder.CurrentPitch = Builder.CurrentPitch + 1.0
            end
    
            if IsControlPressed(2, 0x3C3DD371) then -- PAGE DOWN
                Builder.CurrentPitch = Builder.CurrentPitch - 1.0
            end

            if IsControlPressed(2, 0x156F7119) then -- 3
                Builder.CurrentRoll = Builder.CurrentRoll + 1.0
            end
    
            if IsControlPressed(2, 0xC7B5340A) then -- 4
                Builder.CurrentRoll = Builder.CurrentRoll - 1.0
            end

            if IsControlPressed(2, 0xE30CD707) then -- Reset 
                Builder.CurrentZ      = nil
                Builder.CurrentPitch  = pitch
                Builder.CurrentRoll   = roll
            end

            if IsControlPressed(2, 0x760A9C6F) then -- Place Object

                local newPlayerCoords = GetEntityCoords(PlayerPedId())
                local coordsDist      = vector3(newPlayerCoords.x, newPlayerCoords.y, newPlayerCoords.z)
                local propertyCoords  = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
                local distance        = #(coordsDist - propertyCoords)

                if distance <= tonumber(property.furnitureRange) then

                    local objectCoords        = GetEntityCoords(object)
                    local _pitch, _roll, _yaw = table.unpack(GetEntityRotation(object, 2))

                    local objectNewCoords = { x = objectCoords.x, y = objectCoords.y, z = objectCoords.z, pitch = _pitch, roll = _roll, yaw = _yaw }
    
                    TriggerServerEvent("tpz_housing:addPropertyFurniturePlacement", propertyId, objectHash, label, objectNewCoords)
        
                    RemoveEntityProperly(object, tonumber(objectHash) )
        
                    Builder.IsPlacing = false
                    Builder.CurrentZ  = nil
                    Builder.CurrentPitch = nil
                    Builder.CurrentRoll = nil

                    SendNotification(nil, Locales['FURNITURE_PLACED'], "success")

                else
                    SendNotification(nil, Locales['TOO_FAR'], "error")
                end

                Wait(200)
            end

        
            if IsControlPressed(2, 0x4AF4D473) then -- Cancel
    
                RemoveEntityProperly(object, tonumber(objectHash) )
    
                Builder.IsPlacing = false
                Builder.CurrentZ  = nil

                Wait(200)
            end

        end

    end)

end

--[[ ------------------------------------------------
   Base Events
]]---------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if ClientData.IsInMenu then
        DestroyAllCams(true)
    end

    if ClientData.Loaded then

        for propertyId, property in pairs(ClientData.Properties) do

            for _, furniture in pairs (property.furniture) do
    
                if furniture.loadedObject then
    
                    RemoveEntityProperly(furniture.loadedObject, tonumber(furniture.hash) )

                    furniture.loadedObject = nil
                end
            
            end
    
        end

    end

    for i, v in pairs(Furnitures.Locations) do

        if v.BlipHandle then
            RemoveBlip(v.BlipHandle)
        end

        if v.NPC then
            RemoveEntityProperly(v.NPC )
        end

    end

end)

--[[ ------------------------------------------------
   Threads (Repeating)
]]---------------------------------------------------

if Config.Furnitures.Enabled then


    -- Load / Render Property Furnitures
    Citizen.CreateThread(function()

        while true do

            Wait(2000)
     
            local player = PlayerPedId()
 
            if ClientData.Loaded then
     
                local coords     = GetEntityCoords(player)
                local coordsDist = vector3(coords.x, coords.y, coords.z)
   
                for propertyId, property in pairs(ClientData.Properties) do

                    local propertyCoords = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
                    local distance       = #(coordsDist - propertyCoords)
    
                    if distance > (property.furnitureRange * 2) then
    
                        local length = GetTableLength(property.furniture)
    
                        if length > 0 then
    
                            for _, furniture in pairs (property.furniture) do
        
                                if furniture.loadedObject then
        
                                    RemoveEntityProperly(furniture.loadedObject, tonumber(furniture.hash) )
                                    
                                    furniture.loadedObject = nil
                                end
                                
                            end
                            
                        end
    
                    end

                    if distance <= (property.furnitureRange * 2) then

                        local length = GetTableLength(property.furniture)
    
                        if length > 0 then
                            
                            for _, furniture in pairs (property.furniture) do
        
                                if not furniture.loadedObject then
                                    LoadHashModel(tonumber(furniture.hash))
        
                                    local toVec  = vector3(furniture.coords.x, furniture.coords.y, furniture.coords.z)
                                    local object = CreateObject(tonumber(furniture.hash), toVec, false, false, false, false, false)
    
                                    SetEntityVisible(object, true)

                                    SetEntityRotation(object, furniture.coords.pitch, furniture.coords.roll, furniture.coords.yaw, 2)
                                    
                                    --SetEntityHeading(object, furniture.coords.yaw)
    
                                    SetEntityCollision(object, true)
                                    FreezeEntityPosition(object, true)
    
                                    furniture.loadedObject = object
                                end
                                
                            end
        
                        end
    
                    end

                end

            end
    
        end
    
    end)


    Citizen.CreateThread(function()

        RegisterFurniturePrompts()
    
        while true do
    
            Wait(0)
    
            local player       = PlayerPedId()
            local isPlayerDead = IsEntityDead(player)
    
            local sleep        = true
    
            if ClientData.Loaded and not isPlayerDead then
    
                local coords = GetEntityCoords(player)
    
                for storeId, storeConfig in pairs(Furnitures.Locations) do
    
                    local coordsDist = vector3(coords.x, coords.y, coords.z)
                    local coordsStore = vector3(storeConfig.Coords.x, storeConfig.Coords.y, storeConfig.Coords.z)
                    local distance = #(coordsDist - coordsStore)
    
                    if not Furnitures.Locations[storeId].BlipHandle and storeConfig.BlipData.Enabled then
                        AddBlip(storeId)
                    end
    
                    if Furnitures.Locations[storeId].NPC and distance > Config.RenderNPCDistance then

                        RemoveEntityProperly(Furnitures.Locations[storeId].NPC)

                        Furnitures.Locations[storeId].NPC = nil
                    end
                    
                    if not Furnitures.Locations[storeId].NPC and distance <= Config.RenderNPCDistance then
                        SpawnNPC(storeId)
                    end
    
                    if distance <= storeConfig.ActionDistance then
                        sleep = false

                        local label = CreateVarString(10, 'LITERAL_STRING', Locales['FURNITURE_PROMPT_FOOTER'] )
                        PromptSetActiveGroupThisFrame(FurniturePrompts, label)

                        for i, prompt in pairs (FurniturePromptsList) do

                            PromptSetVisible(prompt.prompt, 0)

                            if prompt.type == 'OPEN' and not ClientData.IsInMenu then
                                PromptSetVisible(prompt.prompt, 1)
                            end

                            if prompt.type == 'ZOOM' and ClientData.IsInMenu then
                                PromptSetVisible(prompt.prompt, 1)  
                            end

                            if prompt.type == 'BUY' and CurrentObjectEntity.Entity then
                                PromptSetVisible(prompt.prompt, 1)
                            end

                            if IsControlPressed(2, Keys[Furnitures.PromptKeys['OPEN'].key1]) and not ClientData.IsInMenu then

                                CurrentZoom = Furnitures.CameraHandlers.MinZoom

                                OpenFurnitureStore(storeId)
    
                                local cameraCoords = storeConfig.CameraCoords

                                StartCam(cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty,
                                cameraCoords.rotz, CurrentZoom)
    
                                Wait(1500)
                            end

                            if IsControlPressed(2, Keys[Furnitures.PromptKeys['ZOOM'].key2]) and ClientData.IsInMenu then -- zoom out

                                if CurrentZoom < Furnitures.CameraHandlers.MinZoom then -- Zoom out limit

                                    CurrentZoom = CurrentZoom + 4.0

                                    local cameraCoords = storeConfig.CameraCoords

                                    StartCam(cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty,
                                    cameraCoords.rotz, CurrentZoom)
                                end

                                Wait(50)
                            end
                
                            if IsControlPressed(2, Keys[Furnitures.PromptKeys['ZOOM'].key1]) and ClientData.IsInMenu then -- zoom in
                
                                if CurrentZoom > Furnitures.CameraHandlers.MaxZoom then -- Zoom in limit

                                    CurrentZoom = CurrentZoom - 4.0

                                    if CurrentZoom <= Furnitures.CameraHandlers.MaxZoom then
                                        CurrentZoom = Furnitures.CameraHandlers.MaxZoom
                                    end
                
                                    local cameraCoords = storeConfig.CameraCoords

                                    StartCam(cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty,
                                    cameraCoords.rotz, CurrentZoom)
                                end
                
                                Wait(50)
   
                            end

                        end

                       -- end
    
                    end
    
    
                end
                
            end
    
            if sleep then
                Citizen.Wait(1000)
            end
            
        end
    
    end)

end