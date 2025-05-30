# TPZ-CORE Housing

## Requirements

1. TPZ-Core: https://github.com/TPZ-CORE/tpz_core
2. TPZ-Characters: https://github.com/TPZ-CORE/tpz_characters
3. TPZ-Inventory: https://github.com/TPZ-CORE/tpz_inventory
4. TPZ-Menu-Base: https://github.com/TPZ-CORE/tpz_menu_base
5. TPZ-Inputs: https://github.com/TPZ-CORE/tpz_inputs

# Installation

1. When opening the zip file, open `tpz_housing-main` directory folder and inside there will be another directory folder which is called as `tpz_housing`, this directory folder is the one that should be exported to your resources (The folder which contains `fxmanifest.lua`).

2. Add `ensure tpz_housing` after the **REQUIREMENTS** in the resources.cfg or server.cfg, depends where your scripts are located.

## Description

||@everyone||

*We provide you the most advanced property housing script, the most efficient and clean which supports huge playerbase, with full functional synced updates without issues and many features for your server that others don't.*

`𝙳𝙴𝙿𝙴𝙽𝙳𝙴𝙽𝙲𝙸𝙴𝚂`:

- We provide `36` house properties by default (with image backgrounds, door registrations and menu locations that have been already setup - plug & play).

- Set in the configuration the maximum owned properties by player and the maximum keyholders of a property (we don’t want someone to share a house to the whole server).

- Property transfers, to transfer your property to another player properly without having to put it for sale. 

- Property for sale, to place your property for sale and receive / not the configured amount  based on every property.

- Real Estate Job to allow only the players with the specified job to sell properties to another players and have earnings (which makes it even more realistic). A real estate can also open all property doors if a property is not owned by another person.

- Blips on the map displaying properties for sell and owned properties for the players who own them (The specified blips are also updated properly if a property has been sold, bought or transferred). 

- We provide the `doorhashes.lua` file which is for adding doors (this is required for custom mlos, to register their doors) for our own housing doorlock system.

- Keyholders to share your property with friends or family members through the management menu, keyholders can have specific permissions based on the property actions. 

- Teleportation system support to enter or leave properties when not having doors available to setup.

- Tax system to pay automatically every x days the required amount of money  (similar to renting), if the ledger of the house does not have the required amount, the house will be lost from the players ownership. This system is mostly used to prevent the players buying properties and having them for the whole eternity (even if they never play again or being away for months) and besides all that, money wasting / laundering which is also required for the servers to have. 

- All the property management menu actions are also configurable if you decide to not use any of them (such as ledger,, selling or transferring, etc). 

- The script will be fully responsive to a huge playerbase, it will not cause any server delays or crashes when having many players online, all the updates are requested and updated properly.

- Properly saving all data before server restarts or every x minutes (fully configurable).

- Discord Webhooking.

`𝙸𝙼𝙿𝙾𝚁𝚃𝙰𝙽𝚃 𝙸𝙽𝙵𝙾𝚁𝙼𝙰𝚃𝙸𝙾𝙽:` 

- We also support items as external method for currency methods, there are servers who do not use the API functions but items instead as "money".

- Some of the property updates, such as property transfers, upgrades, ledger, etc. and many more, are not updated directly to the whole server in purpose, by updating to the whole server, it can cause many issues, crashes included, so we do update only the most important data, to avoid those kind of problems.

- All the properties are created and configured through the configuration only, no in-game menu creator as others. Also, each property has its own configurations (cost, selling, storage capacity, rendering, etc), nothing is the same as other properties which makes it even better and accessible for new changes at anytime. 
