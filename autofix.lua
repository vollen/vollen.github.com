local function exec(cmd)
    local f = io.popen(cmd);
    if(f) then
        local content = f:read("*a")
        f:close()
        return true, content;
    end
    return false, nil;
end

local _, ROOT=exec("pwd")

local files = io.popen("find . -name '*.md'")
for file in files:lines() do
    local 
    print(exec(string.format( "cat %s | head -n 3", file)))
end