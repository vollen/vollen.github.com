-----------------------------------------------
-- [FILE] MapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("MapAI", package.seeall)
defclass("MapAI", MapAI)

function init(self, cfg)
    self.state  = MAP_ST_WAIT
    self.sync   = ROLE_SYNC_NONE
    self.cfg    = cfg
    self.ui     = nil

    --是否是同步地图
    self.isSyncMap = (self.cfg.type ~= 3)

    self.monNum = 0
    self.flagNum = 0

    self.pvpList = {} --玩家各个角色信息{[id]->info, ...}
    self.pveList = {} --同步怪物id列表{id1, id2, ...}

    self.transList = {}
    self.canTrans = false

    self.addTransTime = 0
    self.lastTime = 0

    self.msgFlag        = false
    self.msgMons        = nil
    self.msgHero        = nil
    self.msgSafePlayer  = nil
    self.msgBattPlayer  = nil

    self:enter()
end

function clear(self)
    self.msgFlag        = false
end

function update(self, dt)
    if self.state == MAP_ST_LOOP then
        self:onLoop(dt)
    elseif self.state == MAP_ST_INIT then
        self:onInit()
    elseif self.state == MAP_ST_UNIT then
        self:onUnit()
    elseif self.state == MAP_ST_MONS then
        self:onMons()
    elseif self.state == MAP_ST_HERO then
        self:onHero()
    elseif self.state == MAP_ST_GAME then
        self:onStart()
    elseif self.state == MAP_ST_WAIT then
        if self.msgFlag then
            self.state = MAP_ST_INIT
        end
    end
end

function onInit(self)
    self.state = MAP_ST_UNIT

    if self.cfg.music then
        Audio:playMusic(self.cfg.music)
    end

    self:tryAddTrans(TRANS_OPEN)
end

function onUnit(self)
    self.state = MAP_ST_MONS
    for i, v in ipairs(self.cfg.mapdata.unitList or {}) do
        local unit = Unit:create(v)
    end
end

function onMons(self)
    self.state = MAP_ST_HERO

    if self.msgMons then
        for i,v in ipairs(self.msgMons) do
            v.ignoreBorn = true
            self:addMon(v)
        end
    end

    if self.msgSafePlayer then
        for i,v in ipairs(self.msgSafePlayer) do
            self:addSafePlayer(v)
        end
    end

    if self.msgBattPlayer then
        for i,v in ipairs(self.msgBattPlayer) do
            self:addBattPlayer(v)
        end
    end
end

function onHero(self)
    self.state = MAP_ST_GAME

    if self.msgHero then
        self:addHero(self.msgHero)
    end
end

function onLoop(self, dt)
    self.lastTime = self.lastTime + dt
    if self.canTrans and Role.hero then
        local x, y = Role.hero.x, Role.hero.y
        for i, v in pairs(self.transList) do
            if math.abs(x-v.x) < 30 and math.abs(y-v.y) < 30 then
                self:onTrans(v)
                break
            end
        end
    end
end

function onSync(self, flag)
    --trace("mon sync flag: ", self.sync, flag)
    if self.sync == flag then
        return
    end
    self.sync = flag
    for i,id in ipairs(self.pveList) do
        local mon = Role:get(id)
        if mon then
            mon:setSync(self.sync)
        end
    end
end

function onTrans(self, cfg)
    self.canTrans = false

    Map:setScale(1)
    Game:setTimeScale(1)
end

function onStart(self)
    self.state = MAP_ST_LOOP

    Guide.playFlag = false
    if Game:inMain() then
        Guide:event(GUIDE_GOTO_MAIN)
    end
    Guide:event(GUIDE_ENTER_MAP, Map.id)
    Guide:apply()
end

function onPause(self)
    self.ui:hideCountDown()
    BasePausePanel:show()
    BasePausePanel:addResumeBtn()
    BasePausePanel:addBtn("返回主城", Game.gotoMain, Game)
end

function onResume(self)

end

function enter(self)
    local p = Net.map_enter_c2s()
    p.mapid = Map.id
    p.inst  = Map.inst
    Net:send(p)
end


function onEnterSafe(self, msg)
    --uint16:	msg.inst	[实际地图实例]
    --uint16:	msg.x	[横坐标]
    --uint16:	msg.y	[纵坐标]
    --uint8:	msg.status	[状态]
    --uint32:	msg.status_data	[状态额外数据]	[loop]
    --p_safeplayer:	msg.players	[附近的玩家列表]	[loop]

    self.msgSafePlayer  = msg.players
    self.msgHero        = msg
    self.msgHero.sync   = ROLE_SYNC_SEND
    self.msgHero.quad   = true--发送格子信息

    Map.inst = msg.inst

    self.msgFlag = true
