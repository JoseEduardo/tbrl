function onSay(player, words, param)
	local freeArena = findFreeArena()
	insertPlayerInArena(player, freeArena)
	startArenaReadyToStart()
end