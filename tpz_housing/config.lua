
Config = {}

Config.DevMode = false
Config.Debug   = false

Keys = { 
    ["ENTER"] = 0xC7B5340A ,["BACKSPACE"] = 0x156F7119, ["G"] = 0x760A9C6F, ["SPACEBAR"] = 0xD9D0E1C0, 
    ["A"] = 0x7065027D, ["D"] = 0xB4E465B4, ["S"] = 0xD27782E3, ["W"] = 0x8FD015D8,
    ["DOWN"] = 0x3C3DD371, ["UP"] = 0x446258B6, ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313,
    ['R'] = 0xE30CD707, ['ZOOM_IN'] = 0x62800C92, ['ZOOM_OUT'] = 0x8BDE7443,
}

Config.PromptKeys     = {
    ['SELL']      = { type = "PROPERTY_BUY_ACTIONS", key = "SPACEBAR",  label = "Sell Property To",    hold = 1000 },
    ['BUY']       = { type = "PROPERTY_BUY_ACTIONS", key = "G",         label = "Buy Property",        hold = 1000 },
    ['BUY_GOLD']  = { type = "PROPERTY_BUY_ACTIONS", key = "BACKSPACE", label = "Buy Property (Gold)", hold = 1000 }, -- If you don't want gold, remove the whole line.
    
    ['MENU_OPEN'] = { type = "MENU_ACTIONS",         key = "G",         label = "Press",               hold = 750 },
    ['STORAGE']   = { type = "MENU_ACTIONS",         key = "R",         label = "Open",                hold = 750 },
    ['WARDROBE']  = { type = "MENU_ACTIONS",         key = "SPACEBAR",  label = "Checkout",            hold = 750 },

    ['TELEPORT']  = { type = "TELEPORT",             key = "ENTER",     label = "Property",            hold = 1000 },
}

--[[-------------------------------------------------------
 General
]]---------------------------------------------------------

-- If your server is receiving query errors and displaying that a property does not exist when it really does
-- the option below will fix your problem, this problem is for low-pc or servers in general but can also caused
-- through oxmysql.
Config.StartQueryDelay = 1 -- Time in seconds (5-10 will fix your problem)

-- The following option is saving all the data before server restart hours
-- (2-3 Minutes atleast before server restart is mostly preferred).
Config.RestartHours = { "7:57" , "13:57", "19:57", "1:57"}

-- As default, we save all data every 15 minutes to avoid data loss in case for server crashes.
-- @Duration = Time in minutes.
Config.SaveDataRepeatingTimer = { Enabled = true, Duration = 15 }

-- How many houses should each player have on their character?
Config.MaxHouses = 3

-- How many players should have access to a property? 
Config.MaxHouseKeyHolders = 3

-- @Config.RealEstateJob.Enabled Set to false if you don't want the properties to be sold from a job.
-- If not set to false, only the following job can sell properties to the players.

-- @ReceivePercentage the percentage real estate job will receive when selling a property.
-- Ex. If a property costs $300, and ReceivePercentage is 5%, the seller will receive $15.
Config.RealEstateJob = { Enabled = false, Job = "realestate", ReceivePercentage = 5 }

-- Reset all the property ledger account money when a property has been placed for sell.
Config.ResetPropertyLedger = false


-- Set it to false if you don't want the players to be teleported outside of their property after selecting a character.
-- We provide this system in case they bug inside or other players who left inside that property to be teleported outside.
Config.TeleportOutsideOnJoin = { Enabled = true, ClosestDistance = 10.0 }

-- to open their wardrobe, change the event trigger below.
Config.WardrobeEventTrigger = "tpz_clothing:openWardrobe"

-- Set to false if you want the storage to be set as "private", only owner and the keyholders with permission access will be able to open the storage
-- and not other players (this destroys the whole point of lockpicking and robberies system).
Config.StorageAllowPublicAccess = false

-- Options in the property management menu to display / not based on your personal and server preferences.
-- (!) DO NOT MODIFY THE TYPE NAMES.
Config.ManagementMenu = {
    { Type = 'MENU_WARDROBE_LOCATION', Enabled = true }, -- set wardrobe location menu option
    { Type = 'MENU_STORAGE_LOCATION',  Enabled = true }, -- set storage location menu option
    { Type = 'MENU_LEDGER',            Enabled = true }, -- deposit or withdraw money from the ledger menu option
    { Type = 'MENU_SET_KEYHOLDERS',    Enabled = true }, -- set property keyholders (members to have access to the house) menu option
    { Type = 'MENU_TRANSFER',          Enabled = true }, -- transfer the property to another player menu option
    { Type = 'MENU_SELL',              Enabled = true }, -- sell the property menu option
}

--[[-------------------------------------------------------
 Doors
]]---------------------------------------------------------

-- The following key is locking / unlocking a door when pressing close to the door distance.
Config.DoorKey = 0xC7B5340A

-- The following rendering checks for near locked states / doors.
Config.RenderDoorStateDistance = 30

--[[-------------------------------------------------------
 Blip Settings
]]---------------------------------------------------------

