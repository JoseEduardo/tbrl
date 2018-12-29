local CONST_BACKPACK = 9774
local CONST_CHEST_STARTED_KEY = 9886
local CONST_CHEST_KEY = 9888
local CONST_BLESS_1 = 6899
local CONST_BLESS_2 = 6898
local CONST_MUL_FOR_BLESS1 = 100
local CONST_MUL_FOR_BLESS2 = 60
local CONST_ARENA_IN_BATTLE = 9998
local CONST_ARENA_WAVE_NUM = 9995

local CONST_CHEST_FAILED_KEY = 9887
local CONST_WINNER_MSG = "You win."

function doWinnerPlayer(playerObj)
    playerObj:sendTextMessage(MESSAGE_INFO_DESCR, CONST_WINNER_MSG)
    playerObj:teleportTo(playerObj:getTown():getTemplePosition())
end

function doResetPlayer(player)
    player:removeExperience(player:getExperience(), false)
    doRemoveAllItemsForPlayer(player)
    resetSpellForPlayer(player)
    setPlayerStorageValue(player, CONST_CHEST_STARTED_KEY, 0)
    setPlayerStorageValue(player, CONST_CHEST_KEY, 1)
    setPlayerStorageValue(player, CONST_CHEST_FAILED_KEY, 0)
    setPlayerStorageValue(player, CONST_ARENA_IN_BATTLE, 0)
    setPlayerStorageValue(player, CONST_ARENA_WAVE_NUM, 0)

    local creature = Creature(player)
    creature:addMana(creature:getMaxMana(), false)
    creature:addHealth(creature:getMaxHealth())
end

function doRemoveAllItemsForPlayer(player)
    for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
        local item = player:getSlotItem(i)
        if item then
            item:remove()
        end
    end

    if not player:getSlotItem(CONST_SLOT_BACKPACK) then
        player:addItem(CONST_BACKPACK, 1, false, CONST_SLOT_BACKPACK)
    end
end

