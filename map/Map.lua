-----------------------------------------------
-- [FILE] Map.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("Map", package.seeall)
defclass("Map", Map)

function enter(self, mapid, inst, params, forceEnter, reason)
    if self.lastPosList == nil then
        self.lastPosList = {}
    end

    if self:checkForTeam(mapid) == false then
        return
    end

    self.tempId     = mapid
    self.tempInst   = inst
    self.tempReason  = reason or self.enterReason or 0
    self.isForceEnter = forceEnter

    if forceEnter then
        self:doEnter()
    else
        local p = Net.map_check_enter_c2s()
        p.mapid = mapid
        p.inst = inst
        p.params = params or {}
        local cfg = SysMap:get(mapid)
        if inst == 0 and cfg.type == 1 and self.lastPosList[mapid] then
            p.inst = self.lastPosList[mapid].inst
        end
        Net:sync(p)
    end
end

function doEnter(self)
    if self.lastPosList == nil then
        self.lastPosList = {}
    end

    if self.id then
        local cfg = SysMap:get(self.id)
        if cfg and cfg.type == 1 and Role.hero then
            local tab = {}
            tab.inst = self.inst
            tab.x = Role.hero.x
            tab.y = Role.hero.y
            self.lastPosList[self.id] = tab
            self.lastMainMapId = self.id
        end
    end

    self.id     = self.tempId
    self.inst   = self.tempInst
    self.reason = self.tempReason
    self.enterReason = nil --不同于tempReason和reason 此变量用于进入原因得到的时机早于enter的时机时的一个临时变量
    self.cfg    = SysMap:get(self.id)
    if self.inst == 0 and self.cfg.type == 1 and self.lastPosList[self.id] then
        self.inst = self.lastPosList[self.id].inst
    end

    Game:gotoLoad()
end

function checkForTeam(self, mapid)
    local ret = true
    --只有队员在跟随状态时 无法随意进入副本
    if Vo.team.id ~= 0
        and SysMap:get(mapid).type ~= 1         --不是主城
        and not SysTeamventure:get(mapid)       --且不是组队副本
     then
        if Vo.team.leaderId ~= Vo.player.id then
            if TeamModule:getMyTeamVo().status == 1 then
                UIMisc:warn("请离队或暂离再进入!")
                ret = false
            end
        end
    end
    return ret
end

function leave(self, resean)
    local p = Net.map_leave_c2s()
    p.reason = resean or 0
    Net:send(p)
end

function init(self)
    trace("Map init ", self.cfg.id)
    self:initData()
    self:initView()

    self.terrain = MapTerrain
    self.terrain:init(self.cfg)

    self.render = self.cfg.map_render or MapRender
    self.render:init(self.cfg)

    self.ai = self.cfg.map_ai or SafeMapAI
    self.ai:init(self.cfg)

    self.bgSize = self.bgLayer:getContentSize()
    self.mgSize = self.mgLayer:getContentSize()
    self.fgSize = self.fgLayer:getContentSize()
    self:setupMoveK()

    local function scheduleUpdate(dt)
        self:update(dt)
    end
    self.view:scheduleUpdateWithPriorityLua(scheduleUpdate, 0)
end


function initData(self)
    self.width  = self.cfg.width
    self.height = self.cfg.height

    self.viewW  = visibleOrigin.x + visibleSize.width
    self.viewH  = visibleOrigin.y + visibleSize.height
    
    local phys = SysMapPhysics:get(self.cfg.physics)
    self.phyVg = phys.vg
    self.phyKx = phys.kx
    self.phyKy = phys.ky
    self.phyCamX = winSize.width * phys.cam_x
    self.phyCamY = winSize.height * phys.cam_y

    self.x = 0
    self.y = 0

    self.bgMoveXK = 1
    self.bgMoveYK = 1
    self.mgMoveXK = 1
    self.mgMoveYK = 1

    self.followTarget   = nil
    self.followOffsetX  = 0
    self.followOffsetY  = 0

    self.scale      = 1.0
    self.scaleAdd   = 1.0
    self.scaleMap   = 1.0

    self.scaleDt    = 0
    self.scaleDest  = 0
    self.scaleTime  = 0
    self.scaleFlag  = false

    self.shakeFlag  = false
    self.shakeX     = 0
    self.shakeY     = 0
    self.shakeIdx   = 0
    self.shakeMax   = 0
    self.shakePos   = nil
