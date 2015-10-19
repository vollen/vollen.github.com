local root = "/home/leng/git/blog/code"
package.path = package.path .. ";"  .. root.. "/misc/?.lua" 
require "misc"
require "compile"

output = "output/chapter12.md"

local str = ""

str = str .. compile [[
    #chapter12
    ## 1. y = 6 - 4x/7
    ## 2. n = [6, 10, -2] X [3, -1, 17] = [168, -108, -36]
        |l=math.sqrt(168 * 168 + 108 * 108 + 36 * 36 )|
          d = pn = [6 * 168 / |l|, 10 * -108 / |l|, -36 * -108 / |l|]
          panel = 
]]

clear(output)
echo(str)
