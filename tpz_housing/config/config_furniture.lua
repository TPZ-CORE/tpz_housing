Furnitures = {}

Furnitures.PromptKeys  = {
    ['OPEN']  = { label = "Press", key1 = "G"},

	['BUY']   = { label = "Buy Furniture", key1 = "ENTER"},
	['ZOOM']  = { label = "ZOOM IN & ZOOM OUT CAMERA ADJUSTMENTS", key1 = "UP", key2 = "DOWN"}, -- Do not touch.
}

Furnitures.CameraHandlers = {
	MinZoom = 68.0,
	MaxZoom = 8.0,
}

--[[-------------------------------------------------------
 Furniture Store Locations
]]---------------------------------------------------------

Furnitures.Locations = {

	['Valentine'] = {

		-- The following coords is for the blip and action menu.
		Coords = {x = -358.526, y = 736.5936, z = 116.96, h = 123.14295196533},

        BlipData = {
            Enabled = true,
            Title   = "Valentine Furnitures",
            Sprite  = -1179229323,
        },

        NPCData = {
            Enabled = true,
            Model = "s_m_m_bwmworker_01",

            Coords = { x = -358.526, y = 736.5936, z = 115.96, h = 123.1429519653},
        },

		-- The camera coords will be activated once the store opens, to display the objects ( furnitures ).
		CameraCoords = { x = -359.709, y = 734.9312, z = 117.79, h = 113.02261352539 , roty = 0.0, rotz = 144.0, fov = 60.0 },
		
		-- The objects ( furnitures ) coords which will be spawned and displayed when selecting.
		ObjectPlacementCoords = { x = -363.77032470703125, y = 728.9488525390625, z = 117.06},

        ActionDistance = 1.5,
	},

	['SaintDenis'] = {

		-- The following coords is for the blip and action menu.
		Coords = {x = 2880.263, y = -1237.85, z = 45.997, h = 213.18894958 },

        BlipData = {
            Enabled = true,
            Title   = "Saint Denis Furnitures",
            Sprite  = -1179229323,
        },

        NPCData = {
            Enabled = true,
            Model = "s_m_m_cktworker_01",

            Coords = { x = 2880.263, y = -1237.85, z = 44.997, h = 213.18894958 },
        },

		-- The camera coords will be activated once the store opens, to display the objects ( furnitures ).
		CameraCoords = { x = 2880.263, y = -1237.85, z = 46.998, h = 169.17692565 , roty = 0.0, rotz = 164.0, fov = 60.0 },
		
		-- The objects ( furnitures ) coords which will be spawned and displayed when selecting.
		ObjectPlacementCoords = { x = 2877.950439453125, y = -1246.3436279296875, z = 46.55},

        ActionDistance = 1.5,
	},
}


--[[-------------------------------------------------------
 Categories & Furniture Objects
]]---------------------------------------------------------

-- (!) All object models and their hash can be found: https://rdr2.mooshe.tv
-- (!) Default Images have been taken on Blackwater Photography Store (Screenshots).

-- @hash : Model Hash (Signed)

