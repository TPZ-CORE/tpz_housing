local TPZ = exports.tpz_core:getCoreAPI()

local PlayerData = { 
   IsInMenu = false, 
   DisplayingUI = false, 
   IsBusy = false, 
   Identifier = nil,
   CharIdentifier = 0, 
   Job = nil, 
   Properties = {}, 
   ItemsList = {}, 
   Loaded = false 
}


function GetPlayerData()
   return PlayerData
end

--[[ ------------------------------------------------
   Local Functions
]]---------------------------------------------------

local IsPermittedToBuy = function()
   
   local cb = 0

   for _, property in pairs (PlayerData.Properties) do

      if property.identifier == PlayerData.Identifier and tostring(property.charidentifier) == tostring(PlayerData.CharIdentifier) and property.owned == 1 then
         cb = cb + 1
      end

   end

   return (cb < Config.MaxHouses)

end


local HasPropertyAccess = function(property)

   if property.identifier == PlayerData.Identifier and tostring(property.charidentifier) == tostring(PlayerData.CharIdentifier) then
      return true
   end

   local found  = false
   local length = TPZ.GetTableLength(property.keyholders)

   if length > 0 then

      for _, keyholder in pairs (property.keyholders) do
         
         if keyholder.identifier == PlayerData.Identifier and tostring(keyholder.char) ==  tostring(PlayerData.CharIdentifier) then
            found = true
         end

      end

   end

   return found

end

local TeleportOutsideOnJoin = function()

   local player = PlayerPedId()
   local coords = GetEntityCoords(player)

   for propertyId, property in pairs(PlayerData.Properties) do

      local coordsDist          = vector3(coords.x, coords.y, coords.z)
      local menuActionsDistance = #(coordsDist - property.Locations.MenuActions)

      local distance            = #(coordsDist - menuActionsDistance)

      if distance <= Config.TeleportOutsideOnJoin.ClosestDistance then

         FreezeEntityPosition(player, true)

         local teleportCoords = property.Locations.PrimaryEntrance

         TPZ.TeleportToCoords(teleportCoords.x, teleportCoords.y, teleportCoords.z, teleportCoords.w)
                       
         Wait(1000)
         FreezeEntityPosition(player, false)
         
      end

   end

end

--[[ ------------------------------------------------
   Public Events
]]---------------------------------------------------

function HasPermissionByName(propertyId, permission, identifier, char)

   if PlayerData.Properties[propertyId] == nil then
      return 0
   end

   local Property = PlayerData.Properties[propertyId]

   if Property.identifier == identifier and tostring(Property.charidentifier) == tostring(char) then
      return 1
   end

   if Property.keyholders[identifier .. "_" .. char] == nil then
      return 0
   end

   local KeyholderData = Property.keyholders[identifier .. "_" .. char]

   return tonumber(KeyholderData.permissions[permission])
end

--[[ ------------------------------------------------
   Basic Events
]]---------------------------------------------------

-- Gets the properties data on character select.
AddEventHandler("tpz_core:isPlayerReady", function()
   TriggerServerEvent("tpz_housing:server:requestPlayerData")
end)


-- Gets the properties data on devmode.
if Config.DevMode then
   Citizen.CreateThread(function () TriggerServerEvent("tpz_housing:server:requestPlayerData") end)
end

-- Updates the player job and job grade in case if changes.
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
   PlayerData.Job = data.job
end)

--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterNetEvent("tpz_housing:client:updatePlayerData")
AddEventHandler("tpz_housing:client:updatePlayerData", function(data)
	PlayerData.Identifier     = data[1]
   PlayerData.CharIdentifier = data[2]
   PlayerData.Job            = data[3]
   PlayerData.Properties     = data[4]

	PlayerData.Loaded         = true

   if not Config.TeleportOutsideOnJoin.Enabled then
      return
   end

   TeleportOutsideOnJoin()

end)

