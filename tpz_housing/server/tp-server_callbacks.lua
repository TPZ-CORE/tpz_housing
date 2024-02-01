local TPZ           = {}
local TPZInv        = exports.tpz_inventory:getInventoryAPI()

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

exports.tpz_core:rServerAPI().addNewCallBack("tpz_housing:getPlayerFurniture", function(source, cb)
	local _source         = source

    local xPlayer         = TPZ.GetPlayer(_source)
	local charidentifier  = xPlayer.getCharacterIdentifier()

	exports["ghmattimysql"]:execute("SELECT furniture FROM characters WHERE charidentifier = @charidentifier", { ['@charidentifier'] = charidentifier}, function(result)
		
		if result[1] then
			return cb( json.decode(result[1].furniture) )
		end

		return cb( nil )
	end)
end)