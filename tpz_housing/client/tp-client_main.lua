ClientData = { IsInMenu = false, DisplayingUI = false, IsBusy = false, CharIdentifier = 0, Job = nil, Properties = {}, ItemsList = {}, Loaded = false }


--[[ ------------------------------------------------
   Local Functions
]]---------------------------------------------------

local IsPermittedToBuy = function()
   
   local totalProperties = 0

   for _, property in pairs (ClientData.Properties) do

      if property.owned == 1 and tonumber(property.charidentifier) == ClientData.CharIdentifier then
         totalProperties = totalProperties + 1
      end

   end

   return (totalProperties < Config.MaxHouses)

end


local IsAllowedToEnterProperty = function(property)

   if tonumber(property.charidentifier) == ClientData.CharIdentifier then
      return true
   end

   local found  = false
   local length = GetTableLength(property.keyholders)

   if length > 0 then

      for _, keyholder in pairs (property.keyholders) do
         
         if _ == tostring(ClientData.CharIdentifier) then
            found = true
         end
      end

   end

   return found

end

local TeleportOutsideOnJoin = function()

   local player = PlayerPedId()
   local coords = GetEntityCoords(player)

   for propertyId, property in pairs(ClientData.Properties) do

      local coordsDist          = vector3(coords.x, coords.y, coords.z)
      local menuActionsDistance = #(coordsDist - property.Locations.MenuActions)

      local distance            = #(coordsDist - menuActionsDistance)

      if distance <= Config.TeleportOutsideOnJoin.ClosestDistance then

         FreezeEntityPosition(player, true)

         local teleportCoords = property.Locations.PrimaryEntrance

         exports.tpz_core:rClientAPI().teleportToCoords(teleportCoords.x, teleportCoords.y, teleportCoords.z, teleportCoords.w)
                       
         Wait(1000)
         FreezeEntityPosition(player, false)
         
      end

   end

end

--[[ ------------------------------------------------
   Basic Events
]]---------------------------------------------------

-- Gets the properties data on character select.
AddEventHandler("tpz_core:isPlayerReady", function()

   TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)

      ClientData.CharIdentifier = data.charIdentifier
      ClientData.Job            = data.job

      TriggerServerEvent("tpz_housing:requestProperties")

   end)


end)


-- Gets the properties data on devmode.
if Config.DevMode then

   Citizen.CreateThread(function ()

      Wait(2000)

      TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)

         if data == nil then
            return
         end

         ClientData.CharIdentifier = data.charIdentifier
         ClientData.Job            = data.job

         TriggerServerEvent("tpz_housing:requestProperties")

      end)

   end)
end

-- Updates the player job and job grade in case if changes.
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
   ClientData.Job      = data.job
end)


--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterNetEvent("tpz_housing:loadProperties")
AddEventHandler("tpz_housing:loadProperties", function(properties, items)
	ClientData.Properties = properties
   ClientData.ItemsList  = items

	ClientData.Loaded     = true

   if not Config.TeleportOutsideOnJoin.Enabled then
      return
   end

   TeleportOutsideOnJoin()
end)


