local root = "/home/leng/git/blog/lua"
package.path = package.path .. ";"  .. root.. "/misc/?.lua" 
require "misc"
require "compile"

output = "output/chapter10.md"

local str = ""

str = str .. compile [[
    |test="test"| 
    |test|
]]

clear(output)
echo(str)
