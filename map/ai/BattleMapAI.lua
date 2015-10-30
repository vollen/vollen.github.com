-----------------------------------------------
-- [FILE] BattleMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("BattleMapAI", package.seeall)
defclass("BattleMapAI", BattleMapAI, MapAI)

function onInit(self)
    super.onInit(self)
    
    Role:setAnger(0)
    Touch:setCtlId(1002)

    self.ui = BaseFightUI
    self.ui:init()
    FightHead:setChangeable(false)
end

--todo  为了路线,先加本地怪
function onMons(self)
    super.onMons(self)
    for i,v in ipairs(self.cfg.mapdata.monList or {}) do
        self:addMon(v)
    end
end

function onEnterBatt(self, msg)
    if self.state == MAP_ST_WAIT then
        super.onEnterBatt(self, msg)
    else
        --复活进入
        msg.sync   = ROLE_SYNC_SEND
        self:addHero(msg)
    end
end

function addHero(self, msg, class)
    --随机坐标点
    if msg.x == 0 and msg.y == 0 then
        local transInList = self.cfg.mapdata.transInList
        local transCnt = transInList and #transInList or 0
        if transCnt >= 1 then
            local transIn = transInList[math.random(transCnt)]
            msg.x, msg.y = transIn.x, transIn.y
        end
    end

    local hero = super.addHero(self, msg, class)
    return hero
end
