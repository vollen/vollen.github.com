title: glsl_info
tags: 
    - opengl
    - glsl
---

[GLSL教程](http://blog.csdn.net/racehorse/article/details/6593719)

 
# 入口
只能是main 函数

#注释
```glsl
//单行注释
/*
多行注释
*/
```
#变量名
+ 只包括 a-z, A-Z, 0-9 和 下划线(_);
+ 不能以数字开头
+ 不能使用关键字， 保留字
+ 不能以gl\_、webgl\_、\_webgl\_开头

#类型
强类型语言，赋值操作只能在同类型之间操作。
### 基本类型
int float bool
### 集合类型
vec2 vec3 vec4
ivec2 ivec3 ivec4
bvec2 bvec3 bvec4

mat2 mat3 mat4
### 纹理类型
sampler2D samplerCube

## 类型转换
3中基本类型可以通过同名内置函数互相转换

# 运算符
## 取负
\- 
## 四则运算
\* / + - ++ --
## 赋值
= += -= *= /=
## 比较
\> < <= >= == !=
## 逻辑
! && || ""
## 条件
condi ? a : b

# 矢量和矩阵
可以通过类型同名函数构造
矩阵是列主序的

可以使用以下几组分量名来访问矢量的第 1-4个元素
x, y, z, w
r, g, b, a
s, t, p, q
也可以使用[]加索引来访问元素

## 混合
可以通过分量名同时取矢量的多个分量， 然后按顺序复制给另一矢量。
同时使用的分量名必须是同一集合的。
```js
vec2 v2;
vec3 v3;
v2 = v3.wx;
```

# 结构体
struce name {
    float a;
    vec2 b;
} value1;
通过结构体同名函数， 然后按顺序传入成员参数， 即可构造结构体。
通过点运算符(.)可以访问成员
只支持 = == != 操作符。

# 数组
只支持一维数组
声明时必须使用整型常量表达式
不可以使用const 修饰
只支持整型常量表达式和uniform变量作为索引
不能在声明时一次性初始化， 只能用索引显式的对每个元素初始化
在以下两种情况下， 数组声明时可以不指定大小。
1. 在引用数组之前， 再次声明同类的指定大小的数组
2. 所有引用数组的索引值都是编译时常量， 编译器会自动给它分配使用到的最大大小

# 取样器
只能是uniform变量 或者访问纹理的函数的参数
只能通过 gl.uniform1i() 来赋值， 值必须是纹理单元编号

# 分支与循环
## 分支 
if(){} 
elseif(){} 
else{}
## for
for(初始表达式; 条件表达式; 步进表达式){
    循环内容
}
条件表达式可以为空
只允许有一个循环变量
循环表达式只能是 + 或 - 常量表达式
条件表达式必须是循环变量与整形常量的比较
循环变量不可在循环体内被赋值
限制是为了在编译器就可对for循环内联展开， 加快速度

## continue, break, discard
continue 跳出本次循环， 执行下次循环
break 结束当前循环， 并不在执行循环
discard 只能在片元着色器使用， 表示放弃当前片元， 直接处理下一个

# 函数
返回类型 函数名(参数类型 参数名, ...){
    函数执行
    return 返回值;
}
通过`函数名(参数列表)`来调用
不允许递归
使用之前必须先进行声明
## 参数限定词
in 传入函数的值， 函数内部可以使用， 也可以修改， 但不会影响到函数外部传入的变量
const in 不能被修改
out 传入变量的引用， 函数不使用其值， 在函数内修改， 会影响到函数外部传入的变量
inout 函数使用初始值，并且可以修改， 影响到外部变量
默认 in

## 内置函数
### 角度函数
radians, degrees
### 三角函数
sin, cos, tan, asin, acos, atan
### 指数函数
pow, exp, log, exp2, log2, sqrt, inversesqrt
### 通用数学函数
asb min max mod sign floor ceil clamp mix step smoothstep fract
### 几何函数
length distance dot cross normalize reflect faceforward
### 矩阵函数
matrixCmpmult
### 矢量函数
lessThan lessThanEqual greaterThan greaterThanEqual equal notEqual
any all not
### 纹理查询函数
texture2D textureCube texture2DProj texture2DLod textureCubeLod 
texture2dProjLod

# 全局变量， 局部变量
声明在函数外部的是全局变量
函数内部的是局部变量
attribute uniform varying 变量必须是全局变量
for 循环可以声明变量， 但是if 闭门会

## 变量限定字
### const
声明该变量不可变， 声明的同时必须初始化。
### attribute
只能在顶点着色器使用
类型只能是 float vec2 vec3 vec4 mat2 mat3 mat4
能容纳的attribute类型变量数目与设备有关， 至少8个
const mediump int gl_MaxVertexAttribs 最大attribute变量数量
### uniform
可以是出了数组或结构体外的任意类型
为每个顶点着色器和片元着色器 提供一致性数据
### varying
类型与attribute相同
必须在顶点和片元着色器同时声明
值并不是直接从顶点着色器传递给片元着色器的， 中间有光栅化过程，对顶点数据进行了内插

## 精度限定字
highp mediump lowp

## 声明对应类型的默认精度
precision 精度限定字 类型名称;
除了片元着色器的float 类型外， 其他所有的类型都有默认精度， 所以如果没有特殊需求，只需要给片元着色器的float类型设置精度

# 预处理指令
```c
#if condi
#endif

#ifdef MACRO
#endif

#ifndef MACRO
#endif

#define MACRO value
#undef MACRO

//配置glsl es 版本， 只有两个值可选
#version 100 | 101 
```
GL_ES
GL_FRAGMENT_PRECISION_HIGH 片元着色器支持highp精度


《OpenGl着色语言》 笔记

作者： Randi Rost

## 基础知识
ARB: OpenGL Architecture Review Board
扩展: 最开始添加的时候， 扩展添加厂家后缀，被更多厂家实现之后添加EXT前缀, 完全经过ARB审查之后， 添加ARB前缀, 再然后才会被添加到OpenGL规范中。
`glGetString(GL_EXTENSION)`可以返回当前实现所支持的扩展。
客户（应用程序）- 服务器(OpenGL实现) 模型。
数据绑定发生在发出命令时，之后对该数据的更改不影响存储在OpenGL内的数据。
帧缓冲区
双重缓冲区
    深度缓冲区
    模板缓冲区
    积聚缓冲区 比颜色缓冲区更高的精度，允许几幅图像积聚在一起， 可以用来显示动态模糊效果。
    多重采样缓冲区

状态机 OpenGL有非常多的状态来控制绘制过程， 这些状态是彼此正交的。
glEnable/glDisable 用来开启或关闭某种状态
glEnableClientState/glDisableClientState
glPushAttrib/glPopAttrib
glPushClientAttrib/glPopClientAttrib
glGet*

渲染管线

### 绘制几何对象
两种方式：逐顶点 和 顶点数组
### 逐顶点
glBegin 开始一个图元
glVertx， glColor, glNormal 等函数配置顶点属性
glEnd 结束改图元
### 顶点数组
在顶点数组中存储顶点属性， 然后使用 glDrawArray, glDrawElements等接口一次性绘制大量图元。
glColorPointer 指定顶点颜色值数组
glVertexPointer 指定顶点位置值数组

模型空间
世界空间

一维纹理 二维纹理 三维纹理 立方贴图纹理(每个主轴方向有一个二维纹理)
纹理单元

### glsl 特点
glsl 是一种高级过程语言
顶点着色器和片元着色器使用相同的语言(很小一部分不一样)
基于C和C++语法以及流控制
生来支持矢量和矩阵操作
类型比C和C++更严格， 调用必须有返回值
使用类型限定符而不是读取和写入操作来管理输入和输出
着色器长度没有限制

### 顶点着色器
属性变量(attribute) 一致变量(uniform) 易变变量(varying)
顶点着色器输出的 varying变量数量可以多于片元着色器接收的。

### 比C增加的
添加矢量vec*和矩阵mat*类型
可以使用 xyzw rgba 等分量来直接访问数据。
sampler 类型
输入输出限定符


### glslviewer
[github](https://github.com/patriciogonzalezvivo/glslViewer)
[viewer + sublime](https://zhuanlan.zhihu.com/p/32443564)

GPU 工作方式： 单指令多线程， 同一个指令控制器， 多个线程执行同样的指令。