function onSay(player, words, param)
	setPlayerStorageValue(player, 9998, 0)
	--resetAllArena()
	local freeArena = findFreeArena()
	insertPlayerInArena(player, "1")
--	startArenaReadyToStart()
end