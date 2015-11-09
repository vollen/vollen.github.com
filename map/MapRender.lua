-----------------------------------------------
-- [FILE] MapRender.lua
-- [DATE] 2015-07-15
-- [CODE] BY tianye
-- [MARK] NONE
-----------------------------------------------

module("MapRender", package.seeall)
defclass("MapRender", MapRender)

function init(self, cfg)
    self.tgList = {}

    self:setupBg(cfg)
    self:setupMg(cfg)
    self:setupFg(cfg)
    self:setupTg(cfg)
end

function clear()

end

function update(self, dt)
    if Role.hero then
        for i, v in ipairs(self.tgList) do
            local dx = math.abs(Role.hero.x - v.x)
            if dx < 200 then
                if v.a > 180 then
                    v.a = v.a - 1
                    v.p:setOpacity(v.a)
                end
            else
                if v.a < 255 then
                    v.a = v.a + 1
                    v.p:setOpacity(v.a)
                end
            end
        end
    end
end

function setupBg(self, cfg)
    local sp = cc.Sprite:create(cfg.mapdata.bg) or cc.Node:create()
    sp:setAnchorPoint(cc.p(0, 0))

    local bg = Map.bgLayer
    bg:setAnchorPoint(cc.p(0, 0))
    bg:setContentSize(sp:getContentSize())
    bg:addChild(sp)

    if cfg.mapdata.bgeff then
        for i,v in ipairs(cfg.mapdata.bgeff) do
            bg:addChild(self:getSceneEffect(v), 999)
        end
    end
end

function setupMg(self, cfg)
    local mg = Map.mgLayer
    mg:setAnchorPoint(cc.p(0, 0))
    mg:setContentSize(cc.size(cfg.mg_width, cfg.mg_height))

    for i,v in ipairs(cfg.mapdata.mg or {}) do
        local sp = self:getSceneSprite(v)
        if sp then
            sp:setPosition(v.x, v.y)
            sp:setRotation(v.rotate or 0)
            mg:addChild(sp, v.z)
        end
    end
end

function setupFg(self, cfg)
    local fg = Map.fgLayer
    fg:setAnchorPoint(cc.p(0, 0))
    fg:setContentSize(cc.size(cfg.width, cfg.height))

    for i,v in ipairs(cfg.mapdata.fg or {}) do
        local sp = self:getSceneSprite(v)
        if sp then
            sp:setPosition(v.x, v.y)
            sp:setRotation(v.rotate or 0)
            fg:addChild(sp, v.z)
        end
    end
end

function setupTg(self, cfg)
    local tg = Map.tgLayer
    tg:setAnchorPoint(cc.p(0, 0))
    tg:setContentSize(cc.size(cfg.width, cfg.height))

    if cfg.mapdata.tg then
        for i,v in ipairs(cfg.mapdata.tg) do
            local sp = self:getSceneSprite(v)
            if sp then
                sp:setPosition(v.x, v.y)
                sp:setRotation(v.rotate or 0)
                tg:addChild(sp, v.z)

                table.insert(self.tgList, {p = sp, a = 255, x = v.x, y = v.y})
            end
        end
    end

    if cfg.mapdata.fgeff then
        for i,v in ipairs(cfg.mapdata.fgeff) do
            tg:addChild(self:getSceneEffect(v), 999)
        end
    end
end


function getSceneSprite(self, v)
    local list = SysSceneResSet:get(v.p)
    if list then
        local node = cc.Node:create()
        node:setCascadeOpacityEnabled(true)

        for i,p in ipairs(list) do
            local f = Asset:getSpriteFrame(p)
            if f then
                local sp
                if list.mask then
                    sp = as3d.AsSprite:createWithSpriteFrame(f)
                    sp:setLight(self:getSceneLight())
                else
                    sp = cc.Sprite:createWithSpriteFrame(f)
                end

                if v.turn then
                    sp:setFlippedX(true)
                end
                node:addChild(sp)
            end
        end
        return node
    else
        local sp = cc.Sprite:create(v.p)
        if sp then
            if v.turn then
                sp:setFlippedX(true)
            end
            return sp
        end
    end
    return nil
end


function getSceneEffect(self, v)
    local sp = cc.Sprite:create()
    sp:setPosition(v.x, v.y)

    if v.loop then
        sp:runAction(cc.RepeatForever:create(Asset:getAnimate(v.file)))
    else
        sp:runAction(Asset:getAnimate(v.file))
    end
    if v.turn then
        sp:setFlippedX(true)
    end
    return sp
end

function getSceneLight(self)
    if self.light then
        return self.light
    else
        self.light = as3d.AsLight:create(false, false)
        return self.light
    end
end
--将场景变黑 突出人物
function setSceneMask (self, bool)
    if self.mask == nil then
        self.mask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), Map.width + 200, Map.height + 200)
        self.mask:setPosition(-100, -100)
        Map.roleLayer:addChild(self.mask, -1)
    end
    if bool then
        Map.tgLayer:setVisible(false)
        self.mask:setOpacity(0)
        self.mask:runAction(cc.FadeTo:create(0.2, 200))
    else
        Map.tgLayer:setVisible(true)
        self.mask:runAction(cc.FadeTo:create(0.2, 0))
    end
end
