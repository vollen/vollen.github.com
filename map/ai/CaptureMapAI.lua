----------------------------------------------
-- [FILE] CaptureMapAI.lua
-- [DATE] 2015-10-21
-- [CODE] BY wagnhuai
-- [MARK] NONE
-----------------------------------------------

module("CaptureMapAI", package.seeall)
defclass("CaptureMapAI", CaptureMapAI, TeamMapAI)

function init(self, cfg)
    Msg:rg(self.onMsg, self, CAPTURE_QUIZ)
	Msg:rg(self.onMsg, self, PUZZLE_END)
    Msg:rg(self.onMsg, self, CAPTURE_SCORE)
    super.init(self, cfg)
    self.showQuiz = false
end

function onInit(self)
    super.onInit(self)
    if CaptureModule.captureResultType == 2 or CaptureModule.captureResultType == 3 then
        self.ui:addScore()
    end
    if self.showQuiz then
        self:onQuiz()
    end
end

function onMsg(self, msgId, msgData)
	super.onMsg(self, msgId, msgData)
    if msgId == CAPTURE_QUIZ then
        self.showQuiz = true
	elseif msgId == PUZZLE_END then
        self:onQuizEnd(msgData)
    elseif msgId == CAPTURE_SCORE then
        self.ui:setScore(msgData)
    end
end

function onQuiz (self)
    local list = SysConf:get("capture", "quiz_list")
    local num = math.random(0, #list)
    local id = list[math.ceil(num)]
    id = id or list[1]
	Puzzle:show(id, PuzzleResultForNet, 3)
end

function onQuizEnd (self, result)
	local p = Net.capture_quiz_c2s()
	p.result = result
	Net:send(p)
end

function onLoop(self, dt)
    super.onLoop(self, dt)
end


function onFinish (self)
    super.onFinish (self)

    local func = function()
        if Map.lastMainMapId then
            Map:enter(Map.lastMainMapId, 0, nil, nil, MAP_LEAVE_TOMAIN)
        else
            Game:gotoMain()
        end
    end

    if CaptureModule.captureResult.result == 1 then
        delayCall(Map, 2, func)
    else
        func()
    end
end
