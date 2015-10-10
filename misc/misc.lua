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
