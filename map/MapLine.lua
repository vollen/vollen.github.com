function printMapLine()
    local data = MapTerrain.lineMap
    local maxn = #MapTerrain.lines

    local str = "return {\n"
    for i = 1, maxn do
        if data[i] then
            str = str .. "    ["..i.."] = {\n"
            for j = 1, maxn do
                if data[i][j] then
                    str = str .. "        ["..j.."] = " .. item(data[i][j]) .. ",\n"
                end
            end
            str = str .. "    },\n"
        end
    end
    str = str .. "}\n"

    local fd = io.open(string.format("/home/leng/work/aries/cpp/%dpath.lua", Map.id), "w+")
    fd:write(str)
    fd:flush()
    fd:close()
end

function item(data)
    local tt = "{"
    
    if data[1] then
        tt = tt .. "{x1=" .. tostring(data[1].x1) .. ",x2=" .. tostring(data[1].x2) .. "},"
    end
    
    if data[2] then
        tt = tt .. "{op=" .. tostring(data[2].op)
        if data[2].vx then
            tt = tt .. ",vx=" .. tostring(math.floor(data[2].vx))
        end

        if data[2].vy then
            tt = tt .. ",vy=" .. tostring(math.floor(data[2].vy))
        end
        tt = tt .. "},"
    end

    if data[3] then
        -- tt = tt .. "[3] = {x1=" .. tostring(data[3].x1) .. ",x2=" .. tostring(data[3].x2) .. ",y=" .. tostring(data[3].y) .. "},"
        tt = tt .. "[3] = {x1=" .. tostring(data[3].x1) .. ",x2=" .. tostring(data[3].x2) .. "},"

        if data[4] then
            tt = tt .. " [4] = {op=" .. tostring(data[4].op)
            if data[4].vx then
                tt = tt .. ",vx=" .. tostring(math.floor(data[4].vx))
            end

            if data[4].vy then
                tt = tt .. ",vy=" .. tostring(math.floor(data[4].vy))
            end
            tt = tt .. "},"
        end
        
    end

    if data.p then
        tt = tt .. "p=" .. tostring(data.p)
    end
    tt = tt .. "}"
    return tt
end
