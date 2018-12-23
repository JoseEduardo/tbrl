function onSay(player, words, param)
	--resetAllArena()
	local freeArena = findFreeArena()

	insertPlayerInArena(player, "1")
	startArenaReadyToStart()
end