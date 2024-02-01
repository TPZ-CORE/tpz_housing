
--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterNetEvent("tpz_housing:closeNUI")
AddEventHandler("tpz_housing:closeNUI", function()
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
end

EnableNUI = function(state)
	SetNuiFocus(false, false)

	ClientData.DisplayingUI = state

	SendNUIMessage({ type = "enable",  enable = state })
end

--[[ ------------------------------------------------
   Callbacks
]]---------------------------------------------------

RegisterNUICallback('closeNUI', function()
	EnableNUI(false)
end)
