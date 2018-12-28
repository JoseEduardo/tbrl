local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
 
function onCreatureAppear(cid)                npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)            npcHandler:onCreatureDisappear(cid)            end
function onCreatureSay(cid, type, msg)        npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                            npcHandler:onThink()                        end
 
local PremiumSpells = false
local AllSpells = true
-- 1,5 Sorcerer
-- 2,6 Druid
-- 3,7 Paladin
-- 4,8 Knight
local spells = {
    [5706] = { buy = 100, spell = "Find Person", name = "Level 008: Find Person", vocations = {1,2,3,4,5,6,7,8}, level = 8, premium = 1},
    [8704] = { buy = 20, spell = "Light Healing", name = "Level 008: Light Healing", vocations = {1,2,3,5,6,7}, level = 8, premium = 1},
    [7618] = { buy = 100, spell = "Wound Cleansing", name = "Level 008: Wound Cleansing", vocations = {4,8}, level = 8, premium = 1},
    [2120] = { buy = 10, spell = "Magic Rope", name = "Level 009: Magic Rope", vocations = {1,2,3,4,5,6,7,8}, level = 9, premium = 1},
    [10092] = { buy = 10, spell = "Cure Poison", name = "Level 010: Cure Poison", vocations = {1,2,3,4,5,6,7,8}, level = 10, premium = 1},
    [2287] = { buy = 120, spell = "Energy Strike", name = "Level 012: Energy Strike", vocations = {1,2,5,6}, level = 12, premium = 1},
    [1386] = { buy = 30, spell = "Levitate", name = "Level 012: Levitate", vocations = {1,2,3,4,5,6,7,8}, level = 12, premium = 1},
    [2051] = { buy = 2, spell = "Great Light", name = "Level 013: Great Light", vocations = {1,2,3,4,5,6,7,8}, level = 13, premium = 1},
    [2544] = { buy = 70, spell = "Conjure Arrow", name = "Level 013: Conjure Arrow", vocations = {3,7}, level = 13, premium = 1},
    [1490] = { buy = 120, spell = "Terra Strike", name = "Level 013: Terra Strike", vocations = {1,2,5,6}, level = 13, premium = 1},
    [2169] = { buy = 30, spell = "Haste", name = "Level 014: Haste", vocations = {1,2,3,4,5,6,7,8}, level = 14, premium = 1},
    [1489] = { buy = 120, spell = "Flame Strike", name = "Level 014: Flame Strike", vocations = {1,2,5,6}, level = 14, premium = 1},
    [2671] = { buy = 60, spell = "Food", name = "Level 014: Food", vocations = {2,6}, level = 14, premium = 1},
    [2523] = { buy = 600, spell = "Magic Shield", name = "Level 014: Magic Shield", vocations = {1,2,5,6}, level = 14, premium = 1},
    [6683] = { buy = 120, spell = "Ice Strike", name = "Level 015: Ice Strike", vocations = {1,2,5,6}, level = 15, premium = 1},
    [2383] = { buy = 120, spell = "Brutal Strike", name = "Level 016: Brutal Strike", vocations = {4,8}, level = 16, premium = 1},
    [2545] = { buy = 70, spell = "Conjure Poisoned Arrow", name = "Level 016: Conjure Poisoned Arrow", vocations = {3,7}, level = 16, premium = 1},
    [6300] = { buy = 120, spell = "Death Strike", name = "Level 016: Death Strike", vocations = {1,5}, level = 16, premium = 1},
    [2376] = { buy = 120, spell = "Physical Strike", name = "Level 016: Physical Strike", vocations = {2,6}, level = 16, premium = 1},
    [2543] = { buy = 80, spell = "Conjure Bolt", name = "Level 017: Conjure Bolt", vocations = {3,7}, level = 17, premium = 1},
    [7488] = { buy = 200, spell = "Heal Friend", name = "Level 018: Heal Friend", vocations = {2,6}, level = 18, premium = 1},
    [1487] = { buy = 150, spell = "Fire Wave", name = "Level 018: Fire Wave", vocations = {1,5}, level = 18, premium = 1},
    [6684] = { buy = 150, spell = "Ice Wave", name = "Level 018: Ice Wave", vocations = {2,6}, level = 18, premium = 1},
    [5787] = { buy = 2000, spell = "Challenge", name = "Level 020: Challenge", vocations = {8}, level = 20, premium = 1},
    [2265] = { buy = 350, spell = "Intense Healing", name = "Level 020: Intense Healing", vocations = {1,2,3,5,6,7}, level = 20, premium = 1},
    [2206] = { buy = 300, spell = "Strong Haste", name = "Level 020: Strong Haste", vocations = {1,2,5,6}, level = 20, premium = 1},
    [1504] = { buy = 40, spell = "Cure Electrification", name = "Level 022: Cure Electrification", vocations = {2,6}, level = 22, premium = 1},
    [2389] = { buy = 150, spell = "Ethereal Spear", name = "Level 023: Ethereal Spear", vocations = {3,7}, level = 23, premium = 1},
    [5024] = { buy = 400, spell = "Energy Beam", name = "Level 023: Energy Beam", vocations = {1,5}, level = 23, premium = 1},
    [13929] = { buy = 120, spell = "Creature Illusion", name = "Level 023: Creature Illusion", vocations = {1,2,5,6}, level = 23, premium = 1},
    [7364] = { buy = 120, spell = "Conjure Sniper Arrow", name = "Level 024: Conjure Sniper Arrow", vocations = {3,7}, level = 24, premium = 1},
    [2546] = { buy = 120, spell = "Conjure Explosive Arrow", name = "Level 025: Conjure Explosvie Arrow", vocations = {3,7}, level = 25, premium = 1},
    [2195] = { buy = 200, spell = "Charge", name = "Level 025: Charge", vocations = {4,8}, level = 25, premium = 1},
    [9007] = { buy = 300, spell = "Summon Creature", name = "Level 025: Summon Creature", vocations = {1,2,5,6}, level = 25, premium = 1},
    [2202] = { buy = 10, spell = "Cancel Invisibility", name = "Level 026: Cancel Invvisibility", vocations = {3,7}, level = 26, premium = 1},
    [2308] = { buy = 40, spell = "Ignite", name = "Level 026: Ignite", vocations = {1,5}, level = 26, premium = 1},
    [2163] = { buy = 5, spell = "Ultimate Light", name = "Level 026: Ultimate Light", vocations = {1,2,5,6}, level = 26, premium = 1},
    [13883] = { buy = 120, spell = "Whirlwind Throw", name = "Level 028: Whirlwind Throw", vocations = {4,8}, level = 28, premium = 1},
    [2315] = { buy = 180, spell = "Great Energy Beam", name = "Level 029: Great Energy Beam", vocations = {1,5}, level = 29, premium = 1},
    [8474] = { buy = 200, spell = "Cure Burning", name = "Level 030: Cure Burning", vocations = {2,6}, level = 30, premium = 1},
    [2273] = { buy = 100, spell = "Ultimate Healing", name = "Level 030: Ultimate Healing", vocations = {1,2,5,6}, level = 30, premium = 1},
    [18492] = { buy = 400, spell = "Enchant Party", name = "Level 032: Enchant Party", vocations = {1,5}, level = 32, premium = 1},
    [18491] = { buy = 400, spell = "Protect Party", name = "Level 032: Protect Party", vocations = {3,7}, level = 32, premium = 1},
    [18489] = { buy = 400, spell = "Heal Party", name = "Level 032: Heal Party", vocations = {2,6}, level = 32, premium = 1},
    [18490] = { buy = 400, spell = "Train Party", name = "Level 032: Train Party", vocations = {4,8}, level = 32, premium = 1},
    [1505] = { buy = 150, spell = "Groundshaker", name = "Level 033: Groundshaker", vocations = {4,8}, level = 33, premium = 1},
    [7363] = { buy = 85, spell = "Conjure Piercing Bolt", name = "Level 033: Conjure Piercing Bolt", vocations = {3,7}, level = 33, premium = 1},
    [1491] = { buy = 250, spell = "Electrify", name = "Level 034: Electrify", vocations = {1,5}, level = 34, premium = 1},
    [7588] = { buy = 300, spell = "Divine Healing", name = "Level 035: Divine Healing", vocations = {3,7}, level = 35, premium = 1},
    [2393] = { buy = 250, spell = "Berserk", name = "Level 035: Berserk", vocations = {4,8}, level = 35, premium = 1},
    [2165] = { buy = 200, spell = "Invisibility", name = "Level 035: Invisibility", vocations = {1,2,5,6}, level = 35, premium = 1},
    [8919] = { buy = 220, spell = "Mass Healing", name = "Level 036: Mass Healing", vocations = {2,6}, level = 36, premium = 1},
    [2279] = { buy = 250, spell = "Energy Wave", name = "Level 038: Energy Wave", vocations = {1,5}, level = 38, premium = 1},
    [2289] = { buy = 250, spell = "Terra Wave", name = "Level 038: Terra Wave", vocations = {2,6}, level = 38, premium = 1},
    [2295] = { buy = 180, spell = "Divine Missile", name = "Level 040: Divine Missile", vocations = {3,7}, level = 40, premium = 1},
    [1903] = { buy = 250, spell = "Inflict Wound", name = "Level 040: Inflict Wound", vocations = {4,8}, level = 40, premium = 1},
    [671] = { buy = 500, spell = "Strong Ice Wave", name = "Level 040: Strong Ice Wave", vocations = {2,6}, level = 40, premium = 1},
    [2433] = { buy = 200, spell = "Enchant Staff", name = "Level 041: Enchant Staff", vocations = {5}, level = 41, premium = 1},
    [7367] = { buy = 200, spell = "Enchant Spear", name = "Level 045: Enchant Spear", vocations = {3,7}, level = 45, premium = 1},
    [6558] = { buy = 200, spell = "Cure Bleeding", name = "Level 045: Cure Bleeding", vocations = {2,4,6,8}, level = 45, premium = 1},
    [2298] = { buy = 300, spell = "Divine Caldera", name = "Level 050: Divine Caldera", vocations = {3,7}, level = 50, premium = 1},
    [1496] = { buy = 500, spell = "Envenom", name = "Level 050: Envenom", vocations = {2,6}, level = 50, premium = 1},
    [6132] = { buy = 400, spell = "Recovery", name = "Level 050: Recovery", vocations = {3,4,7,8}, level = 50, premium = 1},
    [8920] = { buy = 600, spell = "Rage of the Skies", name = "Level 055: Rage of the Skies", vocations = {1,5}, level = 55, premium = 1},
    [2522] = { buy = 600, spell = "Protector", name = "Level 055: Protector", vocations = {4,8}, level = 55, premium = 1},
    [2309] = { buy = 500, spell = "Lightning", name = "Level 055: Lightning", vocations = {1,5}, level = 55, premium = 1},
    [11303] = { buy = 600, spell = "Swift Foot", name = "Level 055: Swift Foot", vocations = {3,7}, level = 55, premium = 1},
    [4208] = { buy = 600, spell = "Wrath of Nature", name = "Level 055: Wrath of Nature", vocations = {2,6}, level = 55, premium = 1},
    [2547] = { buy = 200, spell = "Conjure Power Bolt", name = "Level 059: Conjure Power Bolt", vocations = {7}, level = 59, premium = 1},
    [9110] = { buy = 650, spell = "Eternal Winter", name = "Level 060: Eternal Winter", vocations = {2,6}, level = 60, premium = 1},
    [7416] = { buy = 650, spell = "Blood Rage", name = "Level 060: Blood Rage", vocations = {4,8}, level = 60, premium = 1},
    [2187] = { buy = 650, spell = "Hell's Core", name = "Level 060: Hell's Core", vocations = {1,5}, level = 60, premium = 1},
    [7591] = { buy = 650, spell = "Salvation", name = "Level 060: Salvation", vocations = {3,7}, level = 60, premium = 1},
    [5777] = { buy = 300, spell = "Sharpshooter", name = "Level 060: Sharpshooter", vocations = {3,7}, level = 60, premium = 1},
    [8930] = { buy = 400, spell = "Front Sweep", name = "Level 070: Front Sweep", vocations = {4,8}, level = 70, premium = 1},
    [2300] = { buy = 450, spell = "Holy Flash", name = "Level 070: Holy Flash", vocations = {3,7}, level = 70, premium = 1},
    [8062] = { buy = 400, spell = "Strong Terra Strike", name = "Level 070: Strong Terra Strike", vocations = {2,6}, level = 70, premium = 1},
    [1492] = { buy = 400, spell = "Strong Flame Strike", name = "Level 070: Strong Flame Strike", vocations = {1,2,5,6}, level = 70, premium = 1},
    [2268] = { buy = 400, spell = "Curse", name = "Level 075: Curse", vocations = {1,5}, level = 75, premium = 1},
    [6301] = { buy = 100, spell = "Cure Curse", name = "Level 080: Cure Curse", vocations = {3,7}, level = 80, premium = 1},
    [8473] = { buy = 400, spell = "Intense Wound Cleansing", name = "Level 080: Intense Wound Cleansing", vocations = {4,8}, level = 80, premium = 1},
    [6686] = { buy = 240, spell = "Strong Ice Strike", name = "Level 080: Strong Ice Strike", vocations = {2,6}, level = 80, premium = 1},
    [2311] = { buy = 240, spell = "Strong Energy Strike", name = "Level 080: Strong Energy Strike", vocations = {1,5}, level = 80, premium = 1},
    [2421] = { buy = 240, spell = "Fierce Berserk", name = "Level 090: Fierce Berserk", vocations = {4,8}, level = 90, premium = 1},
    [7378] = { buy = 800, spell = "Strong Ethereal Spear", name = "Level 090: Strong Ethereal Spear", vocations = {3,7}, level = 90, premium = 1},
    [7465] = { buy = 90, spell = "Ultimate Flame Strike", name = "Level 090: Ultimate Flame Strike", vocations = {1,5}, level = 90, premium = 1},
    [12334] = { buy = 90, spell = "Ultimate Terra Strike", name = "Level 090: Ultimate Terra Strike", vocations = {2,6}, level = 90, premium = 1},
    [2640] = { buy = 300, spell = "Intense Recovery", name = "Level 100: Intense Recovery", vocations = {3,4,7,8}, level = 100, premium = 1},
    [10547] = { buy = 90, spell = "Ultimate Energy Strike", name = "Level 100: Ultimate Energy Strike", vocations = {1,5}, level = 100, premium = 1},
    [2271] = { buy = 90, spell = "Ultimate Ice Strike", name = "Level 100: Ultimate Ice Strike", vocations = {2,6}, level = 100, premium = 1},
    [2390] = { buy = 400, spell = "Annihilation", name = "Level 110: Annihilator", vocations = {4,8}, level = 110, premium = 1},
}
 