-- https://alloc8or.re/rdr3/doc/enums/eBlipModifier.txt (The following URL is for Blip Color Hashes)
Config.PropertyBlips = {

    -- Owned properties will only be displayed for the players who own that property.
    Owned  = { Sprite = -235048253, Color = 0xF91DD38D },

    -- (!) Set to false ( OnSale = false } if you don't want to display blips for properties which are on sale.
    -- @DisplayPropertyId : If set to true, it will use the `PROPERTY_ON_SALE_BLIP_ID` locale to display the property id on the world map
    -- when hovering the properties who are for sale. (1.0.9 version)

    -- Set @DisplayThroughRenderingDistance = false if you want all properties on sale to be displayed on the map.
    -- (!) There is a limitation of blips on the map, it can cause crashes if there are too many.
    OnSale = { Sprite = 444204045, Color = 0xA5C4F725, DisplayPropertyId = true, DisplayThroughRenderingDistance = false },
    
    -- Set to true if you wan't to display a blip for the keyholders of owned properties.
    Keyholders = { Enabled = true, Sprite = -235048253 },-- 1.1.4

}

--[[-------------------------------------------------------
 Notifications
]]---------------------------------------------------------

-- @param source : The source always null when called from client.
-- @param type   : returns "error", "success", "info"
function SendNotification(source, message, type)
    local duration = 3000

    if not source then
        TriggerEvent('tpz_core:sendBottomTipNotification', message, duration)
    else
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, message, duration)
    end
  
end


--[[-------------------------------------------------------
 Repo System
]]---------------------------------------------------------

-- We do not use specific dates for the owners to pay taxes, we all know players would love to abuse it.
-- Instead, from the day the players bought a house, they have to pay for the tax every @PaymentDuration.

-- (!) The Duration will be displayed on the management menu.
-- If a tax will not be paid, this house will be lost from their ownership and put into sell.

-- (!) The ledger for paying the taxes, will be using ONLY dollars.
-- (!) Dollars currency will be based on @purchaseMethods.dollars of each property to get if its an item or not for deposits / withdrawals.
Config.TaxRepoSystem = {
    Enabled = true,

    UpdateDuration  = 10, -- The update time in minutes.
    PaymentDuration = 14, -- By default, every 14 days for the repo tax payment.
}

--[[-------------------------------------------------------
 Property Locations
]]---------------------------------------------------------

