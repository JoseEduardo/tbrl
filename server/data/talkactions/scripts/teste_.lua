local CONST_ARENA_IN_BATTLE = 9998

function onSay(player, words, param)
print(getPlayerStorageValue(player, CONST_ARENA_IN_BATTLE))	
--[[
	player:addSkillTries(SKILL_DISTANCE, - player:getSkillTries(SKILL_DISTANCE))
    player:addSkillTries(SKILL_CLUB, - player:getSkillTries(SKILL_CLUB))
    player:addSkillTries(SKILL_SWORD, - player:getSkillTries(SKILL_SWORD))
    player:addSkillTries(SKILL_AXE, - player:getSkillTries(SKILL_AXE))
    player:addSkillTries(SKILL_SHIELD, - player:getSkillTries(SKILL_SHIELD))
]]
	--player:removeExperience(player:getExperience(), false)
end