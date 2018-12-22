function showSQMCanMove(params)
	if getPlayerStorageValue(params.player, 98811) ~= 1 then
		return true
	end

	local magicEffect = 57
	local movementsExec = getPlayerStorageValue(params.player, params.summon.uid)

	local monsterType = MonsterType(params.summon:getName())
	local steps = monsterType:getExperience()-movementsExec

	local sumPos = params.summon:getPosition()
	local fromPos = {x=sumPos.x-steps,y=sumPos.y-steps,z=sumPos.z}
	local toPos = {x=sumPos.x+steps,y=sumPos.y+steps,z=sumPos.z}
	showRangeMoves(fromPos, toPos, sumPos, magicEffect)

	addEvent(showSQMCanMove, params.time+params.time, params)
end

function doMoveMob(player, pos)
	local mob = getPlayerStorageValue(player, 98812)
	local monster = Monster(mob)
	if monster == nil then return end

	local monsterType = MonsterType(monster:getName())
	local moveExec = getPlayerStorageValue(player, mob)
	local steps = monsterType:getExperience()-moveExec

	local sumPos = monster:getPosition()
	local fromPos = {x=sumPos.x-steps,y=sumPos.y-steps,z=sumPos.z}
	local toPos = {x=sumPos.x+steps,y=sumPos.y+steps,z=sumPos.z}
	if tonumber(pos.x) < tonumber(fromPos.x) or tonumber(pos.x) > tonumber(toPos.x) then
		return false
	end

	if tonumber(pos.y) < tonumber(fromPos.y) or tonumber(pos.y) > tonumber(toPos.y) then
		return false
	end

	local distance = getDistanceBetween(sumPos, pos)-15
	if distance <= steps then 
		monster:moveTo(pos, 0, 0)
		setPlayerStorageValue(player, mob, moveExec+distance)
	end

end

function showRangeMoves(from, to, pos, magicEffect)
	for nx=from.x, to.x do
        for ny=from.y, to.y do
 			if nx ~= pos.x or ny ~= pos.y then
 				curPos = {x=nx,y=ny,z=pos.z}
 				if isWalkable(curPos) then
 					doSendMagicEffect(curPos, magicEffect)
 				end
 			end
        end
    end
end