Furnitures.Categories = {

    [1] = {

		Category = "Chairs",

		Furniture = {

			{ 
				label              = "Comfy Chair #1",
				cost               = { account = 0, cost = 1 },
				hash               = -48905921,
			},

			{ 
				label              = "Comfy Chair #2",
				cost               = { account = 0, cost = 1 },
				hash               = 579705889,
			},

			{ 
				label              = "Comfy Chair #3",
				cost               = { account = 0, cost = 1 },
				hash               = 126203870,
			},

			{ 
				label              = "Comfy Chair #4",
				cost               = { account = 0, cost = 1 },
				hash               = 70472470,
			},

			{ 
				label              = "Comfy Chair #5",
				cost               = { account = 0, cost = 1 },
				hash               = 1322876246,
			},


			{ 
				label              = "Comfy Chair #6",
				cost               = { account = 0, cost = 1 },
				hash               = -477388537,
			},

			{ 
				label              = "Comfy Chair #7",
				cost               = { account = 0, cost = 1 },
				hash               = -772253778,
			},

			{ 
				label              = "Dining Chair",
				cost               = { account = 0, cost = 1 },
				hash               = 1402789292,
			},

			{ 
				label              = "Well Made Thin Chair",
				cost               = { account = 0, cost = 1 },
				hash               = 535187220,
			},

			{ 
				label              = "Wooden Bar Chair",
				cost               = { account = 0, cost = 1 },
				hash               = 1407600554,
			},

			{ 
				label              = "Wooden Exterior Chair #1",
				cost               = { account = 0, cost = 1 },
				hash               = -1399874861,
			},

			{ 
				label              = "Wooden Exterior Chair #2",
				cost               = { account = 0, cost = 1 },
				hash               = `p_chairfolding02x`,
			},

			{ 
				label              = "Handmade Chair",
				cost               = { account = 0, cost = 1 },
				hash               = 1384285496,
			},
	
			{ 
				label              = "Old Wooden Chair",
				cost               = { account = 0, cost = 1 },
				hash               = -1025740342,
			},

			{ 
				label              = "Comfy Wooden Stool",
				cost               = { account = 0, cost = 1 },
				hash               = `p_stoolfolding01x`,
			},

			{ 
				label              = "Wooden Stool",
				cost               = { account = 0, cost = 1 },
				hash               = `p_stool02x`,
			},

			{ 
				label              = "Piano Chair",
				cost               = { account = 0, cost = 1 },
				hash               = `p_pianochair01x`,
			},

		},

    },

    [2] = {

		Category = "Tables",

		Furniture = {

			{ 
				label              = "Round Saloon Table",
				cost               = { account = 0, cost = 1 },
				hash               = 1070917324, 
			},
	
			{ 
				label              = "Wooden Long Table",
				cost               = { account = 0, cost = 1 },
				hash               = 1624513686,
			},

			{ 
				label              = "Wooden Log Table",
				cost               = { account = 0, cost = 1 },
				hash               = `p_table05x`,
			},
	
			{ 
				label              = "Wooden Table",
				cost               = { account = 0, cost = 1 },
				hash               = 85453683, 
			},

			{ 
				label              = "Dining Table",
				cost               = { account = 0, cost = 1 },
				hash               = `p_table58x`, 
			},

			{ 
				label              = "Dining Round Table",
				cost               = { account = 0, cost = 1 },
				hash               = `p_table52x`, 
			},

			{ 
				label              = "Luxury Round Table",
				cost               = { account = 0, cost = 1 },
				hash               = `p_table56x`, 
			},

			{ 
				label              = "Small Round Table",
				cost               = { account = 0, cost = 1 },
				hash               = `p_table57x`, 
			},

			
			{ 
				label              = "Small Round Luxury Table",
				cost               = { account = 0, cost = 1 },
				hash               = `p_table40x`, 
			},

			{ 
				label              = "Short Height Table",
				cost               = { account = 0, cost = 1 },
				hash               = `p_table53x`, 
			},

			{ 
				label              = "Table Work",
				cost               = { account = 0, cost = 1 },
				hash               = `p_tablework03x`, 
			},

			{ 
				label              = "Work Desk",
				cost               = { account = 0, cost = 1 },
				hash               = `p_desk08x`, 
			},

		},

    },

	[3] = {

		Category = "Couches",
		
		Furniture = {

			{ 
				label              = "Yellow Sofa",
				cost               = { account = 0, cost = 1 },
				hash               = -384569888, 
			},
	
			{ 
				label              = "Victorian Sofa",
				cost               = { account = 0, cost = 1 },
				hash               = 530637668, 
			},
	
			{ 
				label              = "Wine Red Leather Couch",
				cost               = { account = 0, cost = 1 },
				hash               = 1529403351, 
			},
			
			{ 
				label              = "Red Luxury Couch",
				cost               = { account = 0, cost = 1 },
				hash               = -521377860, 
			},
	
			{ 
				label              = "Yellow Leather Couch",
				cost               = { account = 0, cost = 1 },
				hash               = 987924370, 
			},

		},

    },
	
	[4] = {

		Category = "Beds",

		Furniture = {

			{ 
				label              = "Old Bed",
				cost               = { account = 0, cost = 1 },
				hash               = -335869017, 
			},

			{ 
				label              = "Single Luxury Bed",
				cost               = { account = 0, cost = 1 },
				hash               = 1190865994, 
			},

			{ 
				label              = "Wooden Double Fancy Bed",
				cost               = { account = 0, cost = 1 },
				hash               = 204817984, 
			},


			{ 
				label              = "Natives Bed",
				cost               = { account = 0, cost = 1 },
				hash               = -619474087, 
			},

			{ 
				label              = "Cot",
				cost               = { account = 0, cost = 1 },
				hash               = `p_cot01x`, 
			},


		},
	},

	[5] = {

		Category = "Benches",

		Furniture = {

			{ 
				label              = "Cloth Bench",
				cost               = { account = 0, cost = 1 },
				hash               = 964931263, 
			},

			{ 
				label              = "Wooden Bench",
				cost               = { account = 0, cost = 1 },
				hash               = 1057555344, 
			},

			{ 
				label              = "Wicker Bench",
				cost               = { account = 0, cost = 1 },
				hash               = 1220939063, 
			},

			{ 
				label              = "Green Seat Bench",
				cost               = { account = 0, cost = 1 },
				hash               = 1530158847, 
			},

			{ 
				label              = "Work Bench",
				cost               = { account = 0, cost = 1 },
				hash               = 61143397, 
			},

			{ 
				label              = "Log Bench #1",
				cost               = { account = 0, cost = 1 },
				hash               = 1229219138, 
			},

			{ 
				label              = "Log Bench #2",
				cost               = { account = 0, cost = 1 },
				hash               = -359794697, 
			},



		},

	},

	[6] = {

		Category = 'Dressers & Side Tables',

		Furniture = {

			{ 
				label              = "Dresser With Mirror #1",
				cost               = { account = 0, cost = 1 },
				hash               = -565436466, 
			},
			

			{ 
				label              = "Dresser With Mirror #2",
				cost               = { account = 0, cost = 1 },
				hash               = 600136167, 
			},

			{ 
				label              = "Dresser With (3) Mirrors",
				cost               = { account = 0, cost = 1 },
				hash               = 1577952271, 
			},


			{ 
				label              = "Dresser With Black Mirror",
				cost               = { account = 0, cost = 1 },
				hash               = 1043358469, 
			},

			{
				label              = "Dark Wood Dresser",
				cost               = { account = 0, cost = 1 },
				hash               = 29773816, 
			},

			{ 
				label              = "Wooden Side Table #1",
				cost               = { account = 0, cost = 1 },
				hash               = 335118833, 
			},

			{ 
				label              = "Wooden Side Table #2",
				cost               = { account = 0, cost = 1 },
				hash               = -96741014, 
			},

			{ 
				label              = "Wooden Side Table #3",
				cost               = { account = 0, cost = 1 },
				hash               = 341544623, 
			},

		},
	},

	
	[7] = {

		Category = 'Baths',

		Furniture = {

			{ 
				label              = "Luxury Bath",
				cost               = { account = 0, cost = 1 },
				hash               = `p_bath02bx`,
			},

			{ 
				label              = "Wooden Bath",
				cost               = { account = 0, cost = 1 },
				hash               = 29326204,
			},

		},
	},

	[8] = {

		Category = 'Chests',

		Furniture = {

			{ 
				label              = "Quality Lootable Chest",
				cost               = { account = 0, cost = 1 },
				hash               = -576101586, 
			},

			{ 
				label              = "Poor Wooden Lootable Chest",
				cost               = { account = 0, cost = 1 },
				hash               = 370527842, 
			},

			
			{ 
				label              = "Poor Wooden Chest",
				cost               = { account = 0, cost = 1 },
				hash               = 1048795905, 
			},

			{ 
				label              = "Crafted Darthur Chest",
				cost               = { account = 0, cost = 1 },
				hash               = 1657003541, 
			},

			
			{ 
				label              = "Storage Box Chest",
				cost               = { account = 0, cost = 1 },
				hash               = `p_storagebox01x`, 
			},

			{ 
				label              = "Log Chest",
				cost               = { account = 0, cost = 1 },
				hash               = -1215506615, 
			},

		},
	},

	[9] = {

		Category = 'Lamps, Lanterns & Candles',

		Furniture = {

			{ 
				label              = "Lantern",
				cost               = { account = 0, cost = 1 },
				hash               = 319326044, 
			},

			{ 
				label              = "Melted Candle Lamp",
				cost               = { account = 0, cost = 1 },
				hash               = `p_candlelamp01x`, 
			},

			{ 
				label              = "Candle Stick",
				cost               = { account = 0, cost = 1 },
				hash               = 526843578, 
			},

			{ 
				label              = "Melted Candle",
				cost               = { account = 0, cost = 1 },
				hash               = -1200234060, 
			},
			
			{ 
				label              = "Candle Stand",
				cost               = { account = 0, cost = 1 },
				hash               = `p_candlestand`, 
			},

			{ 
				label              = "Exterior Lamp #1",
				cost               = { account = 0, cost = 1 },
				hash               = 241043473, 
			},

			{ 
				label              = "Exterior Lamp #2",
				cost               = { account = 0, cost = 1 },
				hash               = `p_candlestand`, 
			},

			{ 
				label              = "Floor Lamp",
				cost               = { account = 0, cost = 1 },
				hash               = `p_floorlamp01x`, 
			},

		},
	},

	[10] = {

		Category = 'Fences',

		Furniture = {

			{ 
				label              = "Fence #1",
				cost               = { account = 0, cost = 1 },
				hash               = -414284023, 
			},

			{ 
				label              = "Fence #2",
				cost               = { account = 0, cost = 1 },
				hash               = `p_fence02cx`, 
			},


			{ 
				label              = "Fence #3",
				cost               = { account = 0, cost = 1 },
				hash               = 616554936, 
			},

			{ 
				label              = "Fence #4",
				cost               = { account = 0, cost = 1 },
				hash               = 539490743, 
			},

			{ 
				label              = "Fence Stick",
				cost               = { account = 0, cost = 1 },
				hash               = `p_fencestick01ax`, 
			},

		},
	},


	[11] = {

		Category = 'Decorations',

		Furniture = {

			{ 
				label              = "Piano",
				cost               = { account = 0, cost = 1 },
				hash               = `p_piano03x`, 
			},

			
			{ 
				label              = "Old Alarm Clock",
				cost               = { account = 0, cost = 1 },
				hash               = `p_alarmclock01x`, 
			},
			
			{ 
				label              = "Wall Clock",
				cost               = { account = 0, cost = 1 },
				hash               = `p_valbankclock01x`, 
			},


			{ 
				label              = "Small Wooden Cabinet",
				cost               = { account = 0, cost = 1 },
				hash               = `p_cabinet04x`, 
			},

			{ 
				label              = "Wash Tub",
				cost               = { account = 0, cost = 1 },
				hash               = 768802576,
			},

			{ 
				label              = "Water Bucket",
				cost               = { account = 0, cost = 1 },
				hash               = `p_bucket_ladle01a`,
			},

			{ 
				label              = "Ice Bucket",
				cost               = { account = 0, cost = 1 },
				hash               = `p_icebucket01x`, 
			},

			
			{ 
				label              = "Flower Pot",
				cost               = { account = 0, cost = 1 },
				hash               = `p_pot_flowerarng05x`, 
			},

			{ 
				label              = "Silver Jug",
				cost               = { account = 0, cost = 1 },
				hash               = `p_jugsilver01x`, 
			},

			
			{ 
				label              = "Clay Jug",
				cost               = { account = 0, cost = 1 },
				hash               = `p_jug01x`, 
			},

			{ 
				label              = "Boiler",
				cost               = { account = 0, cost = 1 },
				hash               = `p_boiler01x`, 
			},

						
			{ 
				label              = "Oil Can",
				cost               = { account = 0, cost = 1 },
				hash               = `p_oilcan02x`, 
			},

			{ 
				label              = "Cuptin",
				cost               = { account = 0, cost = 1 },
				hash               = `p_cuptin01x`, 
			},

			{ 
				label              = "Glass",
				cost               = { account = 0, cost = 1 },
				hash               = `p_glass01x`, 
			},

			{ 
				label              = "Cigarettes Ash Tray",
				cost               = { account = 0, cost = 1 },
				hash               = `p_ashtray01x`, 
			},

			{ 
				label              = "Dog Food Plate",
				cost               = { account = 0, cost = 1 },
				hash               = `p_platedog01x`, 
			},


			{ 
				label              = "Phonograph",
				cost               = { account = 0, cost = 1 },
				hash               = `p_phonograph01x`,
			},


			{ 
				label              = "Barrel",
				cost               = { account = 0, cost = 1 },
				hash               = `p_barrel05b`,
			},

			
			{ 
				label              = "Water Barrel",
				cost               = { account = 0, cost = 1 },
				hash               = `p_barrelhalf02x`, 
			},

			{ 
				label              = "Whiskey Barrel",
				cost               = { account = 0, cost = 1 },
				hash               = `p_whiskeybarrel01x`, 
			},
			
			{ 
				label              = "Moonshine Barrel",
				cost               = { account = 0, cost = 1 },
				hash               = `p_barrelmoonshine`, 
			},

						
			{ 
				label              = "Wheel Barrel",
				cost               = { account = 0, cost = 1 },
				hash               = `p_wheelbarrel01x`, 
			},

			{ 
				label              = "Wheel Barrow #1",
				cost               = { account = 0, cost = 1 },
				hash               = `p_wheelbarrow01x`, 
			},

			{ 
				label              = "Wheel Barrow #2",
				cost               = { account = 0, cost = 1 },
				hash               = `p_wheelbarrow02x`, 
			},

									
			{ 
				label              = "Wheel Wooden Cart",
				cost               = { account = 0, cost = 1 },
				hash               = `p_cart03x`, 
			},

			{ 
				label              = "Sack",
				cost               = { account = 0, cost = 1 },
				hash               = `p_sack_01x`, 
			},

			{ 
				label              = "Trap",
				cost               = { account = 0, cost = 1 },
				hash               = `p_trap02x`,
			},

			{ 
				label              = "Crate Box #1",
				cost               = { account = 0, cost = 1 },
				hash               = `p_crate02x`,
			},


			{ 
				label              = "Crate Box #2",
				cost               = { account = 0, cost = 1 },
				hash               = `p_crate15x`,
			},

			{ 
				label              = "Wooden Pallet",
				cost               = { account = 0, cost = 1 },
				hash               = `p_pallet02x`,
			},

			{ 
				label              = "Wood Board",
				cost               = { account = 0, cost = 1 },
				hash               = `p_woodboard01x`,
			},

			{ 
				label              = "Crate Brand Box",
				cost               = { account = 0, cost = 1 },
				hash               = `p_cratebrand01x`,
			},

			{ 
				label              = "X3 Wooden Crate Boxes",
				cost               = { account = 0, cost = 1 },
				hash               = 1461854168, 
			},

			{ 
				label              = "Guns Rack",
				cost               = { account = 0, cost = 1 },
				hash               = `p_gunrack02x`, 
			},

			{ 
				label              = "Hitching Post",
				cost               = { account = 0, cost = 1 },
				hash               = `p_hitchingpost05x`,
			},

			{ 
				label              = "Water Trough",
				cost               = { account = 0, cost = 1 },
				hash               = `p_watertrough01x`, 
			},


			{ 
				label              = "Hay Bale",
				cost               = { account = 0, cost = 1 },
				hash               = `p_haybale01x`, 
			},

			{ 
				label              = "Hay Bale Stack",
				cost               = { account = 0, cost = 1 },
				hash               = `p_haybalestack01x`, 
			},

			{ 
				label              = "Wooden Ladder",
				cost               = { account = 0, cost = 1 },
				hash               = `p_ladder01x`, 
			},


			{ 
				label              = "Bedroll Closed",
				cost               = { account = 0, cost = 1 },
				hash               = `p_bedrollclosed01x`, 
			},

			{ 
				label              = "Bedroll Open",
				cost               = { account = 0, cost = 1 },
				hash               = -206425590, 
			},

			{ 
				label              = "Tent Roll",
				cost               = { account = 0, cost = 1 },
				hash               = `s_cvan_tentroll01`,
			},

			{ 
				label              = "Open Tent Rug",
				cost               = { account = 0, cost = 1 },
				hash               = `p_ambtentrug01b`, 
			},


			{ 
				label              = "Tent",
				cost               = { account = 0, cost = 1 },
				hash               = `p_amb_tent01x`,
			},

			{ 
				label              = "Folded Blanket",
				cost               = { account = 0, cost = 1 },
				hash               = `p_foldedblanket01x`, 
			},

			{ 
				label              = "Mattress",
				cost               = { account = 0, cost = 1 },
				hash               = `p_mattress04x`, 
			},

			{ 
				label              = "Newspaper Stack",
				cost               = { account = 0, cost = 1 },
				hash               = `p_newspaperstack01x`, 
			},

			{ 
				label              = "Dirty Plates",
				cost               = { account = 0, cost = 1 },
				hash               = `p_basin_dirty_01x`, 
			},

			{ 
				label              = "Basin Water",
				cost               = { account = 0, cost = 1 },
				hash               = `p_basinwater01x`, 
			},

			
			{ 
				label              = "Washboard",
				cost               = { account = 0, cost = 1 },
				hash               = `p_washboard01x`, 
			},


			{ 
				label              = "Spittoon",
				cost               = { account = 0, cost = 1 },
				hash               = `p_spittoon03bx`, 
			},


			{ 
				label              = "Wood Logs Base",
				cost               = { account = 0, cost = 1 },
				hash               = `p_cordwood01x`, 
			},

			{ 
				label              = "Chopped Wood Piles",
				cost               = { account = 0, cost = 1 },
				hash               = `p_woodpilechopped01x`, 
			},

			{ 
				label              = "Tree Stump Log",
				cost               = { account = 0, cost = 1 },
				hash               = `p_treestump02x`, 
			},


			{ 
				label              = "Axe",
				cost               = { account = 0, cost = 1 },
				hash               = `p_axe01x`, 
			},

			
			{ 
				label              = "Clamp",
				cost               = { account = 0, cost = 1 },
				hash               = `p_clamp01x`, 
			},

			{ 
				label              = "Prybar",
				cost               = { account = 0, cost = 1 },
				hash               = `p_prybar01x`, 
			},

			{ 
				label              = "Hook Gaff",
				cost               = { account = 0, cost = 1 },
				hash               = `p_hookgaff01x`, 
			},

			{ 
				label              = "Sledge Hammer",
				cost               = { account = 0, cost = 1 },
				hash               = `p_sledgehammer01x`, 
			},

			{ 
				label              = "Hammer",
				cost               = { account = 0, cost = 1 },
				hash               = `p_hammer01x`, 
			},

			{ 
				label              = "Broom",
				cost               = { account = 0, cost = 1 },
				hash               = `p_broom03x`, 
			},

			
			{ 
				label              = "Horse Saddle",
				cost               = { account = 0, cost = 1 },
				hash               = `p_horsesaddle01x`, 
			},

			{ 
				label              = "Wine Box",
				cost               = { account = 0, cost = 1 },
				hash               = `p_winebox01x`, 
			},

			{ 
				label              = "Clothes Line",
				cost               = { account = 0, cost = 1 },
				hash               = `p_clothesline01x`, 
			},

			{ 
				label              = "Furnace",
				cost               = { account = 0, cost = 1 },
				hash               = `p_furnace01x`, 
			},

			{ 
				label              = "Campfire Combined With Pot",
				cost               = { account = 0, cost = 1 },
				hash               = 174418135, 
			},

			{ 
				label              = "Grinding Wheel",
				cost               = { account = 0, cost = 1 },
				hash               = `p_grindingwheel01x`, 
			},

			
			{ 
				label              = "Coal Bin",
				cost               = { account = 0, cost = 1 },
				hash               = `p_coalbin01x`, 
			},

			
			{ 
				label              = "Debris #1",
				cost               = { account = 0, cost = 1 },
				hash               = `p_debris03x`, 
			},

			{ 
				label              = "Debris #2",
				cost               = { account = 0, cost = 1 },
				hash               = `p_debris07x`, 
			},

			
			{ 
				label              = "Toolshed #1",
				cost               = { account = 0, cost = 1 },
				hash               = `p_toolshed01x`, 
			},

			{ 
				label              = "Toolshed #2",
				cost               = { account = 0, cost = 1 },
				hash               = `p_toolshed02x`, 
			},

			{ 
				label              = "Animal Feedbags",
				cost               = { account = 0, cost = 1 },
				hash               = `p_feedbags01x`, 
			},

			{ 
				label              = "Chicken Coop Cart",
				cost               = { account = 0, cost = 1 },
				hash               = `p_chickencoopcart01x`, 
			},

			{ 
				label              = "Christmas Tree",
				cost               = { account = 0, cost = 1 },
				hash               = `mp006_p_xmastree01x`, 
			},

			
			{ 
				label              = "Christmas Wreath",
				cost               = { account = 0, cost = 1 },
				hash               = `mp006_p_wreath01x`, 
			},


		},
	},




}