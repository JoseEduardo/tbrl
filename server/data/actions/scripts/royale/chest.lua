local CONST_ID_OPEN_CHEST = 5675
local CONST_TIME_OPEN_SEC = 5
local CONST_CHEST_KEY = 9888
local CONST_CHEST_FAILED_KEY = 9887
local CONST_CHEST_STARTED_KEY = 9886
local CONST_ACTION_ID_CHEST_OPEN = 7784

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if getPlayerStorageValue(player, CONST_CHEST_STARTED_KEY) == 1 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED , "You're already opening a chest.")
		return true 
	end

	setPlayerStorageValue(player, CONST_CHEST_KEY, 1)
	setPlayerStorageValue(player, CONST_CHEST_STARTED_KEY, 1)
	setPlayerStorageValue(player, CONST_CHEST_FAILED_KEY, 0)
	local posPlayer = player:getPosition()

	for i=1, CONST_TIME_OPEN_SEC do
		addEvent(sendCountToPlayer, i*1000, {player=player, posPlayer=posPlayer, count=i})
	end
	addEvent(transformChest, (CONST_TIME_OPEN_SEC*1000)+500, {player=player, position=fromPosition, posPlayer=posPlayer, item=item})
	return true
end

function sendCountToPlayer(params)
	local playerObj = params.player
	if samePosition(playerObj:getPosition(), params.posPlayer) and getPlayerStorageValue(playerObj, CONST_CHEST_STARTED_KEY) == 1 then
		if params.count <= 1 then
			playerObj:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "It will open in " .. params.count .. " second")
		else 
			playerObj:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "It will open in " .. params.count .. " seconds")
		end
		setPlayerStorageValue(playerObj, CONST_CHEST_KEY, getPlayerStorageValue(playerObj, CONST_CHEST_KEY)+1)
	else
		setPlayerStorageValue(playerObj, CONST_CHEST_STARTED_KEY, 0)
		setPlayerStorageValue(playerObj, CONST_CHEST_FAILED_KEY, 1)
	end
end

function transformChest(params)
	local playerObj = params.player
	if samePosition(playerObj:getPosition(), params.posPlayer) and getPlayerStorageValue(playerObj, CONST_CHEST_KEY) >= 4 and getPlayerStorageValue(playerObj, CONST_CHEST_FAILED_KEY) ~= 1 then
		doRemoveItem(params.item.uid)
		local newItem = Game.createItem(CONST_ID_OPEN_CHEST, 1, params.position)

		newItem:setAttribute(ITEM_ATTRIBUTE_TEXT, playerObj:getName())
		doSetItemActionId(newItem.uid, CONST_ACTION_ID_CHEST_OPEN)
	end
	setPlayerStorageValue(playerObj, CONST_CHEST_STARTED_KEY, 0)
end

function samePosition(pos1, pos2)
	return pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z
end