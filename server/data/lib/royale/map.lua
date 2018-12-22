function getMobaMapTiles(fromPos, toPos)
local posIndex = 0
local consX = 1
local consY = 1
local file = io.open("map.txt", "w")
for x = fromPos.x, toPos.x do
  for y = fromPos.y, toPos.y do
    for z = fromPos.z, toPos.z do
        for stackpos = 0, 255 do
            totalArea = {x=x, y=y, z=z, stackpos=stackpos}
          
            thing = getTileThingByPos(totalArea)
            if thing.itemid > 0 then
                --file:write("["..posIndex.."] = {pos={x="..consX..", y="..consY..", z="..z..", stackpos="..stackpos.."}, item="..thing.itemid.."},".."\n")
                file:write(consX..","..consY..","..z..","..stackpos..","..thing.itemid..",".."\n")
                posIndex = posIndex+1
            end
        end
    end
    consY = consY+1
  end
  consY = 1
  consX = consX+1
end
file:close()
print('end')
end

function doRemoveTile(pos)-- Script by mock
    pos.stackpos = 0
    local sqm = getTileThingByPos(pos)
    doRemoveItem(sqm.uid,1)
end

function doCreateTile(id,pos) -- By mock
    doAreaCombatHealth(0,COMBAT_FIREDAMAGE,pos,0,0,0, CONST_ME_EXPLOSIONHIT)
    doCreateItem(id,1,pos)
end


function lines_from(file)
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function createMap(posStart)
    --[[
    for i,v in ipairs(arenaConfigTiles) do
        local newpos = Position(v.pos.x,v.pos.y,v.pos.z,0)
        doCreateTile(v.item, newpos)
    end
    --]]

    local file = 'map.txt'
    local lines = lines_from(file)

    for k,v in pairs(lines) do
        res = {}
        for w in string.gmatch(v, "([^"..",".."]+)") do
            res[#res + 1] = w
        end
        local newpos = Position(posStart.x+res[1],posStart.y+res[2],res[3],res[4])
        doCreateTile(res[5], newpos)
    end

end