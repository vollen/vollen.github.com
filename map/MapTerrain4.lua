

LINE_1  =   1
LINE_2  =   2

function selectLine(self, _v1, _v2)
    self.pMinX2     =   nil
    self.pMaxX1     =   nil

    self.pRelateX1    = nil
    self.pRelateX2    = nil

    self.hasInterX = false

    self:getInterRangeW()
    self:getInterRangeH()
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
    if self.pMaxX1.x < self.pMinX2.x then
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
            return true,  {{x1 = v2.x1 + 5, x2 = v2.x2 - 5}, p = math.min(50, (v2.x2 - v2.x1)/2)}
        else
            return false
        end
    end

    if self.hasInterX then
        if self:isHigher(self.pMaxX1, self.pRelateX1) then
            return true
        end

        if self:isHigher(self.pMinX2, self.pRelateX2) then
            return true
        end

        return false

    else
        local dx, dy = self:getDiffXY(LINE_1, self.pMaxX1, self.pMinX2)
        --从高处往下走
        if dy < 0 and dx < self:getFallX(p2.y - p1.y) then
            return true
        end

        return false
    end
end

function canJump(self)
    if self.hasInterX then
        local dx, dy = self:getDiffXY(LINE_1, self.pMaxX1, self.pRelateX1)
        if dy > 0 and dy < self:getSecJumpY(0) then
            return true
        end

        dx, dy = self:getDiffXY(LINE_1, self.pMinX2, self.pRelateX2)
        if dy > 0 and dy < self:getSecJumpY(0) then
            return true
        end

        return false
    else
        local dx, dy = self:getDiffXY(LINE_1, self.pMaxX1, self.pMinX2)
        return _canJump
    end
end

function _canJump(self, dx, dy)
    if dy > 0 and dy < self:getSecJumpY(dx) then
        return true
    else
        return false
    end
end

function isHigher(self, pEnd, pRelate)
    if pEnd.i == LINE_1 and pEnd.y > pRelate.y then
        return true
    end
end

--返回高度差
function getDiffXY(self, i, pEnd, pRelate)
    local p1, p2 = self:sortByY(pEnd, pRelate)
    local dy = p2.y - p1.y
    if p2.i == i then
        dy = -dy
    end

    return math.abs(p2.x - p1.x), dy
end


--根据高度排序
function sortByY(self, p1, p2)
    if p1.y > p2.y then
        return p2, p1
    end 
    return p1, p2
end


--辅助函数， 用于标明能运动的距离
function getFallX(self, y)
    return fall_max_x
end

--
function getJumpY(self)
    return jump_max_y
end

function getJumpX(self, dy)
    return jump_max_x
end

function getSecJumpX(self, dy)
    return sec_jump_max_x
end

function getSecJumpY(self, dx)
    if dx > sec_jump_max_x then
        return 0
    end
end

function checkLineCross(self)
end


jump_vx = 400
jump_vy = 700
sec_jump_vy = 600

fall_max_x = 260
sec_jump_max_x = 550
sec_jump_max_y = 250
jump_max_x = 260
jump_max_y = 150
--走出平台线，至少位移距离
fall_gap = 120

SIDE_LEFT = 1
SIDE_RIGHT = 2
