local CONST_BASE_EXP_DEATH = 20000
function onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local playerObj = Player(player)
	doResetPlayer(playerObj)
	doRemovePlayerFromArena(playerObj)

	if killer ~= nil then
		killer:addExperience(playerObj:getExperience()+CONST_BASE_EXP_DEATH, true)
		killer:addItem(2152, 100, false, CONST_SLOT_BACKPACK)
		mostDamageKiller:addItem(2152, 50, false, CONST_SLOT_BACKPACK)
	end
	return true
end