RegisterNetEvent("tpz_housing:updateProperty")
AddEventHandler("tpz_housing:updateProperty", function(propertyId, type, data)

   -- In case a player is not connected, to not return null errors since properties
   -- have not yet loaded.
   if ClientData.Properties[propertyId] == nil then
      return
   end

   if type == 'BUY' then

      ClientData.Properties[propertyId].identifier     = data[1]
      ClientData.Properties[propertyId].charidentifier = data[2]
      ClientData.Properties[propertyId].owned          = 1
      ClientData.Properties[propertyId].duration       = 0
      ClientData.Properties[propertyId].paid           = 0

   elseif type == 'TRANSFERRED' then

      ClientData.Properties[propertyId].identifier     = data[1]
      ClientData.Properties[propertyId].charidentifier = data[2]

   elseif type == 'SOLD' then

      ClientData.Properties[propertyId].identifier     = nil
      ClientData.Properties[propertyId].charidentifier = 0

      ClientData.Properties[propertyId].duration       = 0
      ClientData.Properties[propertyId].paid           = 0
      ClientData.Properties[propertyId].owned          = 0

      ClientData.Properties[propertyId].keyholders     = nil
      ClientData.Properties[propertyId].charidentifier = {}

      if Config.ResetUpgrades then
         ClientData.Properties[propertyId].upgrade = 0
      end

   elseif type == 'LOCATION' then
      
      local locationCoords = { x = data[2].x, y = data[2].y, z = data[2].z }

      if data[1] == 'WARDROBE' then
         ClientData.Properties[propertyId].wardrobe = locationCoords
     
      elseif data[1] == 'STORAGE' then
         ClientData.Properties[propertyId].storage = locationCoords
      end

   elseif type == "UPGRADE" then

      ClientData.Properties[propertyId].upgrade = ClientData.Properties[propertyId].upgrade + 1

   elseif type == "PAID" then

      ClientData.Properties[propertyId].paid = tonumber(data[1])

   elseif type == 'ADDED_FURNITURE' then

      ClientData.Properties[propertyId].furniture[data[1]]        = {}
      ClientData.Properties[propertyId].furniture[data[1]].hash   = data[2]
      ClientData.Properties[propertyId].furniture[data[1]].label  = data[3]
      ClientData.Properties[propertyId].furniture[data[1]].coords = data[4]

   elseif type == 'REMOVED_FURNITURE' then

      RemoveEntityProperly(ClientData.Properties[propertyId].furniture[data[1]].loadedObject, tonumber(data[2]) )

      ClientData.Properties[propertyId].furniture[data[1]] = nil

      ClientData.IsBusy = false

   elseif type == 'ADDED_KEYHOLDER' then
      ClientData.Properties[propertyId].keyholders[data[1]]          = {}
      ClientData.Properties[propertyId].keyholders[data[1]].username = data[2]

   elseif type == 'REMOVED_KEYHOLDER' then
      ClientData.Properties[propertyId].keyholders[data[1]] = nil

      ClientData.IsBusy = false
   end

end)

RegisterNetEvent("tpz_housing:setBusy")
AddEventHandler("tpz_housing:setBusy", function(cb)
   ClientData.IsBusy = cb
end)

--[[ ------------------------------------------------
   Threads (Repeating)
]]---------------------------------------------------

