
local select=select
local setmetatable=setmetatable
local getfenv=getfenv
local setfenv=setfenv
local loadstring=loadstring
local type=type
local tostring=tostring
local next=next
local unpack=unpack
local assert=assert
local string=string
local table=table
local io=io
 
local function result(...)
    return select("#",...),select(1,...)
end
 
function compile(code)
    local is_code=string.sub(code,1,1)~="|"
    local codes={""}
    local args={}
    local args_cache={}
    local E=setmetatable({},{__index=getfenv(2)})
    for v in string.gmatch(code,"[^|]+") do
        if is_code then
            table.insert(codes,v)
        else
            local f,err=loadstring("return " .. v)

            local n,value=result(setfenv(assert(f,err),E)())
            if n>0 then
                local t=type(value)

                if t=="nil" or t=="number" or t=="boolean" then
                    table.insert(codes,tostring(value))
                elseif t=="string" then
                    table.insert(codes, value)
                else
                    local n=args_cache[value]
                    if not n then
                        table.insert(args,value)
                        n=#args
                        args_cache[value]=n
                    end
                    table.insert(codes,"__arg_"..tostring(n))
                end
            end
        end
        is_code=not is_code
    end

    local code_string=table.concat(codes, "")
 
    return code_string
end


