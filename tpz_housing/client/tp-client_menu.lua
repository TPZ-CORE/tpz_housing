local TPZ = exports.tpz_core:getCoreAPI()

local MenuData = {}

TriggerEvent('tpz_menu_base:getData',function(call)
    MenuData = call
end)

local LocationType    = nil
local CurrentProperty = nil

--[[ ------------------------------------------------
   Local Functions
]]---------------------------------------------------

local GetFixedString = function (string, boolean)
    
    local cb = "<font color=#8B0000>" .. string .. "</font>"

    if tonumber(boolean) == 1 then 
        cb = "<font color= rgb(46, 204, 113);>" .. string .. "</font>"
    end

    return cb
end

--[[ ------------------------------------------------
   Property Menu Actions
]]---------------------------------------------------

function OpenMenuManagement(propertyId)

    local PlayerData = GetPlayerData()

    if LocationType then
        return
    end

    MenuData.CloseAll()

    if CurrentProperty == nil then
        CurrentProperty = propertyId
    end

    PlayerData.IsInMenu = true

    local property = PlayerData.Properties[CurrentProperty]

    TaskStandStill(PlayerPedId(), -1)

    local options = {}

    for _, option in pairs (Config.ManagementMenu) do 

        if option.Enabled then

            local description = Locales[option.Type .. "_DESCRIPTION"]

            if option.Type == 'MENU_SELL' then
                description = string.format(Locales['MENU_SELL_DESCRIPTION_' .. string.upper(property.sell.account)], property.sell.receive )
            end

            table.insert(options, { label = Locales[option.Type], value = option.Type, desc = description })
        end

    end

    table.insert(options, { label = Locales['MENU_EXIT'], value = "backup", desc = ""})

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
            
            DisplayRadar(true)
            PlayerData.IsInMenu = false

            CurrentProperty = nil
            return

        elseif (data.current.value == "MENU_WARDROBE_LOCATION") then
        
            if HasPermissionByName(CurrentProperty, 'set_wardrobe',  PlayerData.Identifier, PlayerData.CharIdentifier) == 0 then
                SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
                return
            end

            MenuData.CloseAll()

            LocationType = string.upper(data.current.value)
            TaskStandStill(PlayerPedId(), 1)

        elseif (data.current.value == "MENU_STORAGE_LOCATION") then

            if HasPermissionByName(CurrentProperty, 'set_storage',  PlayerData.Identifier, PlayerData.CharIdentifier) == 0 then
                SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
                return
            end

            MenuData.CloseAll()

            LocationType = string.upper(data.current.value)
            TaskStandStill(PlayerPedId(), 1)

        elseif (data.current.value == "MENU_LEDGER") then
            
            OpenMenuLedger()

        elseif (data.current.value == "MENU_SET_KEYHOLDERS") then

            if HasPermissionByName(CurrentProperty, 'keyholders',  PlayerData.Identifier, PlayerData.CharIdentifier) == 0 then
                SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
                return
            end

            OpenMenuKeyholders()

        elseif (data.current.value == "MENU_TRANSFER") then

            if property.identifier ~= PlayerData.Identifier and tostring(property.charidentifier) ~= tostring(PlayerData.CharIdentifier) then
                SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
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

                        TriggerServerEvent("tpz_housing:server:transferOwnedProperty", CurrentProperty, inputId)

                        TaskStandStill(PlayerPedId(), 1)

                        DisplayRadar(true)
                        PlayerData.IsInMenu = false

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

        elseif (data.current.value == "MENU_SELL") then

            if property.identifier ~= PlayerData.Identifier and tostring(property.charidentifier) ~= tostring(PlayerData.CharIdentifier) then
                SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
                return
            end

            OpenMenuSellProperty()
        end

    end,

    function(data, menu)
        TaskStandStill(PlayerPedId(), 1)

        PlayerData.IsInMenu = false

        DisplayRadar(true)

        CurrentProperty = nil
        MenuData.CloseAll()
    end)

end



---------------------------------------------
-- KEYHOLDERS MENU
---------------------------------------------

