local ROOT="~/advance/blog"
local DRAFT_ROOT=ROOT .. "/source/_drafts/"

local MIN_LINE_CNT = 15;

for filename in io.popen("ls " .. DRAFT_ROOT):lines() do
    local r = io.popen("wc -l " .. DRAFT_ROOT .. filename)
    local str = r:read("*a")
    local lineCnt = string.match(str, "^(%w+)")
    if tonumber(lineCnt) > MIN_LINE_CNT then
        local splitI = string.find(filename, "\.md")
        if splitI then
            filename = string.sub(filename, 1, splitI -1)
            local success = os.execute("hexo publish " .. filename)
            if success ~= 0 then
                break
            end
        end
    end
end