end

function onEnterBatt(self, msg)
    --uint16:	msg.x	[横坐标]
    --uint16:	msg.y	[纵坐标]
    --uint32:	msg.secs_left	[地图剩余时间]
    --uint8:	msg.career	[当前职业]
    --uint32:	msg.hp	[当前职业剩余血量]
    --uint32:	msg.group	[阵营]
    --uint16:	msg.watcher_count	[观战人数]
    --p_battplayer:	msg.players	[玩家列表]	[loop]
    --p_mon:	msg.mons	[怪物列表]	[loop]
    --p_unit:	msg.units	[机关列表]	[loop]

    self.msgBattPlayer  = msg.players
    self.msgMons        = msg.mons
    self.msgHero        = msg
    self.msgHero.sync   = ROLE_SYNC_SEND

    self.msgFlag = true
end

function onEnterVenture(self, msg)
    local x, y = 100, 300
    if self.cfg.mapdata.transInList and #self.cfg.mapdata.transInList >= 1 then
        local transIn = self.cfg.mapdata.transInList[1]
        x, y = transIn.x, transIn.y
    end
    self.msgHero = {x = x, y = y, career = VentureModule.heroCareer}
    self.msgHero.sync   = ROLE_SYNC_NONE

    self.msgFlag = true
end

function onFigureChange(self, msg)
    local role = Role:get(msg.player_id)
    if role then
        role:setShow(msg.hero_show)
        Pet:add(msg.player_id, msg.player_show.pet_id)
    else
        if msg.player_id == Vo.player.id then
            local info = {
                career = msg.hero_show.career,
                hero_show = msg.hero_show,
                player_show = msg.player_show,
            }
            self:addHero(info)
        else
            self:addSafePlayer(msg)
        end
    end
end

function onSetStatus (self, id, status, data)
    local role = Role:get(id)
    if role then
        if status == 0 then

        elseif status == 1 then

        end
    end
end

function finish(self)
    Game:pause(Map.view)
    Audio:stopMusic()
    self.state = MAP_ST_NONE
end

function onFinish(self)

end

function addMon(self, msg, class)
    local ignoreBorn = false
    local mon
    if msg.id then
        mon = Role:get(msg.id)
        if mon then
            mon:destroy()
            ignoreBorn = true
        end
    end

    local monid = msg.mon_id or msg.mid
    local moncfg = SysMon:get(monid)
    class = class or moncfg.ai_script or Mon

    if msg.lvl == nil or msg.lvl == 0 then
        if self.cfg.adaptlvl == 0 then
            msg.lvl = (moncfg.lvl == 0 and Vo.player.lvl or moncfg.lvl)
        else
            msg.lvl = self.cfg.adaptlvl
        end
    end

    local info = {
        id      = msg.id,
        monid   = monid,
        moncfg  = moncfg,

        lvl     = msg.lvl,
        name    = moncfg.name,
        group   = msg.group or moncfg.group,
        hp      = msg.hp,

        turn    = msg.turn,
        flag    = msg.flag,
        path    = msg.path,
        home_x  = msg.x,
        home_y  = msg.y,

        ignoreBorn = ignoreBorn or msg.ignoreBorn,
    }

    mon = class:new(info)
    mon:setXY(msg.x, msg.y)

    if info.id and info.hp then
        mon:setSync(self.sync)
        table.insert(self.pveList, mon.id)
    end

    self.monNum = self.monNum + 1
    if mon.flag == 1 then
        self.flagNum = self.flagNum + 1
    end

    return mon
end

function addHero(self, msg, class)
    class = class or Hero
    local x,y,sync,quad,group
    if Role.hero then
        x = Role.hero.x
        y = Role.hero.y
        sync = Role.hero.syncFlag
        quad = Role.hero.syncQuad
        group = Role.hero.group
        Role.hero:destroy()
    end


    local player = Vo.player
    local career = msg.career or player.orderList[1]
    local attr   = FightUtil:getFightAttr(career, player.heroList, player.orderList)
    local show   = player.heroList[career].show
    local info = {
        id      = player.id,
        lvl     = player.lvl,
        name    = player.name,
        group   = msg.group or group or GROUP_HERO,
        career  = career,
        myself  = msg.myself or true,
        attr    = attr,
        show    = msg.hero_show or show,
        hp      = msg.hp,
    }

    Role.hero = class:new(info)
    Role.hero:setSync(msg.sync or sync, msg.quad or quad)
    Role.hero:setXY(msg.x or x, msg.y or y)
    Role.hero:setZ(-200)
    Map:setFollow(Role.hero, winSize.width/2, winSize.height/3)

    local pet = PetModule:getPetByCareer(career)
    if pet then
        Pet:add(player.id, pet.mo.id)
    else
        Pet:del(player.id)
    end

    Msg:send(HERO_CHANGE)
    Msg:send(VENTURE_TARGET, {id = TARGET_ROLE, curNum = Role.hero.career})

    return Role.hero