function OpenMenuSellProperty()
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()

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

            TriggerServerEvent("tpz_housing:server:sell", CurrentProperty)

            TaskStandStill(PlayerPedId(), 1)
            PlayerData.IsInMenu = false

            DisplayRadar(true)

            CurrentProperty = nil
            MenuData.CloseAll()
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
                    
                    local PlayerData = GetPlayerData()
                    local property   = PlayerData.Properties[CurrentProperty]

                    if property.keyholders == nil then
                        property.keyholders = {}
                    end

                    if TPZ.GetTableLength(property.keyholders) < Config.MaxHouseKeyHolders then
  
                        TriggerServerEvent("tpz_housing:server:addPropertyKeyholder", CurrentProperty, inputId)

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

    local PlayerData = GetPlayerData()
    local property   = PlayerData.Properties[CurrentProperty]
    
    local elements   = {}

    local length = TPZ.GetTableLength(property.keyholders)

    if length > 0 then

        local count = 0 

        for _, keyholder in pairs (property.keyholders) do
            count = count + 1
            
            table.insert(elements, { 
                username   = keyholder.username, 
                label      = count .. ". " .. keyholder.username, 
                identifier = keyholder.identifier,
                char       = keyholder.char,
                username   = keyholder.username,
                value      = _, 
                desc       = string.format(Locales['MENU_KEYHOLDERS_MANAGE'], keyholder.username) 
            })

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
            menu.close()
            OpenMenuKeyholders()
        else
            menu.close()
            OpenSelectedPlayerCatalog(data.current.identifier, data.current.char, data.current.username)
            
            --if PlayerData.IsBusy then
            --    return
            --end

            --PlayerData.IsBusy = true

            --TriggerServerEvent("tpz_housing:server:removePropertyKeyholder", CurrentProperty, data.current.value, data.current.username)

            --while PlayerData.IsBusy do
            --    Wait(50)
            --end

            --OpenMenuKeyholdersList()
        end

    end,

    function(data, menu)
        OpenMenuKeyholders()
    end)

end

function OpenSelectedPlayerCatalog(identifier, char, username)

    local elements = {

        {
            label = Locales['MENU_KEYHOLDERS_PERMISSIONS_TITLE'],
            value = "permissions",
            desc = "",
        },

        {
            label = Locales['MENU_KEYHOLDERS_REMOVE_TITLE'],
            value = "remove",
            desc = "",
        },

        {
            label = Locales['MENU_BACK'],
            value = "back",
            desc = ""
        },
    }

    MenuData.Open('default', GetCurrentResourceName() .. "_user_management", 'menuapi',
    {
        title = username,
        subtext = "",
        align = "left",
        elements = elements,
        lastmenu = "MEMBERS"
    },

    function(data, menu)
        if (data.current == "backup" or data.current.value == "back") then -- go back
            menu.close()
            OpenMenuKeyholdersList()
        end

        if (data.current.value == 'permissions') then
            menu.close()
            OpenSelectedPlayerPermissions(identifier, char, username)
        end

        if (data.current.value == "remove") then
            menu.close()

            TriggerServerEvent("tpz_housing:server:removePropertyKeyholder", CurrentProperty, identifier, char, username)

            Wait(1000)
            OpenMenuKeyholders()
        end

    end,
    function(data, menu)
        OpenMenuKeyholdersList()
        menu.close()
    end)

end

function OpenSelectedPlayerPermissions(identifier, char, username)

    local elements = {

        { label = GetFixedString("ledger_deposit",        HasPermissionByName(CurrentProperty, 'ledger_deposit',  identifier, char)),  value = "ledger_deposit",  desc = "" },
        { label = GetFixedString("ledger_withdraw",       HasPermissionByName(CurrentProperty, 'ledger_withdraw', identifier, char)),  value = "ledger_withdraw", desc = "" },
        { label = GetFixedString("keyholders_management", HasPermissionByName(CurrentProperty, 'keyholders',      identifier, char)),  value = "keyholders",      desc = "" },
        { label = GetFixedString("set_wardrobe",          HasPermissionByName(CurrentProperty, 'set_wardrobe',    identifier, char)),  value = "set_wardrobe",    desc = "" },
        { label = GetFixedString("set_storage",           HasPermissionByName(CurrentProperty, 'set_storage',     identifier, char)),  value = "set_storage",     desc = "" },
        { label = GetFixedString("storage_access",        HasPermissionByName(CurrentProperty, 'storage_access',  identifier, char)),  value = "storage_access",  desc = "" },
  
        {
            label = Locales['MENU_BACK'],
            value = "back",
            desc = ""
        },
    }

    MenuData.Open('default', GetCurrentResourceName() .. "_user_perms_management", 'menuapi',
    {
        title = username,
        subtext = "",
        align = "left",
        elements = elements,
        lastmenu = "MEMBERS"
    },

    function(data, menu)

        if (data.current == "backup" or data.current.value == "back") then -- go back
            menu.close()
            OpenSelectedPlayerCatalog(identifier, char, username)

        else
            TriggerServerEvent('tpz_housing:server:onMembersPermissionUpdate', CurrentProperty, identifier, char, data.current.value)

            Wait(500)
            OpenSelectedPlayerPermissions(identifier, char, username)
        end

    end,
    function(data, menu)
        OpenSelectedPlayerCatalog(identifier, char, username)
        menu.close()
    end)

