# TPZ-CORE Housing

## Requirements

TPZ Menu Base : https://github.com/TPZ-CORE/tpz_menu_base

TPZ Society : https://github.com/TPZ-CORE/tpz_society

TPZ Doorlocks : https://github.com/TPZ-CORE/tpz_doorlocks

## General Information

All objects such as furnitures, are loaded client side (not synced), with a rendering system to create or delete this object based on the player distance - property distance. 

All objects will seem as synced but they actually not, since the objects are mot movable, we dont have to sync them, but spawn them based on the closest player on a property, with this way, we avoid entity limitation crashes (pool-sizing).
