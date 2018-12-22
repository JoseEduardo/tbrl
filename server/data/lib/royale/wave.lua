local CONST_WAVE_INTERVAL = 60000
local CONST_START_DEC_SQM = 1000
local CONST_DEC_SQM = 200
local CONST_WAVE_MOVE_MSG = "The poison move in "

function startFirstWaveArenas()
    local arenaIds = db.storeQuery("SELECT `arena_id`, `frompos_x`, `frompos_y`, `topos_x`, `topos_y` from `royale_arena` where `in_match` = 0 AND `wave_number` <= 0")
    local arenaId = false
    if arenaIds ~= false then
		repeat
			local arenaId = result.getDataInt(arenaIds, "arena_id")
			local endPoint = generateEndPointForMatch(arenaId, result.getDataInt(arenaIds, "frompos_x"), result.getDataInt(arenaIds, "frompos_y"), result.getDataInt(arenaIds, "topos_x"), result.getDataInt(arenaIds, "topos_y"))
    
    		addEvent(sendMessageToAllPlayerFromArena, 100, {arenaId=arenaId, currTime=CONST_WAVE_INTERVAL/1000}) --WAVE 1
    		addEvent(doProcessWaveMove, 3000, {arenaId=arenaId, wave=1, endPoint=endPoint, startPosX=result.getDataInt(arenaIds, "frompos_x"), startPosY=result.getDataInt(arenaIds, "frompos_y") ,toPosX=result.getDataInt(arenaIds, "topos_x"), toPosY=result.getDataInt(arenaIds, "topos_y")}) --WAVE 1

    		addEvent(sendMessageToAllPlayerFromArena, CONST_WAVE_INTERVAL, {arenaId=arenaId, currTime=CONST_WAVE_INTERVAL/1000}) --WAVE 2
    		addEvent(doProcessWaveMove, CONST_WAVE_INTERVAL*2, {arenaId=arenaId, wave=2, endPoint=endPoint, startPosX=result.getDataInt(arenaIds, "frompos_x"), startPosY=result.getDataInt(arenaIds, "frompos_y") ,toPosX=result.getDataInt(arenaIds, "topos_x"), toPosY=result.getDataInt(arenaIds, "topos_y")}) --WAVE 2

    		addEvent(sendMessageToAllPlayerFromArena, CONST_WAVE_INTERVAL, {arenaId=arenaId, currTime=CONST_WAVE_INTERVAL/1000}) --WAVE 3
    		addEvent(doProcessWaveMove, CONST_WAVE_INTERVAL*3, {arenaId=arenaId, wave=3, endPoint=endPoint, startPosX=result.getDataInt(arenaIds, "frompos_x"), startPosY=result.getDataInt(arenaIds, "frompos_y") ,toPosX=result.getDataInt(arenaIds, "topos_x"), toPosY=result.getDataInt(arenaIds, "topos_y")}) --WAVE 3

    		addEvent(sendMessageToAllPlayerFromArena, CONST_WAVE_INTERVAL, {arenaId=arenaId, currTime=CONST_WAVE_INTERVAL/1000}) --WAVE 4
    		addEvent(doProcessWaveMove, CONST_WAVE_INTERVAL*4, {arenaId=arenaId, wave=4, endPoint=endPoint, startPosX=result.getDataInt(arenaIds, "frompos_x"), startPosY=result.getDataInt(arenaIds, "frompos_y") ,toPosX=result.getDataInt(arenaIds, "topos_x"), toPosY=result.getDataInt(arenaIds, "topos_y")}) --WAVE 4

    		addEvent(sendMessageToAllPlayerFromArena, CONST_WAVE_INTERVAL, {arenaId=arenaId, currTime=CONST_WAVE_INTERVAL/1000}) --WAVE 5
    		addEvent(doProcessWaveMove, CONST_WAVE_INTERVAL*5, {arenaId=arenaId, wave=5, endPoint=endPoint, startPosX=result.getDataInt(arenaIds, "frompos_x"), startPosY=result.getDataInt(arenaIds, "frompos_y") ,toPosX=result.getDataInt(arenaIds, "topos_x"), toPosY=result.getDataInt(arenaIds, "topos_y")}) --WAVE 5

    		addEvent(sendMessageToAllPlayerFromArena, CONST_WAVE_INTERVAL, {arenaId=arenaId, currTime=CONST_WAVE_INTERVAL/1000}) --WAVE 6
    		addEvent(doProcessWaveMove, CONST_WAVE_INTERVAL*6, {arenaId=arenaId, wave=6, endPoint=endPoint, startPosX=result.getDataInt(arenaIds, "frompos_x"), startPosY=result.getDataInt(arenaIds, "frompos_y") ,toPosX=result.getDataInt(arenaIds, "topos_x"), toPosY=result.getDataInt(arenaIds, "topos_y")}) --WAVE 6

		until not result.next(arenaIds)
		result.free(arenaIds)
    end

    return arenaId;
