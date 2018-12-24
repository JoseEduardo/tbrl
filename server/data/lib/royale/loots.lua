local CONST_SEC_OPEN_CHEST = 5
local CONST_ID_CLOSED_CHEST = 8587
local CONST_MAX_CHEST = 90
local CONST_MIN_CHEST = 30

function populateLootsToArena(arenaId)
    local resultId = db.storeQuery("SELECT `frompos_x`, `frompos_y`, `topos_x`, `topos_y` from `royale_arena` where `arena_id` = " .. arenaId .. "")
    if resultId ~= false then
		math.randomseed(os.mtime())
        local fromPosX = result.getDataInt(resultId, "frompos_x")
        local fromPosY = result.getDataInt(resultId, "frompos_y")
        local toPosX = result.getDataInt(resultId, "topos_x")
        local toPosY = result.getDataInt(resultId, "topos_y")

		local maxChest = math.random(CONST_MIN_CHEST, CONST_MAX_CHEST)
		print(maxChest)
		for i=1, maxChest do
			repeat
				math.randomseed(os.mtime())
		    	positionToTp = {x = math.random(fromPosX, toPosX), y = math.random(fromPosY, toPosY), z = math.random(0, 7)}
			until (isWalkable(positionToTp) == true)
			doCreateItem(CONST_ID_CLOSED_CHEST, 1, positionToTp)
		end
    end
end

