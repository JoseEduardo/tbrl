function processMonsterClicked(player, posClient)
	local magicEffectId = 56
	local magicEffectTime = 0
	local splitedPos = splitPos(posClient, "|")

	local pos = {x=splitedPos[1], y=splitedPos[2], z=splitedPos[3], stackpos=255}
	local thing = getThingfromPos(pos)

	if getPlayerStorageValue(player, 98811) ~= 1 then
		if isMonster(thing.uid) and isSummon(thing.uid) then
			local summon = Monster(thing.uid)
			local master = summon:getMaster()
	    	if master and master:isPlayer() and master == player then
				showAttacks(player, summon)
				
				setPlayerStorageValue(player, 98810, pos)
				setPlayerStorageValue(player, 98811, 1)
				setPlayerStorageValue(player, 98812, summon.uid)

				params = {player=player, summon=summon, magicEffectId=magicEffectId, time=magicEffectTime}
				showSQMCanMove(params)
	    		return true
	    	end
		end
	end
	local currPos = getPlayerStorageValue(player, 98810)
	if currPos ~= pos and getPlayerStorageValue(player, 98811) == 1 then
		doMoveMob(player, pos)
		setPlayerStorageValue(player, 98811, 0)
		hideAttacks(player)
	end
	return false
end

function processAttack(player, attack)
	local summon = getPlayerStorageValue(player, 98812)
	executeAttack(player, attack, summon)
end