Citizen.CreateThread(function()

   RegisterPrompts()

   while true do
      Wait(0)

      local player            = PlayerPedId()
      local isPlayerDead      = IsEntityDead(player)

      local isPaused          = IsPauseMenuActive()
		local isInCimematicMode = Citizen.InvokeNative(0x74F1D22EFA71FAB8)

      local sleep             = true

      if ClientData.Loaded and not ClientData.IsBusy and not isPlayerDead and not isPaused and not isInCimematicMode then

         local coords = GetEntityCoords(player)
  
         for propertyId, property in pairs(ClientData.Properties) do

            local coordsDist     = vector3(coords.x, coords.y, coords.z)
            local propertyCoords = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
            local distance       = #(coordsDist - propertyCoords)

            if Config.PropertyBlips.OnSale and property.owned == 0 and property.blip == nil then
               CreatePropertyBlip(propertyId, "ON_SALE", propertyCoords)
            end

            -- display only on owner
            if property.owned == 1 then

               if property.blip and property.blipType == 'ON_SALE' then
                  RemoveBlip(property.blip)

                  property.blip     = nil
                  property.blipType = nil
               end

               if tonumber(property.charidentifier) == ClientData.CharIdentifier and property.blip == nil then
                  CreatePropertyBlip(propertyId, "OWNED", propertyCoords)
               end

            end

            if distance <= property.Locations.ActionDistance and property.owned == 0 then
               sleep = false

               if not ClientData.DisplayingUI then

                  SetCurrentBackgroundImageUrl(property.backgroundImageUrl)
                  EnableNUI(true)
               end

               local label = CreateVarString(10, 'LITERAL_STRING', string.format(Locales['PROPERTY_PROMPT_FOOTER'], property.cost, property.goldCost, property.tax, property.defaultStorageWeight ) )
               PromptSetActiveGroupThisFrame(Prompts, label)


               for i, prompt in pairs (PromptsList) do

                  PromptSetVisible(prompt.prompt, 0)

                  if prompt.type == "SELL" and Config.RealEstateJob.Enabled and Config.RealEstateJob.Job == ClientData.Job then
                     PromptSetVisible(prompt.prompt, 1)

                  end
                  
                  if prompt.type == "BUY" or prompt.type == "BUY_GOLD" then
                     PromptSetEnabled(prompt.prompt, 1)
                     PromptSetVisible(prompt.prompt, 1)

                     if Config.RealEstateJob.Enabled and Config.RealEstateJob.Job ~= ClientData.Job then
                        PromptSetEnabled(prompt.prompt, 0)
                        
                     end
                  end
                  
                  if PromptHasHoldModeCompleted(prompt.prompt) then

                     if prompt.type == 'SELL' then
                        ClearPedTasksImmediately(player)
                        ClientData.IsBusy = true
                        CloseNUIProperly()

                        Wait(500)
                        TaskStartScenarioInPlace(player, joaat('WORLD_HUMAN_WRITE_NOTEBOOK'), -1)

                        local nearestPlayers = GetNearestPlayers(3.0)
                        local foundPlayer    = false

                        local inputData = {
                           title        = Locales['REAL_ESTATE_SELL_TITLE'],
                           desc         = Locales['REAL_ESTATE_SELL_DESCRIPTION'],
                           buttonparam1 = Locales['REAL_ESTATE_SELL_ACCEPT'],
                           buttonparam2 = Locales['REAL_ESTATE_SELL_DECLINE'],
                        }
                                                   
                        TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)

                           local inputId = tonumber(cb)

                           if inputId ~= nil and inputId ~= 0 and inputId > 0 then

                              if inputId == GetPlayerServerId(PlayerId()) then
                                 SendNotification(nil, Locales['REAL_ESTATE_SELL_TO_SELF'], "error")

                                 ClientData.IsBusy = false
                                 ClearPedTasks(player)
                                 return
                              end

                              for _, targetPlayer in pairs(nearestPlayers) do

                                 if inputId == GetPlayerServerId(targetPlayer) then
                                    foundPlayer = true
                                 end
                              end

                              if foundPlayer then

                                 TriggerServerEvent("tpz_housing:buySelectedProperty", 'BUY', propertyId, inputId)

                                 Wait(2000)
                              else
                                 SendNotification(nil, Locales['PLAYER_NOT_FOUND'], "error")
                              end

                           else

                              if cb ~= 'DECLINE' then
                                 SendNotification(nil, Locales['INVALID_INPUT'], "error")
                              end

                           end

                           ClientData.IsBusy = false
                           ClearPedTasks(player)
                        end) 

                     elseif prompt.type == "BUY" or prompt.type == "BUY_GOLD" then

                        local isPermittedToBuy = IsPermittedToBuy()

                        if isPermittedToBuy then
                           CloseNUIProperly()

                           TriggerServerEvent("tpz_housing:buySelectedProperty", prompt.type, propertyId, nil)

                           Wait(2000)

                        else
                           SendNotification(nil, Locales['REACHED_MAX_PROPERTIES'], "error")
                        end

                     end
   
                     Wait(1000)
   
                  end
               end

            end

         end

      end

      if sleep then
         
         if ClientData.DisplayingUI then
           CloseNUIProperly()
         end

         Wait(1000)
      end
       
   end

end)

