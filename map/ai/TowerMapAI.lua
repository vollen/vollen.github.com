-----------------------------------------------
-- [FILE] TowerMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("TowerMapAI", package.seeall)
defclass("TowerMapAI", TowerMapAI, TeamMapAI)

function onInit(self)
    super.onInit(self)

    self.wave = 1
    self.waveCnt = TowerModule.mapList[Map.id].waveCnt
    self.card = nil
    self.finishMsg = nil
    self.nextTime = nil
    self.nextTimeLab = nil
    self.finishTime = 0

    --复活时间
    local reviveCfg = SysConf:get("tower", "revive_secs")
    self.reviveTime = reviveCfg[1]
    self.reviveTimeAdd = reviveCfg[2]
    self.reviveTimeMax = reviveCfg[3]
end

function onStart(self)
    local waitT = SysConf:get("tower", "pre_wait_secs")
    local nextTime = waitT - 2 - (self.totalTime - self.timeLeft)
    self:showNextTime(nextTime)
    self.ui:showCountDown(nextTime, false, false, nil, "pic/uires/JieMian/ZhanDouJieMian/KaiShiDaoJiShi/%s.png", -1)
    super.onStart(self)
end

function onLoop(self, dt)
    if self.finishTime ~= 0 then
        self.timeLeft = self.totalTime - self.finishTime
    end

    super.onLoop(self, dt)

    if self.nextTime then
        local left = self.nextTime - os.time()
        if left <=0 then
            self:hideNextTime()
        elseif self.nextTimeLab then
            local str = string.format("下一波敌人将在%d秒后出现（%d/%d）", math.ceil(left), self.wave, self.waveCnt)
            self.nextTimeLab:setString(str)
        else 
            self:showNextTime(self.nextTime)
        end
    end
end

function addMon(self, msg, class)
    super.addMon(self, msg, class)

    if self.nextTime then
        self:hideNextTime()
    end
end

function onMsg(self, msgId, msgData)
    super.onMsg(self, msgId, msgData)

    if msgId == TEAM_LUCK_HIDE then
        self:showCardPanel()
        Msg:rm(self, TEAM_LUCK_HIDE)
    elseif msgId == TOWER_CARD_FINISH then
        self:showFinishPanel()
        Msg:rm(self, TOWER_CARD_FINISH)
    end
end

function onWaveEnd(self, msg)
    self.card = msg.card
    self.wave = self.wave + 1
    --复活
    if (not Role.hero) or Role.hero.dead then
        self.ui:hideCountDown()
    end

    if msg.luck and #msg.luck > 0 then
        Msg:rg(self.onMsg, self, {TEAM_LUCK_HIDE})
    else
        self:showCardPanel()
        self:showNextTime(os.time() + SysConf:get("tower", "card_secs"))
    end

    --结束时间
    if self.wave > self.waveCnt then
        self.finishTime = self.totalTime - self.timeLeft
    end
end

function onFightEnd(self, msg)
    self.finishMsg = msg

    --胜利等抽牌，失败直接结束
    if msg.result == 1 and self.card and #self.card > 0 then
        Msg:rg(self.onMsg, self, TOWER_CARD_FINISH)
    else
        self:showFinishPanel()
    end
end

function showFinishPanel(self)
    self:finish()
    self:hideNextTime()
    
    TeamFinishPanel:show(self.finishMsg.summary, self.finishTime, self.finishMsg.result)
    TeamFinishPanel:setExitCall(TowerModule.show, TowerModule)
end

function onWaveInfo(self, wave)
    self.wave = wave
end

function showCardPanel(self)
    if self.card and #self.card > 0 then
        TowerCardPanel:show(self.wave - 1, self.card)
        self.card =  nil
    else
        Msg:send(TOWER_CARD_FINISH)
    end

    if self.finishMsg then
        self:finish()
    end
end

function showNextTime(self, time)
    if self.finishTime then
        return
    end

    self.nextTime = time
    if not self.nextTimeLab and self.ui then
        self.nextTimeLab = ccui.Text:create()
        self.nextTimeLab:setFontSize(30)
        self.nextTimeLab:setFontName(FONT_TEXT)
        self.nextTimeLab:setColor(COLOR_SYSTEM)
        self.nextTimeLab:setPosition(UI.Middle, UI.Top - 150)
        self.ui:addChild(self.nextTimeLab)
    else
        self.nextTimeLab:setVisible(true)
    end
end

function hideNextTime(self)
    if self.nextTimeLab then
        self.nextTimeLab:setVisible(false)
    end
    self.nextTime = nil
end

function onHeroDieAll(self)
    super.onHeroDieAll(self)

    self.reviveTime = math.min(self.reviveTime + self.reviveTimeAdd,  self.reviveTimeMax)
end

function onLuckOpen(self, isLocal)
    if super.onLuckOpen(self, isLocal) then
        local time = SysConf:get("tower", "lucky_secs")
        self.luckPanel:setLastTime(time)

        self:showNextTime(os.time() + SysConf:get("tower", "card_secs") + time)
    end
end
