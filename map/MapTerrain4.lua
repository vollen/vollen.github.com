
v1, v2 = v1, v2

function selectLine(self, _v1, _v2)
    v1 = self:_fixV(_v1, 1)
    v2 = self:_fixV(_v2, 2)

    self.pMinX2     =   nil
    self.pMaxX1     =   nil

    self.pRelateX1    = nil
    self.pRelateX2    = nil

    self.hasInterX = false
    self._ladders = {}

    self:getInterRangeW()
    self:getInterRangeH()
end

function _fixV(self, v, index)
    local p1, p2 = {x=v.x1, y = v.y1, i = index}, {x=v.x2, y = v.y2, i = index}
    if p1.y > p2.y then
        p1, p2 = p2, p1
    end
    return {b = p1, t = p2}
end


function getInterRangeW(self)
    self.pMinX2, self.pMaxX1 = v1.t, v1.b
    if self.pMinX2.x > self.pMaxX1.x then
        self.pMinX2, self.pMaxX1 = self.pMaxX1, self.pMinX2
    end

    local l2, r2 = v2.t, v2.b
    if l2.x > r2.x then
        l2, r2 = r2, l2
    end

    if self.pMinX2.x < l2.x then
        self.pMinX2 = l2
    end

    if self.pMaxX1.x > r2.x then
        self.pMaxX1 = r2
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
    if inter.i == 1 then
        line = v2
        index = 2
    else
        line = v1
        index = 1
    end

    local y = line:calcLineY(inter.x)
    return {x = inter.x, y = y, i = index}
end

function canSlide(self)
    --相连接，直接走过去
    if v1.group == v2.group then
        if math.abs(v1.x1 - v2.x2) < 20 or math.abs(v1.x2 - v2.x1) < 10 then
            return {{x1 = v2.x1 + 5, x2 = v2.x2 - 5}, p = math.min(50, (v2.x2 - v2.x1)/2)}
        else
            return nil
        end
    end
end

