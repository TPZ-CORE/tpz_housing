MenuData = {}

TriggerEvent('tpz_menu_base:getData',function(call)
    MenuData = call
end)

--[[ ------------------------------------------------
   Store Menu Actions
]]---------------------------------------------------

local CurrentStoreLocation      = nil
local SelectedFurnitureCoords   = nil

local SelectedFurnitureMinZoom = 1.0
local SelectedFurnitureMaxZoom = 5.0

local SelectedFurnitureZoom    = 2.0

CurrentObjectEntity             = { Entity = nil, ObjectHash = nil }

local DeleteObjectEntity = function ()
    
    if CurrentObjectEntity.Entity then

        RemoveEntityProperly(CurrentObjectEntity.Entity, CurrentObjectEntity.ObjectHash )

        CurrentObjectEntity.Entity     = nil
        CurrentObjectEntity.ObjectHash = nil
    end

end

local LoadObjectEntity = function(object)

    if object ~= "backup" and CurrentObjectEntity.Entity == nil then

        LoadHashModel(tonumber(object))
        
        CurrentObjectEntity.ObjectHash = tonumber(object)

        local coords  = Furnitures.Locations[CurrentStoreLocation].ObjectPlacementCoords

        local entity = CreateObject(tonumber(object), coords.x, coords.y, coords.z, false, false, false, false, false)
        
        CurrentObjectEntity.Entity = entity

        SetEntityVisible(entity, true)
    
        SetEntityCollision(entity, true)
        FreezeEntityPosition(entity, true)
    
        Citizen.CreateThread(function ()
            
            while DoesEntityExist(entity) do
                Wait(50)
    
                SetEntityHeading(entity, GetEntityHeading(entity) + 5)
            end
    
        end)

    end

end

function OpenFurnitureStore(location)
    MenuData.CloseAll()

    ClientData.IsInMenu = true

    TriggerEvent("tpz_hud:setHiddenStatus", true)
    TaskStandStill(PlayerPedId(), -1)

    CurrentStoreLocation = location

    local elements = {}

    for _, furniture in pairs (Furnitures.Categories) do
        table.insert(elements, { label = furniture.Category, value = _, desc = ""})
    end

    table.insert(elements, { label = Locales['FURNITURES_STORE_EXIT'], value = "backup", desc = ""})

    MenuData.Open('default', GetCurrentResourceName(), 'furnitures_categories',

    {
        title    = Locales['FURNITURES_STORE_TITLE'],
        subtext  = "",
        align    = "left",
        elements = elements,
    },

    function(data, menu)

        if (data.current.value == "backup") then
            MenuData.CloseAll()

            TaskStandStill(PlayerPedId(), 1)
            ClientData.IsInMenu = false
            TriggerEvent("tpz_hud:setHiddenStatus", false)
            DestroyAllCams(true)

            DeleteObjectEntity()
        else
            OpenFurnitureStoreCategory(data.current.value, data.current.label)
        end


    end,

    function(data, menu)
        MenuData.CloseAll()

        TaskStandStill(PlayerPedId(), 1)
        ClientData.IsInMenu = false
        TriggerEvent("tpz_hud:setHiddenStatus", false)
        DestroyAllCams(true)

        DeleteObjectEntity()
            
    end)
end

function OpenFurnitureStoreCategory(category, title)

    LoadObjectEntity(Furnitures.Categories[category].Furniture[1].hash)
    ClientData.IsInMenu = true

    local elements = {}

    local count = 0
    for _, furniture in pairs (Furnitures.Categories[category].Furniture) do
        count = count + 1
        table.insert(elements, { furnitureLabel = furniture.label, label = count .. ". " .. furniture.label, value = furniture.hash, desc = string.format(Locales['FURNITURES_STORE_DESCRIPTION_' .. furniture.cost.account], furniture.cost.cost), account = furniture.cost.account, cost = furniture.cost.cost})
    end

    table.insert(elements, { label = Locales['FURNITURES_STORE_BACK'], value = "backup", desc = ""})

    MenuData.Open('default', GetCurrentResourceName(), 'furnitures_category_furniture',

    {
        title    = title,
        subtext  = "",
        align    = "left",
        elements = elements,
    },

    function(data, menu)
        
        if (data.current.value == "backup") then
            MenuData.CloseAll()

            DeleteObjectEntity()

            Wait(250)
            OpenFurnitureStore(CurrentStoreLocation)

        else

            if ClientData.IsBusy then
                SendNotification(nil, Locales['FURNITURES_BUY_DELAY_WARNING'], "error")
                return
            end

            ClientData.IsBusy = true

            TriggerServerEvent("tpz_housing:buySelectedFurniture", data.current.account, data.current.cost, data.current.value, data.current.furnitureLabel)
        end

    end,

    function(data, menu)
        menu.close()

        DeleteObjectEntity()

        Wait(250)
        OpenFurnitureStore(CurrentStoreLocation)
    end, 

    function (data, menu)

        DeleteObjectEntity()

        LoadObjectEntity(data.current.value)
    end)

