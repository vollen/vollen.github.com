

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

[MSDN WEBGL](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API)
Khronos Group 开放标准的应用程序接口API 
[khronos webgl](https://www.khronos.org/webgl/)

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
vec2 gl_PointCoord; //片元在被绘制的点内的坐标

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
```js
[
    2/(right - left),       0,          0,      -(right + left) / (right -left),
    0,                2/(top-bottom),   0,      -(top + bottom) / (top - bottom),
    0,                    0,    -2/(far - near), -(far + near) / (far - near),
]
```
透视投影
```
[
    1/(aspect * tan(fov/2)),    0, 0, 0,
    0, 1/tan(fov/2), 0, 0,
    0, 0, -(far + near)/(far - near), -2* far * near/(far - near),
    0, 0, -1, 0
]
```
MVP矩阵 = 投影矩阵 * 视图矩阵 * 模型矩阵

# 深度缓冲
gl.enable(gl.DEPTH_TEST);
gl.clear(gl.DEPTH_BUFFER_BIT);

# 多边形便宜
gl.enable(gl.POLYGON_OFFSET_FILL)

# 光照
## 光源
点光源
平行光
环境光
## 反射
color = color_diffuse + color_ambient
+ 环境光
color = light_color * face_color
+ 平行光
color = light_color * face_color * cos(a)
cos(a) = v_normal * v_light_direct
+ 点光源
需要计算光源到顶点的方向， 然后按照平行光的公式处理
记住计算处理的方向要归一化
v_light_direct = normalize(a_light_position - a_position)

## 平面法向量
从平面的正方向看去， 顶点顺序是顺时针的。 可以使用左手握拳， 找到法向量方向。
使用平面任意两向量叉乘可计算出平面法向量

## 逆转置
逆转置矩阵可以用于计算平面法向量的变化。

## 逐片元光照
对顶点进行光照处理，可能表现效果会不那么自然。 可以在片元器里处理光照，表现的更自然。
这需要通过varying变量， 将 v_Color, v_Normal, v_Position, v_Light等信息传递到片元着色器。


# 着色器程序
```js
var shader = gl.createShader(gl.VERTEX_SHADER || gl.FRAGMENT_SHADER)
gl.deleteShader(shader);
gl.shaderSource(shader, source);
gl.compileShader(shader);
gl.getShaderParameter(shader, pname); //查看shader状态
gl.getShaderInfoLog(); //获取shader输出的日志信息
gl.createProgram();
gl.deleteProhram(program);
gl.attachShader(program, shader);
gl.detachShader(program, shader);
gl.linkProgram(program);
gl.useProgram(program); //可以使用该函数， 在不同的着色器程序之间来回切换
gl.getProgramParameter(program, pname);
gl.getProgramInfoLog(program);
```

# 获取指定范围内的颜色值
```js
gl.readPixels(x, y, w, h, format, type, pixels);
//example
var w = 1, h = 1;
var pixels = new Uint8Array(w * h * 4);
gl.readPixels(x, y, w, h, gl.RGBA, gl.UNSIGNED_BYTE, pixels);
```

# 其他高级策略
## 检查物体是否被点击
点击时通过uniform传递一个参数到着色器程序， 将物体绘制成指定颜色，然后从缓冲区读取点击点的颜色， 判断是否为指定颜色， 如果是， 表示选中了。
检查完之后， 记得将对应的参数重置， 然后重新绘制。
## 检查表面是否被点击
可以将表面信息传入到着色器中， 然后根据不同表面绘制不同的颜色， 思路跟上面类似， 通过检查指定点颜色来判断。
## 平视显示器
将两个canvas叠加， 2D信息部分用一个canvas显示， 叠加在3D图像上。
## 将3D物体显示在2d内容上
类似上例， 不过需要将上面的3dcanvas 的背景色alpha值设为0
## 雾化
```js
    float factor = (a_end - distance) /(a_end - a_start);
    v_Color = 光照之后的颜色 * factor + a_FrogColor * ( 1 - factor);
    //使用w分量来近似视点的距离
    //在视图坐标系中，w = 顶点的视图坐标z分量* -1, 视点在原点， 所以可以通过w来近似距离。
    v_Dist = gl_Position.w;
```

## 混合
在绘制的时候， 可以设置颜色混合策略
```js
gl.enable(gl.BLEND);
gl.blendFunc(src_factor, dst_factor);
//color = src_color * src_factor + dst_color * dst_factor;
//最常用的, a_color = color_src * a_src + color_dest * (1 - a_src) 
gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
```
混合参数可选值
gl.ZERO, gl.ONE, gl.SRC_COLOR, gl.ONE_MINUS_SRC_COLOR, gl.DST_COLOR, gl.ONE_MINUS_DRS_COLOR, 
gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.DST_ALPHA, gl.ONE_MINUS_DST_ALPHA,
gl.SRC_ALPHA_SATURATE

使用颜色混合的时候需要关闭深度缓存， 否则前面的颜色直接覆盖了后面的颜色， 也就无从混合了。
### 如何同时使用深度缓存和颜色混合呢？
```js
//开启深度缓存
gl.enable(gl.DEPTH_TEST);
//绘制所有透明度 >= 1.0 的物体
//锁定深度缓存区， 使之只读
gl.depthMask(true);
//绘制所有半透明物体
//解锁深度缓存区
gl.depthMask(false);

//当不透明的物体后面有透明物体时， 因为深度缓存的原因， 会直接被遮挡。 而不透明的颜色则可以继续混合。
```
## 渲染到纹理
### 帧缓冲区对象和渲染缓冲区对象
帧缓冲区对象包含三种不同的对象， 用于实现不同的功能， 颜色关联对象用于代替颜色缓冲区，深度关联对象用于代替深度缓冲区， 模板关联对象用于代替模板缓冲区。
这几种对象可以是两种类型的： 纹理对象或渲染缓冲区对象。
```js
//如何配置一个离屏渲染的帧缓冲区
//1.创建帧缓冲区对象
var framebuffer = gl.createFrameBuffer();
//2.创建纹理对象并设置其尺寸和参数
var texture = gl.createTexture();
gl.bindTexture(gl.TEXTURE_2D, texture);
gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
//gl.texParameteri();
//3.创建渲染缓冲区对象
var depthBuffer = gl.createRenderbuffer();
//4.绑定渲染缓冲区对象并设置其尺寸
gl.bindRenderbuffer(gl.RENDERBUFFER, depthBuffer);
gl.renderbufferStorage(gl.RENDERBUFFER, g.DEPTH_COMPONENT16, width, height);
//5.绑定帧缓冲区
gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
//5.将帧缓冲区的颜色关联对象指定为纹理对象
gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACTMENT0, gl.TEXTURE_2D, texture, 0);
//6.将帧缓冲区的深度关联对象指定为渲染缓冲区对象
gl.framebufferRenderbuffer(gl.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, gl.RENDER_BUFFER, depthBuffer);
//7.检查帧缓冲区是否正确配置
gl.checkFramebufferStatus(gl.FRAMEBUFFER);
//8.绘制到帧缓冲区
gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
gl.viewport(0, 0, width, height);

//切换会默认的颜色缓冲区
gl.bindFramebuffer(gl.FRAMEBUFFER, null);

//帧缓冲区对象可以被删除
gl.deleteFrameBuffer(frameBuffer);
//渲染缓冲区对象也可以被删除
gl.deleteRenderbuffer(depthBuffer)
```

## 阴影
思路： 使用两对着色器，第一对着色器，用于生成阴影贴图。第二对着色器根据片元在光照坐标系上的z值与光照贴图的值比较， 如果z值较大， 则处于阴影之中。 
1. 将视点移至光源位置， 然后使用着色器1绘制。 这里将要被绘制的片元都是被光照到的最前面的，将该片元的z值通过帧缓冲区绘制到阴影贴图中。
2. 将视点移回原来的位置， 然后使用着色器2绘制。计算出片元在光源坐标系下的z值， 与阴影贴图上的记录的z值比较是否被光照到。

Tips: 比较的时候， 需要在读取出来的z值上加上 0.005, 否则可能会出现马赫带。
    马赫带出现的原因是因为纹理贴图上的颜色分量精度为1/256， 而着色器的精度值为1/65535。所以可能会出现完全相同的坐标，阴影贴图的z值比着色器中的小， 而误以为它是阴影区域。所以需要在读出来的z值上添加一个略大于精度值单位的值。

将z值全部放在一个分量上可能会遇到分量值域太小不够用的情况， 我们可以考虑将颜色的4个分量都用来存储。
```js
    const vec4 bitShift = vec4(1.0, 256.0, 256.0 * 256.0, 256.0 * 256.0 * 256.0);
    const vec4 bitMask = vec4(1.0 / 256.0, 1.0 / 256.0, 1.0 / 256.0, 0.0);
    vec4 rgbaDepth = fract(gl_FragCoord.z * bitShift);
    rgbaDepth -= rgbaDepth.gbaa * bitMask;
    gl_FragColor = rgbaDepth;

    function unpackDepth(const in vec4 rgbaDepth){
        const vec4 bitShift = vec4(1.0, 1.0 / 256.0, 1.0/(256.0 * 256.0), 1.0/(256.0 * 256.0 * 256.0));
        float depth = doc(rgbaDepth, bitShift);
        return depth;
    }
```

## 加载三维模型
### Blender建模软件
### Obj格式
```js
# //注释 
mtllib filename //引用mtl文件
o name  //声明一个名为name的模型
v vertexs //顶点们
usemtl Material //使用材质Material
f indexes  //使用了材质的表面， 表面是由纹理坐标和法线的索引序列定义的， 索引从1开始
```
### mtl 文件格式
```js
newmtl Material //定义新的材质
Ka 0.000000 0.000000 0.000000 //环境色
Kd 1.000000 0.000000 0.000000 //漫射色
Ks 0.000000 0.000000 0.000000 //高光色
Ns 96.078431                  //高光色权重
Ni 1.000000                   //表面光学密度
d 1.000000                    //透明度
illum 0                       //光照模型
```

## 上下文丢失
通过监听webglcontextlost, webglcontextrestored 这两个事件来响应上下文丢失和恢复的情况。
在恢复时，重新设置webgl状态
```js
    canvas.addEventListener("webglcontextlost", function(ev){
        cancelAnimationFrame(requestId);
        //默认是不在触发restore事件， 所以要阻止默认行为
        ev.preventDefault();
    }, false);
    canvas.addEventListener("webglcontextrestored", function(ev){
        //重新设置webgl 相关状态， 变量位置
    }, false);
```

## opengl 默认的裁剪空间中， 使用的左手坐标系
常用的第三方库使用的是右手坐标系。
可以通过在投影矩阵的z轴缩放因子上 * -1, 将传统库使用的右手坐标系， 转变为裁剪坐标系需要的左手坐标系。

## 逆转置矩阵
逆转置矩阵可以用与将平面的法向量变换到正确的值。
当不包含 缩放因子不一致 的缩放变换时， 可以直接使用模型矩阵的3x3子矩阵来变化法向量。
当包含缩放因子不一致 的缩放变换时，则必须使用逆转置矩阵来变换。
