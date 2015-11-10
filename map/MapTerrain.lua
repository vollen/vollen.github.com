-----------------------------------------------
-- [FILE] MapTerrain.lua
-- [DATE] 2015-07-15
-- [CODE] BY tianye
-- [MARK] NONE
-----------------------------------------------

module("MapTerrain", package.seeall)

--TODO:优化效率 by tianye
--------------------------------------
YSTEP       = 200
YSTEP_HALF  = 100

-- Line
LINE_DOWN       = 1
LINE_UP         = 2

-- Rect
RECT_LADDER     = 1 --梯子
RECT_OBSTACLE   = 2 --障碍
RECT_HINDER     = 3 --只阻挡箱子的障碍
--------------------------------------

function init(self, cfg)
    self.mapid = cfg.id
    self.width = cfg.width
    self.height = cfg.height
    
    --平台线
    self.lines = {}
    self.lineMove = {}
    self.lineDownIndex = {}
    self.lineUpIndex = {}
    
    --梯子
    self.ladders = {}
    self.ladderIndex = {}
    
    --只阻挡箱子的障碍
    self.hinders = {}
    self.hinderIndex = {}
    
    --障碍
    self.obstacles = {}
    self.obstacleIndex = {}
    self.obstacleMove = {}
    
    

    -- init Line
    if cfg.mapdata.lines then
        for i,line in ipairs(cfg.mapdata.lines) do
            self:initLine(line)
        end
        -- self:initLine({x1 = -600, y1 = -300, x2 = self.width + 600, y2 = -300, block = LINE_DOWN})
    end

    -- initLadder
    if cfg.mapdata.rects then
        for i,rect in ipairs(cfg.mapdata.rects) do
            if rect.type == RECT_LADDER then
                self:initLadder(rect)
            elseif rect.type == RECT_HINDER then
                self:initHinder(rect)
            elseif rect.type == RECT_OBSTACLE then
                self:initHinder(rect)
                self:initObstacle(rect)
                
                self:initLine({x1 = rect.x, y1 = rect.y + rect.h, x2 = rect.x + rect.w, y2 = rect.y + rect.h, block = LINE_DOWN})
                self:initLine({x1 = rect.x, y1 = rect.y, x2 = rect.x + rect.w, y2 = rect.y, block = LINE_UP})
            end    
        end
    end
    
    local YN = math.ceil(cfg.height / YSTEP) + 1
    for i = 1, YN do
        self:initLineIndex(i)
        self:initLadderIndex(i)
        self:initHinderIndex(i)
        self:initObstacleIndex(i)
    end
end

function initLine(self, v, onlyUpdate)
    if v.x1 > v.x2 then
        v.x1, v.x2 = v.x2 - 1, v.x1 + 1
        v.y1, v.y2 = v.y2, v.y1
    else
        v.x1, v.x2 = v.x1 - 1, v.x2 + 1
    end
    
    local dx = math.abs(v.x1 - v.x2)
    local dy = math.abs(v.y1 - v.y2)
    local dl = math.sqrt(dx*dx + dy*dy)
    
    v.kx = dx/dl
    v.ky = dy/dl
    
    if v.x1 ~= v.x2 then
        v.k = (v.y2 - v.y1)/(v.x2 - v.x1)
    else
        v.k = 0 --不应该出现竖线的情况
    end
    
    v.block = v.block or LINE_DOWN
    
    if not onlyUpdate then
        if v.fromUnit then
            table.insert(self.lineMove, v)
        else
            table.insert(self.lines, v)
        end
    end
end

function initLineIndex(self, index)
    local ty = index * YSTEP - YSTEP_HALF
    local downlist = {}
    local uplist = {}
    for i, v in ipairs(self.lines) do
        local y1,y2
        if v.y1 < v.y2 then
            y1 = v.y1
            y2 = v.y2
        else
            y1 = v.y2
            y2 = v.y1
        end
        
        local valid = false
        if ty >= y1 and ty <= y2 then
            valid = true
        elseif math.abs(ty - y1) <= YSTEP_HALF or math.abs(ty - y2) <= YSTEP_HALF then
            valid = true
        end
        
        if valid then
            if v.block == LINE_DOWN then
                table.insert(downlist, i)
            elseif v.block == LINE_UP then
                table.insert(uplist, i)
            end
            
        end        
    end
    self.lineDownIndex[index] = downlist
    self.lineUpIndex[index] = uplist