end


--[[ ------------------------------------------------
   Property Menu Actions
]]---------------------------------------------------

local FurnitureEditor = { isEnabled = false, entityId = 0 }

local LocationType    = nil
local CurrentProperty = nil

function OpenMenuManagement(propertyId)

    if FurnitureEditor.isEnabled or LocationType then
        return
    end

    MenuData.CloseAll()

    if CurrentProperty == nil then
        CurrentProperty = propertyId
    end

    ClientData.IsInMenu = true

    TriggerEvent("tpz_hud:setHiddenStatus", true)

    local property = ClientData.Properties[CurrentProperty]

    TaskStandStill(PlayerPedId(), -1)

    local options  = {
        {
            label = Locales['MENU_UPGRADES'], 
            value = "upgrade", 
            desc = string.format(Locales['MENU_CURRENT_UPGRADE'], property.upgrade),
        },
     
        {
            label = Locales['MENU_FURNITURE'],
            value = "furniture", 
            desc = "",
        },

        {
            label = Locales['MENU_WARDROBE_LOCATION'],
            value = "wardrobe", 
            desc = "",
        },

        {
            label = Locales['MENU_STORAGE_LOCATION'], 
            value = "storage", 
            desc = "",
        },


        {
            label = Locales['MENU_SET_KEYHOLDERS'],
            value = 'keyholders',
            desc = "",
        },

        {
            label = Locales['MENU_TRANSFER'], 
            value = "transfer", 
            desc = "",
        },


        {
            label = Locales['MENU_SELL'], 
            value = "sell", 
            desc = string.format(Locales['MENU_SELL_DESCRIPTION'], Config.SellPercentage, property.cost),
        },


        {
            label = Locales['MENU_EXIT'], 
            value = "backup", 
            desc = "",
        },
    }


    MenuData.Open('default', GetCurrentResourceName(), 'main',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = options,
    },

    function(data, menu)
        if (data.current == "backup") then
            return
        end
        
        if (data.current.value == "backup") then
            MenuData.CloseAll()
            TaskStandStill(PlayerPedId(), 1)
            ClientData.IsInMenu = false
            TriggerEvent("tpz_hud:setHiddenStatus", false)
            CurrentProperty = nil
            return

        elseif (data.current.value == "wardrobe") or (data.current.value == "storage") then
            MenuData.CloseAll()

            LocationType = string.upper(data.current.value)
            TaskStandStill(PlayerPedId(), 1)

        elseif (data.current.value == 'upgrade') then

            if not Config.UpgradeHouses then
                SendNotification(nil, Locales['MENU_UPGRADES_NOT_ALLOWED'], 'error')
                return
            end

            OpenMenuUpgrades()

        elseif (data.current.value == "furniture") then
            
            OpenMenuFurniture()

        elseif (data.current.value == "keyholders") then
            OpenMenuKeyholders()

        elseif (data.current.value == "transfer") then

            if not Config.PropertyTransfers then
                SendNotification(nil, Locales['MENU_TRANSFER_NOT_ALLOWED'], 'error')
                return
            end

            local inputData = {
                title        = Locales['MENU_TRANSFER_TITLE'],
                desc         = Locales['MENU_TRANSFER_DESCRIPTION'],
                buttonparam1 = Locales['MENU_ACCEPT'],
                buttonparam2 = Locales['MENU_DECLINE'],
            }

            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)

                local inputId = tonumber(cb)

                if inputId ~= nil and inputId ~= 0 and inputId > 0 then

                    if inputId == GetPlayerServerId(PlayerId()) then
                        SendNotification(nil, Locales['CANNOT_TRANSFER_TO_SAME_PERSON'], "error")
                        return
                    end

                    local nearestPlayers = GetNearestPlayers(3.0)
                    local foundPlayer    = false

                    for _, targetPlayer in pairs(nearestPlayers) do

                        if inputId == GetPlayerServerId(targetPlayer) then
                           foundPlayer = true
                        end
                    end

                    if foundPlayer then

                        TriggerServerEvent("tpz_housing:transferOwnedProperty", CurrentProperty, inputId)

                        TaskStandStill(PlayerPedId(), 1)
                        ClientData.IsInMenu = false
                        TriggerEvent("tpz_hud:setHiddenStatus", false)
                        CurrentProperty = nil
                        MenuData.CloseAll()

                    else
                        SendNotification(nil, Locales['PLAYER_NOT_FOUND'], "error")
                    end

                else

                   if cb ~= 'DECLINE' then
                      SendNotification(nil, Locales['INVALID_INPUT'], "error")
                   end

                end

            end) 

        elseif (data.current.value == "sell") then
            OpenMenuSellProperty()
        end

    end,

    function(data, menu)
        TaskStandStill(PlayerPedId(), 1)
        ClientData.IsInMenu = false
        TriggerEvent("tpz_hud:setHiddenStatus", false)
        CurrentProperty = nil
        MenuData.CloseAll()
    end)