-- Menu Locations
Citizen.CreateThread(function()

   RegisterMenuPrompts()

   while true do
      Wait(0)

      local player            = PlayerPedId()
      local isPlayerDead      = IsEntityDead(player)

      local sleep             = true

      if ClientData.Loaded and not ClientData.IsInMenu and not isPlayerDead  and not Builder.IsPlacing then

         local coords           = GetEntityCoords(player)

         local coordsDist       = vector3(coords.x, coords.y, coords.z)

         for propertyId, property in pairs(ClientData.Properties) do

            local requiredDistance = property.Locations.ActionDistance
            local locationType     = nil

            if property.storage and property.storage.x then

               local storageVector   = vector3(property.storage.x, property.storage.y, property.storage.z)
               local storageDistance = #(coordsDist - storageVector)

               if storageDistance <= requiredDistance then
                  locationType = "STORAGE"
               end

            end

            if property.wardrobe and property.wardrobe.x then

               local wardrobeVector   = vector3(property.wardrobe.x, property.wardrobe.y, property.wardrobe.z)
               local wardrobeDistance = #(coordsDist - wardrobeVector)

               if wardrobeDistance <= requiredDistance then
                  locationType = "WARDROBE"
               end

            end

            if property.owned == 1 and property.charidentifier == ClientData.CharIdentifier then

               local menuActionsDistance = #(coordsDist - property.Locations.MenuActions)

               if menuActionsDistance <= requiredDistance then
                  locationType = "MENU_OPEN"
               end

            end

            if locationType then
               sleep = false

               local literalString = Locales['PROPERTY_PROMPT_' .. locationType .. '_FOOTER']
               local label         = CreateVarString(10, 'LITERAL_STRING', literalString )

               PromptSetActiveGroupThisFrame(MenuPrompts, label)

               for i, prompt in pairs (MenuPromptsList) do
                     
                  PromptSetVisible(prompt.prompt, 0)

                  if prompt.type == locationType then
                     PromptSetVisible(prompt.prompt, 1)
                  end
                  
                  if PromptHasHoldModeCompleted(prompt.prompt) then

                     if prompt.type == 'MENU_OPEN' then
                        
                        OpenMenuManagement(propertyId)

                     elseif prompt.type == 'STORAGE' then

                        local nearestPlayers = GetNearestPlayers(2.5)

                        local foundPlayer = false
    
                        for _, player in pairs(nearestPlayers) do
                            if player ~= PlayerId() then
                                foundPlayer = true
                            end
                        end

                        Wait(250)

                        if not foundPlayer then

                           TriggerEvent("tpz_inventory:openInventoryContainerById", tonumber(property.containerId), Locales['PROPERTY_STORAGE_TITLE'], false)

                        else
                            TriggerEvent("tpz_core:sendRightTipNotification", Locales['SOMEONE_CLOSE'], 3000)
                        end
                    
                     elseif prompt.type == 'WARDROBE' then
                        -- todo
                     end

                     Wait(1500)

                  end

               end

            end

         end

      end

      if sleep then
         Wait(1000)
      end

   end

end)


-- Teleportation

Citizen.CreateThread(function()

   RegisterTeleportPrompts()

   while true do
      Wait(0)

      local player            = PlayerPedId()
      local isPlayerDead      = IsEntityDead(player)

      local sleep             = true

      if ClientData.Loaded and not isPlayerDead then

         local coords = GetEntityCoords(player)
  
         for propertyId, property in pairs(ClientData.Properties) do

            if property.hasTeleportationEntrance and property.owned == 1 then

               local distanceType    = nil
               local coordsDist      = vector3(coords.x, coords.y, coords.z)
              
               local primaryCoords   = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
               local secondaryCoords = vector3(property.Locations.SecondaryExit.x, property.Locations.SecondaryExit.y, property.Locations.SecondaryExit.z)
             
               local primaryDistance = #(coordsDist - primaryCoords)

               if primaryDistance <= property.Locations.ActionDistance then
                  distanceType = "PRIMARY"
               end

               local secondaryDistance = #(coordsDist - secondaryCoords)

               if secondaryDistance <= property.Locations.ActionDistance then
                  distanceType = "SECONDARY"
               end

               if distanceType then
                  sleep = false

                  local label = CreateVarString(10, 'LITERAL_STRING', Config.PromptKeys['TELEPORT'].label)
                  PromptSetActiveGroupThisFrame(TeleportPrompts, label)

                  local keystr = CreateVarString(10, 'LITERAL_STRING', Locales['PROPERTY_TELEPORT_PROMPT_FOOTER_' .. distanceType])
                  PromptSetText(TeleportPromptsList, keystr)
          
                  if PromptHasHoldModeCompleted(TeleportPromptsList) then

                     FreezeEntityPosition(PlayerPedId(), true)

                     if distanceType == "PRIMARY" then

                        if IsAllowedToEnterProperty(property) then

                           local teleportCoords = property.Locations.SecondaryExit
                           exports.tpz_core:rClientAPI().teleportToCoords(teleportCoords.x, teleportCoords.y, teleportCoords.z, teleportCoords.w)
   
                           Wait(1000)
                           FreezeEntityPosition(PlayerPedId(), false)

                        else
                           SendNotification(nil, Locales['NOT_ALLOWED_TO_ENTER'], "error")
                           FreezeEntityPosition(PlayerPedId(), false)
                           Wait(1000)
                        end
                        
                     elseif distanceType == "SECONDARY" then
                        
                        local teleportCoords = property.Locations.PrimaryEntrance

                        exports.tpz_core:rClientAPI().teleportToCoords(teleportCoords.x, teleportCoords.y, teleportCoords.z, teleportCoords.w)
                       
                        Wait(1000)
                        FreezeEntityPosition(PlayerPedId(), false)
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