end

function initView(self)
    self.view = cc.Node:create()

    self.bgLayer = cc.Node:create()
    self.view:addChild(self.bgLayer)

    self.mgLayer = cc.Node:create()
    self.view:addChild(self.mgLayer)

    self.fgLayer = cc.Node:create()
    self.view:addChild(self.fgLayer)

    self.tgLayer = cc.Node:create()
    self.view:addChild(self.tgLayer)
    
    self.roleLayer = cc.Node:create()
    self.fgLayer:addChild(self.roleLayer, 100)

    self.effectLayer = cc.Node:create()
    self.fgLayer:addChild(self.effectLayer, 200)


    --五个机关层，　分别在 中景 / 前景最下 /　人前　／　怪前　／　怪后
    self.unitMgLayer    = cc.Node:create()
    self.unitFgLayer    = cc.Node:create()
    self.unitFrontLayer = cc.Node:create()
    self.unitLayer      = cc.Node:create()
    self.unitBehideLayer= cc.Node:create()

    self.mgLayer:addChild(self.unitMgLayer, 100)
    self.fgLayer:addChild(self.unitFgLayer, -255)

    self.roleLayer:addChild(self.unitFrontLayer, 100)
    self.roleLayer:addChild(self.unitLayer, -10)
    self.roleLayer:addChild(self.unitBehideLayer, -100)
    
    self.shadowLayer = cc.Node:create()
    self.roleLayer:addChild(self.shadowLayer, -1)
end


function clear(self)
    if self.ai then
        self.ai:clear()
        self.ai = nil
    end

    if self.render then
        self.render:clear()
        self.render = nil
    end

    if self.view then
        self.view:unscheduleUpdate()
        self.view = nil
    end
end


function update(self, dt)
    if not self.view then
        return
    end

    if self.shakeFlag then
        self.shakeX = self.shakePos[self.shakeIdx][1]
        self.shakeY = self.shakePos[self.shakeIdx][2]
        self:setXY(self.x, self.y)

        self.shakeIdx = self.shakeIdx + 1
        if self.shakeIdx > self.shakeMax then
            self.shakeFlag = false
            self.shakePos = nil
        end
    end

    if self.scaleFlag then
        self.scaleTime = self.scaleTime - dt
        if self.scaleTime < 0 then
            self.scaleFlag = false
            self.scale = self.scaleDest
        else
            self.scale = self.scale + self.scaleDt * dt
        end
        self.view:setScale(self.scale)
        self.bgLayer:setScale(1/self.scale)
        self:setupMoveK()
    end

    if self.followTarget then
        local tarX, tarY
        if type(self.followTarget) == "table" then
            tarX, tarY = self.followTarget.x, self.followTarget.y
        else
            tarX, tarY = self.followTarget:getPosition()
        end


        --边界检测
        local mapDesX, mapDesY = self:checkBound(tarX, tarY, self.followOffsetX, self.followOffsetY)
        if self.scaleFlag then
            self:setXY(mapDesX, mapDesY)
        else
            local vx = mapDesX - self.x
            local vy = mapDesY - self.y

            if math.abs(vx) > 4 or math.abs(vy) > 4 then
                self:setXY(self.x + vx * dt * 4, self.y + vy * dt * 4)
            end
        end
    end

    self.render:update(dt)
    self.ai:update(dt)
end


function setXY(self, x, y)
    self.x = x
    self.y = y

    if self.shakeFlag then
        x = x + self.shakeX
        y = y + self.shakeY
    end

    self.tgLayer:setPosition(x, y)
    self.fgLayer:setPosition(x, y)
    self.mgLayer:setPosition(x * self.mgMoveXK, y * self.mgMoveYK)
    self.bgLayer:setPosition(x * self.bgMoveXK, y * self.bgMoveYK)
end


