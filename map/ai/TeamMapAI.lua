-----------------------------------------------
-- [FILE] TeamMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("TeamMapAI", package.seeall)
defclass("TeamMapAI", TeamMapAI, BattleMapAI)


function onInit(self)
    super.onInit(self)

    --时间
    self.totalTime = SysTeamventure:get(Map.id).time_limit
    --复活
    self.reviveTime = 10

    --幸运宝箱
    self.luckUnitX = nil
    self.luckUnitY = nil
    self.luckUnitWait = false
    self.luckUnitTag = "lucyUnit"
    self.luckGoods = {}
    self.luckPanel = TeamLuckPanel
    Msg:rg(self.onMsg, self, {ROLE_DESTORY, HERO_DIE_ALL})

    ChatTray:setChannel(ChatModule.TEAM)
end

function onEnterBatt(self, msg)
    super.onEnterBatt(self, msg)
    --时间
    self.timeLeft = msg.secs_left
end

function addHero(self, msg, class)
    local hero  = super.addHero(self, msg, class)
    --后端发来血量为0 表示在死亡状态
    if msg.hp == 0 then
        FightHead:sucide()
    end
    return hero
end

function addBattPlayer(self, msg, class)
    local role = super.addBattPlayer(self, msg, class)
    if role and role.attr.hp == 0 then
        role:die(1)
    end

    return role
end

function onLoop(self, dt)
    self.timeLeft = self.timeLeft - dt
    if self.timeLeft > 0 then
        self.ui:setMapTime(self.timeLeft, self.totalTime)
    else
        self.ui:setMapTime(0, self.totalTime)
    end

    super.onLoop(self, dt)
end

function onMsg(self, msgId, msgData)
    if msgId == ROLE_DESTORY then
        if msgData.isMon then
            self:onMonDestory(msgData)
        end
    elseif msgId == HERO_DIE_ALL then
        self:onHeroDieAll()
    elseif msgId == TEAM_OPEN_LUCK then
        local p = Net.map_luck_open_c2s()
        Net:send(p)
        self:onLuckOpen(true)
    end
end

function onMonDestory(self, mon)
    self.monNum = self.monNum - 1
    if self.monNum == 0 then
        self.luckUnitX = mon.x
        self.luckUnitY = mon.y

        if self.luckUnitWait then
            self:showLuckUnit()
        end
    end
end

--复活倒计时
function onHeroDieAll(self)
    local group = Role.hero and Role.hero.group
    for id, role in pairs(Role.roles) do
        if not group or role.group == group then
            Map:setFollow(role)
        end
    end

    self.ui:showCountDown(self.reviveTime, false, true, function ()
        self:enter()
    end)
end


--[[收到幸运掉落]]
function onGetLuck(self, list)
    if #list == 0 then return end
    self.luckGoods = list
    self:showLuckUnit()
end

--显示幸运宝箱机关
function showLuckUnit(self)
    if not self.luckUnitX or self.monNum > 0 then
        self.luckUnitWait = true
    else
        local data = {
            id = 304011,
            data = TEAM_OPEN_LUCK,
            uniqueId = self.luckUnitTag,
        }

        Unit:callUnit(data, self.luckUnitX, self.luckUnitY)
        self.luckUnitWait = false
        self.luckUnitX = nil
        self.luckUnitY = nil
        Msg:rg(self.onMsg, self, TEAM_OPEN_LUCK)
    end
end

function onLuckOpen(self, isLocal)
    local unit = Unit:getUnitByTag(self.luckUnitTag)
    if unit then
        unit:die()
    end

    --收到后端消息，才打开界面
    if isLocal then return false end

    Msg:rm(self, TEAM_OPEN_LUCK)
    self.luckPanel:show(self.pvpList, self.luckGoods)
    return true
end

--暂停
function onPause(self)
    local dlg = Dialog:new("强制退出副本", 210)
    dlg:showBtnClose(function() dlg:hide() end)
    dlg:showBtnL("取消", function() dlg:hide() end)
    dlg:showBtnR("退出", function()
        Game:gotoMain(MAP_LEAVE_GIVEUP)
        dlg:hide()
    end)

    dlg:setString("强制退出副本将会领取已获得的奖励，但会让队友陷入苦战，真的要放弃他们吗？")
end