end



---------------------------------------------
-- KEYHOLDERS MENU
---------------------------------------------

function OpenMenuSellProperty()
    MenuData.CloseAll()

    local options  = {
        {
            label = Locales['MENU_SELL_ACCEPT'], 
            value = "accept", 
            desc = Locales['MENU_SELL_ACCEPT_DESCRIPTION'],
        },
     
     
        {
            label = Locales['MENU_BACK'],
            value = "backup", 
            desc = "",
        },

    }

    MenuData.Open('default', GetCurrentResourceName(), 'menu_sell',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = options,
    },

    function(data, menu)

        if (data.current.value == "backup") then
            OpenMenuManagement()

        elseif (data.current.value == "accept") then

            TriggerServerEvent("tpz_housing:sellOwnedProperty", CurrentProperty)

            TaskStandStill(PlayerPedId(), 1)
            ClientData.IsInMenu = false
            TriggerEvent("tpz_hud:setHiddenStatus", false)
            CurrentProperty = nil
            MenuData.CloseAll()
        end


    end,

    function(data, menu)
        OpenMenuManagement()
            
    end)

end

function OpenMenuUpgrades()
    MenuData.CloseAll()

    local property = ClientData.Properties[CurrentProperty]

    local elements = {}

    if property.upgrade < #Upgrades then

        local nextUpgrade  = Upgrades[property.upgrade + 1]
        local materials    = ""

        if nextUpgrade.HasMaterials then
            local count = 0

            for item, quantity in pairs (nextUpgrade.Materials) do
                count = count + 1

                local itemLabel = "unknown"

                if ClientData.ItemsList[item] then
                    itemLabel = ClientData.ItemsList[item].label
                end

                materials = materials .. "X" .. quantity .. " " .. itemLabel .. ", "
    
                if count == 4 or count == 8 then
                    materials = materials .. "</br>"
                end
    
            end

            table.insert(elements, { label = string.format(Locales['MENU_UPGRADES_UPGRADE_LABEL'], property.upgrade + 1), value = property.upgrade + 1, desc = string.format(Locales['MENU_UPGRADES_UPGRADE_EXTRA_STORAGE'], nextUpgrade.ExtraStorageWeight, nextUpgrade.Cost, materials)})

        else
            table.insert(elements, { label = string.format(Locales['MENU_UPGRADES_UPGRADE_LABEL'], property.upgrade + 1), value = property.upgrade + 1, desc = string.format(Locales['MENU_UPGRADES_UPGRADE_EXTRA_STORAGE_COST'], nextUpgrade.ExtraStorageWeight, nextUpgrade.Cost)})
        end
        
    end
    
    table.insert(elements, { label = Locales['MENU_BACK'], value = "backup", desc = ""})

    MenuData.Open('default', GetCurrentResourceName(), 'menu_keyholders_main',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = elements,
    },

    function(data, menu)

        if (data.current.value == "backup") then
            OpenMenuManagement()

        else

            if ClientData.IsBusy then
                return
            end

            ClientData.IsBusy = true
                        
            TriggerServerEvent("tpz_housing:upgradeOwnedProperty", CurrentProperty, ( property.upgrade + 1) )

            while ClientData.IsBusy do
                Wait(50)
            end

            OpenMenuUpgrades()

        end

    end,

    function(data, menu)
        OpenMenuManagement()
            
    end)

