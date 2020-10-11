1. 数据结构选型。 怎么选择使用哪个数据结构? 最近使用的比较复杂的一次是? 常用数据结构的时间复杂度分析
2. 地图空间搜索。 怎么搜索， 使用什么数据结构？
3. 渲染优化
4. 项目中比较有意思的解决方案
5. 战斗中的数据验证

1. C# 拆箱装箱。优化
2. 智能指针
3. 客户端性能优化。 压缩纹理，压缩比（pvrtc, etc, astc）
4. opengl es 的版本变化， 引入了什么?
[opengles 官方文档](https://www.khronos.org/opengles/)
[OpenGL ES 3.0 对比 OpenGL ES 2.0 的异同点和新功能](https://blog.csdn.net/afei__/article/details/88859449)
opengl es 1.0 是固定功能管线。
2.0, 3.0 引入可编程管线。 
3.0 完全兼容 2.0，并提供了更多新功能。
主要的变化有:

+ 删除了管线中的`Alpha 测试` 和`逻辑操作（LogicOp）`两部分
+ 着色器脚本变化
1. 着色器中必须添加版本声明， `#version 300 es`
2. 输入输出
新增了`in`，`out`，`inout` 关键字，用来取代 `attribute` 和 `varying` 关键字
3. layout 变量赋值
```
# shader脚本中
layout (location = 1) uniform float a;
GLES30.glUniform1f(1, 1f);
```
+ 新功能
1. 纹理
支持 `gamma 校正`
强制支持 ETC2/EAC
2. 着色器
二进制程序文件
实例 和顶点 id
片元着色器可修改片元深度
uniform block
3. 几何形状
实例渲染
布尔遮挡查询
4. 缓冲区对象
uniform 缓冲区对象
缓冲区对象间拷贝
5. 帧缓冲区
多重渲染目标（MRT)
帧缓冲区失效提示
新的混合方程式, 支持最大值/最小值函数作为混合方程式
多重采样渲染缓冲区




[WebGL，OpenGL和OpenGL ES三者的关系](https://blog.csdn.net/qq_23034515/article/details/108283747)
OpenGL 是一个通用的图形API接口标准，在不同的设备上有不同的实现。
OpenGL-ES 是 OpenGL 的嵌入式版本， 相比OpenGL 删除了一些低效率的功能。
WebGL 是 OpenGL-ES 的一个 JavaScript 绑定。

[WebGPU](https://zhuanlan.zhihu.com/p/95956384)
WebGPU是最新的Web 3D图形API，是WebGL的升级版。
浏览器封装了现代图形API（Dx12、Vulkan、Metal），提供给Web 3D程序员WebGPU API。


5. GPU 优化
6. 实时阴影
7. 网络相关， 状态同步与帧同步， protobuff， 长连接短连接
8. lua 相关功能
目标是作为一种胶水语言，能够方便的嵌入到一个宿主语言中。整个语言的包特别小，源代码只有 20k 行。打包出来的库只有 200k 左右。
lua 是由纯C实现， 方便移植。

+ 基础数据类型
nil boolean string number function table thread userdata
+ 元表
table 的扩展， lua 的核心机制之一。
setmetatable(table, metatable)
__index
__newindex
__call
__tostring
__eq
__add
__sub
+ 垃圾回收
lua 使用自动垃圾回收机制， 程序不需要手动管理内存。 所有不可再被访问到内存都将被释放。所有直接被 Registry, _Global 以及全部变量 引用的内存不会被回收。
lua 垃圾回收算法为 标记-清除算法。 算法开始时，会标记所有根对象， 然后从这些对象开始，把所有它们引用到的对象全部标记。清除的时候， 所有未被标记的对象被回收。
有增量回收和代际回收两种机制。
1. 增量回收，是指垃圾回收与代码逻辑交替执行，每次只标记或回收一部分对象。整个回收过程需要持续很多帧。
2. 代际回收，分为两部分，新生代回收和全局回收。
新生代回收只会扫描并回收最近分配的对象。当新生代回收结束时占用内存还大于某一个阈值时，便会开始一个不中断的全局回收。
每当当前占用内存大于上次全局回收之后的内存 x% 的时候， 会触发一次新生代回收。 

+ 弱表
弱表是包含弱引用的表， 它可以有三种类型，弱键/弱值/弱键值。如果一个值只被一个弱表作为弱值/弱键引用, 那么它可以被回收。
对于弱表来说，键或值中的任何一个被回收之后， 这个键值对都会被从弱表中删除。
对于弱表的类型修改，需要到下一次垃圾回收之后才会生效。

+ 协程
[Lua的协程和协程库详解](https://www.cnblogs.com/zrtqsk/p/4374360.html)
lua 中的协程是比线程更轻量级的一种调度方式。 它有自己的调用堆栈。 同一时刻，只能有一个协程在执行， 执行中的协程只能通过 coroutine.yield 来交出控制权。
要开始执行一个协程只能使用 coroutine.resume 。
coroutine.yield(...) 中传入的参数会作为调用 coroutine.resume() 函数的第二个及更多返回值, 第一个返回值为 boolean 表示协程是否执行完毕。
当函数执行完毕的时候， 函数返回值会作为最后一个 coroutine.resume() 的返回值。
coroutine.resume(...) 中传入的参数会作为协程中调用 coroutine.yield(...) 函数的返回值。 首次调用的参数会作为协程主函数的参数。 
```lua
local c = coroutine.create(function (a, b)
    print("coroutine: ",  a, b)
    local c, d = coroutine.yield(a + b)
    print("coroutine: ", c, d)
    return c + d
end)
print("main：", coroutine.resume(1, 2))
print("main:", coroutine.resume(3, 4))
print("main:", coroutine.resume())


--[[ 输出
coroutine: 1 2
main: True 3
coroutine: 3 4
main: true 7
main: false cannot resume dead coroutine
]]--
```

+ 与其他语言的交互
luastack
+ 热更新
[Lua热更新](https://gameinstitute.qq.com/community/detail/120538)
require 加载脚本进来， 会保存在 package.loaded 中， 只需要下面这样既可完成简单粗暴的热更。但是这样已经引用了该模块的地方不会被更新。
```lua
function reload_module(module_name)
    package.loaded[modulename] = nil
    require(modulename)
end
```
+ luajit
[LuaJIT GC64 模式](https://blog.openresty.com.cn/cn/luajit-gc64-mode/)

+ lua ffi
lua ffi 是luajit 提供的一个用于调用 C 接口的库，使用 ffi, 可以在lua 中声明 C 接口和数据结构, 然后直接调用。而不需要写繁琐的绑定代码。
cocos 使用的lua 绑定工具是基于 tolua++ 的，在上层开发了生成工具( bindings-generator)用于生成 tolua ++ 需要的配置文件。


1. 同屏小怪数量较多， 如何优化渲染开销
2. 子弹碰撞如何实现，raycast 是怎么做的
3. 如何判断点在扇形内，如何判断椎体与球体相交
```ts
/**
 * 扇形和点, 扇形 原点 o， 正方向 v , 夹角 a , 长度 l
 * 对于点 p。 
 *  Math.acos(op · v) < a / 2 && dis(p, o) < l
 * 椎体和球体相交, 思路一样， 只不过三维有大小。
 * 球的圆心为 c， 半径为 r, 
 * 令 rt 为扇形原点到球心与球切线的夹角
 * 则椎体与球体相交在以下情况成立
 * 
 * dis(o, c) - r < l && Math.acos(oc · v) - rt < a/ 2;
 */
```
4. 渲染， 常用光照模型， opengl 渲染管线
5. 算法题