function resetSpellForPlayer(player)
    local count = getPlayerInstantSpellCount(player)
    local t = {}
    for i = 0, count - 1 do
        local spell = getPlayerInstantSpellInfo(player, i)
        if spell.level ~= 0 then
            t[#t+1] = spell
        end
    end
 
    for i, spell in ipairs(t) do
        player:forgetSpell(spell.name)
 
    end
    return true
end

--DEPRECATED
function doAdjustePlayerForBlass_OLD(cid)
    local player = Player(cid)
    --RESET ALL
    player:addManaSpent(-player:getManaSpent())
    player:addSkillTries(SKILL_DISTANCE, - player:getSkillTries(SKILL_DISTANCE))
    player:addSkillTries(SKILL_CLUB, - player:getSkillTries(SKILL_CLUB))
    player:addSkillTries(SKILL_SWORD, - player:getSkillTries(SKILL_SWORD))
    player:addSkillTries(SKILL_AXE, - player:getSkillTries(SKILL_AXE))
    player:addSkillTries(SKILL_SHIELD, - player:getSkillTries(SKILL_SHIELD))

    --BLESS 1
    if getPlayerStorageValue(player, CONST_BLESS_1) == 1 then
        player:addManaSpent(player:getVocation():getRequiredManaSpent(player:getBaseMagicLevel() + CONST_MUL_FOR_BLESS1) - player:getManaSpent())
    end
    if getPlayerStorageValue(player, CONST_BLESS_1) == 2 then
        player:addSkillTries(SKILL_DISTANCE, player:getVocation():getRequiredSkillTries(SKILL_DISTANCE, player:getSkillLevel(SKILL_DISTANCE) + CONST_MUL_FOR_BLESS1) - player:getSkillTries(SKILL_DISTANCE))
    end
    if getPlayerStorageValue(player, CONST_BLESS_1) == 3 then
        player:addSkillTries(SKILL_CLUB, player:getVocation():getRequiredSkillTries(SKILL_CLUB, player:getSkillLevel(SKILL_CLUB) + CONST_MUL_FOR_BLESS1) - player:getSkillTries(SKILL_CLUB))
        player:addSkillTries(SKILL_SWORD, player:getVocation():getRequiredSkillTries(SKILL_SWORD, player:getSkillLevel(SKILL_SWORD) + CONST_MUL_FOR_BLESS1) - player:getSkillTries(SKILL_SWORD))
        player:addSkillTries(SKILL_AXE, player:getVocation():getRequiredSkillTries(SKILL_AXE, player:getSkillLevel(SKILL_AXE) + CONST_MUL_FOR_BLESS1) - player:getSkillTries(SKILL_AXE))
    end
    if getPlayerStorageValue(player, CONST_BLESS_1) == 4 then
        player:addSkillTries(SKILL_SHIELD, player:getVocation():getRequiredSkillTries(SKILL_SHIELD, player:getSkillLevel(SKILL_SHIELD) + CONST_MUL_FOR_BLESS1) - player:getSkillTries(SKILL_SHIELD))
    end

    --BLESS 1
    if getPlayerStorageValue(player, CONST_BLESS_2) == 1 then
        player:addManaSpent(player:getVocation():getRequiredManaSpent(player:getBaseMagicLevel() + CONST_MUL_FOR_BLESS2) - player:getManaSpent())
    end
    if getPlayerStorageValue(player, CONST_BLESS_2) == 2 then
        player:addSkillTries(SKILL_DISTANCE, player:getVocation():getRequiredSkillTries(SKILL_DISTANCE, player:getSkillLevel(SKILL_DISTANCE) + CONST_MUL_FOR_BLESS2) - player:getSkillTries(SKILL_DISTANCE))
    end
    if getPlayerStorageValue(player, CONST_BLESS_2) == 3 then
        player:addSkillTries(SKILL_CLUB, player:getVocation():getRequiredSkillTries(SKILL_CLUB, player:getSkillLevel(SKILL_CLUB) + CONST_MUL_FOR_BLESS2) - player:getSkillTries(SKILL_CLUB))
        player:addSkillTries(SKILL_SWORD, player:getVocation():getRequiredSkillTries(SKILL_SWORD, player:getSkillLevel(SKILL_SWORD) + CONST_MUL_FOR_BLESS2) - player:getSkillTries(SKILL_SWORD))
        player:addSkillTries(SKILL_AXE, player:getVocation():getRequiredSkillTries(SKILL_AXE, player:getSkillLevel(SKILL_AXE) + CONST_MUL_FOR_BLESS2) - player:getSkillTries(SKILL_AXE))
    end
    if getPlayerStorageValue(player, CONST_BLESS_2) == 4 then
        player:addSkillTries(SKILL_SHIELD, player:getVocation():getRequiredSkillTries(SKILL_SHIELD, player:getSkillLevel(SKILL_SHIELD) + CONST_MUL_FOR_BLESS2) - player:getSkillTries(SKILL_SHIELD))
    end
end

function doAdjustePlayerForBless(player)
    local ml = 10 
    local distance = 10
    local attack = 10
    local defense = 10

    --BLESS 1
    if getPlayerStorageValue(player, CONST_BLESS_1) == 1 then
        ml = CONST_MUL_FOR_BLESS1
    end
    if getPlayerStorageValue(player, CONST_BLESS_1) == 2 then
        distance = CONST_MUL_FOR_BLESS1
    end
    if getPlayerStorageValue(player, CONST_BLESS_1) == 3 then
        attack = CONST_MUL_FOR_BLESS1
    end
    if getPlayerStorageValue(player, CONST_BLESS_1) == 4 then
        defense = CONST_MUL_FOR_BLESS1
    end

    --BLESS 1
    if getPlayerStorageValue(player, CONST_BLESS_2) == 1 then
        ml = CONST_MUL_FOR_BLESS2
    end
    if getPlayerStorageValue(player, CONST_BLESS_2) == 2 then
        distance = CONST_MUL_FOR_BLESS2
    end
    if getPlayerStorageValue(player, CONST_BLESS_2) == 3 then
        attack = CONST_MUL_FOR_BLESS2
    end
    if getPlayerStorageValue(player, CONST_BLESS_2) == 4 then
        defense = CONST_MUL_FOR_BLESS2
    end
    db.asyncQuery("UPDATE `players` SET `maglevel`=".. ml ..", `manaspent`=0, `skill_club` = ".. attack ..", `skill_club_tries` = 0, `skill_sword` = ".. attack ..", `skill_sword_tries` = 0, `skill_axe` = ".. attack ..", `skill_axe_tries` = 0, `skill_dist` = ".. distance ..", `skill_dist_tries` = 0,`skill_shielding` = ".. defense ..", `skill_shielding_tries` = 0 WHERE `id` = " .. Player(player):getGuid() .. "")
end

function doResetSkills(player)
    db.asyncQuery("UPDATE `players` SET `maglevel`=1, `manaspent`=0, `skill_club` = 10, `skill_club_tries` = 0, `skill_sword` = 10, `skill_sword_tries` = 0, `skill_axe` = 10, `skill_axe_tries` = 0, `skill_dist` = 10, `skill_dist_tries` = 0,`skill_shielding` = 10, `skill_shielding_tries` = 0 WHERE `id` = " .. player:getGuid() .. "")
end