RegisterNetEvent("tpz_housing:client:updateProperty")
AddEventHandler("tpz_housing:client:updateProperty", function(propertyId, actionType, data)

   -- In case a player is not connected, to not return null errors since properties
   -- have not yet loaded.
   if PlayerData.Properties[propertyId] == nil then
      return
   end

   if actionType == 'BUY' then

      PlayerData.Properties[propertyId].identifier     = data[1]
      PlayerData.Properties[propertyId].charidentifier = data[2]
      PlayerData.Properties[propertyId].owned          = 1
      PlayerData.Properties[propertyId].duration       = 0
      PlayerData.Properties[propertyId].paid           = 0

   elseif actionType == 'TRANSFERRED' then

      PlayerData.Properties[propertyId].identifier     = data[1]
      PlayerData.Properties[propertyId].charidentifier = data[2]

   elseif actionType == 'SOLD' then

      PlayerData.Properties[propertyId].identifier     = nil
      PlayerData.Properties[propertyId].charidentifier = 0

      PlayerData.Properties[propertyId].duration       = 0
      PlayerData.Properties[propertyId].paid           = 0
      PlayerData.Properties[propertyId].owned          = 0

      PlayerData.Properties[propertyId].keyholders     = nil
      PlayerData.Properties[propertyId].charidentifier = {}

      if Config.ResetPropertyLedger then
         PlayerData.Properties[propertyId].ledger = 0
      end

      RemoveBlip(PlayerData.Properties[propertyId].blip)

      PlayerData.Properties[propertyId].blip     = nil
      PlayerData.Properties[propertyId].blipType = nil

   elseif actionType == 'LOCATION' then
      
      local locationCoords = { x = data[2].x, y = data[2].y, z = data[2].z }

      if data[1] == 'MENU_WARDROBE_LOCATION' then
         PlayerData.Properties[propertyId].wardrobe = locationCoords
     
      elseif data[1] == 'MENU_STORAGE_LOCATION' then
         PlayerData.Properties[propertyId].storage = locationCoords
      end

   elseif actionType == "PAID" then

      PlayerData.Properties[propertyId].paid = tonumber(data[1])

   elseif actionType == "LEDGER" then

      PlayerData.Properties[propertyId].ledger = tonumber(data[1])

   elseif actionType == 'ADDED_KEYHOLDER' then
      PlayerData.Properties[propertyId].keyholders[data[1] .. "_" .. data[2]]          = {}
      PlayerData.Properties[propertyId].keyholders[data[1] .. "_" .. data[2]].username = data[3]

      PlayerData.Properties[propertyId].keyholders[data[1] .. "_" .. data[2]].identifier  = data[1]
      PlayerData.Properties[propertyId].keyholders[data[1] .. "_" .. data[2]].char        = data[2]

      PlayerData.Properties[propertyId].keyholders[data[1] .. "_" .. data[2]].permissions = {}

      local permissions = {
    
        ['ledger_deposit']        = 0,
        ['ledger_withdraw']       = 0,
        ['keyholders']            = 0,
        ['set_wardrobe']          = 0,
        ['set_storage']           = 0,
        ['storage_access']        = 0,
        
      } -- sell & transfer will be never permitted, only owner will be having those perms.
    
      PlayerData.Properties[propertyId].keyholders[data[1] .. "_" .. data[2]].permissions = permissions

   elseif actionType == 'UPDATE_KEYHOLDER_PERMISSION' then

      PlayerData.Properties[propertyId].keyholders[data[1] .. "_" .. data[2]].permissions[data[3]] = tonumber(data[4])
      
   elseif actionType == 'REMOVED_KEYHOLDER' then
      PlayerData.Properties[propertyId].keyholders[data[1]] = nil

      PlayerData.IsBusy = false
   end

end)

