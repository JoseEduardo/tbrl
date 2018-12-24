local CONST_MAX_MANA = 500
local CONST_MAX_HEALTH = 500
local CONST_MAX_CAP = 150000
local CONST_SPEED_PLAYER = 400

function onLogin(player)
	local creature = Creature(player.uid)
	doChangeSpeed(player, CONST_SPEED_PLAYER)
	creature:setMaxHealth(CONST_MAX_HEALTH)

	player:setMaxMana(CONST_MAX_MANA)
	player:setCapacity(CONST_MAX_CAP)
	player:registerEvent("PlayerDeathRoyale")
	return true
end
