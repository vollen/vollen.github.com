

script 的起始个结束标签都不能省略

webgl程序基本流程
```js
//获取到canvas结点
var ele = document.getElementById("canvas");
//获取绘制上下文
var gl = ele.getContext("webgl")
//然后就可以通过这个gl来使用webgl接口了
//初始化着色器
initShaders();
//设置背景色
gl.clearColor(r, g, b, a)
//清除所有颜色
gl.clear()
//绘制
draw()
```

[webgl编程指南示例地址](https://sites.google.com/site/webglbook/)
[webgl编程指南代码库地址](http://rodger.global-linguist.com/webgl/lib)
#勘误
35页, webgl坐标系统的Y轴应该是“正方向为下”
48页代码56行应该使用width, 57行应该是用height


#接口
gl.clearColor(r, g, b, a)
gl.clear(glenum bufferType)
gl.drawArrays(mode, first, count)

#着色器
##顶点着色器
###内置变量
vec4 gl_Position
float gl_Point_size
####传参函数族
gl.vertexAttrib[1234][fi][?v](location, params)

##片元着色器
###内置变量
vec4 gl_FragColor; //片元颜色
vec2 gl_FragCoord; //片元坐标

### attribute 变量
```js
//1.在着色器中声明变量
attribute vec4 a_point;
//2.在着色器中使用变量
gl_Position = a_point;
//3.在JS代码中想变量传输数据
var location = gl.getAttribLocation(glProgram, "a_point");
gl.vertexAttrib3f(location, 0.0, 0.0, 0.0);
```

## uniform变量
gl.getUniformLocation(name);
gl.uniform[1234][fi](location, params);

## varying变量
用于从顶点着色器向片元着色器传输数据。
如果在顶点着色器和片元着色器中有着相同类型和命名的varying型变量， 
那么在顶点着色器中给该变量赋的值会被自动地传入片元着色器。

+ 右手坐标系
旋转的方向， 用右手法则来判断， 右手握拳， 大拇指伸直并使其指向旋转轴的正方向， 那么右手其余手指的旋转方向为旋转的正方向。

+ JavaScript程序和着色器程序是协同运行的

+ webgl 函数是向颜色缓冲区中绘制内容， 而颜色缓冲区在每一次显示到屏幕上之后会被清空。
所以每一次重新绘制时， 都需要重新绘制所有内容， 而不仅仅是变化的部分。


## arrayBuffer
```js
var buffer = gl.createBuffer();
var a_point = gl.getAttribLocation(gl.program, "a_point");
gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
gl.vertexAttribPointer(a_point, size, gl.Float, normalized, stride, offset);
gl.enableVertexAttribArray(a_point);
```
## 其他渲染管线流程
###图元装配
###图元光栅化
rasterzation process

# 仿射变换
webgl 和 opengl 中的矩阵都是按照列主序存储在数组中的。
所以以下矩阵都使用列矩阵形式表示
## 平移矩阵
[
    1, 0, 0, 0
    0, 1, 0, 0
    0, 0, 1, 0
    x, y, z, 1
]
## 旋转矩阵
### 绕 z 轴旋转
x' = x * cos(B) - y * sin(B)
y' = x * sin(B) + y * cos(B)
z' = z
[
    cos(B), sin(B), 0, 0
    -sin(B), cos(B),  0, 0
    0,      0        1, 0
    0,      0,       0, 1
]

### 缩放矩阵
[
    sx, 0, 0, 0
    0, sy, 0, 0
    0, 0, sz, 0
    0, 0,  0, 1
]

## 矩阵与的乘法
乘法之后的维度变化
(m x n) * (m' x n') = m x n'

## 在着色器中使用矩阵
p' = matrix * p
使用矩阵matrix 可将点p变换到点p';
可通过 gl.uniformMatrix4fv往着色器程序传矩阵参数。

```js
//声明uniform变量
uniform mat4 u_matrix;
attribute vec4 a_point;
//使用
gl_Position = u_matrix * a_point;
//js中传递参数
var u_matrix = gl.getUniformLocation(gl.program, "u_matrix");
var matrix = new Float32Array([/*矩阵数据*/]);
gl.uniformMatrix4fv(u_matrix, false, matrix);
```

```js
//请求一次异步函数调用
var requestId = requestAnimationFrame(callback)
cancelAnimationFrame(requestId);
```

# 纹理
## 浏览器配置
浏览器中, 由于安全原因，默认是不允许访问本地文件的。
为了能继续调试学习，我们需要解除这一限制。
当然也可以通过在本地安装web服务器来实现（nginx, node/http-server）， 这里不赘述。
### chrome
启动的时候， 传入--allow-file-access-from-files参数。
在windows中可通过修改 "右键->属性->目标" 中的值来实现。
linux 中可在启动程序的命令之后附加参数.

## st/uv 坐标系统
原点在左下角， s轴向左， t轴向上， s和t的值域都为[0, 1];

##
gl.TEXTURE[0-8] 多个内置纹理单元
gl.TEXTURE_2D 二维纹理
gl.TEXTURE_CUBE_MAP 立方体纹理

```js
//创建纹理
var texture = gl.createTexture();
//纹理可被删除
//gl.deleteTexture(texture);
//反转纹理Y轴, 因为webgl的坐标系统与png、jpg等格式的图片的坐标系统y轴是相反的，
//所以需要反转。 或者通过在着色器中反转t轴坐标也可以。
gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, 1);
//是否预乘Alpha
//gl.pixelStorei(gl.UNPACK_PREMULTIPLU_ALPHA_WEBGL, 1)
//激活/绑定纹理
gl.activeTexture(gl.TEXTURE[0-8]);
gl.bindTextre(gl.TEXTURE_2D, texture);
//设置纹理参数, pname: gl.TEXTURE_MIN_FILTER, gl.TEXTURE_WRAP_S,gl.TEXTURE_WRAP_T
gl.texParameteri(gl.TEXTURE_2D, pname, param);
//将纹理图像分配给纹理对象
gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGB, gl.RGB, gl.UNSIGNED_BYTE, image);

//片元着色器中的方法
uniform sampler2D u_sampler;
gl_FragColor = texture2D(u_sampler, v_textureCoord);
```

# 三维世界
## 视点和视线
视点：观察者坐标(eyeX, eyeY, eyeZ)
观察目标点： 被观察目标所在点(atX, atY, atZ)
上方向： 最终绘制在屏幕上的影像中的向上的方向 (upX, upY, upZ)

视图矩阵： 通过上面三个矢量， 计算出的物体绘制时的变换矩阵
模型矩阵： 模型通过各种仿射变换之后得到的最终变换矩阵
模型视图矩阵： 视图矩阵 * 模型矩阵， 因为对于同一模型的所有顶点都一样， 所以预乘节省运算

# 投影
正视投影
透视投影
MVP矩阵 = 投影矩阵 * 视图矩阵 * 模型矩阵

# 深度缓冲
gl.enable(gl.DEPTH_TEST);
gl.clear(gl.DEPTH_BUFFER_BIT);

# 多边形便宜
gl.enable(gl.POLYGON_OFFSET_FILL)
