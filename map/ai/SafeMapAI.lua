-----------------------------------------------
-- [FILE] SafeMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------
module("SafeMapAI", package.seeall)
defclass("SafeMapAI", SafeMapAI, MapAI)

function onInit(self)
    super.onInit(self)

    Map.terrain:initLineMap()

    Touch:setCtlId(1001)

    CaptureModule:checkResult()
end

function addHero(self, msg)
    self:addNpc()

    local hero = super.addHero(self, msg, HeroForSafeMap)
    hero.hpBar:setVisible(false)
    --设置初始位置
    local pos = Map.lastPosList[Map.id]
    if pos then
        hero:setXY(pos.x, pos.y)
        hero:netSyncStand()
        Map:setFollow(hero, winSize.width/2, winSize.height/3)
    end

    --设置跟随队长
    local vo = TeamModule:getMyTeamVo()
    if vo and vo.status == 1 and Vo.team.leaderId ~= Vo.player.id then
        hero:setFollow(Vo.team.leaderId, TeamModule:getMyTeamPos()-1)
    end
    --召唤队员
    if Vo.team.id ~= 0 and Vo.team.leaderId == Vo.player.id then
        local p = Net.team_beckon_c2s()
        Net:send(p)
    end
end

function addSafePlayer(self, msg, class)
    local player = super.addSafePlayer(self, msg, class)
    if player then
        player.hpBar:setVisible(false)
    end
end

function addNpc(self)
    --NPC
    for id,sys in pairs(ClientTaskNpc.data) do
        if sys.mapid == Map.id then
            Npc:new(sys, sys.x, sys.y)
        end
    end
    TaskModule:setNpcTask()
end