end

function OpenMenuLedger()
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local property   = PlayerData.Properties[CurrentProperty]

    local options  = {
        {
            label = Locales['MENU_LEDGER_DEPOSIT_TITLE'], 
            value = "deposit", 
            desc = Locales['MENU_LEDGER_DEPOSIT_DESCRIPTION'],
        },
     
        {
            label = Locales['MENU_LEDGER_WITHDRAW_TITLE'],
            value = "withdraw", 
            desc = Locales['MENU_LEDGER_WITHDRAW_DESCRIPTION'],
        },

        {
            label = Locales['MENU_BACK'],
            value = "backup", 
            desc = "",
        },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menu_ledger_main',

    {
        title    = string.format(Locales['MENU_PROPERTY_TITLE'], CurrentProperty),
        subtext  = string.format(Locales['MENU_LEDGER_SUB_DESCRIPTION'], property.ledger),
        align    = "left",
        elements = options,
    },

    function(data, menu)

        if (data.current.value == "backup") then
            OpenMenuManagement()

        elseif (data.current.value == "withdraw") or (data.current.value == "deposit") then
            
            if HasPermissionByName(CurrentProperty, 'ledger_' .. data.current.value,  PlayerData.Identifier, PlayerData.CharIdentifier) == 0 then
                SendNotification(nil, Locales['INSUFFICIENT_PERMISSIONS'], "error")
                return
            end

            local actionType = string.upper(data.current.value)

            local inputData = {
                title        = Locales['INPUT_' .. actionType .. '_TITLE'],
                desc         = Locales['INPUT_' .. actionType .. '_DESCRIPTION'],
                buttonparam1 = Locales['INPUT_ACCEPT_BUTTON'],
                buttonparam2 = Locales['INPUT_DECLINE_BUTTON']
            }

            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)
                                
                local numberInput = tonumber(cb)
    
                if numberInput ~= nil and numberInput ~= 0 and numberInput > 0 then

                    TriggerServerEvent("tpz_housing:server:updateAccountLedgerById", CurrentProperty, actionType, numberInput)
                    OpenMenuManagement() 
                else

                    if cb ~= "DECLINE" then 
                       SendNotification(nil, Locales['INVALID_QUANTITY'], "error")
                    end
                    
                end

            end)

        end


    end,

    function(data, menu)
        OpenMenuManagement() 
    end)

end


--[[ ------------------------------------------------
   Threads
]]---------------------------------------------------

-- Sets Property Locations (Crafting, Wardrobe, Storages)
Citizen.CreateThread(function ()
    while true do
        
        Wait(0)

        local sleep = true

        if LocationType then
    
            sleep = false

            DrawTxt(Locales['SET_' .. LocationType], 0.50, 0.85, 0.7, 0.5, true, 255, 255, 255, 255, true)

            if IsControlJustReleased(0, 0x760A9C6F) then

                local PlayerData = GetPlayerData()
                local property   = PlayerData.Properties[CurrentProperty]

                local coords   = GetEntityCoords(PlayerPedId())

                local coordsDist = vector3(coords.x, coords.y, coords.z)
                local propertyCoords = vector3(property.Locations.PrimaryEntrance.x, property.Locations.PrimaryEntrance.y, property.Locations.PrimaryEntrance.z)
                local distance = #(coordsDist - propertyCoords)

                if distance <= tonumber(property.actionsRange) then

                    local currentPlayerCoords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent("tpz_housing:server:setPropertyLocationByType", CurrentProperty, LocationType, currentPlayerCoords)

                    PlayerData.IsInMenu = false
                    LocationType        = nil
                    CurrentProperty     = nil

                    DisplayRadar(true)

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

CreateThread(function()
    while true do
        Wait(1)

        local PlayerData = GetPlayerData()

        if PlayerData.IsInMenu then

          DisableControlAction(0, 0xCC1075A7, true) -- MWUP
          DisableControlAction(0, 0xFD0F0C2C, true) -- MWDOWN

          if PlayerData.IsInMenu then
            DisplayRadar(false)
          end

        else
          Wait(1000)
        end
    end

end)