
Config = {}


Config.DevMode = false
Config.Debug   = false

Keys = { 
    ["ENTER"] = 0xC7B5340A ,["BACKSPACE"] = 0x156F7119, ["G"] = 0x760A9C6F, ["SPACEBAR"] = 0xD9D0E1C0, 
    ["A"] = 0x7065027D, ["D"] = 0xB4E465B4, ["S"] = 0xD27782E3, ["W"] = 0x8FD015D8,
    ["DOWN"] = 0x3C3DD371, ["UP"] = 0x446258B6, ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313,
    ['R'] = 0xE30CD707,
}

Config.PromptKeys     = {
    ['SELL']      = { type = "PROPERTY_BUY_ACTIONS", key = "G",         label = "Sell Property To",    hold = 1000 },
    ['BUY']       = { type = "PROPERTY_BUY_ACTIONS", key = "SPACEBAR",  label = "Buy Property",        hold = 1000 },
    ['BUY_GOLD']  = { type = "PROPERTY_BUY_ACTIONS", key = "BACKSPACE", label = "Buy Property (Gold)", hold = 1000 }, -- If you don't want gold, remove the whole line.
    
    ['MENU_OPEN'] = { type = "MENU_ACTIONS",         key = "G",         label = "Press",               hold = 750 },
    ['STORAGE']   = { type = "MENU_ACTIONS",         key = "R",         label = "Open",                hold = 750 },
    ['WARDROBE']  = { type = "MENU_ACTIONS",         key = "SPACEBAR",  label = "Checkout",            hold = 750 },

    ['TELEPORT']  = { type = "TELEPORT",             key = "ENTER",     label = "Property",            hold = 1000 },
}

--[[-------------------------------------------------------
 General
]]---------------------------------------------------------

Config.RestartHours = { "7:57" , "13:57", "19:57", "1:57"}

-- How many houses should each player have on their character?
Config.MaxHouses = 2

-- How many players should have access to a property? 
Config.MaxHouseKeyHolders = 2

-- @Config.RealEstateJob.Enabled Set to false if you don't want the properties to be sold from a job.
-- If not set to false, only the following job can sell properties to the players.

-- @ReceivePercentage the percentage real estate job will receive when selling a property.
-- Ex. If a property costs $300, and ReceivePercentage is 5%, the seller will receive $15.
Config.RealEstateJob = { Enabled = true, Job = "realestate", ReceivePercentage = 5 }

-- Set to false if you don't want the player's to upgrade their house inventory capacities.
Config.UpgradeHouses = true

-- Set it to false if you don't want the property upgrades to reset when placing the property for sale.
Config.ResetUpgrades = true

-- Set to false if you don't want the players to be able to transfer their property and only place it back for sell.
Config.PropertyTransfers = true

-- If you set it to 0, the players who sell their property, will not receive any amount back.
-- The percentage for receiving of the property total price, for example, if a property cost was
-- 500 Dollars and @Config.SellPercentage is 20, they will receive only the 20% of that cost which is (100 Dollars).

-- (!) Keep in mind, if a player received a property by donation or someone transferred, the money
-- wouldn't and should not be given to them.

-- Set to the percentage if you want them to receive the money (EX: Config.SellPercentage = 20)
Config.SellPercentage = 0

-- The distance for rendering NPC Models.
Config.RenderNPCDistance = 30

-- Set it to false if you don't want the players to be teleported outside of their property after selecting a character.
-- We provide this system in case they bug inside or other players who left inside that property to be teleported outside.
Config.TeleportOutsideOnJoin = { Enabled = true, ClosestDistance = 10.0 }

--[[-------------------------------------------------------
 Blip Settings
]]---------------------------------------------------------

-- https://alloc8or.re/rdr3/doc/enums/eBlipModifier.txt (The following URL is for Blip Color Hashes)
Config.PropertyBlips = {
    Owned  = { Sprite = -235048253, Color = 0xF91DD38D }, -- Owned properties will only be displayed for the players who own that property.
    OnSale = { Sprite = 444204045, Color = 0xA5C4F725 }, -- Set to false ( OnSale = false } if you don't want to display blips for properties which are on sale.
}

--[[-------------------------------------------------------
 Furniture Settings
]]---------------------------------------------------------

-- All furnitures, for any kind of modifications can be found on config_furnitures.lua file.
Config.Furnitures = {
    Enabled = true, -- Set to false if you don't want the player's to add any furniture on their houses.
    MaxFurniture = 30, -- The max furniture which will be allowed for each house to have.
}

--[[-------------------------------------------------------
 Repo System (Connected with TPZ-Banking) & Ledger Settings
]]---------------------------------------------------------

-- We do not use specific dates for the owners to pay taxes, we all know players would love to abuse it.
-- Instead, from the day the players bought a house, they have to pay for the tax every @PaymentDuration.
-- By default is in the 14th day.

