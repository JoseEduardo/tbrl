local rewards = {
    {id = 2463, chance = 90, count = 1},
    {id = 2460, chance = 70, count = 1},
    {id = 2464, chance = 40, count = 1},
    {id = 2472, chance = 30, count = 1},
    {id = 2466, chance = 90, count = 1},
    {id = 2468, chance = 70, count = 1},
    {id = 2470, chance = 40, count = 1},
    {id = 2473, chance = 30, count = 1},
    {id = 2476, chance = 90, count = 1},
    {id = 2477, chance = 70, count = 1},
    {id = 2486, chance = 40, count = 1},
    {id = 2487, chance = 30, count = 1},
    {id = 2491, chance = 90, count = 1},
    {id = 2492, chance = 70, count = 1},
    {id = 2495, chance = 40, count = 1},
    {id = 2498, chance = 30, count = 1},
    {id = 2510, chance = 90, count = 1},
    {id = 2514, chance = 70, count = 1},
    {id = 2516, chance = 40, count = 1},
    {id = 2519, chance = 30, count = 1},
    {id = 2528, chance = 90, count = 1},
    {id = 2543, chance = 90, count = 20},
    {id = 2544, chance = 90, count = 20},
    {id = 2545, chance = 90, count = 20},
    {id = 2547, chance = 90, count = 20},
    {id = 2640, chance = 10, count = 1},
    {id = 2645, chance = 35, count = 1},
    {id = 2647, chance = 40, count = 1},
    {id = 2648, chance = 10, count = 1},
    {id = 2656, chance = 15, count = 1},
    {id = 2671, chance = 90, count = 5},
    {id = 2787, chance = 90, count = 5},
    {id = 2789, chance = 90, count = 5},
    {id = 11307, chance = 20, count = 1},
    {id = 12649, chance = 11, count = 1},
    {id = 13829, chance = 95, count = 1},
    {id = 18450, chance = 30, count = 1},
    {id = 18452, chance = 20, count = 1},
    {id = 20139, chance = 70, count = 1},
    {id = 2392, chance = 40, count = 1},
    {id = 2415, chance = 30, count = 1},
	{id = 2430, chance = 50, count = 1},
	{id = 2435, chance = 60, count = 1},
	{id = 2444, chance = 40, count = 1},
	{id = 2455, chance = 70, count = 1},
	{id = 2456, chance = 70, count = 1}
}
local rewardsMagic = {
	{id = 2278, chance = 90, count = 50},   
	{id = 2274, chance = 60, count = 50},   
	{id = 2268, chance = 40, count = 20},   
	{id = 2293, chance = 50, count = 60}, 
	{id = 2305, chance = 90, count = 30}
}
local rewardsPotions = {
	{id = 7588, chance = 90, count = 20},   
	{id = 7589, chance = 60, count = 20},   
	{id = 7590, chance = 40, count = 20},   
	{id = 7591, chance = 50, count = 20}, 
	{id = 7618, chance = 90, count = 20},
	{id = 7620, chance = 90, count = 20}
}
local CONST_MSG_ANOTHER_PLAYER_CHEST = "This chest belongs to another player."
local CONST_QTY_MAGIC_ITENS = 5
local CONST_QTY_POTIONS_ITENS = 5

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerName = item:getAttribute(ITEM_ATTRIBUTE_TEXT)
	if playerName ~= player:getName() then
		player:sendTextMessage(MESSAGE_INFO_DESCR, CONST_MSG_ANOTHER_PLAYER_CHEST)
		return true
	end
	if item:getAttribute(ITEM_ATTRIBUTE_ACTIONID) ~= 1 then
		math.randomseed(os.mtime())
		for i = 1, (item:getCapacity()-(CONST_QTY_MAGIC_ITENS+CONST_QTY_POTIONS_ITENS) ) do
			local rewardId = math.random(1, #rewards)
	        local reward = rewards[rewardId]
	        local rand = math.random(100)
	        if rand >= reward.chance then
          		addItemChest(item, reward.id, reward.count)
	        end
	    end
		for i = 1, CONST_QTY_MAGIC_ITENS do
			local rewardMgId = math.random(1, #rewardsMagic)
	        local rewardMagic = rewardsMagic[rewardMgId]
	        local randMagic = math.random(100)
	        if randMagic >= rewardMagic.chance then
          		addItemChest(item, rewardMagic.id, rewardMagic.count)
	        end
	    end
		for i = 1, CONST_QTY_POTIONS_ITENS do
			local rewardPtId = math.random(1, #rewardsPotions)
	        local rewardPotion = rewardsPotions[rewardPtId]
	        local randPotion = math.random(100)
	        if randPotion >= rewardPotion.chance then
          		addItemChest(item, rewardPotion.id, rewardPotion.count)
	        end
	    end
		item:setAttribute(ITEM_ATTRIBUTE_ACTIONID, 1)
	end
end

function addItemChest(item, itemId, qty)
 	local container = Container(item.uid)
    container:addItem(itemId, qty, INDEX_WHEREEVER, 0)
end