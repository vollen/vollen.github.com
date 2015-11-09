-----------------------------------------------
-- [FILE] ExamMapAI.lua
-- [DATE] 2015-11-07
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------
module("ExamMapAI", package.seeall)
defclass("ExamMapAI", ExamMapAI, SafeMapAI)


function init(self, cfg)
	super.init(self, cfg)
end


function onInit(self)
	super.onInit(self)

	-- 
	self.ui = BaseFightUI
    self.ui:init()
    FightHead:setChangeable(false)

    --
    ExamModule:show()
end
