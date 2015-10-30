-----------------------------------------------
-- [FILE] TestMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("TestMapAI", package.seeall)
defclass("TestMapAI", TestMapAI, MapAI)

function enter(self)
    self:onEnterVenture()
end

function onInit(self)
    super.onInit(self)

    Touch:setCtlId(1002)

    self.ui = BaseFightUI
    self.ui:init()  
end

function onMons(self)
    super.onMons(self)
    for i,v in ipairs(self.cfg.mapdata.monList or {}) do
        self:addMon(v)
    end
end

function onPause(self)
    super.onPause(self)
    BasePausePanel:addBtn("重新开始", function() Map:enter(self.cfg.id, 1, nil, true) end)
end
