
module("MapTerrain", package.seeall)

function isHigher(self, pEnd, pRelate)
    if pEnd.i == LINE_1 and pEnd.y > pRelate.y then
        return true
    end
end

--返回高度差
function getDiffXY(self, i, pEnd, pRelate)
    local p1, p2 = self:sortByY(pEnd, pRelate)
    local dy = p2.y - p1.y
    local dx = p2.x - p1.x
    if p2.i == i then
        dy = -dy
    else
        dx = -dx
    end

    return dx, dy
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
function getJumpY(self, x)
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
    return sec_jump_max_y
end

function checkFall(self, x, y1, y2, toLeft)
    y1, y2 = self:_sortAsc(y1, y2)

    local k = toLeft and -1 or 1
    local _start = x + k * fall_gap
    local _end = x + k * fall_max_x 
    local dt = k * 10

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

function _sortAsc(self, a, b)
    if a > b then
        return b, a
    end
    return a, b
end

LINE_1  =   1
LINE_2  =   2

fall_max_x = 260
sec_jump_max_x = 550
sec_jump_max_y = 250
jump_max_x = 260
jump_max_y = 150
--走出平台线，至少位移距离
fall_gap = 30
ten_add_fall_gap = fall_gap + 10

SIDE_LEFT = 1
SIDE_RIGHT = 2
