function Position.getNextPosition(self, direction, steps)
	steps = steps or 1
	if direction == WEST then
		self.x = self.x - steps
	elseif direction == EAST then
		self.x = self.x + steps
	elseif direction == NORTH then
		self.y = self.y - steps
	elseif direction == SOUTH then
		self.y = self.y + steps
	elseif direction == NORTHWEST then
		self.x = self.x - steps
		self.y = self.y - steps
	elseif direction == NORTHEAST then
		self.x = self.x + steps
		self.y = self.y - steps
	elseif direction == SOUTHWEST then
		self.x = self.x - steps
		self.y = self.y + steps
	elseif direction == SOUTHEAST then
		self.x = self.x + steps
		self.y = self.y + steps
	end
end

function getNextPositionFromToNewPos(position, direction, steps)
	steps = steps or 1
	if direction == WEST then
		position.x = position.x - steps
	elseif direction == EAST then
		position.x = position.x + steps
	elseif direction == NORTH then
		position.y = position.y - steps
	elseif direction == SOUTH then
		position.y = position.y + steps
	elseif direction == NORTHWEST then
		position.x = position.x - steps
		position.y = position.y - steps
	elseif direction == NORTHEAST then
		position.x = position.x + steps
		position.y = position.y - steps
	elseif direction == SOUTHWEST then
		position.x = position.x - steps
		position.y = position.y + steps
	elseif direction == SOUTHEAST then
		position.x = position.x + steps
		position.y = position.y + steps
	end
	return position
end

function isInRange(position, fromPosition, toPosition)
    --return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.z >= fromPosition.z and position.x <= toPosition.x and position.y <= toPosition.y and position.z <= toPosition.z)
    return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.x <= toPosition.x and position.y <= toPosition.y)
end

function Position.getTile(self)
	return Tile(self)
end

function isWalkable(position)
    local tile = Tile(position)
    if not tile then
        return false
    end

    if tile:getTopCreature() then 
    	return false
    end
 	if tile.uid == 70001 then
 		return false
 	end

	if tile:hasFlag(TILESTATE_BLOCKPATH) then
		return false
	end

    local ground = tile:getGround()
    if not ground or ground:hasProperty(CONST_PROP_BLOCKSOLID) then
        return false
    end
 
    local items = tile:getItems()
    for i = 1, tile:getItemCount() do
        local item = items[i]
        local itemType = item:getType()
        if itemType:getType() ~= ITEM_TYPE_MAGICFIELD and not itemType:isMovable() and item:hasProperty(CONST_PROP_BLOCKSOLID) then
            return false
        end
    end
    return true
end

function splitPos(inputstr, sep)
	if sep == nil then
	    sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	    t[i] = str
	    i = i + 1
	end
	return t
end

