local ROOT="~/advance/blog"
local DRAFT_ROOT=ROOT .. "/source/_drafts/"

for filename in io.popen("ls " .. DRAFT_ROOT):lines() do
    local r = io.popen("wc -l " .. DRAFT_ROOT .. filename)
    local str = r:read("*a")
    local lineCnt = string.match(str, "^(%w+)")
    if tonumber(lineCnt) > 15 then
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

