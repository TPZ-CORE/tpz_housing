# TPZ-CORE Housing

## Requirements

1. TPZ-Core: https://github.com/TPZ-CORE/tpz_core
2. TPZ-Characters: https://github.com/TPZ-CORE/tpz_characters
3. TPZ-Inventory: https://github.com/TPZ-CORE/tpz_inventory
4. TPZ-Society: https://github.com/TPZ-CORE/tpz_society
5. TPZ-Menu Base: https://github.com/TPZ-CORE/tpz_menu_base
6. TPZ-Doorlocks: https://github.com/TPZ-CORE/tpz_doorlocks

# Installation

1. When opening the zip file, open `tpz_housing-main` directory folder and inside there will be another directory folder which is called as `tpz_housing`, this directory folder is the one that should be exported to your resources (The folder which contains `fxmanifest.lua`).

2. Add `ensure tpz_housing` after the **REQUIREMENTS** in the resources.cfg or server.cfg, depends where your scripts are located.

## General Information

You can find 37 Houses by default (More will be added in future updates).

All objects such as furnitures, are loaded client side (not synced), with a rendering system to create or delete this object based on the player distance - property distance. 

All objects will seem as synced but they actually not, since the objects are not movable, we dont have to sync them, but spawn them based on the closest player on a property, with this way, we avoid entity limitation crashes (pool-sizing).
