local CONST_BASE_EXP_DEATH = 20000
function onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	player:removeExperience(player:getExperience(), true)
	killer:addExperience(player:getExperience()+CONST_BASE_EXP_DEATH, true)
end
