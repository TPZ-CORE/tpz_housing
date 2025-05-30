Locales = {}

Locales = {
    ['PROPERTY_ON_SALE_BLIP']                   = "Property On Sale",
    ['PROPERTY_ON_SALE_BLIP_ID']                = "Property On Sale (#%s)", -- 1.0.9

    ['PROPERTY_OWNED_BLIP']                     = "Owned Property",

    ['PROPERTY_PROMPT_FOOTER']                  = "Cost: ~t6~$%s Dollars ~q~Or ~o~%s Gold ~q~| Tax: ~t6~$%s ~q~| Storage: ~pa~%s KG",
    ['PROPERTY_PROMPT_FOOTER_ONLY_DOLLARS']     = "Cost: ~t6~$%s Dollars ~q~| Tax: ~t6~$%s ~q~| Storage: ~pa~%s KG",
    ['PROPERTY_PROMPT_FOOTER_ONLY_GOLD']        = "Cost: ~o~%s Gold ~q~| Tax: ~t6~$%s ~q~| Storage: ~pa~%s KG",

    ['PROPERTY_TELEPORT_PROMPT_FOOTER_PRIMARY']   = "Enter Property",
    ['PROPERTY_TELEPORT_PROMPT_FOOTER_SECONDARY'] = "Leave Property",

    ['PROPERTY_PROMPT_MENU_OPEN_FOOTER']        = "Property Menu Actions",
    ['PROPERTY_PROMPT_STORAGE_FOOTER']          = "Storage",
    ['PROPERTY_PROMPT_WARDROBE_FOOTER']         = "Wardrobe",

    ['REAL_ESTATE_SELL_TITLE']                  = "Sell Property",
    ['REAL_ESTATE_SELL_DESCRIPTION']            = "To whom would you like to sell this property?",
    ['REAL_ESTATE_SELL_ACCEPT']                 = "ACCEPT",
    ['REAL_ESTATE_SELL_DECLINE']                = "DECLINE",
    ['REAL_ESTATE_SELL_TO_SELF']                = "~e~You can't sell this property to yourself, you should buy it instead.",

    ['INVALID_INPUT']                           = "~e~Invalid input",
    ['PLAYER_NOT_FOUND']                        = "~e~Player not found nearby.",
    ['PLAYER_NOT_VALID']                        = "~e~The selected player is not online or id is invalid.",
    ['ANOTHER_PLAYER_NEARBY']                   = "~e~You can't open the storage while another player is close.",

    ['REACHED_MAX_PROPERTIES']                  = "~e~You have reached the maximum properties.",
    ['TARGET_REACHED_MAX_PROPERTIES']           = "~e~The selected user has reached the maximum properties.",

    ['NOT_ENOUGH_MONEY']                        = "~e~You don't have enough to buy this property.",
    ['TARGET_NOT_ENOUGH_MONEY']                 = "~e~The selected user does not have enough money.",

    ['BANK_ACCOUNT_DOES_NOT_EXIST']             = "~e~You don't have any bank account, it is required for paying bills.",
    ['BANK_ACCOUNT_DOES_NOT_EXIST_TARGET']      = "~e~The selected player does not have any bank account.",

    ['MENU_PROPERTY_TITLE']                     = "Property ID: %s",

    ['MENU_KEYHOLDERS_LIST']                    = "Property Keyholders",
    ['MENU_KEYHOLDERS_ADD_NEW']                 = "Add New Keyholder",

    ['MENU_KEYHOLDERS_ADD_NEW_TITLE']           = "Player ID",
    ['MENU_KEYHOLDERS_ADD_NEW_DESCRIPTION']     = "To add a new property keyholder, you must insert a valid player id.",

    ['MENU_KEYHOLDERS_ADD_NEW_TO_SELF']         = "~e~You can't add yourself as a keyholder, property already belongs to you.",
    ['MENU_KEYHOLDERS_REACHED_MAX']             = "~e~You have reached the maximum keyholders of this property.",
    ['MENU_KEYHOLDERS_ALREADY_EXISTS']          = "~e~The following player already exists as a keyholder.",
    ['MENU_KEYHOLDERS_DOES_NOT_EXISTS']         = "~e~The following player does not exist.",

    ['MENU_KEYHOLDERS_ADDED']                   = "You have added ~o~%s~q~ as a keyholder in the property.",
    ['MENU_KEYHOLDERS_REMOVED']                 = "You have removed ~o~%s~q~ from the property.",

    ['NOT_ALLOWED_TO_ENTER']                    = "~e~You are not allowed to enter this property.",

    ['MENU_TRANSFER_TITLE']                     = "Player ID",
    ['MENU_TRANSFER_DESCRIPTION']               = "To add a new property owner, you must insert a valid player id.",
    ['CANNOT_TRANSFER_TO_SAME_PERSON']          = "~e~You can't transfer the property to yourself while it already belongs to you.",

    ['TRANSFERRED_PROPERTY']                    = "You have successfully transferred your property to another person.",
    ['TRANSFERRED_PROPERTY_TO_SELF']            = "A property has been transferred to your ownership.",

    ['SUCCESSFULLY_BOUGHT_PROPERTY']            = "You have successfully purchased a house property.",

    ['SUCCESSFULLY_SOLD_TO']                    = "You have successfully sold the following property and received: %s Dollars",

    ['MENU_ACCEPT']                             = "ACCEPT",
    ['MENU_DECLINE']                            = "DECLINE",

    ['MENU_BACK']                               = "Go Back",

    ['MENU_WARDROBE_LOCATION']                  = "Set Wardrobe Location",
    ['MENU_WARDROBE_LOCATION_DESCRIPTION']      = "",

    ['MENU_STORAGE_LOCATION']                   = "Set Storage Location",
    ['MENU_STORAGE_LOCATION_DESCRIPTION']       = "",

    ['MENU_SET_KEYHOLDERS']                     = "Manage Property Keyholders",
    ['MENU_SET_KEYHOLDERS_DESCRIPTION']         = "",
    
    ['MENU_LEDGER']                             = "Ledger",
    ['MENU_LEDGER_DESCRIPTION']                 = "",

    ['MENU_LEDGER_SUB_DESCRIPTION']             = "Your ledger account has: %s dollars available.",

    ['MENU_LEDGER_DEPOSIT_TITLE']               = "Deposit",
    ['MENU_LEDGER_DEPOSIT_DESCRIPTION']         = "Deposit money on the ledger account of your property to pay the taxes.",

    ['MENU_LEDGER_WITHDRAW_TITLE']              = "Withdraw",
    ['MENU_LEDGER_WITHDRAW_DESCRIPTION']        = "Withdraw money from the property ledger account.",

    ['MENU_TRANSFER']                           = "Transfer",
    ['MENU_TRANSFER_DESCRIPTION']               = "",

    ['MENU_SELL']                               = "Sell",
    ['MENU_SELL_DESCRIPTION']                   = "",

    ['MENU_SELL_ACCEPT']                        = "Accept",
    ['MENU_SELL_ACCEPT_DESCRIPTION']            = "Are you sure you want to sell this property?",

    ['MENU_SELL_DESCRIPTION_DOLLARS']           = "You will receive %s dollars by placing it for sale.",
    ['MENU_SELL_DESCRIPTION_GOLD']              = "You will receive %s gold by placing it for sale.",

    ['SOLD_PROPERTY_RECEIVED_DOLLARS']          = "You have sold this property and received $%s dollars.",
    ['SOLD_PROPERTY_RECEIVED_GOLD']             = "You have sold this property and received $%s gold.",

    ['SOLD_PROPERTY']                           = "You have sold this property.", -- not receiving any money.


    ['MENU_EXIT']                               = "Exit Menu",

    ['SET_CRAFTING']                            = "Press ~e~[G]~q~ To Set Crafting Location",
    ['SET_MENU_WARDROBE_LOCATION']              = "Press ~e~[G]~q~ To Set Wardrobe Location.",
    ['SET_MENU_STORAGE_LOCATION']               = "Press ~e~[G]~q~ To Set Storage Location.",

    ['LOCATION_SET']                            = "The location has been set successfully.",
    ['TOO_FAR']                                 = "~e~You are too far from the property distance.",

    ['PROPERTY_STORAGE_TITLE']                  = "Property Storage",

    ['PROPERTY_BILL_REASON']                    = "Owned Property",
    ['PROPERTY_BILL_ISSUER']                    = "Real Estate",

    ['REAL_ESTATE_SUCCESSFULLY_SOLD_DOLLARS']   = "You have sold a property and received %s dollars.",
    ['REAL_ESTATE_SUCCESSFULLY_SOLD_GOLD']      = "You have sold a property and received %s gold.",

    ['LOCKED']                                  = "Locked",
    ['UNLOCKED']                                = "Unlocked",

    ['INPUT_DEPOSIT_TITLE']                     = "Deposit",
    ['INPUT_DEPOSIT_DESCRIPTION']               = "How many would you like to deposit to the ledger?",

    ['INPUT_WITHDRAW_TITLE']                    = "Withdraw",
    ['INPUT_WITHDRAW_DESCRIPTION']              = "How many would you like to withdraw from the ledger?",

    ['INPUT_ACCEPT_BUTTON']                     = 'ACCEPT',
    ['INPUT_DECLINE_BUTTON']                    = 'CANCEL',

    ['LOCKPICKING_FAILED']                      = "~e~The lockpick broke, progress has failed.",
    ['PROPERTY_ROBBERY_BLIP_TITLE']             = "Property Robbery",

    ['NOT_ENOUGH_MONEY_LEDGER_DEPOSIT']         = "You don't have enough money to deposit.",

    ['NOT_ENOUGH_MONEY_LEDGER_WITHDRAW']        = "You don't have enough money to withdraw from the account.",

    ['LEDGER_DEPOSITED_ACCOUNT_MONEY']          = "Deposited %s dollars to the ledger account.",
    ['LEDGER_WITHDREW_ACCOUNT_MONEY']           = "Withdrew %s dollars from the ledger account.",

    ['NOT_ENOUGH_INVENTORY_WEIGHT']             = "~e~You don't have enough inventory weight.",

    ['MONEY_LEDGER_DEPOSIT_LIMIT']              = "You are not permitted to deposit more than %s dollars.", -- 1.0.8

    
    ['MENU_KEYHOLDERS_MANAGE']                  = "Would you like to manage %s?", -- 1.1.4

    ['MENU_KEYHOLDERS_PERMISSIONS_TITLE']       = "Manage Permissions", -- 1.1.4
    
    ['MENU_KEYHOLDERS_REMOVE_TITLE']            = "Remove From Keyholders", -- 1.1.4
    ['MENU_KEYHOLDERS_REMOVE_DESCRIPTION']      = "Would you like to remove %s?", -- 1.1.4
 
    ['INSUFFICIENT_PERMISSIONS']                = "~e~Insufficient Permissions.", -- 1.1.4

    ['PROPERTY_OWNED_KEYHOLDERS_BLIP']          = "Guest Property", -- 1.1.4


}