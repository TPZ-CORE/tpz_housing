Upgrades = { }

-- @ExtraStorageWeight is adding the extra weight to your house inventory container.
-- that means, if your house has 40 KG by default, and you have the Upgrade #5, your house inventory
-- capacity will be 50 KG since Upgrade #5, gives +10 weight.
Upgrades = { 

    [1] = {	   

        HasMaterials = true,

        Materials = { ['wooden_nails'] = 5, ['wood'] = 10 },

        Cost = 50,

		ExtraStorageWeight = 10,
    },

    [2] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 10, ['wood'] = 20 },

        Cost = 50,

		ExtraStorageWeight = 20,
    },

    [3] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 15, ['wood'] = 25 },

        Cost = 50,
        
		ExtraStorageWeight = 30,
    },

    [4] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 15, ['wood'] = 15, ['rock'] = 20 },

        Cost = 50,

		ExtraStorageWeight = 40,
    },

    [5] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 25, ['wood'] = 25, ['fibers'] = 10, ['oilunrefined'] = 10},

        Cost = 50,

		ExtraStorageWeight = 50,
    },
    [6] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 25, ['wood'] = 25, ['fibers'] = 25, ['oilunrefined'] = 10},

        Cost = 50,

		ExtraStorageWeight = 60,
    },

    [7] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 25, ['wood'] = 25, ['ironbar'] = 10, ['oilunrefined'] = 10},

        Cost = 50,

		ExtraStorageWeight = 70,
    },
    [8] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 35, ['wood'] = 25, ['ironbar'] = 10, ['oilunrefined'] = 10},

        Cost = 50,

		ExtraStorageWeight = 80,
    },
    [9] = {	   

        HasMaterials = false,

        Materials = { ['wooden_nails'] = 25, ['wood'] = 25, ['ironbar'] = 10, ['oilunrefined'] = 15, ['fibers'] = 30},

        Cost = 50,

		ExtraStorageWeight = 90,
    },
    [10] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 35, ['wood'] = 25, ['ironbar'] = 20, ['oilunrefined'] = 20, ['fibers'] = 40},

        Cost = 50,

		ExtraStorageWeight = 100,  
    },
    [11] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 30, ['rock'] = 10, ['metal'] = 5, ['copper'] = 15 },

        Cost = 50,

		ExtraStorageWeight = 110,  
    },
    [12] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 40, ['rock'] = 15, ['metal'] = 5, ['copper'] = 20 },

        Cost = 50,

		ExtraStorageWeight = 120,  
    },
    [13] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 40, ['rock'] = 20, ['metal'] = 10, ['copper'] = 30 },

        Cost = 50,

		ExtraStorageWeight = 130,  
    },
    [14] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 40, ['rock'] = 20, ['metal'] = 5, ['copper'] = 20, ['steel'] = 5 },

        Cost = 50,

		ExtraStorageWeight = 140,  
    },
    [15] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 40, ['rock'] = 20, ['metal'] = 10, ['copper'] = 30, ['steel'] = 10 },

        Cost = 50,

		ExtraStorageWeight = 150,  
    },
    [16] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 40, ['rock'] = 20, ['metal'] = 15, ['copper'] = 30, ['steel'] = 15 },

        Cost = 50,

		ExtraStorageWeight = 160,  
    },
    [17] = {	   

        HasMaterials = false,
        
        Materials = { ['nails'] = 40, ['rock'] = 20, ['metal'] = 20, ['copper'] = 30, ['steel'] = 20 },

        Cost = 50,

		ExtraStorageWeight = 170,  
    },
    [18] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 40, ['leather'] = 10, ['fibers'] = 10, ['copper'] = 30, ['clay'] = 10 },

        Cost = 50,

		ExtraStorageWeight = 180,  
    },
    [19] = {	   

        HasMaterials = false,

        Materials = { ['nails'] = 40, ['leather'] = 20, ['fibers'] = 20, ['copper'] = 30, ['clay'] = 20 },
        
        Cost = 50,

		ExtraStorageWeight = 190,  
    },
    [20] = {	   

        HasMaterials = true,

        Materials = { ['nails'] = 40, ['leather'] = 30, ['fibers'] = 30, ['copper'] = 30, ['clay'] = 30 },

        Cost = 50,

		ExtraStorageWeight = 200,
    }

}