end

function initLadder(self, v)
    v.left = v.x - 1
    v.bottom = v.y
    v.right = v.x + v.w - 1
    v.top = v.y + v.h
    
    table.insert(self.ladders, v)
end

function initLadderIndex(self, index)
    local ty = index * YSTEP - YSTEP_HALF
    local list = {}

    for i,v in ipairs(self.ladders) do
        local valid = false
        if ty >= v.bottom and ty <= v.top then
            valid = true
        elseif math.abs(ty - v.bottom) <= YSTEP_HALF or math.abs(ty - v.top) <= YSTEP_HALF then
            valid = true
        end
        
        if valid then            
            table.insert(list, i)
        end        
    end
    
    self.ladderIndex[index] = list
end

function initHinder(self, v)
    v.left = v.x
    v.bottom = v.y
    v.right = v.x + v.w
    v.top = v.y + v.h
    
    table.insert(self.hinders, v)
end

function initHinderIndex(self, index)
    local ty = index * YSTEP - YSTEP_HALF
    local list = {}

    for i,v in ipairs(self.hinders) do
        local valid = false
        if ty >= v.bottom and ty <= v.top then
            valid = true
        elseif math.abs(ty - v.bottom) <= YSTEP_HALF or math.abs(ty - v.top) <= YSTEP_HALF then
            valid = true
        end
        
        if valid then            
            table.insert(list, i)
        end        
    end
    
    self.hinderIndex[index] = list
end

function initObstacle(self, v, i)
    local w = v.w + OBSTACLE_EDGE + OBSTACLE_EDGE
    if v.fromUnit then
        v.left = v.x - w/2
        v.bottom = v.y - v.h/2
        v.right = v.left + w
        v.top = v.bottom + v.h
        
        table.insert(self.obstacleMove, v)
    else
        v.left = v.x - OBSTACLE_EDGE
        v.bottom = v.y
        v.right = v.x + w
        v.top = v.y + v.h

        table.insert(self.obstacles, v)
    end
end

function initObstacleIndex(self, index)
    local ty = index * YSTEP - YSTEP_HALF
    local list = {}

    for i,v in ipairs(self.obstacles) do
        local valid = false
        if ty >= v.bottom and ty <= v.top then
            valid = true
        elseif math.abs(ty - v.bottom) <= YSTEP_HALF or math.abs(ty - v.top) <= YSTEP_HALF then
            valid = true
        end
        
        if valid then            
            table.insert(list, i)
        end        
    end
    
    self.obstacleIndex[index] = list
end


function calcLineY(self, x, v)
    if v.k == 0 then
        return v.y1
    else
        return v.y1 + (x - v.x1) * v.k
    end
end

function _calcLineY(self, x, v)
    if v.k == 0 then
        return v.y1
    else
        return v.y1 + (x - v.x1) * v.k
    end  
end


function checkLineX(self, line, x)
    return (x > line.x1 and x < line.x2)
end

function _checkLineX(self, line, x)
    return (x > line.x1 and x < line.x2)    
end


function getDownLine(self, x, y)
    local retLine = nil
    local retY = 0    
    
    local t = math.floor(y / YSTEP) + 1
    
    retLine, retY = self:_getDownLine(x, y, t, retY)

    for _,tline in ipairs(self.lineMove) do
        if tline.block == LINE_DOWN and self:_checkLineX(tline, x) then
            local ty = self:_calcLineY(x, tline)
            if ty - tline.fromUnit.moveY < y + tline.fromUnit.lineFixY and ty > retY then
                retLine = tline
                retY = ty
            end
        end
    end

    return retLine, retY
end

function _getDownLine(self, x, y, i, retY)
    local list = self.lineDownIndex[i]
    if not list then
        return nil, retY
    end
    
    local retLine = nil
    for _, v in ipairs(list) do
        local tline = self.lines[v]
        if x >= tline.x1 and x <= tline.x2 then
            local ty = self:_calcLineY(x, tline)
            if ty < y and ty > retY then
                retLine = tline
                retY = ty
            end
        end
    end

    if retLine then
        return retLine, retY
    else
        return self:_getDownLine(x, y, i - 1, retY)
    end
