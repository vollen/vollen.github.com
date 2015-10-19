local t = {}
triangle = t

function t.new(p1, p2, p3)
    local ret = {}
    setmetatable(res, {__index = t})
    ret:init(p1, p2, p3)
    return ret
end
