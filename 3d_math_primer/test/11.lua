local root = "/home/leng/git/blog/code"
package.path = package.path .. ";"  .. root.. "/misc/?.lua" 
package.path = package.path .. ";" .. root .. "/3d_math_primer/code/lua/?.lua"
require "misc"
require "vec3"
require "compile"
output = "output/chapter11.md"

local str = ""
--test1
n={0.3511, 0.9363, 0} p={10, 20, 0} d=6
d2 = d-vec3.dot(n, p)
p2 = vec3.add(p, vec3.dotN(n, d2))
str = str .. compile [[
# chapter11
## 1. 
    | d2 |, | vec3.print(p2) |
]]

--test2
o={3,4,5} d={0.2673, 0.8018, 0.5345}
p1={18, 7, 32} p2 = {13, 52, 26}
v1=vec3.sub(p1, o) v2 = vec3.sub(p2, o)
t1=vec3.dot(v1, d) t2=vec3.dot(v2, d)
p1_ = vec3.add(o, vec3.dotN(d, t1))
p2_ = vec3.add(o, vec3.dotN(d, t2))

str = str .. compile [[
## 2. 
    |t1| | vec3.print(p1_) |
    |t2| | vec3.print(p2_) | 
]]


--test3
n = {0.4338, 0.8602, -0.1613} d=42
p1={3, 6, 9}                        p2={7, 9, 42}
d1=d-vec3.dot(p1, n)                d2=d-vec3.dot(p2, n)
p1_=vec3.add(p1, vec3.dotN(n, d1))  p2_=vec3.add(p2, vec3.dotN(n, d2))

str = str ..compile[[
## 3.
  | vec3.print(p1_) |
  | vec3.print(p2_) |  
]]

--test4
c=vec3.new(2, 6, 9) r=1 p=vec3.new(3, -17, 6)
e = c:sub(p)  d = e:mag()
p_ = p:add( e:dotN((d-r)/d) )

str = str ..compile [[
## 4.
    |p_:print()|
]]

clear(output)
echo(str)
