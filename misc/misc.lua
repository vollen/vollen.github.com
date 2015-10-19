function p(...)
    print(f(...))
end

function f( ... )
    return string.format(...)
end

function clear(file)
    os.execute("rm -rf " .. file)
end

function echo( ... )
    os.execute("echo \"" .. f(...) .. "\" >> " .. output)
end


--[[math]]
function toR(angle)
    return angle * math.pi / 180
end

function cos(angle)
    return math.cos(toR(angle))
end

function sin(angle)
    return math.sin(toR(angle))
end


function onPanel(p, n, d)
    local offset = dot3(p, n) - d
    print("onPanel==", offset)
    return math.abs(offset) < 2
end

function onBall(p, c, r)
    local d = vec3.distance(p, c)
    return math.abs(d - r) < 0.1
end

