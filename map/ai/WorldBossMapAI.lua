-----------------------------------------------
-- [FILE] WorldBossMapAI.lua
-- [DATA] 2015-10-30
-- [CODE] BY gaofeng
-- [MARK] NONE
-----------------------------------------------

module("WorldBossMapAI", package.seeall)
defclass("WorldBossMapAI", WorldBossMapAI, BattleMapAI)

function onInit(self)
    super.onInit(self)

    --时间
    self.totalTime = SysActivityPeriod:get(ACTIVITY_WORLDBOSS, 4).duration
    self.boss = nil
end

--时间
function onLoop(self, dt)
    local timeLeft = WorldBossModule:getLeftTime()
    if timeLeft > 0 then
        self.ui:setMapTime(timeLeft, self.totalTime)
    else
        self.ui:setMapTime(0, self.totalTime)
    end

    super.onLoop(self, dt)
end

function addHero(self, msg, class)
    local hero = super.addHero(self, msg, class)
    if hero then
        --攻击加成
        local addi = (WorldBossModule.singleInspire + WorldBossModule.teamInspire + WorldBossModule.speedInspire) 
        hero.attr.att = (1 + addi / 100) * hero.attr.att  --攻击
    end
    return hero
end

function addMon(self, msg, class)
    local mon = super.addMon(self, msg, class)
    -- if mon.monid == WorldBossModule.bossId then
    if mon and mon.isMon then
        self.boss = mon
        self.boss.attr.hpFull =  WorldBossModule.bossHpTotal
        self.boss:setHp(self.boss.attr.hp, true)
    end
    return mon
end

function setBossHp(self, hp)
    if self.boss and not self.boss.dead then
        self.boss:setHp(hp)
        if hp == 0 then
            self.boss:die(1)
        end
    end
end

function setBossHpMax(self)
    if self.boss and not self.boss.dead then
        self.boss.attr.hpFull =  WorldBossModule.bossHpTotal
        self.boss:setHp(self.boss.attr.hp, true)
    end
end

function onFinish (self)
    super.onFinish (self)
    self:finish()

    Role:delAllOtherPlayers()
    self.isEntered = false
    self.boss = nil
end
