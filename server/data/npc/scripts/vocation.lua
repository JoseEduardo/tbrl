local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local countBless = {}
local blesskeywords = {['magic']={id=1}, ['distance']={id=2}, ['attack']={id=3}, ['defense']={id=4}}
local CONST_BLESS_1 = 6899
local CONST_BLESS_2 = 6898

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end
function onPlayerEndTrade(cid)              npcHandler:onPlayerEndTrade(cid)            end
function onPlayerCloseChannel(cid)          npcHandler:onPlayerCloseChannel(cid)        end
 
function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
 
    local talkUser = cid
    local player = Player(cid)
    for var, item in pairs(blesskeywords) do
        if msgcontains(msg, var) then
            selfSay('Do you want me to grant you ' .. var .. ' blessing?',cid)
            talkState[talkUser] = 90+item.id
            countBless[talkUser] = countBless[talkUser] ~= nil and countBless[talkUser]+1 or 1
            return true
        end
    end

    if msgcontains(msg, "yes") and talkState[talkUser] > 90 and talkState[talkUser] < 95 then
        if countBless[talkUser] == 1 then
            if getPlayerStorageValue(cid, CONST_BLESS_1) == talkState[talkUser]-90 then
                talkState[talkUser] = 0
                selfSay("You already have this blessing!", cid)
            else
                setPlayerStorageValue(cid, CONST_BLESS_1, talkState[talkUser]-90)
                talkState[talkUser] = 0
                selfSay("Choose second bless please!", cid)
            end
        elseif countBless[talkUser] == 2 then
            if getPlayerStorageValue(cid, CONST_BLESS_2) == talkState[talkUser]-90 then
                talkState[talkUser] = 0
                selfSay("You already have this blessing!", cid)
            else
                setPlayerStorageValue(cid, CONST_BLESS_2, talkState[talkUser]-90)
                talkState[talkUser] = 0
                selfSay("I need to send you somewhere far away from here, okay?", cid)
                talkState[talkUser] = 80
            end
        end
        return true
    end
    if (msgcontains(msg, "yes") or msgcontains(msg, "ok")) and talkState[talkUser] == 80 then
        doAdjustePlayerForBless(cid)
        player:teleportTo(player:getTown():getTemplePosition())
        player:remove()
    end

    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