end

function OpenMenuKeyholders() 
    MenuData.CloseAll()

    local options  = {
        {
            label = Locales['MENU_KEYHOLDERS_LIST'], 
            value = "list", 
            desc = "",
        },
     
        {
            label = Locales['MENU_KEYHOLDERS_ADD_NEW'], 
            value = "add", 
            desc = "",
        },
     
        {
            label = Locales['MENU_BACK'],
            value = "backup", 
            desc = "",
        },

    }

    MenuData.Open('default', GetCurrentResourceName(), 'menu_keyholders_main',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = options,
    },

    function(data, menu)

        if (data.current.value == "backup") then
            OpenMenuManagement()

        elseif (data.current.value == "list") then
            OpenMenuKeyholdersList()

        elseif (data.current.value == "add") then

            local inputData = {
                title        = Locales['MENU_KEYHOLDERS_ADD_NEW_TITLE'],
                desc         = Locales['MENU_KEYHOLDERS_ADD_NEW_DESCRIPTION'],
                buttonparam1 = Locales['MENU_ACCEPT'],
                buttonparam2 = Locales['MENU_DECLINE'],
            }

            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)

                local inputId = tonumber(cb)

                if inputId ~= nil and inputId ~= 0 and inputId > 0 then

                    if inputId == GetPlayerServerId(PlayerId()) then
                        SendNotification(nil, Locales['MENU_KEYHOLDERS_ADD_NEW_TO_SELF'], "error")
                        return
                    end

                    local property = ClientData.Properties[CurrentProperty]
                    local length   = GetTableLength(property.keyholders)

                    if length == 0 or length < Config.MaxHouseKeyHolders then
  
                        TriggerServerEvent("tpz_housing:addPropertyKeyholder", CurrentProperty, inputId)

                    else
                        SendNotification(nil, Locales['MENU_KEYHOLDERS_REACHED_MAX'], "error")
                    end
                else

                   if cb ~= 'DECLINE' then
                      SendNotification(nil, Locales['INVALID_INPUT'], "error")
                   end

                end

            end) 

        end


    end,

    function(data, menu)
        OpenMenuManagement()
            
    end)


end

function OpenMenuKeyholdersList()
    MenuData.CloseAll()

    local property = ClientData.Properties[CurrentProperty]
    
    local elements = {}

    local length = GetTableLength(property.keyholders)

    if length > 0 then

        local count = 0 

        for _, keyholder in pairs (property.keyholders) do
            count = count + 1
            table.insert(elements, { username = keyholder.username, label = count .. ". " .. keyholder.username, value = _, desc = string.format(Locales['MENU_KEYHOLDERS_REMOVE'], keyholder.username) })
        end

    end

    table.insert(elements, { label = Locales['MENU_BACK'], value = "backup", desc = ""})

    MenuData.Open('default', GetCurrentResourceName(), 'menu_keyholders_list',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = elements,
    },

    function(data, menu)
            
        if (data.current.value == "backup") then
            OpenMenuKeyholders()

        else
            if ClientData.IsBusy then
                return
            end

            ClientData.IsBusy = true

            TriggerServerEvent("tpz_housing:removePropertyKeyholder", CurrentProperty, data.current.value, data.current.username)

            while ClientData.IsBusy do
                Wait(50)
            end

            OpenMenuKeyholdersList()
        end

    end,

    function(data, menu)
        OpenMenuKeyholders()
    end)

end

---------------------------------------------
-- FURNITURES MENU
---------------------------------------------

