
module("MapTerrain", package.seeall)


--[[计算梯子和平台线的可达关系]]
function setLadderMap(self, _ladder, _line, _i)
    line = _line
    ladder = _ladder
    i = _i
    --太远
    if ladder.left - line.x2 > self:getSecJumpX() then
        return
    --太远
    elseif line.x1 - ladder.right > self:getSecJumpX() then
        return
    end

    if self:_ladderLeft(line.x1, line.y1) then
    elseif self:_ladderRight(line.x2, line.y2) then
    elseif self:_ladderMiddle() then
    end
end

--梯子在左边
function _ladderLeft(self, x, y)
    return self:_ladderPoint(ladder.right, x, y)
end

--梯子在右边
function _ladderRight(self, x, y)
    return self:_ladderPoint(ladder.left, x, y)
end

--梯子在中间
function _ladderMiddle(self)
    local midx = (ladder.right + ladder.left) / 2
    local y = self:_calcLineY(midx, line)
    local topDis = (y - ladder.top)
    if topDis > self:getSecJumpY(0) then
    elseif topDis > self:getJumpY(0) then
        self:_setLadderMap({{x1=ladder.top - 10, x2 = ladder.top + 10}, {op = 1}, {x1 = ladder.left, x2 = ladder.right}, {op = 1}, ladder = i}, true)
    elseif topDis > ladder_min_y then
        self:_setLadderMap({{x1=ladder.top - 10, x2 = ladder.top + 10}, {op = 1}, ladder = i}, true)
    elseif topDis > 0 then
        self:_setLadderMap({{x1=ladder.left, x2 = ladder.right}, {op = 3}}, false)
        self:_setLadderMap({{x1=ladder.top - 10, x2 = ladder.top + 10}, {op = 1}, ladder = i}, true)
    else
        local bottomDis = (ladder.bottom - y)
        if bottomDis > 0 then
            local t = math.floor(ladder.bottom / YSTEP) + 1
            local retLine, retY = self:_getDownLine(midx, ladder.bottom, t, y)
            if not retLine then
                self:_setLadderMap({{x1=ladder.bottom - 10, x2 = ladder.bottom - 20}, {op = 3}, ladder = i}, true)
            end
        else
            local toLeft = (line.x2 - ladder.right) < (ladder.left - line.x1)
            local action = {{x1 = y + 10, x2 = y + 20}, {op = 1}}
            if toLeft then
                action[3] = {x1 = line.x1, x2 = ladder.left - 10}
            else
                action[3] = {x1 = ladder.right + 10, x2 = line.x2}
            end
            self:_setLadderMap(action, true)
        end

        if bottomDis < ladder_min_y then
            self:_setLadderMap({{x1 = ladder.left, x2 = ladder.right}, {op = 2}}, false)
        elseif bottomDis < self:getJumpY(0) then
            self:_setLadderMap({{x1 = ladder.left, x2 = ladder.right}, {op = 1}}, false)
        elseif bottomDis < self:getSecJumpY(0) then
            self:_setLadderMap({{x1 = ladder.left, x2 = ladder.right}, {op = 1}, {x1 = ladder.left, x2 = ladder.right}, {op = 1}}, false)
        end
    end
end

function _ladderPoint(self, xBound, x, y, right)
    local disX = x - xBound
    if right then
        disX = -disX
    end

    local multiX = false
    if disX > self:getJumpX() then
        multiX = true
    elseif disX < 0 then
        return false
    end

    local topDis = (y - ladder.top)
    if topDis > self:getSecJumpY(disX) then
        self:_checkLadderJump(x,  y, xBound, ladder.top, multiX, false)
    elseif topDis > self:getJumpY(disX) then
        self:_checkLadderJump(x, y, xBound, ladder.top, multiX, false)
        self:_checkLadderJump(xBound, ladder.top, x, y, true, true)
    elseif topDis > 0 then
        self:_checkLadderJump(x, y, xBound, ladder.top, multiX, false)
        self:_checkLadderJump(xBound, ladder.top, x, y, multiX, true)
    else
        local bottomDis = (ladder.bottom - y)
        if bottomDis > self:getSecJumpY(disX) then
            self:_checkLadderJump(xBound, ladder.bottom, x, y, multiX, true)
        elseif bottomDis > self:getJumpY(disX) then
            self:_checkLadderJump(x, y, xBound, ladder.bottom, true, false)
            self:_checkLadderJump(xBound, ladder.bottom, x, y, multiX, true)
        elseif bottomDis > 0 then
            self:_checkLadderJump(x, y, xBound, ladder.bottom, multiX, false)
            self:_checkLadderJump(xBound, ladder.bottom, x, y, multiX, true)
        else
            self:_checkLadderJump(x, y, xBound, y, multiX, false)
            self:_checkLadderJump(xBound, y, x, y, multiX, true)
        end
    end

    return true
end

function _checkLadderJump(self, x1, y1, x2, y2, isMulti, toLine)
    local midx = (x1 + x2) / 2
    local h = isMulti and self:getSecJumpY(x1-x2) or self:getJumpY(x1-x2)
    local topY = y1 + h
    local edge = self:_checkJumpCross(x1, midx, y1, topY)
    if edge then return end

    edge = self:_checkJumpCross(midx, x2, topY, y2)
    if edge then return end

    local action
    if toLine then
        action = {{x1 = y1 - 10, x2 = y1 + 10}, {op = 1}}
    else
        action = {{x1 = x1 - 10, x2 = x1 + 10}, {op = 1}, ladder = i}
    end
    if isMulti then
        action[3] = {x1 = x1, x2 = x2}
        action[4] = {op = 1}
    end

    self:_setLadderMap(action, toLine)
end


function _setLadderMap(self, action, toLine)
    self:_fixAction(action)

    if toLine then
        self.lineMap[ladder.i][line.i] = action
    else
        self.lineMap[line.i][ladder.i] = action
    end
end

function _fixAction(self, action)
    if not action then return end
    action.p = 100
    self:_fixDest(action[1])
    self:_fixDest(action[3])
end

function _fixDest(self, dest)
    if dest then
        dest.x1, dest.x2 = self:_sortAsc(dest[1], dest[2])
    end
end

ladder_min_y = 50
