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

	-- 标准组件
	self.ui = BaseFightUI
    self.ui:init()
    FightHead:setChangeable(false)

    -- 考试内容
    self.exam_panel = ExamMapPanel
    self.exam_panel:init()
end

