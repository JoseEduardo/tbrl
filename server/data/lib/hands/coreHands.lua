dofile('data/lib/hands/move.lua')
dofile('data/lib/hands/process.lua')
dofile('data/lib/hands/attack.lua')
dofile('data/lib/hands/card.lua')

function printTable(table)
	for key, value in pairs(table) do
		print(key, value)
	end
end