-- (!) DO NOT SET THE PROPERTY NAMES AS INTEGERS (EX: [1] = {} ), Should be like ['1'] = {} Instead to become a STRING (TEXT).
Config.Properties = {

    ['1'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1932.972, 1949.702, 266.07, 23.494300842285), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1934.540, 1944.403, 266.10), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1933.5963134765625, 1949.029541015625, 265.1185302734375), 
                    objYaw = -174.99990844726562,
    
                    textCoords  = vector3(1932.5963134765625, 1949.029541015625, 266.1185302734375),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 250},
            gold    = { enabled = true,  isItem = false, item = '', cost = 25},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 125 }, -- 250 / 2 = 125 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.

        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,
    },

    ['2'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-255.700, 741.5248, 117.46, 295.30194091797), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(-258.198, 735.8474, 117.48, 121.615913391), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-259.524, 738.9733, 118.18), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = true,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 150},
            gold    = { enabled = true,  isItem = false, item = '', cost = 15},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 75 }, -- 150 / 2 = 75 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,
    },

    ['3'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2988.195, 2193.384, 165.74, 77.14215087890), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2990.161, 2188.243, 166.78), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2989.107666015625, 2193.74072265625, 165.73980712890625), 
                    objYaw = -109.74124145507812,
    
                    textCoords  = vector3(2988.807666015625, 2192.74072265625, 166.73980712890625),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(2993.42431640625, 2188.4375, 165.73570251464844), 
                    objYaw = 69.9999771118164,
    
                    textCoords  = vector3(2993.76431640625, 2189.4375, 166.73570251464844),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 500},
            gold    = { enabled = true,  isItem = false, item = '', cost = 50},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 250 }, -- 500 / 2 = 250 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,
    },

    ['4'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(3024.494, 1776.168, 83.179, 167.34350585938), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(3032.382, 1779.709, 84.132), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(3024.12109375, 1777.0723876953125, 83.16913604736328), 
                    objYaw = -20.69721603393554,
    
                    textCoords  = vector3(3025.12109375, 1776.5723876953125, 84.16913604736328),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 250},
            gold    = { enabled = true,  isItem = false, item = '', cost = 25},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 125 }, -- 250 / 2 = 125 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,
    },

    ['5'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2628.726, 1693.783, 116.53, 281.05822753906), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2626.739, 1691.679, 115.68), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2628.221435546875, 1694.3289794921875, 114.66619110107422), 
                    objYaw = -101.51953887939453,
    
                    textCoords  = vector3(2628.021435546875, 1693.3289794921875, 115.66619110107422),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 300},
            gold    = { enabled = true,  isItem = false, item = '', cost = 30},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 150 }, -- 300 / 2 = 150 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,
    },

    ['6'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1980.718, 1195.169, 170.96, 56.607650756836), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1980.667, 1191.524, 171.40), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1981.965087890625, 1195.0836181640625, 170.41778564453125), 
                    objYaw = -124.84463500976562,
    
                    textCoords  = vector3(1981.469587890625, 1194.2836181640625, 171.41778564453125),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 300},
            gold    = { enabled = true,  isItem = false, item = '', cost = 30},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 150 }, -- 300 / 2 = 150 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,
    },

    ['7'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1866.304, 580.5608, 113.84, 165.69606018066), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1867.114, 587.8313, 113.92), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1867.09033203125, 581.2611083984375, 112.83411407470703), 
                    objYaw = 159.0830535888672,
    
                    textCoords  = vector3(1866.09033203125, 581.5611083984375, 113.83411407470703),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 150},
            gold    = { enabled = true,  isItem = false, item = '', cost = 15},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 75 }, -- 150 / 2 = 75 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,
    },

    ['8'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2542.909, 699.4825, 79.726, 9.6655235290527), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2540.678, 697.8855, 80.745), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2542.505859375, 698.691650390625, 79.75918579101562), 
                    objYaw = 10.1307725906372,
    
                    textCoords  = vector3(2543.605859375, 698.891650390625, 80.75918579101562),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 100},
            gold    = { enabled = true,  isItem = false, item = '', cost = 10},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 50 }, -- 100 / 2 = 50 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,
    },

    ['9'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2717.219, 707.5354, 79.155, 200.75015258789), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2715.924, 711.2705, 79.522), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2716.814208984375, 708.1665649414062, 78.60517883300781), 
                    objYaw = 0.07928969711065,
    
                    textCoords  = vector3(2716.814208984375, 708.1665649414062, 79.60517883300781),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 100},
            gold    = { enabled = true,  isItem = false, item = '', cost = 10},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 50 }, -- 100 / 2 = 50 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,
    },

    ['10'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2819.894, 278.9041, 50.963, 45.582988739014), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2825.767, 277.375, 48.097), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2820.560791015625, 278.9088134765625, 50.09118270874023), 
                    objYaw = -135.00006103515625,
    
                    textCoords  = vector3(2819.760791015625, 278.1088134765625, 51.09118270874023),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(2824.4970703125, 270.89910888671875, 47.12080764770508), 
                    objYaw = 44.99993896484375,
    
                    textCoords  = vector3(2824.4970703125, 270.89910888671875, 48.12080764770508),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 250},
            gold    = { enabled = true,  isItem = false, item = '', cost = 25},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 125 }, -- 250 / 2 = 125 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['11'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2238.014, -141.476, 47.603, 318.75), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2238.590, -144.447, 47.628), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2237.12353515625, -141.56480407714844, 46.6264419555664), 
                    objYaw = -50.00226974487305,
    
                    textCoords  = vector3(2237.82353515625, -142.26480407714844, 47.6264419555664),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(2235.559814453125, -147.0606689453125, 46.62866973876953), 
                    objYaw = 129.9977264404297,
    
                    textCoords  = vector3(2234.929814453125, -146.2606689453125, 47.62866973876953),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 250},
            gold    = { enabled = true,  isItem = false, item = '', cost = 25},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 125 }, -- 250 / 2 = 125 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

    },

    ['12'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1792.581, -83.7813, 56.757, 267.1276245117), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1782.195, -85.1265, 56.806), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1792.0633544921875, -83.22394561767578, 55.79853439331055), 
                    objYaw = -93.20934295654297,
    
                    textCoords  = vector3(1792.0633544921875, -84.22394561767578, 56.79853439331055),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


            {
                [1] = { 
                    objCoords = vector3(1785.488525390625, -93.06884765625, 55.8277359008789), 
                    objYaw = -3.47636604309082,
    
                    textCoords  = vector3(1786.488525390625, -93.16884765625, 56.8277359008789),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(1781.1064453125, -89.11561584472656, 55.81596374511719), 
                    objYaw = -93.00005340576172,
    
                    textCoords  = vector3(1781.0064453125, -90.11561584472656, 56.81596374511719),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(1781.36181640625, -82.68769836425781, 55.79853820800781), 
                    objYaw = -93.00005340576172,
    
                    textCoords  = vector3(1781.26181640625, -83.68769836425781, 56.79853820800781),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 500},
            gold    = { enabled = true,  isItem = false, item = '', cost = 50},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 250 }, -- 500 / 2 = 250 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

    },

    
    ['13'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1626.832, -366.809, 75.875, 189.87915039063), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1619.316, -362.713, 75.897), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1627.2501220703125, -366.256103515625, 74.90987396240234), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(1626.2501220703125, -366.256103515625, 75.90987396240234),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

    },

    ['14'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1376.122, -872.619, 70.134, 291.44378662109), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1368.778, -870.906, 70.127), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1376.02392578125, -873.2420654296875, 69.11506652832031), 
                    objYaw = 104.99996185302734,
    
                    textCoords  = vector3(1375.82392578125, -872.3420654296875, 70.11506652832031),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(1365.4197998046875, -872.8801879882812, 69.16214752197266), 
                    objYaw = -75.00003051757812,
    
                    textCoords  = vector3(1365.6197998046875, -873.7801879882812, 70.16214752197266),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 750},
            gold    = { enabled = true,  isItem = false, item = '', cost = 75},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 375 }, -- 750 / 2 = 375 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['15'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1114.282, -1305.71, 66.441, 197.2032623291), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1112.957, -1299.03, 66.405), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1114.6072998046875, -1305.0743408203125, 65.41828918457031), 
                    objYaw = -164.98619079589844,
    
                    textCoords  = vector3(1113.7572998046875, -1305.3743408203125, 66.41828918457031),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(1111.4659423828125, -1297.5782470703125, 65.41828918457031), 
                    objYaw = 15.00000476837158,
    
                    textCoords  = vector3(1112.5259423828125, -1297.2782470703125, 66.41828918457031),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 500},
            gold    = { enabled = true,  isItem = false, item = '', cost = 50},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 250 }, -- 500 / 2 = 250 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['16'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1323.161, -2279.58, 50.549, 314.59680175781), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1316.033, -2276.89, 50.518), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1322.4521484375, -2279.413818359375, 49.52224731445312), 
                    objYaw = -55.22403335571289,
    
                    textCoords  = vector3(1322.9921484375, -2280.313818359375, 50.52224731445312),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(1316.47705078125, -2284.93896484375, 49.52444076538086), 
                    objYaw = 124.99995422363281,
    
                    textCoords  = vector3(1315.87705078125, -2284.13896484375, 50.52444076538086),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 500},
            gold    = { enabled = true,  isItem = false, item = '', cost = 50},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 250 }, -- 500 / 2 = 250 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['17'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1890.716, -1857.69, 43.119, 54.802825927734), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1897.826, -1870.64, 43.131), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1892.202392578125, -1857.3302001953125, 42.1469841003418), 
                    objYaw = 49.99995803833008,
    
                    textCoords  = vector3(1891.502392578125, -1858.2452001953125, 43.1469841003418),
                },
    
                [2] = { 
                    objCoords = vector3(1890.6436767578125, -1859.18701171875, 42.14753723144531), 
                    objYaw = 49.9999580383300,
    
                    textCoords  = vector3(1890.6436767578125, -1859.18701171875, 42.14753723144531),
                },
            },

            {
                [1] = { 
                    objCoords = vector3(1903.3707275390625, -1857.267578125, 42.17497634887695), 
                    objYaw = 139.99986267089844,
    
                    textCoords  = vector3(1902.5707275390625, -1856.667578125, 43.17497634887695),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(1903.274169921875, -1868.918212890625, 42.14916610717773), 
                    objYaw = 49.99995803833008,
    
                    textCoords  = vector3(1903.974169921875, -1868.218212890625, 43.14916610717773),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(1892.9146728515625, -1870.743896484375, 42.15237808227539), 
                    objYaw = -39.99998474121094,
    
                    textCoords  = vector3(1893.4146728515625, -1871.243896484375, 43.15237808227539),
                },
    
                [2] = { 
                    objCoords = vector3(1893.958984375, -1871.619873046875, 42.15237808227539), 
                    objYaw = -39.99998474121094,
    
                    textCoords  = vector3(1893.958984375, -1871.619873046875, 42.15237808227539),
                },
            },

            {
                [1] = { 
                    objCoords = vector3(1889.6453857421875, -1867.8724365234375, 42.16537857055664), 
                    objYaw = -39.99998474121094,
    
                    textCoords  = vector3(1890.1453857421875, -1868.2724365234375, 43.16537857055664),
                },
    
                [2] = { 
                    objCoords = vector3(1890.689697265625, -1868.7486572265625, 42.16537857055664), 
                    objYaw = -39.99998474121094,
    
                    textCoords  = vector3(1890.689697265625, -1869.1486572265625, 42.16537857055664),
                },
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 1000},
            gold    = { enabled = true,  isItem = false, item = '', cost = 100},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 500 }, -- 1000 / 2 = 500 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,
    },

    ['18'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2371.519, -864.765, 43.064, 198.36711120605), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2368.999, -864.116, 43.022), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2370.870361328125, -864.4375, 42.04009246826172), 
                    objYaw = 19.80922698974609,
    
                    textCoords  = vector3(2371.775361328125, -864.1375, 43.04009246826172),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(2370.92919921875, -857.4860229492188, 42.04308700561523), 
                    objYaw = -160.1158447265625,
    
                    textCoords  = vector3(2369.92919921875, -857.760229492188, 43.04308700561523),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 150},
            gold    = { enabled = true,  isItem = false, item = '', cost = 15},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 75 }, -- 150 / 2 = 75 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 7.0,
    },

    ['19'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2069.167, -856.503, 43.345, 181.81117248535), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2071.174, -855.104, 43.356), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(2068.358642578125, -855.8855590820312, 42.35087966918945), 
                    objYaw = -0.22891761362552,
    
                    textCoords  = vector3(2069.058642578125, -855.8855590820312, 43.35087966918945),
                },

                [2] = { 
                    objCoords = vector3(2069.721923828125, -855.8794555664062, 42.35087966918945), 
                    objYaw = -0.43209594488143,
    
                    textCoords  = vector3(2069.721923828125, -855.8794555664062, 42.35087966918945),
                },
            },

            {
                [1] = { 
                    objCoords = vector3(2069.722900390625, -847.3145141601562, 42.35087966918945), 
                    objYaw = 179.60194396972656,
    
                    textCoords  = vector3(2069.022900390625, -847.3145141601562, 43.35087966918945),
                },

                [2] = { 
                    objCoords = vector3(2068.35986328125, -847.3214111328125, 42.35087966918945), 
                    objYaw = 179.60194396972656,
    
                    textCoords  = vector3(2068.35986328125, -847.3214111328125, 42.35087966918945),
                },
            },


            {
                [1] = { 
                    objCoords = vector3(2065.75146484375, -847.3150024414062, 42.35087966918945), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2065.05146484375, -847.3150024414062, 43.35087966918945),
                },

                [2] = { 
                    objCoords = vector3(2064.388671875, -847.3214111328125, 42.35087966918945), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2064.388671875, -847.3214111328125, 42.35087966918945),
                },
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 250},
            gold    = { enabled = true,  isItem = false, item = '', cost = 25},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 125 }, -- 250 / 2 = 125 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['20'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1384.784, -2085.87, 52.600, 113.59962463379), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1392.500, -2084.44, 52.565), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1385.0645751953125, -2085.1806640625, 51.58381652832031), 
                    objYaw = -67.79705810546875,
    
                    textCoords  = vector3(1385.4645751953125, -2086.1806640625, 52.58381652832031),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(1387.3026123046875, -2077.44091796875, 51.58108520507812), 
                    objYaw = -159.75546264648438,
    
                    textCoords  = vector3(1386.3026123046875, -2077.84091796875, 52.58108520507812),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 100},
            gold    = { enabled = true,  isItem = false, item = '', cost = 10},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 50 }, -- 100 / 2 = 50 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,
    },

    ['21'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(347.3879, -666.815, 42.786, 245.91331481934), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(340.2781, -667.204, 42.810), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(347.24737548828125, -666.053466796875, 41.82276153564453), 
                    objYaw = -120.00007629394531,
    
                    textCoords  = vector3(346.774737548828125, -666.953466796875, 42.82276153564453),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(338.2540283203125, -669.947509765625, 41.82113647460937), 
                    objYaw = -29.9360179901123,
    
                    textCoords  = vector3(339.140283203125, -670.447509765625, 42.82113647460937),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },


        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 12.0,

    },

    ['22'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-64.3675, -394.268, 72.241, 300.0), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-63.6798, -392.288, 72.215), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-64.24259948730469, -393.5611267089844, 71.24869537353516), 
                    objYaw = -60.00001907348633,
    
                    textCoords  = vector3(-63.64259948730469, -394.4611267089844, 72.24869537353516),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

    },

    ['23'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-818.110, 350.5407, 98.111, 172.503417968), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-813.138, 355.7528, 98.082), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-818.61376953125, 351.16156005859375, 97.10883331298828), 
                    objYaw = -10.15568351745605,
    
                    textCoords  = vector3(-817.61376953125, 351.00156005859375, 98.10883331298828),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(-819.1436157226562, 358.7345886230469, 97.10627746582031), 
                    objYaw = 169.7873992919922,
    
                    textCoords  = vector3(-820.1436157226562, 358.9545886230469, 98.10627746582031),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['24'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(899.7727, 265.5565, 116.03, 4.6019735336304), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(902.2537, 263.6886, 115.99), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(900.343505859375, 265.2184143066406, 115.04804992675781), 
                    objYaw = 179.99365234375,
    
                    textCoords  = vector3(899.343505859375, 265.2184143066406, 116.04804992675781),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['25'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1117.264, 485.8627, 97.267, 230.1255035), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1120.418, 492.5742, 97.284), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1116.399169921875, 485.99212646484375, 96.3062973022461), 
                    objYaw = 40.00003433227539,
    
                    textCoords  = vector3(1117.19169921875, 486.59212646484375, 97.3062973022461),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(1114.0626220703125, 493.746337890625, 96.29093933105469), 
                    objYaw = -49.99995803833008,
    
                    textCoords  = vector3(1114.6626220703125, 492.946337890625, 97.29093933105469),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 750},
            gold    = { enabled = true,  isItem = false, item = '', cost = 75},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 375 }, -- 750 / 2 = 375 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },
    
    ['26'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1887.682, 297.5323, 76.850, 182.0860443), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1889.801, 304.8412, 77.055), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1888.1700439453125, 297.95916748046875, 76.07620239257812), 
                    objYaw = -179.9995880126953,
    
                    textCoords  = vector3(1887.1700439453125, 297.95916748046875, 77.07620239257812),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(1891.083251953125, 302.62200927734375, 76.0915756225586), 
                    objYaw = -89.99917602539062,
    
                    textCoords  = vector3(1891.083251953125, 301.62200927734375, 77.0915756225586),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

    },

    ['27'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(779.4117, 849.1409, 118.93, 283.232391357), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(779.9094, 844.0106, 118.90), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(778.968994140625, 849.5256958007812, 117.91557312011719), 
                    objYaw = -72.05952453613281,
    
                    textCoords  = vector3(779.268994140625, 848.5256958007812, 118.91557312011719),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(772.6528930664062, 841.267822265625, 117.91557312011719), 
                    objYaw = 17.72804832458496,
    
                    textCoords  = vector3(773.6528930664062, 841.467822265625, 118.91557312011719),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 750},
            gold    = { enabled = true,  isItem = false, item = '', cost = 75},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 375 }, -- 750 / 2 = 375 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

    },

    
    ['28'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(223.4083, 990.6601, 190.92, 351.51095581), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(225.1354, 987.8232, 190.88), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(222.8267822265625, 990.534423828125, 189.90150451660156), 
                    objYaw = -10.21693801879882,
    
                    textCoords  = vector3(223.8267822265625, 990.434423828125, 190.90150451660156),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(215.800048828125, 988.0651245117188, 189.90150451660156), 
                    objYaw = -100.01841735839844,
    
                    textCoords  = vector3(215.600048828125, 987.0651245117188, 190.90150451660156),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 500},
            gold    = { enabled = true,  isItem = false, item = '', cost = 50},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 250 }, -- 500 / 2 = 250 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 12.0,

    },

    ['29'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-67.4751, 1234.961, 170.80, 127.624343872), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-65.7959, 1238.299, 170.77), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-67.30323791503906, 1235.837646484375, 169.76470947265625), 
                    objYaw = -59.89761352539062,
    
                    textCoords  = vector3(-66.80323791503906, 1234.837646484375, 170.76470947265625),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 250},
            gold    = { enabled = true,  isItem = false, item = '', cost = 25},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 125 }, -- 250 / 2 = 125 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 12.0,
    },
    
    ['30'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-616.147, -27.8058, 86.014, 115.4423), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-615.878, -23.6280, 85.971), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-615.939208984375, -27.08654594421386, 84.99760437011719), 
                    objYaw = -70.273193359375,
    
                    textCoords  = vector3(-615.639208984375, -28.08654594421386, 85.99760437011719),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            
            {
                [1] = { 
                    objCoords = vector3(-608.7384643554688, -26.61294746398925, 84.99763488769531), 
                    objYaw = 109.99995422363281,
    
                    textCoords  = vector3(-608.9984643554688, -25.61294746398925, 85.99763488769531),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 500},
            gold    = { enabled = true,  isItem = false, item = '', cost = 50},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 250 }, -- 500 / 2 = 250 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['31'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-692.252, 1042.355, 135.03, 141.36312866), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-690.022, 1041.475, 135.00), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-692.4359130859375, 1042.918701171875, 134.0235595703125), 
                    objYaw = -54.47789001464844,
    
                    textCoords  = vector3(-691.9359130859375, 1042.128701171875, 135.0235595703125),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 250},
            gold    = { enabled = true,  isItem = false, item = '', cost = 25},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 125 }, -- 250 / 2 = 125 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,
    },

    
    ['32'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-1815.23, 654.1401, 131.79, 216.274505615), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-1818.33, 661.9285, 131.87), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-1815.14892578125, 654.9638061523438, 130.88250732421875), 
                    objYaw = -149.3169403076172,
    
                    textCoords  = vector3(-1816.04892578125, 654.4638061523438, 131.88250732421875),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    --[[
    ['property_33'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-1682.74, -341.438, 173.91, 147.3078765), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-1683.90, -338.140, 173.99), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-1682.832763671875, -340.6101379394531, 172.985839843755), 
                    objYaw = -35.00001525878906,
    
                    textCoords  = vector3(-1682.032763671875, -341.2501379394531, 173.98583984375),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(-1678.74462890625, -336.68927001953125, 172.9930419921875), 
                    objYaw = 144.99996948242188,
    
                    textCoords  = vector3(-1679.74462890625, -336.68927001953125, 173.9930419921875),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,


        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_33.png',
    },--]]

    ['34'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-2459.92, 836.6832, 142.37, 182.5136871), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-2461.02, 839.9203, 146.37), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-2460.434814453125, 839.1107177734375, 145.3572235107422), 
                    objYaw = 0.26353466510772,
    
                    textCoords  = vector3(-2459.434814453125, 839.1107177734375, 146.3572235107422),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 150},
            gold    = { enabled = true,  isItem = false, item = '', cost = 15},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 75 }, -- 150 / 2 = 75 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 7.0,

    },

    ['35'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-557.320, 2698.416, 320.25, 154.9732208252), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-554.636, 2698.816, 320.42), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-556.4169311523438, 2698.86376953125, 319.3801574707031), 
                    objYaw = 147.21568298339844,
    
                    textCoords  = vector3(-557.4169311523438, 2699.39376953125, 320.3801574707031),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

            {
                [1] = { 
                    objCoords = vector3(-557.9639892578125, 2708.988037109375, 319.43182373046875), 
                    objYaw = -122.65821075439453,
    
                    textCoords  = vector3(-558.5639892578125, 2708.115037109375, 320.43182373046875),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

    },

    ['36'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-1976.16, -1664.80, 118.03, 324.55331420), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-1977.87, -1670.06, 118.17), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-1976.1314697265625, -1665.6568603515625, 117.19026947021484), 
                    objYaw = 145.1171417236328,
    
                    textCoords  = vector3(-1976.9314697265625, -1664.9568603515625, 118.19026947021484),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

    },

    ['37'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-2373.29, -1592.63, 154.01, 239.1914978027), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-2374.80, -1589.28, 154.28), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(-2374.364013671875, -1592.602294921875, 153.29959106445312), 
                    objYaw = 52.97750091552734,
    
                    textCoords  = vector3(-2373.764013671875, -1591.802294921875, 154.29959106445312),
                },
    
                [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 350},
            gold    = { enabled = true,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 25,

        -- What should be the maximum limit for the players to deposit on the property ledger?
        ledgerLimit = 50,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,
    },

    ['38'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1011.0451, -1759.6350, 47.6051, 179.4546), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1021.4477, -1775.3131, 47.5808), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            {
                [1] = { 
                    objCoords = vector3(1012.2030029297,-1762.0412597656,46.599708557129),  
                    objYaw = 0.26353466510772,
    
                    textCoords  = vector3(1011.1030029297,-1762.0412597656,47.599708557129),
                },
    
                [2] = { 
                    objCoords = vector3(1010.002685546875, -1762.0411376953125, 46.59970474243164),
                    objYaw = 0,
    
                    textCoords  = vector3(1010.002685546875, -1762.0411376953125, 46.59970474243164),
                },
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 6500},
            gold    = { enabled = false,  isItem = false, item = '', cost = 15},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 75 }, -- 150 / 2 = 75 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 55,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 2000, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 7.0,

    },

    ['39'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2401.4912, -1096.9491, 47.4204, 2.6667), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2393.6597, -1084.1970, 52.4369), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.2,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = false,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { 

            { --katw
                [1] = { 
                    objCoords = vector3(2400.3046875, -1095.501220703125, 46.42541885375976), 
                    objYaw = 0,
    
                    textCoords  = vector3(2401.5046875, -1095.501220703125, 47.42541885375976),
                },
    
                [2] = { 
                    objCoords = vector3(2402.5146484375,-1095.5643310546875,46.42541885375976), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2402.5146484375,-1095.5643310547,46.42541885376),
                },
            },

            { 
                [1] = { 
                    objCoords = vector3(2387.85009765625, -1083.4393310546875, 46.43347930908203), 
                    objYaw = 89.9999771118164,
    
                    textCoords  = vector3(2387.85009765625, -1082.4393310546875, 47.43347930908203),
                },
    
                [2] = false,
            },

            {
                [1] = { 
                    objCoords = vector3(2387.718505859375, -1092.5770263671875, 46.4251480102539), 
                    objYaw = -90.00000762939453,
    
                    textCoords  = vector3(2387.718505859375, -1093.1770263671875, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2387.71875, -1093.9228515625, 46.4251480102539), 
                    objYaw = -90.00000762939453,
    
                    textCoords  = vector3(2387.71875, -1093.9228515625, 46.4251480102539),
                },
            },

            {
                [1] = { 
                    objCoords = vector3(2387.718505859375, -1090.2613525390625, 46.4251480102539), 
                    objYaw = -90.00000762939453,
    
                    textCoords  = vector3(2387.718505859375, -1090.9613525390625, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2387.718505859375, -1091.6070556640625, 46.4251480102539), 
                    objYaw = -90.00000762939453,
    
                    textCoords  = vector3(2387.718505859375, -1091.6070556640625, 46.4251480102539),
                },
            },

            {
                [1] = { 
                    objCoords = vector3(2387.718505859375, -1087.9271240234375, 46.4251480102539), 
                    objYaw = -90.00000762939453,
    
                    textCoords  = vector3(2387.718505859375, -1088.5271240234375, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2387.718505859375, -1089.27294921875, 46.4251480102539), 
                    objYaw = -90.00000762939453,
    
                    textCoords  = vector3(2387.718505859375, -1089.27294921875, 46.4251480102539),
                },
            },

            {
                [1] = { 
                    objCoords = vector3(2387.718505859375, -1085.609375, 46.4251480102539), 
                    objYaw = -90.27192687988281,
    
                    textCoords  = vector3(2387.718505859375, -1086.209375, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2387.71875, -1086.954345703125, 46.4251480102539), 
                    objYaw = -89.81372833251953,
    
                    textCoords  = vector3(2387.71875, -1086.954345703125, 46.4251480102539),
                },
            },

            { -- both
                [1] = { 
                    objCoords = vector3(2397.47021484375, -1071.15966796875, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2396.87021484375, -1071.15966796875, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2396.125, -1071.1595458984375, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2396.125, -1071.1595458984375, 46.4251480102539),
                },
            },

            { --panw
                [1] = { 
                    objCoords = vector3(2399.788330078125, -1071.1597900390625, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2399.188330078125, -1071.1597900390625, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2398.443115234375, -1071.1597900390625, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2398.443115234375, -1071.1597900390625, 46.4251480102539),
                },
            },

            { -- both
                [1] = { 
                    objCoords = vector3(2402.106689453125, -1071.1597900390625, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2401.706689453125, -1071.1597900390625, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2400.760498046875, -1071.1595458984375, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2400.760498046875, -1071.1595458984375, 46.4251480102539),
                },
            },

            { -- katw
                [1] = { 
                    objCoords = vector3(2404.42529296875, -1071.15966796875, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2404.02529296875, -1071.15966796875, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2403.080078125, -1071.15966796875, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2403.080078125, -1071.15966796875, 46.4251480102539),
                },
            },

            { -- katw
                [1] = { 
                    objCoords = vector3(2406.74365234375, -1071.15966796875, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2406.04365234375, -1071.15966796875, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2405.398681640625, -1071.1597900390625, 46.4251480102539), 
                    objYaw = 179.99998474121094,
    
                    textCoords  = vector3(2405.398681640625, -1071.1597900390625, 46.4251480102539),
                },
            },

            { 
                [1] = { 
                    objCoords = vector3(2415.254638671875, -1094.43359375, 46.4251480102539), 
                    objYaw = 90.337890625,
    
                    textCoords  = vector3(2415.254638671875, -1093.83359375, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2415.2548828125, -1093.0709228515625, 46.4251480102539), 
                    objYaw = 90.30559539794922,
    
                    textCoords  = vector3(2415.2548828125, -1093.0709228515625, 46.4251480102539),
                },
            },

            { 
                [1] = { 
                    objCoords = vector3(2415.254638671875, -1091.9517822265625, 46.4251480102539), 
                    objYaw = 89.9999771118164,
    
                    textCoords  = vector3(2415.254638671875, -1091.3517822265625, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2415.254638671875, -1090.5892333984375, 46.4251480102539), 
                    objYaw = 89.9999771118164,
    
                    textCoords  = vector3(2415.254638671875, -1090.5892333984375, 46.4251480102539),
                },
            },

            { 
                [1] = { 
                    objCoords = vector3(2415.254638671875, -1089.4661865234375, 46.4251480102539), 
                    objYaw = 89.9999771118164,
    
                    textCoords  = vector3(2415.254638671875, -1088.8661865234375, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2415.25439453125, -1088.1031494140625, 46.4251480102539), 
                    objYaw = 89.9999771118164,
    
                    textCoords  = vector3(2415.25439453125, -1088.1031494140625, 46.4251480102539),
                },
            },

            { 
                [1] = { 
                    objCoords = vector3(2415.254638671875, -1086.97998046875, 46.4251480102539), 
                    objYaw = 89.8932876586914,
    
                    textCoords  = vector3(2415.254638671875, -1086.37998046875, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2415.254638671875, -1085.6182861328125, 46.4251594543457), 
                    objYaw = 90.16177368164062,
    
                    textCoords  = vector3(2415.254638671875, -1085.6182861328125, 46.4251594543457),
                },
            },

            { 
                [1] = { 
                    objCoords = vector3(2415.544921875, -1084.0823974609375, 46.4251480102539), 
                    objYaw = -0.19511154294013,
    
                    textCoords  = vector3(2416.144921875, -1084.0823974609375, 47.4251480102539),
                },
    
                [2] = { 
                    objCoords = vector3(2416.889892578125, -1084.08251953125, 46.4251480102539), 
                    objYaw = 0.11808874458074,
    
                    textCoords  = vector3(2416.889892578125, -1084.08251953125, 46.4251480102539),
                },
            },

        },

        -- @enabled : set to false if you don't want the specified account.
        -- @isItem  : set to true if the specified account money is actually an item on your server.
        -- @item    : the item name.
        -- @cost    : the quantity / amount for buying the property.
        purchaseMethods = {
            dollars = { enabled = true,  isItem = false, item = '', cost = 7000},
            gold    = { enabled = false,  isItem = false, item = '', cost = 35},
        },

        -- If the players are able to sell their property, modify the option below.
        -- (!) Accounts available: "dollars", "gold" or item.
        
        -- If the currency is an item, change the account to the "currency" you will be using, but make sure
        -- if its not dollars or gold, to create a new locale text based on the new currency, such as:
        -- MENU_SELL_DESCRIPTION_DOLLARS, MENU_SELL_DESCRIPTION_GOLD, MENU_SELL_DESCRIPTION_..
        -- SOLD_PROPERTY_RECEIVED_DOLLARS, SOLD_PROPERTY_RECEIVED_GOLD, SOLD_PROPERTY_RECEIVED_..

        sell = { account = "dollars", isItem = false, item = '', receive = 175 }, -- 350 / 2 = 175 = - 50% of default price.

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        -- The tax is always in dollars, the gold currency is ONLY for buying as an extra option.
        -- The tax will be automatically paid through the ledger (if the ledger has enough money available).
        -- (!) Dollars currency will be based on @purchaseMethods.dollars to get if its an item or not.
        tax = 60,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 300, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

    },
}

--[[-------------------------------------------------------
 Webhooks
]]---------------------------------------------------------

Config.Webhooking = {

    ['BOUGHT'] = { 
        Enabled = false, 
        Url = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 
        Color = 10038562,
    },

    ['SOLD'] = { 
        Enabled = false, 
        Url = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 
        Color = 10038562,
    },

    ['TRANSFERRED'] = { 
        Enabled = false, 
        Url = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 
        Color = 10038562,
    },

}
