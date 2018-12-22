function sendAllCardsToClient(player)
	local retStr = 'UP'
	for i = 0, getContainerSize(getPlayerSlotItem(player, CONST_SLOT_RING).uid) do
		local thing = getContainerSimpleItem(getPlayerSlotItem(player, CONST_SLOT_RING).uid, i)

		if thing ~= nil and thing:isItem() then
			local item = Item(thing.uid)
			local monsterName = item:getAttribute(ITEM_ATTRIBUTE_TEXT)
			item:setAttribute(ITEM_ATTRIBUTE_ACTIONID, i)
			local monsterType = MonsterType(monsterName)
			local out = monsterType:getOutfit()

			retStr = retStr .. "/".. monsterType:getName() ..":" .. monsterType:getManaCost() .. ":" .. i .. ":" .. out['lookType'] .. ":" .. out['lookFeet'] .. ":" .. out["lookLegs"] .. ":" .. out["lookHead"] .. ":" .. out["lookBody"]  .. ":" .. out["lookAddons"] .. ":" ..monsterType:getRace()
		end
	end

	Player.sendExtendedOpcode(player, 60, retStr)
	return true
end

function receiveUseCard(player, card)
	setPlayerStorageValue(player, 98600, 1)
	local cardInfo = splitPos(card, "|")
	setPlayerStorageValue(player, 98601, cardInfo[1])
	setPlayerStorageValue(player, 98602, cardInfo[2])
end

function doUseCard(player, posClient)
	local pCreature = Creature(player)
	local qtyManaToSummon = getPlayerStorageValue(player, 98602)
	if pCreature:getMana() < qtyManaToSummon then return end

	local card = getPlayerStorageValue(player, 98601)
	local item = Item(getCardInHand(player, card))
	local splitedPos = splitPos(posClient, "|")
	local pos = {x=splitedPos[1], y=splitedPos[2], z=splitedPos[3], stackpos=255}

	if getDistanceBetween(player:getPosition(), pos)-15 > 1 then
		setPlayerStorageValue(player, 98600, 0)
		Player.sendExtendedOpcode(player, 62, "freeCursor")
		return
	end

	setPlayerStorageValue(player, 98600, 0)
	Player.sendExtendedOpcode(player, 62, "freeCursor")
	item:useInPosition(player, player:getPosition(), pos)

	local container = Container(getPlayerSlotItem(player, CONST_SLOT_FEET).uid)
	item:moveTo(container)
	doPlayerAddMana(player, - qtyManaToSummon)

	doDrawNewCard(player)
end

function getCardInHand(player, param)
	for i = 0, getContainerSize(getPlayerSlotItem(player, CONST_SLOT_RING).uid) do
		local thing = getContainerSimpleItem(getPlayerSlotItem(player, CONST_SLOT_RING).uid, i)
		if thing ~= nil then
			local item = Item(thing.uid)

			if item:getAttribute(ITEM_ATTRIBUTE_ACTIONID) == param then
				return thing.uid
			end
		end
	end
	return nil
end

function processAttack(player, attack)
	local summon = getPlayerStorageValue(player, 98812)
	executeAttack(player, attack, summon)
end

function doDrawNewCard(player)
	local totCard = getContainerSize(getPlayerSlotItem(player, CONST_SLOT_AMMO).uid)
	local randomDraw = math.random(totCard) 

	local card = getContainerSimpleItem(getPlayerSlotItem(player, CONST_SLOT_AMMO).uid, randomDraw-1)
	if card ~= nil then
		local container = Container(getPlayerSlotItem(player, CONST_SLOT_RING).uid)
		card:moveTo(container)
	end

	sendAllCardsToClient(player)
end