end

function doProcessWaveMove(params)
	local currDecSqm = CONST_START_DEC_SQM - (CONST_DEC_SQM*params.wave)

	local safeStartX = (params.endPoint.x - CONST_START_DEC_SQM) < params.startPosX and params.startPosX or params.endPoint.x - CONST_START_DEC_SQM
	local safeStartY = (params.endPoint.y - CONST_START_DEC_SQM) < params.startPosY and params.startPosY or params.endPoint.y - CONST_START_DEC_SQM
	local safeStartPos = {x= safeStartX, y= safeStartY, z=7}

	local safeEndX = (params.endPoint.x + CONST_START_DEC_SQM) > params.toPosX and params.toPosX or params.endPoint.x + CONST_START_DEC_SQM
	local safeEndY = (params.endPoint.y + CONST_START_DEC_SQM) > params.toPosY and params.toPosY or params.endPoint.y + CONST_START_DEC_SQM
	local safeEndPos   = {x= params.endPoint.x + CONST_START_DEC_SQM, y= params.endPoint.y + CONST_START_DEC_SQM, z=0}

	for px=params.startPosX, params.toPosX do
		for py=params.startPosY, params.toPosY do
			if not isSafeZone({x=px, y=py, z=7}, safeStartPos, safeEndPos) then
				Game.createItem(1506, 1, {x=px, y=py, z=0, stackpos=5})
				Game.createItem(1506, 1, {x=px, y=py, z=1, stackpos=5})
				Game.createItem(1506, 1, {x=px, y=py, z=2, stackpos=5})
				Game.createItem(1506, 1, {x=px, y=py, z=3, stackpos=5})
				Game.createItem(1506, 1, {x=px, y=py, z=4, stackpos=5})
				Game.createItem(1506, 1, {x=px, y=py, z=5, stackpos=5})
				Game.createItem(1506, 1, {x=px, y=py, z=6, stackpos=5})
				Game.createItem(1506, 1, {x=px, y=py, z=7, stackpos=5})
			end
		end
	end
end

function isSafeZone(position, fromPos, toPos)
	if position.x >= fromPos.x and toPos.x <= position.x then
		if position.y >= fromPos.y and toPos.y <= position.y then
			return true
		end
	end 
	if not isWalkable(position) then
		return true
	end

	return false
end

function sendMessageToAllPlayerFromArena(params)
	local playerIds = db.storeQuery("SELECT `player_id` from `royale_arena_player` where `arena_id` = " .. params.arenaId .. "")
    if playerIds ~= false then
		repeat
		local playerId = result.getDataInt(playerIds, "player_id")
		local playerObj = Player(playerId)

		playerObj:sendTextMessage(MESSAGE_INFO_DESCR, CONST_WAVE_MOVE_MSG .. params.currTime .. " seconds")
		until not result.next(playerIds)
		result.free(playerIds)					
    end
end

function generateEndPointForMatch(arenaId, fromposX, fromposY, toposX, toposY)
	local positionToTp ={x=1, y=1, z=7}
	repeat
		math.randomseed(os.mtime())
		local setX = math.random(fromposX, toposX)
    	local setY = math.random(fromposY, toposY)
    	positionToTp = {x = setX, y = setY, z = 7};
	until canTeleport(positionToTp) == true

  	db.asyncQuery("UPDATE `royale_arena` SET `endpoint_x` = ".. positionToTp.x .. ", `endpoint_y` = " .. positionToTp.y .. " where `arena_id` = " .. arenaId .. "")
  	return positionToTp;
end