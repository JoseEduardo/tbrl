function onDeath(player, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local item = player:getSlotItem(i)
		if item then
			if not item:moveTo(corpse) then
				item:remove()
			end
		end
	end

	if not player:getSlotItem(CONST_SLOT_BACKPACK) then
		player:addItem(ITEM_BAG, 1, false, CONST_SLOT_BACKPACK)
	end
	killer:addItem(2152, 100, false, CONST_SLOT_BACKPACK)
	return true
end
