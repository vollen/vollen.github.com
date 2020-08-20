local ROOT="~/advance/blog"
local DRAFT_ROOT=ROOT .. "/source/_drafts/"
local list_cmd = string.format("find %s -name \"*.md\"", DRAFT_ROOT)

-- local DRAFT_ROOT="/home/leng/advance/tools_git/crew/src/classes/com/morecruit"
-- local list_cmd = string.format("find %s -name \"*.java\"", DRAFT_ROOT)

local MIN_LINE_CNT = 15;

local cnt = 0
for filename in io.popen(list_cmd):lines() do
    local r = io.popen("wc -l " .. filename)
    local str = r:read("*a")
    local lineCnt = string.match(str, "^(%w+)")
    -- if lineCnt then
    --     cnt = cnt + lineCnt
    --     print("--", filename, lineCnt)
    -- end
    if lineCnt and tonumber(lineCnt) > MIN_LINE_CNT then
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

print("==total-cnt", cnt)