end

function getUpLine(self, x, y)
    local retLine = nil
    local retY = 9999

    local t = math.floor(y / YSTEP) + 1

    for _, v in ipairs(self.lineUpIndex[t] or {}) do
        local tline = self.lines[v]
        if x >= tline.x1 and x <= tline.x2 then
            local ty = self:_calcLineY(x, tline)
            if ty >= y and ty < retY then
                retLine = tline
                retY = ty
            end
        end
    end

    for _,tline in ipairs(self.lineMove) do
        if tline.block == LINE_UP and self:_checkLineX(tline, x) then
            local ty = self:_calcLineY(x, tline)
            if ty >= y and ty < retY then
                retLine = tline
                retY = ty
            end
        end
    end
    
    return retLine, retY
end

function getLadder(self, x, y)
    local t = math.floor(y / YSTEP) + 1

    for _,v in ipairs(self.ladderIndex[t] or {}) do
        local ladder = self.ladders[v]
        if self:checkLadder(x, y, ladder) then
            return ladder
        end
    end
    
    return nil
end


function checkLadder(self, x, y, ladder)
    if ladder and
        x > ladder.left and
        x < ladder.right and
        y > ladder.bottom and
        y < ladder.top
    then
        return true
    end
    return false
end


-- 增加移动平台
function insertMoveLine(self, line)
    if line then
        self:initLine(line)
    end
    
end

function updateMoveLine(self, line)
    if line then
        self:initLine(line, true)
    end
    
end
-- 去除移动平台
function removeMoveLine(self, line)
    if line then
        for i,v in ipairs(self.lineMove) do
            if v == line then
                table.remove(self.lineMove, i)
                break
            end
        end
        
    end
end

-- 增加移动障碍
function insertMoveObstacle(self, rect)
    if rect then
        self:initObstacle(rect)
    end
    
end
-- 去除移动障碍
function removeMoveObstacle(self, rect)
    if rect then
        for i,v in ipairs(self.obstacleMove) do
            if v == rect then
                table.remove(self.obstacleMove, i)
                break
            end
        end
        
    end
end

-----------------------检测障碍碰撞---------------------------------
--检测点和障碍碰撞
function checkPointCollision(self, x, y)
    local ti = math.floor(y / YSTEP) + 1
    for k,v in ipairs(self.obstacleIndex[ti] or {}) do
        local rect = self.obstacles[v]
        if y > rect.bottom and y < rect.top and
            x > rect.left and x < rect.right
        then
            return true, rect.left, rect.right
        end
    end
    
    for k,v in ipairs(self.obstacleMove) do
        if y >= v.bottom and y < v.top then
            if x > v.left and x < v.right then
                return true, v.left, v.right
            end 
        end
    end
    return false
end

--检查t2点是否可达(不需要返回碰撞点)（怪物寻敌和追击用到的检测,如有其他需求可修改）
function checkLineCross(self, t1, t2)
    if t1.x > t2.x then
        t1,t2 = t2,t1
    end
    
    local ty = (t1.y + t2.y)/2 + 40
    local ti = math.floor(ty / YSTEP) + 1
    for k,v in ipairs(self.obstacleIndex[ti] or {}) do
        local rect = self.obstacles[v]
        if ty > rect.bottom and ty < rect.top and
            t1.x < rect.left and t2.x > rect.right
        then
            return true
        end 
    end
    
    for k,v in ipairs(self.obstacleMove) do
        if ty > v.bottom and ty < v.top and
            t1.x < v.left and t2.x > v.right
        then
            return true
        end 
    end
    return false
end

