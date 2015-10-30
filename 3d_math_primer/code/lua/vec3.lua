vec3 = {}

function vec3.new(x, y, z)
    local ret = {}
    setmetatable(ret, {__index = vec3})
    ret:init(x, y, z)
    return ret
end

function vec3.init(self, x, y, z)
    self[1] = x or 0
    self[2] = y or 0
    self[3] = z or 0
end

--输出
function vec3.print(v)
    return string.format("[%f, %f, %f]", v[1], v[2], v[3])
end
--标准化
function vec3.normalize(v)
    local magSq = vec3.magSq(v)
    if magSq > 0 then
        local oneOverMag = 1.0 / math.sqrt(magSq)
        v[1] = v[1] * oneOverMag
        v[2] = v[2] * oneOverMag
        v[3] = v[3] * oneOverMag
    end
end

--3维模
function vec3.mag(v)
    return math.sqrt(v[1] * v1[1] + v[2] * v[2] + v[3] * v[3])
end

--3维模的平方
function vec3.magSq(v)
    return v[1] * v1[1] + v[2] * v[2] + v[3] * v[3]
end

function vec3.dotN(v, n)
    return vec3.new(n * v[1], n * v[2], n* v[3])
end
--3维点乘
function vec3.dot(v1, v2)
    return v1[1] * v2[1] + v1[2] * v2[2]+ v1[3] * v2[3]
end

--3维叉乘
function vec3.cross(v1, v2)
    return vec3.new(v1[2] * v2[3] - v1[3] * v2[2], v1[3] * v2[1] - v1[1] * v2[3], v1[1] * v2[2] -  v1[2] * v2[1])
end

--3维减
function vec3.sub(v1, v2)
    return vec3.new(v1[1]-v2[1], v1[2]-v2[2], v1[3]-v2[3])
end
--3维加
function vec3.add(v1, v2)
    return vec3.new(v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3])
end

function vec3.distance(v1, v2)
    local d1 = v1[1] - v2[1]
    local d2 = v1[2] - v2[2]
    local d3 = v1[3] - v2[3]
    return math.sqrt(d1 * d1 + d2 * d2 + d3 * d3)
end

