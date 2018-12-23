local CONST_ARENA_ID = 9999
local CONST_ARENA_IN_BATTLE = 9998
local CONST_PLAYERS_TO_START = 100

local CONST_MESSAGE_ADD_QUEUE = 'You have been added in the queue.'
local CONST_MESSAGE_GAME_WILL_START = 'Get ready! the game will start in 30 seconds.'
local CONST_MESSAGE_GAME_START = 'SURVIVE!!!'
local CONST_PSEC_WAIT_START = 1000


function installArenasTable()
    db.query("CREATE TABLE `royale_arena` ( `arena_id` INT NOT NULL AUTO_INCREMENT , `frompos_x` INT NOT NULL , `frompos_y` INT NOT NULL , `frompos_z` INT NOT NULL , `topos_x` INT NOT NULL , `topos_y` INT NOT NULL , `topos_z` INT NOT NULL , `in_match` INT NOT NULL , `players_in_arena` INT NOT NULL, `wave_number` INT NOT NULL, `endpoint_x` INT, `endpoint_y` INT , PRIMARY KEY (`arena_id`)) ENGINE = InnoDB")
    db.query("CREATE TABLE `royale_arena_player` ( `arena_id` INT NOT NULL , `player_id` INT NOT NULL ) ENGINE = InnoDB")

    local resultId = db.storeQuery("SELECT `arena_id` from `royale_arena` where `arena_id` = 1")
    if resultId == false then    
        db.asyncQuery("INSERT INTO `royale_arena` (`arena_id`, `frompos_x`, `frompos_y`, `frompos_z`, `topos_x`, `topos_y`, `topos_z`, `in_match`, `players_in_arena`, `wave_number`) VALUES ('1', '220', '6150', '7', '700', '6630', '0', '0', '0', '0')")
    end

end

function findFreeArena()
    local resultId = db.storeQuery("SELECT `arena_id` from `royale_arena` where `in_match` = '0'")
    local arenaId = false
    if resultId ~= false then
		arenaId = result.getDataInt(resultId, "arena_id")
		result.free(resultId)
    end

    return arenaId;
end

function insertPlayerInArena(player, arenaId)
    local resultId = db.storeQuery("SELECT `players_in_arena` from `royale_arena` where `in_match` = 0 AND `arena_id` = " .. arenaId .. "")
    if resultId ~= false then
 		local playerInArena = result.getDataInt(resultId, "players_in_arena")
    	db.asyncQuery("UPDATE `royale_arena` SET `players_in_arena`  = ".. playerInArena+1 .. "")
		result.free(resultId)
		local playerId = player:getId()

    	db.asyncQuery("DELETE FROM `royale_arena_player` where `player_id` = " .. playerId .. "")
		db.asyncQuery("INSERT INTO `royale_arena_player` (`arena_id` , `player_id`) VALUES ('".. arenaId .."', '".. playerId .."')")

		local playerObj = Player(player)
		playerObj:sendTextMessage(MESSAGE_INFO_DESCR, CONST_MESSAGE_ADD_QUEUE)
		setPlayerStorageValue(playerObj, CONST_ARENA_ID, arenaId)
    end

    return arenaId;
end

function resetAllArena()
	db.asyncQuery("UPDATE `royale_arena` SET `players_in_arena`  = 0, `in_match` = 0, `wave_number` = 0, `endpoint_x` = 0, `endpoint_y` = 0")
end


function resetArena(arenaId)
	db.asyncQuery("UPDATE `royale_arena` SET `players_in_arena`  = 0, `in_match` = 0, `wave_number` = 0, `endpoint_x` = 0, `endpoint_y` = 0 where `arena_id` = ".. arenaId .. "")
end

function startArenaReadyToStart()
    local arenaIds = db.storeQuery("SELECT `arena_id`, `frompos_x`, `frompos_y`, `topos_x`, `topos_y` from `royale_arena` where `in_match` = 0 AND `players_in_arena` >= " .. CONST_PLAYERS_TO_START .. "")
    if arenaIds ~= false then
		repeat
			local arenaId = result.getDataInt(arenaIds, "arena_id")

			db.asyncQuery("UPDATE `royale_arena` SET `in_match`  = 1 where `arena_id` = " .. arenaId.. "")
			preparePlayersFromArena(arenaId, result.getDataInt(arenaIds, "frompos_x"), result.getDataInt(arenaIds, "frompos_y"), result.getDataInt(arenaIds, "topos_x"), result.getDataInt(arenaIds, "topos_y"))
		until not result.next(arenaIds)
		result.free(arenaIds)
    end
end

function preparePlayersFromArena(arenaId, fromposX, fromposY, toposX, toposY)
	local playerIds = db.storeQuery("SELECT `player_id` from `royale_arena_player` where `arena_id` = " .. arenaId .. "")
    if playerIds ~= false then
		repeat
			local playerId = result.getDataInt(playerIds, "player_id")
			local playerObj = Player(playerId)
			if playerObj ~= nil then
				local positionToTp ={x=1, y=1, z=7}
				repeat
					math.randomseed(os.mtime())
					local setX = math.random(fromposX, toposX)
			    	local setY = math.random(fromposY, toposY)
			    	positionToTp = {x = setX, y = setY, z = 7};
				until isWalkable(positionToTp) == true

				if getPlayerStorageValue(playerObj, CONST_ARENA_IN_BATTLE) ~= 1 then
					setPlayerStorageValue(playerObj, CONST_ARENA_IN_BATTLE, 1)
					playerObj:sendTextMessage(MESSAGE_INFO_DESCR, CONST_MESSAGE_GAME_WILL_START)
					local params = {player = playerObj, pos = positionToTp}
					addEvent(doTeleportPlayer, CONST_PSEC_WAIT_START, params)
				end
			end
		until not result.next(playerIds)
		result.free(playerIds)					
    end
end

function doTeleportPlayer(params)
	params.player:sendTextMessage(MESSAGE_INFO_DESCR, CONST_MESSAGE_GAME_START)
	doTeleportThing(params.player, params.pos, false)
end