--检查从t1 到 t2 (有向) 是否有障碍, 返回碰撞点(如果没有碰到,返回终点) (角色移动用到)
function checkLineCollision(self, t1, t2, checkLine)
    local ot1, ot2 = t1, t2
    local xBound = "left"
    if t1.x > t2.x then
        t1,t2 = t2,t1
        xBound = "right"
    end
    
    local ty = (t1.y + t2.y)/2 + 10
    local ti = math.floor(ty / YSTEP) + 1
    --人物上下可能分处两个区间， 上移过多，会导致无法检测下方区间的障碍
    for k,v in ipairs(self.obstacleIndex[ti] or {}) do
        local rect = self.obstacles[v]
        if ty >= rect.bottom and ty <= rect.top then
            if t1.x <= rect[xBound] and t2.x >= rect[xBound] then
              return self:getPOfLineAndRect(ot1, ot2, rect.left, rect.right, rect.bottom, rect.top)
            elseif ot1.x > rect.left and ot1.x < rect.right then
                if ot1.x + ot1.x < rect.left + rect.right then
                    return rect.left, ot2.y
                else
                    return rect.right, ot2.y
                end
            end
        end 
    end

    for k,v in ipairs(self.obstacleMove) do
        if ty >= v.bottom and ty <= v.top then
            --穿过障碍边线
            if t1.x <= v[xBound] and t2.x >= v[xBound] then
                return self:getPOfLineAndRect(ot1, ot2, v.left,v.right, v.bottom, v.top)
            elseif ot1.x > v.left and ot1.x < v.right then
                if ot1.x + ot1.x < v.left + v.right then
                    return v.left, ot2.y
                else
                    return v.right, ot2.y
                end
            end
        end 
    end
    
    if checkLine then
        local n = math.ceil(math.abs(ot2.x - ot1.x)/5)
        local x = ot1.x
        local y = ot1.y
        local dx = (ot2.x - x)/n
        local dy = (ot2.y - y)/n
        for i = 1, n do
            x = x + dx
            y = y + dy
            local tline, ty = MapTerrain:getDownLine(x, y + 5)
            if tline and y < ty then --在平台线上
                y = ty
            end
        end
        return x, y
    else
        return ot2.x, ot2.y
    end
end

--从A点到B点(有向),与障碍的碰撞点 (如果没有碰到,返回终点)
function getPOfLineAndRect(self, t1, t2, left, right, bottom, top)
    --垂直的情况
    if t1.x == t2.x then
        return t2.x, t2.y
    end

    local k = (t2.y -t1.y)/ (t2.x - t1.x)
    local resultX, resultY
    --与两侧边沿碰撞
    if t1.x <= left then
        resultX = left
    elseif t1.x >= right then
        resultX = right
    end
    
    if resultX then
        resultY = (resultX - t1.x)*k  + t1.y
        if resultY >= bottom and resultY <= top then
            --为了不影响贴墙跳跃动作, 这里不调整Y坐标
            -- return resultX + fixX, resultY
            return resultX, t2.y
        end
    end

    --与上下边沿碰撞
    if t1.y <= bottom then
        resultY = bottom
    elseif t1.y >= top then
        resultY = top
    end

    if resultY then
        resultX = (resultY - t1.y) / k  + t1.x
        if resultX >= left and resultX <= right then
            return resultX, resultY
        end
    end

    return t2.x, t2.y
end

--检测矩形和障碍碰撞
function checkRectCollision(self, rect)
    local ty = rect.y + rect.h/2
    local ti = math.floor(ty / YSTEP) + 1
    for k,v in ipairs(self.obstacleIndex[ti] or {}) do
        local tmp = self.obstacles[v]
        if checkRect(tmp, rect) then
            return true, tmp
        end 
    end
    
    for k,v in ipairs(self.obstacleMove) do
        if rect.fromUnit ~= v.fromUnit then
            if not
               (v.right + v.space < rect.x or 
                rect.x + rect.w < v.left - v.space or
                v.bottom + v.h < rect.y or
                rect.y + rect.h < v.bottom)
            then
                return true, v
            end 
        end
    end
    return false
end


--检测箱子和障碍碰撞
function checkRectCollisionForBox(self, rect, booster)
    local ty = rect.y + rect.h/2
    local ti = math.floor(ty / YSTEP) + 1
    for k,v in ipairs(self.hinderIndex[ti] or {}) do
        local tmp = self.hinders[v]
        if checkRect(tmp, rect) then
            return true, tmp
        end 
    end
    
    for k,v in ipairs(self.obstacleMove) do
        if rect.fromUnit ~= v.fromUnit and
         v ~= booster then
            if not
               (v.right + v.space < rect.x or 
                rect.x + rect.w < v.left - v.space or
                v.bottom + v.h < rect.y or
                rect.y + rect.h < v.bottom)
            then
                return true, v
            end 
        end
    end
    return false
