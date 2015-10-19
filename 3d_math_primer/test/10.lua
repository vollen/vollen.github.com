local root = "/home/leng/git/blog/code"
package.path = package.path .. ";"  .. root.. "/misc/?.lua" 
require "misc"
require "compile"

output = "output/chapter10.md"

local str = compile [[ 
#chapter10
|c15=cos(15)|
|s15=sin(15)|
## 1.    [|c15| (|s15| 0 0)]
        1
        [|c15| (-|s15| 0 0)]

|n_2=0.149 / s15|
## 2.    angle = 30°, n = (|n_2|, -|n_2|, |n_2|)
        |angle = 6| |cos6=cos(6)| |sin6=sin(6)| |n_2_2= n_2 * sin6|
        angle = 6°, [|cos6|, (|n_2_2|, -|n_2_2|, |n_2_2|)]
]]

str = str .. compile [[
|w1= 0.233| |y1= -0.257| |x1= 0.060| |z1= -0.935|
|w2= -0.752| |y2= 0.374| |x2= 0.280| |z2= 0.459|
|w_w = w1 * w2| |x_x = x1 * x2| |y_y = y1 * y2| |z_z =z1 *z2|
## 3.    a * b = |w_w + x_x + y_y + z_z|
        a - b = a(-1)b = [|w_w + x_x + y_y + z_z|, (|w1*x2+w2*(-x1)-(-y1)*z2+y2*(-z1)|,|w1*y2+w2*(-y1)-(-z1)*x2+z2*(-x1)|,|w1*z2+w2*(-z1)-(-x1)*y2+x2*(-y1)|)]
        ab = [|w_w - x_x - y_y- z_z|, (|w1*x2+w2*x1-y1*z2+y2*z1|,|w1*y2+w2*y1-z1*x2+z2*x1|,|w1*z2+w2*z1-x1*y2+x2*y1|)]
        ab(2) = [|w_w - x_x - y_y- z_z|, (|w1*x2+w2*x1+x_x+y_y+z_z|,|w1*y2+w2*y1+x_x+y_y+z_z|,|w1*z2+w2*z1+x_x+y_y+z_z|)]
]]

str = str .. compile [[
|w=0.965| |x=0.149| |y=-x| |z=x|
## 4.   
        [|1- 2*y*y-2*z*z|, |2*x*y+2*w*z|, |2*x*z -2*w*y|]
        [|2*x*y-2*w*z|, |1- 2*x*x-2*z*z|, |2*y*z +2*w*x|]
        [|2*x*z+2*w*y|, |2*y*z -2*w*x|, |1- 2*x*x-2*y*y|]

]]

-- str = str .. [[


-- ]]

clear(output)
echo(str)


