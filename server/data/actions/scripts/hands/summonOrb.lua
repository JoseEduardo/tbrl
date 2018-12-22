function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local monsterName = item:getAttribute(ITEM_ATTRIBUTE_TEXT)

	local monster = Game.createMonster(monsterName, toPosition)
	if monster ~= nil then
		monster:setMaster(player)
		setPlayerStorageValue(player, monster.uid, 0)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendCancelMessage("There is not enough room.")
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end

end