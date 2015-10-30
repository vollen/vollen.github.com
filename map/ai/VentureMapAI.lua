-----------------------------------------------
-- [FILE] VentureMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("VentureMapAI", package.seeall)
defclass("VentureMapAI", VentureMapAI, MapAI)

function init(self, cfg)
    super.init(self, cfg)

    self.failResean = 0

    self.getExp = 0
    self.getSilver = 0
    self.getCardGoodsList = {}
    self.getFixedGoodsList = {}

    self.star = 1
    self.result = 0

    self.ventureCfg = VentureModule.ventureCfg
    self.time = VentureModule.time
    self.room = VentureModule.room

    Msg:rg(self.onMsg, self, {HERO_DIE, MON_DIE, UNIT_DIE, HERO_DIE_ALL})
    VentureModule:rgTarget()
end

function enter(self)
    if not Map.isForceEnter then
        local p = Net.map_enter_c2s()
        p.mapid = Map.id
        p.inst  = Map.inst
        Net:send(p)
    else
        self:onEnterVenture()
    end
end

function clear(self)
    super.clear(self)

    Msg:rm(self, {HERO_DIE, MON_DIE, UNIT_DIE, HERO_DIE_ALL})
end

function onInit(self)
    super.onInit(self)

    for i, v in ipairs(self.cfg.mapdata.transOutList or {}) do
        if v.cond == TRANS_TIME then
            self.addTransTime = v.cond_data
        end
    end
    Touch:setCtlId(1002)
    self.ui = BaseFightUI
    self.ui:init()
    self.ui:addMapState("进度:" .. self.room .. "/" .. self.ventureCfg.total_room)
end

function onMons(self)
    super.onMons(self)
    for i,v in ipairs(self.cfg.mapdata.monList or {}) do
        self:addMon(v)
    end
end

function onLoop(self, dt)
    self.time = self.time - dt

    if self.time > 0 then
        self.ui:setMapTime(self.time, self.ventureCfg.duration)
    else
        self.time = 0
        self:finish(0, 1)
    end

    super.onLoop(self, dt)

    if self.addTransTime > self.lastTime then
        self:tryAddTrans(TRANS_TIME)
    end
end

function onStart(self)
    --3秒开始倒计时
    if not Map.isForceEnter then
        if self.ventureCfg.boss then
            self.ui:showStartTimer(3)
        else
            self.ui:showStartTimer(0)
        end
    end

    super.onStart(self)
end


function onFinish(self)
    if self.failResean == 2 then
        return
    end

    if self.result == 0 then
        VentureFinishPanel:show()
        Guide:event(GUIDE_VENTURE_FAIL, self.ventureCfg.mapId)
    else
        VentureRewardPanel:show()
        Guide:event(GUIDE_VENTURE_WIN, self.ventureCfg.mapId)
    end

    local p = Net.venture_info_c2s()
    Net:send(p)

    p = Net.venture_elite_info_c2s()
    Net:send(p)
end

function onTrans(self)
    super.onTrans(self)
    VentureModule.time = self.time
    if self:isLastRoom() then
        self:finish(1)
    else
        VentureModule.room = self.room + 1
        VentureModule.heroHp = Role.hero.attr.hp
        VentureModule.heroCareer = Role.hero.career
        Map:enter(SysMap:get(Map.id).next_map, 0, nil, true)
    end
end

function onPause(self)
    BasePausePanel:show()
    BasePausePanel:addResumeBtn()
    BasePausePanel:addBtn("重新开始", function() Guide:event(GUIDE_CLICK_BTN, 82030102); self:againHandler() end)
    BasePausePanel:addBtn("重选关卡", function() Guide:event(GUIDE_CLICK_BTN, 82030103); self:selectHandler() end)
    BasePausePanel:addBtn("返回主城", function() Guide:event(GUIDE_CLICK_BTN, 82030104); Game:gotoMain() end)
end

function onMsg(self, msgId, data)
    if msgId == HERO_DIE then

    elseif msgId == MON_DIE then
        self:onMonDie(data)
    elseif msgId == UNIT_DIE then
        self:onUnitDie(data)
    elseif msgId == HERO_DIE_ALL then
        self:finish(0, 3)
    end
end

function finish(self, result, reason)
    super.finish(self)
    self.result = result
    self.failResean = reason or 0

    if self.result == 1 then
        local func = function()
            Msg:send(VENTURE_TARGET, {id = TARGET_HP, curNum = Role.hero.attr.hp/Role.hero.attr.hpFull*100})
            Msg:send(VENTURE_TARGET, {id = TARGET_TIME, curNum = self.ventureCfg.duration - self.time})
            for i = 2, 3 do
                if VentureModule.targetList[i].state then
                    self.star = self.star + 1
                end
            end
            local p = Net.venture_success_c2s()
            p.star = self.star
            p.time_cost = math.ceil(self.ventureCfg.duration - self.time)
            if VentureModule.getClue then
                p.got_clue = 1
            else
                p.got_clue = 0
            end
            Net:sync(p)
        end
        self:showSuccessEff(func)
    else
        local p = Net.venture_fail_c2s()
        p.reason = self.failResean
        Net:sync(p)
    end
end

function addHero(self, msg, class)
    local hero = super.addHero(self, msg, class)
    if VentureModule.heroHp then
        hero:setHp(VentureModule.heroHp)
    end
    return hero
end

function addTrans(self, cfg)
    if #self.transList > 0 then
        return
    end
    if self:isLastRoom() then

    else

    end
    super.addTrans(self, cfg)
end

function isLastRoom(self)
    local map = SysMap:get(Map.id)
    return not (map.next_map and map.next_map > 0)
end

function againHandler(self)
    self:finish(0, 2)
    VentureModule:enter(self.ventureCfg.mapId)
end

function selectHandler(self)
    self:finish(0, 2)
    VentureModule:ventureHandler()
end

function onMonDie(self, mon)
    self.monNum = self.monNum - 1
    if mon.flag == 1 then
        self.flagNum = self.flagNum - 1
    elseif mon.flag == 2 then
        local flag = self:tryAddTrans(TRANS_BOSS)
        if flag then
            return
        end
    elseif mon.flag == 3 then
        self:finish(0, 3)
        return
    end
    if self.monNum == 0 then
        local flag = self:tryAddTrans(TRANS_MON)
        if flag then
            return
        end
    end
    if self.flagNum == 0 then
        local flag = self:tryAddTrans(TRANS_FLAG)
        if flag then
            return
        end
    end
end

function onUnitDie(self, unit)
    if unit.flag == 1 then
        self.flagNum = self.flagNum - 1
    elseif unit.flag == 2 then
        local flag = self:tryAddTrans(TRANS_BOSS)
        if flag then
            return
        end
    elseif unit.flag == 3 then
        self:finish(0, 3)
        return
    end
    if self.flagNum == 0 then
        local flag = self:tryAddTrans(TRANS_FLAG)
        if flag then
            return
        end
    end
end
