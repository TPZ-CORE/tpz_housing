
--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterNetEvent("tpz_housing:client:closeNUI")
AddEventHandler("tpz_housing:client:closeNUI", function()
	SendNUIMessage({ action = 'closeUI' })
end)


--[[ ------------------------------------------------
   Functions
]]---------------------------------------------------


SetCurrentBackgroundImageUrl = function(cb)
    SendNUIMessage({ action = "updateCurrentSelectedType", backgroundImageUrl = cb})
end

CloseNUIProperly = function()
	SendNUIMessage({ action = 'closeUI' })

	GetPlayerData().DisplayingUI = false
end

EnableNUI = function(state)
	SetNuiFocus(false, false)

	GetPlayerData().DisplayingUI = state

	SendNUIMessage({ type = "enable",  enable = state })
end

--[[ ------------------------------------------------
   Callbacks
]]---------------------------------------------------

RegisterNUICallback('closeNUI', function()
	EnableNUI(false)
end)
