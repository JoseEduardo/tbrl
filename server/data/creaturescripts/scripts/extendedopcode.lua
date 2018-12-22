local OPCODE_LANGUAGE = 1
local MONSTER_CLICKED = 80
local EXECUTE_ATTACK = 82
local USE_CARD = 61

function onExtendedOpcode(player, opcode, buffer)

	if opcode == OPCODE_LANGUAGE then
		-- otclient language
		if buffer == 'en' or buffer == 'pt' then
			-- example, setting player language, because otclient is multi-language...
			-- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
		end
		return
	end

	if opcode == MONSTER_CLICKED then
		if getPlayerStorageValue(player, 98600) == 1 then
			doUseCard(player, buffer)
			return true
		end
		processMonsterClicked(player, buffer)
	end

	if opcode == EXECUTE_ATTACK then
		processAttack(player, buffer)
	end

	if opcode == USE_CARD then
		receiveUseCard(player, buffer)
	end

end

