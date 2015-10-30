

-- [[
-------------------------------------------------------------------
-- 初始化寻路数据
-------------------------------------------------------------------
function initLineMap(self)
    self.lineEnd = {}
    self.lineMap = {}
    for i,line in ipairs(self.lines) do
        line.i = i
        self:setLineEnd(line.x1, line.y1)
        self:setLineEnd(line.x2, line.y2)
    end
    for i,line1 in ipairs(self.lines) do
        self.lineMap[i] = {}
        for j,line2 in ipairs(self.lines) do
            self.lineMap[i][j] = self:setLineMap(line1, line2) 
        end
    end

    printMapLine()
end

function setLineEnd(self, x, y)
    --local key = x .. "_" .. y
    --local n = self.lineEnd[key] or 0
    --self.lineEnd[key] = n + 1

    table.insert(self.lineEnd, {x, y})
end

function getLineEnd(self, x, y)
    --local key = x .. "_" .. y
    --return self.lineEnd[key] or 0
    
    local c = 0
    for i,p in ipairs(self.lineEnd) do
        if math.abs(p[1] - x) < 30 and math.abs(p[2] - y) < 30 then
            c = c + 1
        end
    end
    return c
end

--相连的
function isConnected(self, v1, v2)
    --相连接，直接走过去
    if v1.group == v2.group then
        if math.abs(v1.x1 - v2.x2) < 20 or math.abs(v1.x2 - v2.x1) < 10 then
            return {{x1 = v2.x1 + 5, x2 = v2.x2 - 5}, p = math.min(50, (v2.x2 - v2.x1)/2)}
        else
            return nil
        end
    end
end

function isTooHigh(self, v1, v2)
    --太高的平台不可到达
    local y1 = (v1.y1 + v1.y2)/2
    local y2 = (v2.y1 + v2.y2)/2
    if y2 - y1 > sec_jump_max_y then
        for i,ladder in ipairs(self.ladders) do
            if y2 + 30 > ladder.bottom and 
                y2 - 30 < ladder.top and
                v2.x1 < ladder.right and
                v2.x2 > ladder.left and
                ladder.bottom - y1 < sec_jump_max_y - 10
            then
                local action = self:getLadderAction(ladder, v1)
                if action then
                    return action
                end
            end
        end
        return nil
    end
end

function canPassL(self, v1, v2)
    local minX = math.max(v1.x1 - sec_jump_max_x, 10)
    for tx = v1.x1 - fall_gap, minX,  -10 do
        local tline, ty = self:getDownLine(tx, v1.y1 + jump_max_y)
        if tline == v2 then
            return tx
        end
    end
    
    return false
end

function canPassR(self, v1, v2)
    local maxX = math.min(v1.x2 + sec_jump_max_x, self.width - 10)
    for tx = v1.x2+ fall_gap, maxX, 10 do
        local tline, ty = self:getDownLine(tx, v1.y2  + jump_max_y)
        if tline == v2 then
            return tx
        end
    end

    return false
end

function hasLadder(self, v1, v2)
    for i,ladder in ipairs(self.ladders) do
        if y1 + 30 > ladder.bottom and 
            y1 - 30 < ladder.top and
            v1.x1 < ladder.right and
            v1.x2 > ladder.left and
            v2.x1 < ladder.right and
            v2.x2 > ladder.left and
            ladder.bottom - y2 < sec_jump_max_y - 10
        then
            local action = self:getLadderAction(ladder, v1)
            if action then
                return action
            end
        end
    end
end

function hasLadder2(self, v1, v2)
    for i,ladder in ipairs(self.ladders) do
        if y1 + 30 > ladder.bottom and 
            y1 - 30 < ladder.top and
            v1.x1 < ladder.right and
            v1.x2 > ladder.left and
            v2.x1 < ladder.right and
            v2.x2 > ladder.left
        then
            local lx = (ladder.left + ladder.right)/2
            local ly = (ladder.top + ladder.bottom)/2
            local tline, ty = self:getDownLine(lx, ly)
            if tline == v2 then
                return {t = 2, {x1 = lx - 10, x2 = lx + 10}, {op = 2}, p = ly - y2}
            end
        end
    end
end

function setLineMap(self, v1, v2)
    if v1 == v2 then
        return nil
    end

    self:isConnected()
    self:isTooHigh()
    
    local passL = false
    local passR = false
    if y1 - y2 > 20 then
        passL = self:canPassL()
        passR = self:canPassR()
        if passL == false and passR == false then
            self:hasLadder()            
            return nil
        end
    end
    
    --上下是否有交叉
    local x1 = math.max(v1.x1, v2.x1)
    local x2 = math.min(v1.x2, v2.x2)
    local sy, dy 
    if x2 - x1 > -10 then
        if y1 < y2 then
        else
            if passL and self:getLineEnd(math.max(v1.x1, 10), v1.y1) == 1 then
                return {{x1 = v1.x1 - 30, x2 = v1.x1 - 10}, p = y1 - y2}
            elseif passR and self:getLineEnd(math.min(v1.x2, self.width - 10), v1.y2) == 1 then
                return {{x1 = v1.x2 + 10, x2 = v2.x2 + 30}, p = y1 - y2}
            else
                self:hasLadder2()
            end
        end
    end

    return self:getLineAction(v1, v2, passL or passR)
end


function getLadderAction(self, ladder, line)
    local x1, x2, y1, y2, op, side
    if line.x1 > ladder.right then
        x1, y1 = line.x1, line.y1
        x2, y2 = ladder.right, ladder.bottom
        side = SIDE_LEFT
    elseif line.x2 < ladder.left then
        x1, y1 = line.x2, line.y2
        x2, y2 = ladder.left, ladder.bottom
    else
        x1 = (ladder.left + ladder.right) / 2
        y1 = self:_calcLineY(x1, line)
        x2 = x1
        y2 = ladder.bottom
        side = SIDE_RIGHT

        if y1 > y2 then
            op = 2
        end
    end

    return self:getAction(x1, x2, y1, y2, side, op)
end

function getLineAction(self, v1, v2, passX)
    local x1, x2, y1, y2, side

    if passX then
        x2 = passX
        y2 = self:_calcLineY(x2, v2)
        if x2 > v1.x2 then
            x1 = v1.x2
            y1 = v1.y2
        else
            x1 = v1.x1
            y1 = v1.y1
        end
    else
        --往左走
        if v1.x1 > v2. x2 then
            x1, y1 = v1.x1, v1.y1
            x2, y2 = v2.x2, v2.y2
            side = SIDE_LEFT
        --往右走
        elseif v1.x2 < v2.x1 then
            x1, y1 = v1.x2, v1.y2
            x2, y2 = v2.x1, v2.y1 
            side = SIDE_RIGHT
        else
            --找出更短的那根
            local lv, sv = v1, v2
            if v1.x2 - v1.x1 < v2.x2 - v2.x1 then
                lv, sv = sv, lv
            end

            x1 = (sv.x1 + sv.x2) / 2
            if x1 > lv.x1 and x1 < lv.x2 then
            elseif sv.x1 > lv.x1 and sv.x1 < lv.x2 then
                x1 = sv.x1
            elseif sv.x2 > lv.x1 and sv.x2 < lv.x2 then
                x1 = sv.x2
            end

            x2 = x1
            y1 = self:_calcLineY(x1, v1)
            y2 = self:_calcLineY(x1, v2)
        end
    end


    --跳跃，检查上方障碍
    local dx =  math.abs(x1 - x2)
    if  y1 - y2 < 300 or dx > fall_max_x then
        --检查跳跃最高点
        local tline, ty = self:getDownLine((x1+ x2) / 2, y1 + jump_max_y)
        if ty > y1 and tline ~= v2 then
            return nil
        end
        --检查跳跃落点
        local tline, ty = self:getDownLine(x2, y1 + 40)
        if ty > y2 and tline ~= v2 then
            return nil
        end
        --检查二段跳最高点
        if dx > jump_max_x then
            tline, ty = self:getDownLine((x1+ x2) / 2, y1 + sec_jump_max_y)
            if ty > y2 and tline ~= v2 then
                return nil
            end
        end
    end

    return self:getAction(x1, x2, y1, y2, side)
end

function getAction(self, x1, x2, y1, y2, side, op)
    if y1 > y2 and self:getLineEnd(x1, y1) > 1 then
        return nil
    end

    local dx = x2 -x1
    local dy = y2 - y1
    local vx = dx >= 0 and jump_vx or -jump_vx
    local op = op or 1
    local midx = (x1 + x2) / 2

    local multiFlagX, multiFlagY
    if dy > sec_jump_max_y then
        return nil
    elseif dy > jump_max_y then
        multiFlagY = true
    end

    dx = math.abs(dx)
    if dx > sec_jump_max_x then
        return nil
    elseif dx > jump_max_x then
        vx = vx * dx / 2 / jump_max_x
        multiFlagX = true
    else
        --可以直接掉下去
        if dy < -300 then
            if side == SIDE_LEFT then side = SIDE_RIGHT
            elseif side == SIDE_RIGHT then side = SIDE_LEFT end
            op = 0
        end

        vx = vx * dx / jump_max_x
    end

    --左右误差
    local diffL, diffR = 10, 10
    if side == SIDE_LEFT then
        diffL = -5
        diffR = 15
    elseif side == SIDE_RIGHT then
        diffL = 25
        diffR = -5
    end

    local p = math.abs(dx) + math.max(dy, 0)
    if multiFlagX or multiFlagY then
        local y
        if x1 == x2 then
            y = (y1 + y2) / 2
        end

        return {{x1 = x1 - diffL, x2 = x1 + diffR}, {op = op, vx = vx, vy = jump_vy},
        {x1 = midx - diffL, x2 = midx + diffR, y = y}, {op = op, vx = vx, vy = sec_jump_vy}, 
        p = p}
    else
        if op == 0 then
            return {{x1 = x2 - diffL, x2 = x2 + diffR}, p = p}
        else
            return {{x1 = x1 - diffL, x2 = x1 + diffR}, {op = op, vx = vx, vy = jump_vy}, p = p}
        end
    end
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

--]]