function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
 
    local shopWindow = {}
    local player = Player(cid)
    local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
 
    local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
        selfSay("You have choosen the spell: " .. spells[item].spell .. " which costs " .. spells[item].buy .. " gold.", cid)
     
        local player = Player(cid)
        if player:hasLearnedSpell(spells[item].spell) then
            return selfSay("You already know this spell.", cid)
        end
--[[     
        if player:getLevel() < spells[item].level then
            return selfSay("You need to obtain a level of " .. spells[item].level .. " or higher to be able to learn this spell.", cid)
        end
]]
--[[
        if not isInArray(spells[item].vocations, player:getVocation():getId()) then
            return selfSay("This spell is not for your vocation.", cid)
        end
]]
        if PremiumSpells and (spells[item].premium == 1) and not player:isPremium() then
            return selfSay("You need to be premium in order to obtain this spell.", cid)
        end
 
        if player:getMoney() < spells[item].buy then
            return selfSay("You don't have enough money.", cid)
        end
 
        player:removeMoney(spells[item].buy)
        player:learnSpell(spells[item].spell)
        player:getPosition():sendMagicEffect(12)
        selfSay("You have learned " .. spells[item].spell, cid)
        return true
    end
 
    if msgcontains(msg, "spells") then
        selfSay("Here are the spells that you can learn from me.", cid)
        for var, item in pairs(spells) do
            if not AllSpells then
                if not player:hasLearnedSpell(item.spell) then
                    if player:getLevel() >= item.level then
                        if isInArray(item.vocations, player:getVocation():getId()) then
                            if PremiumSpells then
                                if (item.premium == 1) and player:isPremium() then
                                    table.insert(shopWindow, {id = var, subType = 0, buy = item.buy, sell = 0, name = item.spell})
                                end
                            else
                                table.insert(shopWindow, {id = var, subType = 0, buy = item.buy, sell = 0, name = item.spell})
                            end
                        end
                    end
                end
            else
                table.insert(shopWindow, {id = var, subType = 0, buy = item.buy, sell = 0, name = item.spell})
            end
        end
        openShopWindow(cid, shopWindow, onBuy, onSell)
    end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())