function OpenMenuFurniture()
    MenuData.CloseAll()

    local options  = {
        {
            label = Locales['MENU_FURNITURE_AVAILABLE'], 
            value = "personal", 
            desc = "",
        },
     
        {
            label = Locales['MENU_FURNITURE_USED'],
            value = "property", 
            desc = "",
        },

        {
            label = Locales['MENU_BACK'],
            value = "backup", 
            desc = "",
        },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menu_furnitures_main',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = options,
    },

    function(data, menu)

        if (data.current.value == "backup") then
            OpenMenuManagement()

        elseif (data.current.value == "personal") then
            OpenMenuAvailableFurniture()

        elseif (data.current.value == "property") then
            OpenMenuPropertyFurniture()
        end


    end,

    function(data, menu)
        OpenMenuManagement() 
    end)


end

function OpenMenuAvailableFurniture() 
    MenuData.CloseAll()

    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_housing:getPlayerFurniture", function(cb)

        local elements = {}

        if cb then

            local length = GetTableLength(cb)

            if length > 0 then

                local count = 0 
                for _, furniture in pairs (cb) do
                    count = count + 1
                    table.insert(elements, { furnitureLabel = furniture.label, label = count .. ". " .. furniture.label, value = _, desc = string.format(Locales['MENU_FURNITURE_QUANTITY'], furniture.quantity) })
                end

            end
        end
    
        table.insert(elements, { label = Locales['MENU_BACK'], value = "backup", desc = ""})

        MenuData.Open('default', GetCurrentResourceName(), 'menu_furnitures_personal',

        {
            title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
            subtext  = "",
            align    = "left",
            elements = elements,
        },
    
        function(data, menu)
            
            if (data.current.value == "backup") then
                OpenMenuFurniture()
    
            else

                local property = ClientData.Properties[CurrentProperty]
                local length   = GetTableLength(property.furniture)

                if length >= Config.Furnitures.MaxFurniture then
                    SendNotification(nil, Locales['FURNITURES_MAX_LIMIT'], "error")
                    return
                end

                StartSelectedFurniturePlacement(CurrentProperty, data.current.value, data.current.furnitureLabel)

                TaskStandStill(PlayerPedId(), 1)
                ClientData.IsInMenu = false
                TriggerEvent("tpz_hud:setHiddenStatus", false)
                MenuData.CloseAll()
            end
    
        end,
    
        function(data, menu)

            OpenMenuFurniture()
        end)

    end)

end

function OpenMenuPropertyFurniture() 
    MenuData.CloseAll()

    local property = ClientData.Properties[CurrentProperty]

    local loadedRenderCamera = false
    SelectedFurnitureCoords  = nil

    local elements = {}

    local length = GetTableLength(property.furniture)

    if length > 0 then

        local count = 0 

        for _, furniture in pairs (property.furniture) do
            count = count + 1
            table.insert(elements, { entity = furniture.loadedObject, coords = furniture.coords, furnitureLabel = furniture.label, label = count .. ". " .. furniture.label, value = _, desc = string.format(Locales['MENU_FURNITURE_LOCATED'], Round(furniture.coords.x, 3), Round(furniture.coords.y, 3), Round(furniture.coords.z, 3)) })
        end

    end

    table.insert(elements, { label = Locales['MENU_BACK'], value = "backup", desc = ""})

    MenuData.Open('default', GetCurrentResourceName(), 'menu_furnitures_property',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = elements,
    },

    function(data, menu)
        
        if (data.current.value == "backup") then
            OpenMenuFurniture()

        else

            DoScreenFadeOut(450)

            if not loadedRenderCamera then
                local coords = GetEntityCoords(PlayerPedId())
                StartCam(coords.x, coords.y, coords.z , -85.0, 0.0,0.0, 70.0)

                loadedRenderCamera = true
            end

            Wait(450)
            SelectedFurnitureZoom = 2.0

            StartCam(data.current.coords.x, data.current.coords.y, data.current.coords.z + SelectedFurnitureZoom, -90.0, 0.0,
            135.0, 70.0)

            MenuData.CloseAll()
            
            OpenMenuPropertyFurnitureOption(data.current.value, data.current.furnitureLabel)

            SelectedFurnitureCoords = data.current.coords

            DoScreenFadeIn(450)

        
        end

    end,

    function(data, menu)
        OpenMenuFurniture()
    end)

end

