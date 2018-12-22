function showAttacks(player, monster)
	local attacks = getAttacks(monster)
	local strAttacks = "UP"
	for key2, value2 in pairs(attacks) do
		if value2["isMelee"] == 1 then
			strAttacks = strAttacks.."/melee"
		end
		if value2["isMelee"] == 0 then
			strAttacks = strAttacks.."/ranged"
		end
	end

	Player.sendExtendedOpcode(player, 81, strAttacks)
end

function getAttacks(monster)
	local monsterType = MonsterType(monster:getName())
	local attList = monsterType:getAttackList()
	local lstResult = {}
	for key, value in pairs(attList) do
		table.insert(lstResult, value)
	end

	return lstResult;
end

function hideAttacks(player)
	Player.sendExtendedOpcode(player, 81, "CL")
end

function executeAttack(player, attack, summon)
	local currMonster = Monster(summon)
	local target = Creature(player):getTarget()
	if target == nil then return end


	local monsterType = MonsterType(currMonster:getName())
	local steps = monsterType:getExperience()
	if getPlayerStorageValue(player, summon) >= steps then return end

	local lstAttks = getAttacks(currMonster)
	local currAtk  = lstAttks[tonumber(attack)]

	if tonumber(getDistanceBetween(target:getPosition(), currMonster:getPosition())) > tonumber(currAtk['range']) then
		return
	end

	currMonster:selectTarget(target)
	currMonster:executeSpell(attack)

	setPlayerStorageValue(player, summon, getPlayerStorageValue(player, summon)+1)
end