end

----------------------------------------------------
-- 寻路
----------------------------------------------------
function findPath(self, src, dst)
    if self.lineMap == nil then
        return nil
    end
    
    local waitList = {}
    local deadList = {}
    
    local function calc(i, j)
        do return 0 end
        local v1 = self.lines[i]
        local v2 = self.lines[j]
        local dx = ((v1.x1 + v1.x2) - (v2.x1 + v2.x2))/2
        local dy = ((v1.y1 + v1.y2) - (v2.y1 + v2.y2))/2
        return math.abs(dx) + math.abs(dy)
    end
    
    local function cmpi(v1, v2)
        return v1.p + v1.d < v2.p + v2.d
    end
    
    waitList[1] = {i = src, p = 0, d = calc(src, dst)}
    while waitList[1] and waitList[1].i ~= dst do 
        local ff = waitList[1]
        local cc = self.lineMap[ff.i]
        table.remove(waitList, 1)
        deadList[ff.i] = ff
        if cc then
            for i,v in pairs(cc) do
                if deadList[i] == nil then
                    local info = nil
                    for _,tt in ipairs(waitList) do
                        if tt.i == i then
                            info = tt
                            break
                        end
                    end
                    
                    local p = ff.p + v.p + 100
                    local d = calc(ff.i, i)
                    if info then
                        if p < info.p then
                            info.p = p
                            info.f = ff
                        end
                    else
                        table.insert(waitList, {i = i, p = p, d = d, f = ff})
                    end
                end
            end
        end
        
        table.sort(waitList, cmpi)
    end
    
    if #waitList > 0 then
        local result = {}
        local tmp = waitList[1]
        while tmp do
            if tmp.f then
                table.insert(result, 1, tmp.i)
                tmp = tmp.f
            else
                break
            end
        end
        return result
    end
    return nil
end

function initLineMap(self)
    for i,line in ipairs(self.lines) do
        line.i = i
    end

    local cnt = #self.lines
    self.lineCnt = cnt
    for i, ladder in ipairs(self.ladders) do
        ladder.i = cnt + i
    end

    self.lineMap = require("config/scene/"..self.mapid.."path")
end

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
            if i ~= j then
                self.lineMap[i][j] = self:selectLine(line1, line2)
            end
        end
    end

    local cnt = #self.lines
    local index
    for i,ladder in ipairs(self.ladders) do
        index = cnt + i
        ladder.i = index
        self.lineMap[index] = {}
        for j,line in ipairs(self.lines) do
            self:setLadderMap(ladder, line, i)
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
--]]

--[[
function setLineMap(self, v1, v2)
    if v1 == v2 then
        return nil
    end

    --相连接，直接走过去
    if v1.group == v2.group then
        if math.abs(v1.x1 - v2.x2) < 20 or math.abs(v1.x2 - v2.x1) < 10 then
            return {{x1 = v2.x1 + 5, x2 = v2.x2 - 5}, p = math.min(50, (v2.x2 - v2.x1)/2)}
        else
            return nil
        end
    end

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
    
    local passL = false
    local passR = false
    local passX
    if y1 - y2 > 20 then
        local minX = math.max(v1.x1 - sec_jump_max_x, 10)
        for tx = v1.x1 - fall_gap, minX,  -10 do
            local tline, ty = self:getDownLine(tx, v1.y1 + jump_max_y)
            if tline == v2 then
                passL = true
                passX = tx
                break
            end
        end
        
        local maxX = math.min(v1.x2 + sec_jump_max_x, self.width - 10)
        for tx = v1.x2+ fall_gap, maxX, 10 do
            local tline, ty = self:getDownLine(tx, v1.y2  + jump_max_y)
            if tline == v2 then
                passR = true
                passX = tx
                break
            end
        end
        
        if passL == false and passR == false then
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
                return nil
            end
        end
    end

    return self:getLineAction(v1, v2, passX)
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