RegisterNetEvent("tpz_housing:client:setBusy")
AddEventHandler("tpz_housing:client:setBusy", function(cb)
   PlayerData.IsBusy = cb
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

      if PlayerData.Loaded and not PlayerData.IsBusy and not isPlayerDead and not isPaused and not isInCimematicMode then

         local coords = GetEntityCoords(player)
  
         for propertyId, property in pairs(PlayerData.Properties) do

            local coordsDist     = vector3(coords.x, coords.y, coords.z)
            local propertyCoords = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
            local distance       = #(coordsDist - propertyCoords)

            if Config.PropertyBlips.OnSale ~= false and property.owned == 0 and property.blip == nil then
               
               if not Config.PropertyBlips.OnSale.DisplayThroughRenderingDistance or distance <= Config.PropertyBlips.OnSale.DisplayThroughRenderingDistance then
                  CreatePropertyBlip(propertyId, "ON_SALE", propertyCoords)
               end

            end

            if Config.PropertyBlips.OnSale ~= false and Config.PropertyBlips.OnSale.DisplayThroughRenderingDistance ~= false and property.blip ~= nil and property.blipType == 'ON_SALE' then
              
               if distance > Config.PropertyBlips.OnSale.DisplayThroughRenderingDistance then
                  RemoveBlip(property.blip)

                  property.blip     = nil
                  property.blipType = nil
               end

            end

            -- display only on owner
            if property.owned == 1 then

               if property.blip and property.blipType == 'ON_SALE' then
                  RemoveBlip(property.blip)

                  property.blip     = nil
                  property.blipType = nil
               end

               if property.identifier == PlayerData.Identifier and tostring(property.charidentifier) == tostring(PlayerData.CharIdentifier) and property.blip == nil then
                  CreatePropertyBlip(propertyId, "OWNED", propertyCoords)
               end

               -- Create blip for keyholders if enabled.

               if Config.PropertyBlips.Keyholders.Enabled and property.blip == nil then

                  if HasPropertyAccess(property) and property.identifier ~= PlayerData.Identifier and tostring(property.charidentifier) ~= tostring(PlayerData.CharIdentifier) then
                     CreatePropertyBlip(propertyId, "KEYHOLDER", propertyCoords)
                  end

               end

            end

            if distance <= property.Locations.ActionDistance and property.owned == 0 then
               sleep = false

               local purchaseMethods = property.purchaseMethods
               local string = string.format(Locales['PROPERTY_PROMPT_FOOTER'], purchaseMethods.dollars.cost, purchaseMethods.gold.cost, property.tax, property.defaultStorageWeight )

               -- if only dollars are enabled to buy the property.
               if purchaseMethods.dollars.enabled and not purchaseMethods.gold.enabled then
                  string = string.format(Locales['PROPERTY_PROMPT_FOOTER_ONLY_DOLLARS'], purchaseMethods.dollars.cost, property.tax, property.defaultStorageWeight )
               end

               -- if only gold are enabled to buy the property.
               if purchaseMethods.gold.enabled and not purchaseMethods.dollars.enabled then
                  string = string.format(Locales['PROPERTY_PROMPT_FOOTER_ONLY_GOLD'], purchaseMethods.gold.cost, property.tax, property.defaultStorageWeight )
               end

               local label = CreateVarString(10, 'LITERAL_STRING', string )
               
               PromptSetActiveGroupThisFrame(Prompts, label)

               for i, prompt in pairs (PromptsList) do

                  PromptSetVisible(prompt.prompt, 0)
                  PromptSetEnabled(prompt.prompt, 0)

                  if prompt.type == "SELL" and Config.RealEstateJob.Enabled and Config.RealEstateJob.Job == PlayerData.Job then
                     PromptSetVisible(prompt.prompt, 1)
                     PromptSetEnabled(prompt.prompt, 1)
                  end
                  
                  if prompt.type == "BUY" and purchaseMethods.dollars.enabled then
                     PromptSetEnabled(prompt.prompt, 1)
                     PromptSetVisible(prompt.prompt, 1)
                  end

                  if prompt.type == "BUY_GOLD" and purchaseMethods.gold.enabled then
                     PromptSetEnabled(prompt.prompt, 1)
                     PromptSetVisible(prompt.prompt, 1)
                  end

                  if (prompt.type == "BUY" or prompt.type == "BUY_GOLD") and Config.RealEstateJob.Enabled and Config.RealEstateJob.Job ~= PlayerData.Job then
                     PromptSetEnabled(prompt.prompt, 0)
                  end
                  
                  if PromptHasHoldModeCompleted(prompt.prompt) then

                     if prompt.type == 'SELL' then
                        ClearPedTasksImmediately(player)
                        PlayerData.IsBusy = true

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

                                 PlayerData.IsBusy = false
                                 ClearPedTasks(player)
                                 return
                              end

                              for _, targetPlayer in pairs(nearestPlayers) do

                                 if inputId == GetPlayerServerId(targetPlayer) then
                                    foundPlayer = true
                                 end
                              end

                              if foundPlayer then

                                 TriggerServerEvent("tpz_housing:server:buySelectedProperty", 'BUY', propertyId, inputId)

                                 Wait(2000)
                              else
                                 SendNotification(nil, Locales['PLAYER_NOT_FOUND'], "error")
                              end

                           else

                              if cb ~= 'DECLINE' then
                                 SendNotification(nil, Locales['INVALID_INPUT'], "error")
                              end

                           end

                           PlayerData.IsBusy = false
                           ClearPedTasks(player)
                        end) 

                     elseif prompt.type == "BUY" or prompt.type == "BUY_GOLD" then

                        local isPermittedToBuy = IsPermittedToBuy()

                        if isPermittedToBuy then
                           TriggerServerEvent("tpz_housing:server:buySelectedProperty", prompt.type, propertyId, nil)

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

      if PlayerData.Loaded and not PlayerData.IsInMenu and not isPlayerDead then

         local coords           = GetEntityCoords(player)

         local coordsDist       = vector3(coords.x, coords.y, coords.z)

         for propertyId, property in pairs(PlayerData.Properties) do

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

            if property.owned == 1 then -- and property.identifier == PlayerData.Identifier and tostring(property.charidentifier) == tostring(PlayerData.CharIdentifier) then

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
                        
                        if HasPropertyAccess(property) then

                           OpenMenuManagement(propertyId)

                        else
                           SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
                        end

                     elseif prompt.type == 'STORAGE' then

                        local hasStoragePermissionAccess = HasPermissionByName(propertyId, 'storage_access',  PlayerData.Identifier, PlayerData.CharIdentifier)

                        if Config.StorageAllowPublicAccess or hasStoragePermissionAccess == 1 then

                           exports.tpz_inventory:getInventoryAPI().openInventoryContainerById(tonumber(property.containerId), Locales['PROPERTY_STORAGE_TITLE'])

                        else
                           SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
                        end
                    
                     elseif prompt.type == 'WARDROBE' then
                        TriggerEvent(Config.WardrobeEventTrigger)
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

      if PlayerData.Loaded and not isPlayerDead then

         local coords = GetEntityCoords(player)
  
         for propertyId, property in pairs(PlayerData.Properties) do

            if property.hasTeleportationEntrance then

               local distanceType    = nil
               local coordsDist      = vector3(coords.x, coords.y, coords.z)
            
               local secondaryCoords = vector3(property.Locations.SecondaryExit.x, property.Locations.SecondaryExit.y, property.Locations.SecondaryExit.z)

               -- We check if the property is owned for entrance, to make it more efficient not checking for primary coords for no reason.
               if property.owned == 1 then

                  local primaryCoords   = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
                  local primaryDistance = #(coordsDist - primaryCoords)

                  if primaryDistance <= property.Locations.ActionDistance then
                     distanceType = "PRIMARY"
                  end

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

                        if HasPropertyAccess(property) then

                           local teleportCoords = property.Locations.SecondaryExit
                           TPZ.TeleportToCoords(teleportCoords.x, teleportCoords.y, teleportCoords.z, teleportCoords.w)
   
                           Wait(1000)
                           FreezeEntityPosition(PlayerPedId(), false)

                        else
                           SendNotification(nil, Locales['NOT_ALLOWED_TO_ENTER'], "error")
                           
                           FreezeEntityPosition(PlayerPedId(), false)
                           Wait(1000)
                        end
                        
                     elseif distanceType == "SECONDARY" then
                        
                        local teleportCoords = property.Locations.PrimaryEntrance

                        TPZ.TeleportToCoords(teleportCoords.x, teleportCoords.y, teleportCoords.z, teleportCoords.w)
                       
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
