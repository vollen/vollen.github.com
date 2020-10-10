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