-- (!) The Duration will be displayed on their homes when opening the menu.
-- If a tax will not be paid, this house will be lost from their ownership and put into sell.

-- Before purchasing, the system will check if they have at least (1) bank account (TPZ-Banking Support).
-- If they don't, they will not be able to purchase this property.

Config.TaxRepoSystem = {
    Enabled = true,

    UpdateDuration  = 5, -- The update time in minutes.
    PaymentDuration = 14 -- By default, every (14 days) for the repo tax payment.
}


--[[-------------------------------------------------------
 Property Locations
]]---------------------------------------------------------

-- (!) DO NOT SET THE PROPERTY NAMES AS INTEGERS (EX: [1] = {} ), Should be like ['1'] = {} Instead to become a STRING (TEXT).
Config.Properties = {

    ['property_1'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1932.972, 1949.702, 266.07, 23.494300842285), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1934.540, 1944.403, 266.10), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 250,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 25,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 30.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_1.png',
    },

    ['property_2'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-255.700, 741.5248, 117.46, 295.30194091797), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(-258.198, 735.8474, 117.48, 121.615913391), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-259.524, 738.9733, 118.18), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
        },
        
        -- (!) If @hasTeleportationEntrance is true, doors will not be functional below.
        hasTeleportationEntrance = true,

        -- (!) NOT NEED TO MODIFY IF THE HOUSE HAS ACCESS WITH TELEPORT AND NOT DOORS.
        doors = { },

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 150,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 15,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 20.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = false,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_2.png',
    },

    ['property_3'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2988.195, 2193.384, 165.74, 77.14215087890), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2990.161, 2188.243, 166.78), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 500,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 50,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_3.png',
    },

    ['property_4'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(3024.494, 1776.168, 83.179, 167.34350585938), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(3032.382, 1779.709, 84.132), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 250,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 25,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_4.png',
    },

    ['property_5'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2628.726, 1693.783, 116.53, 281.05822753906), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2626.739, 1691.679, 115.68), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 300,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 30,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_5.png',
    },

    ['property_6'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1980.718, 1195.169, 170.96, 56.607650756836), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1980.667, 1191.524, 171.40), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 300,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 30,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_6.png',
    },

    ['property_7'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1866.304, 580.5608, 113.84, 165.69606018066), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1867.114, 587.8313, 113.92), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 150,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 15,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 20.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_7.png',
    },

    ['property_8'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2542.909, 699.4825, 79.726, 9.6655235290527), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2540.678, 697.8855, 80.745), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 100,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 10,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 20.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_8.png',
    },

    ['property_9'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2717.219, 707.5354, 79.155, 200.75015258789), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2715.924, 711.2705, 79.522), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 100,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 10,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 20.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_9.png',
    },

    ['property_10'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2819.894, 278.9041, 50.963, 45.582988739014), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2825.767, 277.375, 48.097), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 250,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 25,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_10.png',
    },

    ['property_11'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2238.014, -141.476, 47.603, 318.75), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2238.590, -144.447, 47.628), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 250,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 25,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_11.png',
    },

    ['property_12'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1792.581, -83.7813, 56.757, 267.1276245117), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1782.195, -85.1265, 56.806), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 500,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 50,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_12.png',
    },

    
    ['property_13'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1626.832, -366.809, 75.875, 189.87915039063), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1619.316, -362.713, 75.897), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_13.png',
    },

    ['property_14'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1376.122, -872.619, 70.134, 291.44378662109), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1368.778, -870.906, 70.127), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 750,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 75,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_14.png',
    },

    ['property_15'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1114.282, -1305.71, 66.441, 197.2032623291), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1112.957, -1299.03, 66.405), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 500,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 50,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_15.png',
    },

    ['property_16'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1323.161, -2279.58, 50.549, 314.59680175781), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1316.033, -2276.89, 50.518), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 500,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 50,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_16.png',
    },

    ['property_17'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 1000,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 100,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_17.png',
    },

    ['property_18'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2371.519, -864.765, 43.064, 198.36711120605), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2368.999, -864.116, 43.022), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 150,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 15,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 7.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 20.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_18.png',
    },

    ['property_19'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(2069.167, -856.503, 43.345, 181.81117248535), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(2071.174, -855.104, 43.356), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 250,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 25,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_19.png',
    },

    ['property_20'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1384.784, -2085.87, 52.600, 113.59962463379), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1392.500, -2084.44, 52.565), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 100,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 10,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_20.png',
    },

    ['property_21'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(347.3879, -666.815, 42.786, 245.91331481934), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(340.2781, -667.204, 42.810), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 12.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_21.png',
    },

    ['property_22'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-64.3675, -394.268, 72.241, 300.0), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-63.6798, -392.288, 72.215), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_22.png',
    },

    ['property_23'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-818.110, 350.5407, 98.111, 172.503417968), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-813.138, 355.7528, 98.082), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 30.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_23.png',
    },

    ['property_24'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(899.7727, 265.5565, 116.03, 4.6019735336304), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(902.2537, 263.6886, 115.99), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_24.png',
    },

    ['property_25'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1117.264, 485.8627, 97.267, 230.1255035), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1120.418, 492.5742, 97.284), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 750,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 75,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_25.png',
    },
    
    ['property_26'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(1887.682, 297.5323, 76.850, 182.0860443), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(1889.801, 304.8412, 77.055), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_26.png',
    },

    ['property_27'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(779.4117, 849.1409, 118.93, 283.232391357), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(779.9094, 844.0106, 118.90), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 750,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 75,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_27.png',
    },

    
    ['property_28'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(223.4083, 990.6601, 190.92, 351.51095581), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(225.1354, 987.8232, 190.88), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 500,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 50,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 12.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_28.png',
    },

    ['property_29'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-67.4751, 1234.961, 170.80, 127.624343872), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-65.7959, 1238.299, 170.77), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 250,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 25,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 12.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_29.png',
    },
    
    ['property_30'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-616.147, -27.8058, 86.014, 115.4423), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-615.878, -23.6280, 85.971), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 500,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 50,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 35.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_30.png',
    },

    ['property_31'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-692.252, 1042.355, 135.03, 141.36312866), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-690.022, 1041.475, 135.00), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 250,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 25,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 10.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_31.png',
    },

    
    ['property_32'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-1815.23, 654.1401, 131.79, 216.274505615), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-1818.33, 661.9285, 131.87), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 30.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_32.png',
    },

    ['property_33'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-1682.74, -341.438, 173.91, 147.3078765), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-1683.90, -338.140, 173.99), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 20.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 30.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_33.png',
    },

    ['property_34'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-2459.92, 836.6832, 142.37, 182.5136871), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-2461.02, 839.9203, 146.37), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 150,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 15,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 7.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_34.png',
    },

    ['property_35'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-557.320, 2698.416, 320.25, 154.9732208252), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-554.636, 2698.816, 320.42), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_35.png',
    },

    ['property_36'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-1976.16, -1664.80, 118.03, 324.55331420), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-1977.87, -1670.06, 118.17), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_36.png',
    },

    ['property_37'] = { -- <- THE NAME FOR THE PROPERTY TO BE SAVED AND LOADED FROM PROPERTIES DATABASE (INCLUDES INVENTORY CONTAINERS). DO NOT MODIFY IT AFTER CREATING A NEW HOUSE FOR NO REASON.

        Locations = {
            PrimaryEntrance = vector4(-2373.29, -1592.63, 154.01, 239.1914978027), -- OUTSIDE LOCATION
            SecondaryExit   = vector4(0,0,0, 0), -- INSIDE PROPERTY LOCATION (ONLY FOR TELEPORTATION PROPERTIES)
           
            MenuActions     = vector3(-2374.80, -1589.28, 154.28), -- THE MENU LOCATION FOR PROPERTY ACTIONS
            ActionDistance  = 1.1,
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

        -- What the cost of this property should be for purchasing? ( Dollars )
        cost = 350,

        -- What the cost of this property should be for purchasing? ( old )
        -- Set to false if you don't want to display gold price.
        goldCost = 35,

        -- How much tax should the player be paying every X Days? (TAX Repo System)
        tax = 25,

        -- @defaultStorageWeight is loaded only once for creating and registering property container on `containers` database table.
        -- the container's name will be the same as the Config.Properties (property_1)
        defaultStorageWeight = 200, -- KG

        -- The max range for the property owners to be able to set Wardrobes, Storage and House Action locations.
        actionsRange = 15.0,

        -- The max range for the property owners to be able to place furniture.
        -- (!) Do not add crazy range furniture distance range, this option is also used for loading
        -- all the placed furnitures for rendering properly.
        furnitureRange = 25.0,

        -- If players can use lockpicking to unlock the property doors.
        -- (!) If @hasTeleportationEntrance is true, lockpicking won't be functional since it works
        -- only for door locks.
        canBreakIn = true,

        -- The house image which will be displayed when someone goes to the main entrance for checking out if its available for sell.
        backgroundImageUrl = 'property_37.png',
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

    
    ['UPGRADE'] = { 
        Enabled = false, 
        Url = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 
        Color = 10038562,
    },

}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source is always null when called from client.
-- @param messageType returns "success" or "error" depends when and where the message is sent.
function SendNotification(source, message, messageType)

    if not source then
        TriggerEvent('tpz_core:sendRightTipNotification', message, 3000)
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', source, message, 3000)
    end
  
end