local root = "/home/leng/git/blog/src"
package.path = package.path .. ";"  .. root.. "/misc/?.lua" 
require "misc"
require "compile"

output = root .."/output/test_3d_math/chapter10.md"

local str = ""

str = str .. compile [[
    |test="test"| 
    |test|
]]

clear(output)
echo(str)