function OpenMenuPropertyFurnitureOption(furnitureId, furnitureLabel) 
    MenuData.CloseAll()

    local options  = {

        {
            label = string.format(Locales['MENU_FURNITURE_DELETE_FROM_PROPERTY'], furnitureLabel), 
            value = "delete", 
            desc = "",
        },

        
        {
            label = Locales['MENU_BACK'],
            value = "backup", 
            desc = "",
        },

    }

    MenuData.Open('default', GetCurrentResourceName(), 'menu_furnitures_property_furniture',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = "",
        align    = "left",
        elements = options,
    },

    function(data, menu)
        
        if (data.current.value == "backup") then
            DestroyAllCams(true)
            OpenMenuPropertyFurniture()
        else

            if ClientData.IsBusy then
                return
            end

            ClientData.IsBusy = true

            TriggerServerEvent("tpz_housing:removeFurnitureFromProperty", CurrentProperty, furnitureId, furnitureLabel)

            while ClientData.IsBusy do
                Wait(50)
            end

            DestroyAllCams(true)
            OpenMenuPropertyFurniture()

        end

    end,

    function(data, menu)

        DestroyAllCams(true)
        OpenMenuPropertyFurniture()
    end)

end

--[[ ------------------------------------------------
   Threads
]]---------------------------------------------------

-- Displays the property furnitures and a prompt for Zooming In & Out controls of that object.
Citizen.CreateThread(function ()
    while true do
        Wait(0)

        if SelectedFurnitureCoords then

            local label = CreateVarString(10, 'LITERAL_STRING', Locales['FURNITURE_PROMPT_FOOTER'] )
            PromptSetActiveGroupThisFrame(FurniturePrompts, label)

            for i, prompt in pairs (FurniturePromptsList) do

                PromptSetVisible(prompt.prompt, 0)

                if prompt.type == 'ZOOM' then
                    PromptSetVisible(prompt.prompt, 1)  
                end

                if IsControlPressed(2, Keys[Furnitures.PromptKeys['ZOOM'].key2])  then -- zoom out

                    
                    SelectedFurnitureZoom = SelectedFurnitureZoom + 0.2

                    if SelectedFurnitureZoom >= SelectedFurnitureMaxZoom then
                        SelectedFurnitureZoom = SelectedFurnitureMaxZoom
                    end

                    StartCam(SelectedFurnitureCoords.x, SelectedFurnitureCoords.y, SelectedFurnitureCoords.z + SelectedFurnitureZoom, -90.0, 0.0,
                    135.0, 70.0)
            

                    Wait(50)
                end
    
                if IsControlPressed(2, Keys[Furnitures.PromptKeys['ZOOM'].key1]) then -- zoom in


                    SelectedFurnitureZoom = SelectedFurnitureZoom - 0.2

                    if SelectedFurnitureZoom <= SelectedFurnitureMinZoom then
                        SelectedFurnitureZoom = SelectedFurnitureMinZoom
                    end

                    StartCam(SelectedFurnitureCoords.x, SelectedFurnitureCoords.y, SelectedFurnitureCoords.z + SelectedFurnitureZoom, -90.0, 0.0,
                    135.0, 70.0)

                    Wait(50)

                end

            end
    
        else
            Wait(1000)
        end
    end

end)


-- Sets Property Locations (Crafting, Wardrobe, Storages)
Citizen.CreateThread(function ()
    while true do
        
        Wait(0)

        local sleep = true

        if LocationType then
    
            sleep = false

            DrawTxt(Locales['SET_' .. LocationType], 0.50, 0.85, 0.7, 0.5, true, 255, 255, 255, 255, true)

            if IsControlJustReleased(0, 0x760A9C6F) then

                local property = ClientData.Properties[CurrentProperty]

                local coords   = GetEntityCoords(PlayerPedId())

                local coordsDist = vector3(coords.x, coords.y, coords.z)
                local propertyCoords = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
                local distance = #(coordsDist - propertyCoords)

                if distance <= tonumber(property.actionsRange) then

                    local currentPlayerCoords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent("tpz_housing:setPropertyLocationByType", CurrentProperty, LocationType, currentPlayerCoords)

                    ClientData.IsInMenu = false
                    LocationType        = nil
                    CurrentProperty     = nil

                    SendNotification(nil, Locales['LOCATION_SET'], "success")

                else
                    SendNotification(nil, Locales['TOO_FAR'], "error")
                end
            end

        end

        if sleep then
            Wait(1000)
        end
    end
end)