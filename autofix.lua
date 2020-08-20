local function exec(cmd)
    local f = io.popen(cmd);
    if(f) then
        local content = f:read("a")
        f:close()
        return content;
    end
    return nil;
end

local function writeFile(file, content)
    local f = io.open(file, "w")
    if(not f) then return end

    f:write(content);
    f:close();
    print("write to file successed: " .. file);
end


local function split(str, p)
    if(p == "") then return {str}; end
    local result = {};
    local i = 1
    local s, e
    while(true) do
        s, e = string.find(str, p, i)
        if(s) then
            table.insert(result, string.sub(str, i, s - 1))
            i = e + 1
        else
            table.insert(result, string.sub(str, i))
            break;
        end
    end
    return result
end

local function printt(t)
    for i, v in ipairs(t) do
        print(i, v)
    end
end


local function getBackupName(file)
    return "/tmp/blog/" .. file
end

local function getFileName(filename)
    local name = string.gsub(filename, ".*/(.-).md$", "%1")
    name = name:gsub("\\ ", " ")
    return name
end

local function mkdirp(filename)
    filename = filename:gsub("/$", "");
    local dir = filename:gsub("^(.*)/.-$", "%1");
    local len = string.len(dir)
    os.execute("mkdir -p " .. dir)
end

local function insertFileContent(file, content)
    local f = io.open(file, "r");
    print("insertFileContent", f, content)
    if(not f)then return end

    local backup = getBackupName(file);
    mkdirp(backup)
    os.execute(string.format("cp -f %s %s", file, backup));

    local contentOrigin = f:read("a")
    print(contentOrigin)
    f:close()

    f = io.open(file, "w+")
    if(not f)then return end
    f:write(content .. "\n")
    f:write(contentOrigin);
    f:close()
    os.execute("cat " .. file)
end

local function getTags(filename)
    local tags = split(filename, "/")
    table.remove(tags, 1)
    table.remove(tags, 1)
    table.remove(tags, 1)
    local name = getFileName(filename)
    tags[#tags] = name
    return tags
end

local monthDict = {
    ["Jan"] = 1,
    ["Feb"] = 2,
    ["Mar"] = 3,
    ["Apr"] = 4,
    ["May"] = 5,
    ["Jun"] = 6,
    ["Jul"] = 7,
    ["Aug"] = 8,
    ["Seq"] = 9,
    ["Oct"] = 10,
    ["Nov"] = 11,
    ["Dec"] = 12,
}
local tmp = {};
local function fixTimeStr(dateStr)
    dateStr = dateStr:gsub("^%s*(.*)%s*$", "%1")
    local week, month, day, time, year = table.unpack(split(dateStr, " "))
    month = monthDict[month] or month
    return string.format("%s-%s-%s %s", year, month, day, time)
end

local function getCreateTime(filename)
    local info = exec(string.format("git log %s | tail -n 5", filename))

    local date = info:gsub(".*Date:(.*)+0800.*", "%1")
    print(date, fixTimeStr(date))
    date = fixTimeStr(date)
    return date
end

local format = [[   
title: {{filename}}
date: {{date}}
tags: {{tags}}
---
]]
local function createInsertContentByName(filename)
    local date = getCreateTime(filename)
    local name = getFileName(filename)
    local tags = getTags(filename)
    local tagStr = "\n";
    for i, v in ipairs(tags) do
        tagStr = tagStr .. "  - " .. v .. "\n"
    end
    local t = {
        filename = name,
        date = date,
        tags = tagStr
    }
    local content = format:gsub("{{(%w+)}}", t)
    return content
end

local function main()
    local ROOT=exec("pwd")
    local files = io.popen("find ./source -name '*.md'")
    for file in files:lines() do
        file = file:gsub("(%s)", "\\%1")
        local top = exec(string.format( "cat %s | head -n 1", file))
        -- print("----", file, top)
        if(top and not top:find("title:")) then
            local t = createInsertContentByName(file)
            insertFileContent(file, t);
            print(file, t)
        end
    end
end

main();
