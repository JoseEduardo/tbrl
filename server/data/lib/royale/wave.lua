local CONST_WAVE_INTERVAL = 60000
local CONST_START_DEC_SQM = 1000
local CONST_DEC_SQM = 200
local CONST_DAMGE_DANGER_ZONE_TIME = 3000
local CONST_WAVE_MOVE_MSG = "The poison move in "
local CONST_DANGET_ZONE_PLAYER_MSG = "You're in the danger zone."

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

	local playerIds = db.storeQuery("SELECT `player_id` from `royale_arena_player` where `arena_id` = " .. params.arenaId .. "")
    if playerIds ~= false then
		repeat
		local playerId = result.getDataInt(playerIds, "player_id")
		local playerObj = Player(playerId)

		if not isSafeZone(getCreaturePosition(playerObj), safeStartPos, safeEndPos) then
			playerObj:sendTextMessage(MESSAGE_INFO_DESCR, CONST_DANGET_ZONE_PLAYER_MSG)
			---REMOVER VIDA
			addEvent(doCheckDangerZonePlayer, CONST_DAMGE_DANGER_ZONE_TIME, {player=playerObj, safeStartPos=safeStartPos, safeEndPos=safeEndPos})
		end
		until not result.next(playerIds)
		result.free(playerIds)					
    end
end

function doCheckDangerZonePlayer(params)
	local actPos = getCreaturePosition(params.player)
	if not isSafeZone(actPos, params.safeStartPos, params.safeEndPos) then
		---REMOVER VIDA
		params.player:sendTextMessage(MESSAGE_INFO_DESCR, CONST_DANGET_ZONE_PLAYER_MSG)
	end
	addEvent(doCheckDangerZonePlayer, CONST_DAMGE_DANGER_ZONE_TIME, params)
end

function isSafeZone(position, fromPos, toPos)
	if position.x >= fromPos.x and toPos.x <= position.x then
		if position.y >= fromPos.y and toPos.y <= position.y then
			return true
		end
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

function getDirectionSafeZone(cid)
	local playerIds = db.storeQuery("SELECT `arena_id` from `royale_arena_player` where `player_id` = " .. cid:getId() .. "")
    if playerIds == false then
    	return false
    end
	local resultArena = db.storeQuery("SELECT `endpoint_y`, `endpoint_x` from `royale_arena` where `arena_id` = " .. result.getDataInt(playerIds, "arena_id") .. "")

	local playerPos, safePos = getCreaturePosition(cid), {x=result.getDataInt(resultArena, "endpoint_x"), y=result.getDataInt(resultArena, "endpoint_y"), z=7}
    local px, py = 0, 0
    local pS = ""
    local text = ""
 
    if(playerPos.x == safePos.x) and (playerPos.y < safePos.y) then
        px = 1
        py = safePos.y - playerPos.y
        pS = "south"
    elseif(playerPos.x == safePos.x) and (playerPos.y > safePos.y) then
        px = 1
        py = playerPos.y - safePos.y
        pS = "north"
    elseif(playerPos.x < safePos.x) and (playerPos.y == safePos.y) then
        px = safePos.x - playerPos.x
        py = 1
        pS = "east"
    elseif(playerPos.x > safePos.x) and (playerPos.y == safePos.y) then
        px = playerPos.x - safePos.x
        py = 1
        pS = "west"
    elseif(playerPos.x > safePos.x) and (playerPos.y > safePos.y) then
        px = playerPos.x - safePos.x
        py = playerPos.y - safePos.y
        pS = "north-west"
    elseif(playerPos.x > safePos.x) and (playerPos.y < safePos.y) then
        px = playerPos.x - safePos.x
        py = safePos.y - playerPos.y
        pS = "south-west"
    elseif(playerPos.x < safePos.x) and (playerPos.y < safePos.y) then
        px = safePos.x - playerPos.x
        py = safePos.y - playerPos.y
        pS = "south-east"
    elseif(playerPos.x < safePos.x) and (playerPos.y > safePos.y) then
        px = safePos.x - playerPos.x
        ps = playerPos.y - safePos.y
        pS = "north-east"
    end

    if(px <= 4 and py <= 4) then
        text = "Safe Zone is standing next you."
    elseif((px > 4 and px <= 100) and (py > 4 and py <= 100)) or ((px > 4 and px <= 100) and (py <= 4)) or ((px <= 4) and (py > 4 and py <= 100)) then
        text = "Safe Zone is to the " .. pS .. "."
    elseif((px > 100 and px <= 274) and (py > 100 and py <= 274)) or ((px > 100 and px <= 274) and (py <= 100)) or ((px <= 100) and (py > 100 and py <= 274)) then
        text = "Safe Zone is far to the " .. pS .. "."
    elseif((px > 274 and px <= 280) and (py > 274 and py <= 280)) or ((px > 274 and px <= 280) and (py < 274)) or ((px < 274) and (py > 274 and py <= 280)) then
        text = "Safe Zone is very far to the " .. pS .. "."
    elseif(px > 280 and py > 280) or (px > 280 and py < 280) or (px < 280 and py > 280) then
        text = "Safe Zone is to the " .. pS .. "."
    end

    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, text)
    return false
end