end

function addSafePlayer(self, msg, class)
	if SettingsModule:hidePlayer() then
		return
	end
    class = class or Hero

    local x,y
    local role = Role:get(msg.player_id)
    if role then
        x = role.x
        y = role.y
        role:destroy()
    end
    local info = self.pvpList[msg.player_id]
    if not info then
        info = {
            id      = msg.player_id,
            sid     = msg.sid,
            lvl     = msg.lvl,
            name    = msg.name,
            group   = GROUP_HERO,
            myself  = msg.myself or false,
        }
        self.pvpList[info.id] = info
    end
    info.career  = msg.hero_show.career
    info.show    = msg.hero_show

    role = class:new(info)
    role:setSync(ROLE_SYNC_RECV)
    role:setXY(msg.x or x, msg.y or y)

	if not SettingsModule:hidePet() then
		Pet:add(msg.player_id, msg.player_show.pet_id)
	end

    Msg:send(ACTOR_ENTER, role)
    return role
end

function addBattPlayer(self, msg, class)
    class = class or Hero
    local x,y
    local role = Role:get(msg.player_id)
    if role then
        x = role.x
        y = role.y
        role:destroy()
    end

    local info = self.pvpList[msg.player_id]
    if not info then
        info = {
            id      = msg.player_id,
            sid     = msg.sid,
            lvl     = msg.lvl,
            name    = msg.name,
            group   = msg.group,
            myself  = msg.myself or false,

            showList  = {},
            heroList  = {},
            orderList = msg.battle_queue,
        }
        self.pvpList[msg.player_id] = info
    end
    
    if msg.hero_attr_list then
        for i,v in ipairs(msg.hero_attr_list) do
            local attr = AttrVo:new()
            attr.hp = v.hp
            attr.hpFull = v.hp_full
            attr.att = v.att
            attr.def = v.def
            attr.dodge = v.dodge
            attr.crit = v.crit
            attr.dmgadd = v.dmg_add
            attr.dmgdec = v.dmg_dec
            info.heroList[v.career] = {attr = attr}
        end
    end
    
    if msg.hero_show_list then
        for i,v in ipairs(msg.hero_show_list) do
           info.showList[v.career] = v
        end
    end

    info.career = msg.career or info.orderList[1]
    info.show = info.showList[info.career]
    info.attr = FightUtil:getFightAttr(info.career, info.heroList, info.orderList)
    info.hp  = info.attr.hp
    
    role = class:new(info)
    role:setSync(ROLE_SYNC_RECV)
    role:setXY(msg.x or x, msg.y or y)

    Msg:send(ACTOR_ENTER, role)
    return role
end

function delPlayer(self, msg)
    local role = Role:get(msg.player_id)

    Pet:del(msg.player_id)

    if role then
        role:destroy()
    end

    self.pvpList[msg.player_id] = nil
    Msg:send(ACTOR_LEAVE, msg)
    return role
end

function addTrans(self, cfg)
    cfg = cfg or self.cfg.mapdata.transOutList[1]

    if self.cfg.showTrans == 1 then
        local trans = cc.Sprite:create()
        trans:setPosition(cc.p(cfg.x,cfg.y))
        Map.unitBehideLayer:addChild(trans)
        cfg.view = trans
        table.insert(self.transList, cfg)

        local act1 = Asset:getAnimate("effect/chuansong/chuxian")
        local act2 = cc.CallFunc:create(function()
            self.canTrans = true
            trans:runAction(cc.RepeatForever:create(Asset:getAnimate("effect/chuansong/xunhuan")))
        end)
        trans:runAction(cc.Sequence:create(act1, act2))
    else
        delayCall(Map, 3, function() self:onTrans() end)
    end
end

function tryAddTrans(self, condition)
    for i, v in ipairs(self.cfg.mapdata.transOutList or {}) do
        if v.cond == condition then
            self:addTrans(v)
            return true
        end
    end

    return false
end

function showSuccessEff (self, func)
    local img = cc.Sprite:create()
    img:setPosition(cc.p(640, 360))
    self.ui.view:addChild(img)
    local act1 = Asset:getAnimate("effect/shenglitexiao")
    local act2 = cc.DelayTime:create(0.5)
    local act3 = cc.CallFunc:create(function()
        if func then
            func()
        end
        img:setVisible(false)
    end)
    img:runAction(cc.Sequence:create(act1, act2, act3))
end
