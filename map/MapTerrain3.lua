
module("MapTerrain", package.seeall)


function selectLine(self, _v1, _v2)
    v1 = _v1
    v2 = _v2
    self.pMinX2     =   nil
    self.pMaxX1     =   nil

    self.pRelateX1    = nil
    self.pRelateX2    = nil

    self.hasInterX = false

    self:getInterRangeW()
    self:getInterRangeH()

    local action = self:canSlide()
    action = action or self:canJump()
    if action then
        self:_fixAction(action)
        return action
    end
end

function getInterRangeW(self)
    if v1.x1 > v2.x1 then
        self.pMaxX1 = {x = v1.x1, y = v1.y1, i = LINE_1}
    else
        self.pMaxX1 = {x = v2.x1, y = v2.y1, i = LINE_2}
    end

    if v1.x2 < v2.x2 then
        self.pMinX2 = {x = v1.x2, y = v1.y2, i = LINE_1}
    else
        self.pMinX2 = {x = v2.x2, y = v2.y2, i = LINE_2}
    end

    --Y轴无交叉
    if (self.pMinX2.x - self.pMaxX1.x) > 10 then
        self.hasInterX = true
    end
end

function getInterRangeH(self)
    if not self.hasInterX then return end
    self.pRelateX1 = self:_getRelateInter(self.pMaxX1)
    self.pRelateX2 = self:_getRelateInter(self.pMinX2)
end

function _getRelateInter(self, inter)
    local line, index
    if inter.i == LINE_1 then
        line = v2
        index = LINE_2
    else
        line = v1
        index = LINE_1
    end

    local y = self:calcLineY(inter.x, line)
    return {x = inter.x, y = y, i = index}
end

function canSlide(self)
    --相连接，直接走过去
    if v1.group == v2.group then
        if math.abs(v1.x1 - v2.x2) < 20 or math.abs(v1.x2 - v2.x1) < 10 then
            return {{v2.x1 + 5, v2.x2 - 5}, p = math.min(50, (v2.x2 - v2.x1)/2)}
        else
            return
        end
    end

    local action
    if self.hasInterX then
        action = self:_checkSlideCross(self.pMaxX1, self.pRelateX1, true)
        if not action then
            action = self:_checkSlideCross(self.pMinX2, self.pRelateX2, false)
        end
        return action
    else
        local dx, dy = self:getDiffXY(LINE_1, self.pMaxX1, self.pMinX2)
        --从高处往下走
        if dy < 0 and math.abs(dx) < self:getFallX(dy) then
            local ps, pe = self.pMaxX1, self.pMinX2
            local o1, o2  = fall_gap, ten_add_fall_gap
            if dx > 0 then
                ps, pe = pe, ps
            else
                o1, o2 = -ten_add_fall_gap, -fall_gap
            end

            local edge = self:checkFall(ps.x, ps.y, pe.y, dx < 0)

            if edge then
                if dx < 0 then
                    if edge > pe.x then
                        return nil
                    end
                else
                    if edge < pe.x then
                        return nil
                    end
                end
            end
            local action = {}
            action[1] = {x1 = ps.x + o1, x2 = ps.x + o2}
            return action
        end

        return
    end
end



function canJump(self)
    if self.hasInterX then
        local dx, dy = self:getDiffXY(LINE_1, self.pMaxX1, self.pRelateX1)
        local action = self:_getVerticalJump(dy)
        if action then
            return action
        end

        dx, dy = self:getDiffXY(LINE_1, self.pMinX2, self.pRelateX2)
        action = self:_getVerticalJump(dy)
        if action then
            return action
        end

        return
    else
        local dx, dy = self:getDiffXY(LINE_1, self.pMaxX1, self.pMinX2)
        return self:_canJump(dx, dy)
    end
end

function _canJump(self, dx, dy)
    local multiX, multiY = false, false

    if math.abs(dx) > self:getJumpX() then
        multiX = true
    end

    if dy > self:getJumpY(dx) then
        multiY = true
    end


    local ps, pe = pMaxX1, pMinX2
    if pe.i == LINE_1 then
        ps, pe = pe, ps
    end

    -- local k = (dx < 0) and 1 or -1
    -- local offset = 
    --
    if multiX or multiY then
        return self:checkSecJump(ps, pe)
    else
        return self:checkJump(ps, pe)
    end
end

function _getVerticalJump(self, dy)
    if dy < 0 or dy > self:getSecJumpY(0) then
        return
    end

    if dy < self:getJumpY(0) then
        return {{x1 = self.pMaxX1.x, x2 = self.pMinX2.x}, {op = 1}}
    elseif dy < self:getSecJumpY(0) then
        return {{x1 = self.pMaxX1.x, x2 = self.pMinX2.x}, {op = 1}, {x1 = self.pMaxX1.x, x2 = self.pMinX2.x}, {op = 1}}
    end
end

function checkSecJump(self, ps, pe)
    local midx = (ps.x + pe.x) / 2
    local topY = ps.y + self:getSecJumpY(ps.x - pe.x)
    local edge = self:_checkJumpCross(ps.x, midx, ps.y, topY)
    if edge then
        return
    end

    edge = self:_checkJumpCross(midx, pe.x, topY, pe.y)
    if edge then
        return
    end

    return {{x1 = ps.x - 10, x2 = ps.x + 10}, {op = 1}, {x1 = ps.x, x2 = pe.x}, {op = 1}}
end

function checkJump(self, ps, pe)
    local midx = (ps.x + pe.x) / 2
    local topY = ps.y + self:getJumpY(0)
    local edge = self:_checkJumpCross(ps.x, midx, ps.y, topY)
    if edge then
        return
    end

    edge = self:_checkJumpCross(midx, pe.x, topY, pe.y)
    if edge then
        return
    end

    return {{x1 = ps.x - 10, x2 = ps.x + 10}, {op = 1}, {x1 = v2.x1, x2 = v2.x2}}
end


function _checkJumpCross(self, x1, x2, y1, y2)
    y1, y2 = self:_sortAsc(y1, y2)

    local _start = x1
    local _end = x2 
    local dt = (x1 > x2) and -10 or 10

    local edge
    local t = math.floor(y2 / YSTEP) + 1
    local retLine, retY
    for _x=_start, _end, dt do
        retLine, retY = self:_getDownLine(_x, y2, t, y1)
        if retLine then
            edge = _x
            break
        end
    end

    return edge
end


function _checkSlideCross(self, p1, p2, toLeft)
    if p1.i == LINE_1 then
        if p1.y > p2.y then
            local k = toLeft and -1 or 1
            local edge = self:checkFall(p1.x, p1.y, p2.y, toLeft)
            local _start = p1.x + k * fall_gap
            --正下方就有障碍，算不可达
            if edge and edge == _start then
                return
            end

            local _end = toLeft and v2.x1 or v2.x2
            local action = {}
            action[1] = {p1.x + k * ten_add_fall_gap, _start}
            --障碍在中间
            if (_start - edge) * (_end - edge) < 0 then
                action[3] = {edge - k * fall_gap, toLeft and v2.x2 or v2.x1}
            end

            return action
        end
    end
end