function setFollow(self, target, offsetX, offsetY, moveSmooth)
    self.followTarget = target
    self.followOffsetX = offsetX or Map.phyCamX
    self.followOffsetY = offsetY or Map.phyCamY

    if self.followTarget and not moveSmooth then
        local tarX, tarY
        if type(self.followTarget) == "table" then
            tarX, tarY = self.followTarget.x, self.followTarget.y
        else
            tarX, tarY = self.followTarget:getPosition()
        end

        local mapDesX, mapDesY = self:checkBound(tarX, tarY, self.followOffsetX, self.followOffsetY)
        self:setXY(mapDesX, mapDesY)
    end
end

function setScaleMap(self, k, t)
    self.scaleMap = k
    self:_setScale(self.scaleMap * self.scaleAdd, t)
end

function setScale(self, k, t)
    self.scaleAdd = k
    self:_setScale(self.scaleMap * self.scaleAdd, t)
end

function _setScale(self, k, t)
    if self.scale ~= k then
        self.scaleFlag = true
        self.scaleTime = t or 0.1
        self.scaleDest = k
        self.scaleDt = (k - self.scale) / self.scaleTime
    end
end

function setShake(self, x, y, max)
    max = max or 5

    self.shakeFlag = true
    self.shakeX    = 0
    self.shakeY    = 0
    self.shakeIdx  = 1
    self.shakeMax  = max * 2
    self.shakePos  = {}

    local idx = 1
    for i = 1, max do
        local k = 1 - (i/self.shakeMax) * 0.3
        if i % 2 == 1 then
            k = -k
        end
        self.shakePos[idx] = {x * k, y * k}
        self.shakePos[idx + 1] = {0, 0}
        idx = idx + 2
    end
end

function setupMoveK(self)
    local bgw = self.bgSize.width - winSize.width
    local bgh = self.bgSize.height - winSize.height

    local mgw = self.mgSize.width * self.scale - winSize.width
    local mgh = self.mgSize.height * self.scale - winSize.height

    local fgw = self.fgSize.width * self.scale - winSize.width
    local fgh = self.fgSize.height * self.scale - winSize.height

    self.bgMoveXK = bgw/fgw
    self.bgMoveYK = bgh/fgh

    self.mgMoveXK = mgw/fgw
    self.mgMoveYK = mgh/fgh
end


function checkBound(self, mapDesX, mapDesY, offsetX, offsetY)
    mapDesX = -mapDesX + offsetX / self.scale
    mapDesY = -mapDesY + offsetY / self.scale

    --边界检测
    if mapDesX > visibleOrigin.x then
        mapDesX = visibleOrigin.x
    else
        local boundW = -self.width + self.viewW / self.scale
        if mapDesX < boundW then
            mapDesX = boundW
        end
    end

    if mapDesY > visibleOrigin.y then
        mapDesY = visibleOrigin.y
    else
        local boundH = -self.height + self.viewH / self.scale
        if mapDesY < boundH then
            mapDesY = boundH
        end
    end

    return mapDesX, mapDesY
end


--[[镜头移动]]
--移动到目标点(到了会发送一个消息出去)
function moveTo(self, desX, desY, time, func, camX, camY)
    camX = camX or Map.phyCamX
    camY = camY or Map.phyCamY
    
    local node = cc.Node:create()
    node:setPosition(-self.x + camX / self.scale, -self.y + camY / self.scale)
    self.view:addChild(node)
    
    local onFinish = function ()
        self:setFollow(nil)
        Msg:send(MAP_MOVE_FINISH)
        node:removeFromParent()
        if func then
            func()
        end
    end

    local move = cc.MoveTo:create(time, cc.p(desX, desY))
    --慢慢拉过去，根据当前移动方式，大概需要1/4 秒
    local delay = cc.DelayTime:create(0.25)
    local call = cc.CallFunc:create(onFinish)

    node:runAction(cc.Sequence:create(move, delay, call))
    self:setFollow(node, camX, camY, true)
end

--镜头回归(镜头移回主角)
function moveBack(self)
    self:setFollow(Role.hero, nil, nil, true)
end

