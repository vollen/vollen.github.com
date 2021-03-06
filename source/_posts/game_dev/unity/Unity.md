
# 资源商店
[unity asset store](https://www.assetstore.unity3d.com/)

# 界面
## 变换工具
+ 手型工具(Q 或按住鼠标中键), 可拖动场景
+ Alt + 鼠标左键， 可旋转场景
+ Alt + 鼠标右键， 可缩放场景
+ 移动工具(W)， 可移动对象，点击坐标轴可沿坐标轴移动
+ 旋转工具(E)， 可旋转对象
+ 缩放工具(R)， 可拉伸对应的轴缩放，中心灰色方块统一缩放
+ 矩形工具， 显示对象在当前截面的矩形，可拉伸，按住 shift 等比拉伸
+ F 键 可以将当前选中的对象，显示在舞台中间
+ 鼠标右键 + W/A/S/D 可以以第一人视角在场景中移动
+ 右上角的坐标轴可以切换到不同的视角
+ 坐标轴中间的方块可以让场景在`透视模式`和`等角投影模式`之间切换
## 变换辅助工具
### 轴心选项
+ center 选中的多个对象的中心点显示为轴心
+ pivot 以最后选中的对象中心为轴心
### 坐标轴选项
+ global 显示世界坐标轴
+ local 显示物体坐标轴
## layers 分层工具
可以选择显示不显示某一分层
## layout
切换工具视图布局，可以保存自定义布局

# 资源管理
+ 直接拖动到 assets 文件夹下
+ 搜索栏可以搜索资源
- name 名称搜索
- t:type 使用类型过滤
- l:tag 标签过滤
+ 移动或重命名资源，最好在 unity 编辑器中进行，否则可能会失去资源之间的关联。
+ 资源分类，方便查找搜索 

# 脚本
+ unity 中的 c# 环境是经过修改的， 与原生的 c# 不一样。


## 本地文档
[manual](file:///Applications/Unity/2019.3.1f1/Documentation/en/Manual/index.html)
[api](file:///Applications/Unity/2019.3.1f1/Documentation/en/ScriptReference/index.html)

# 资源
[游戏蛮牛Unity脚本手册](http://docs.manew.com/Script/index.htm)
[游戏蛮牛Unity用户手册](http://docs.manew.com/Components/1.html)
[Unity3D高级编程之进阶主程](http://www.luzexi.com/Unity3D/index.html)

# linq
[c# LINQ用法](https://www.cnblogs.com/forever-Ys/p/10322130.html)
[LINQ系列目录](https://www.cnblogs.com/libingql/p/4038821.html)
# xml
[C# LINQ to XML](https://www.cnblogs.com/forever-Ys/p/10324833.html)

# gitignore
[unity ignore](https://github.com/github/gitignore/blob/master/Unity.gitignore)

# 新输入系统 
[官方文档](https://docs.unity3d.com/Packages/com.unity.inputsystem@1.0/manual/index.html)
[Unity新输入系统InputSystem尝鲜](http://dingxiaowei.cn/2020/01/23/)
 

## unitypackage
[最佳姿势导出unitypackage](https://zhuanlan.zhihu.com/p/55007069)

## 调试
### 死循环卡死问题查找
[快速查找Unity死循环](http://www.voidcn.com/article/p-pkbvsvxi-wk.html)
使用 VS attach 上unity进程, 启动unity 游戏。
在卡死的时候, 在VS 中打开 `窗口=>调试=>线程`, 点击调试工具栏的暂停按钮, 线程窗口即可在卡死的代码处中断。


## 遮罩/挖孔
[Unity UI Mask实现原理](https://www.pianshen.com/article/1943355651/)
详细的说明了`Mask`实现机制，以及模板裁切过程中的各个参数的意义。


## Unity 


## asset bundle
[官方教程](https://learn.unity.com/tutorial/assets-resources-and-assetbundles)
[官方手册页](https://docs.unity3d.com/Manual/AssetBundlesIntro.html)

[Addressable Assets](https://docs.unity3d.com/Packages/com.unity.addressables@1.15/manual/index.html)

`Asset Bundle` 就是一个文件合集， 就像一个文件夹一样， 包含了很多不同的文件在里面。
+ 能够处理好互相的依赖。bundle 之间可能有依赖关系。
+ 可以使用压缩算法压缩, (LZMA, LZ4)
+ 

# DOTS
[Unity DOTS(一） Job System 介绍](https://zhuanlan.zhihu.com/p/66336209)
[Unity DOTS(二) ECS编码示例](https://zhuanlan.zhihu.com/p/67099436)

## ECS
[浅谈Unity ECS（一）Uniy ECS基础概念介绍：面向未来的ECS](https://zhuanlan.zhihu.com/p/59879279)
[浅谈Unity ECS（二）Uniy ECS内存管理详解：ECS因何而快](https://zhuanlan.zhihu.com/p/64378775)
[浅谈Unity ECS（三）Uniy ECS项目结构拆解：功能要点及案例分析](https://zhuanlan.zhihu.com/p/70782290)
## Job system
[Unity C# Job System介绍(一) Job System总览和多线程](https://zhuanlan.zhihu.com/p/56459126)
[Unity C# Job System介绍(二) 安全性系统和NativeContainer](https://zhuanlan.zhihu.com/p/57626413)
[Unity C# Job System介绍(三) Job的创建和调度](https://zhuanlan.zhihu.com/p/57859896)
[Unity C# Job System介绍(四) 并行化Job和故障排除(完结)](https://zhuanlan.zhihu.com/p/58125078)

### NativeContainer
`NativeContainer`是一种托管的数据类型，为原生内存提供一种相对安全的C#封装。
它包括一个指向非托管分配内存的指针。当和`Job System`一起使用时，一个`NativeContainer`使得一个`Job`可以访问和主线程共享的数据，而不是在一份拷贝数据上工作。
除了`NativeContainer`, `Job`中使用的其他数据都是以**数据的拷贝**的形式存在的，无法与主线程交换数据。
可用的 `NativeContainer` 有: `NativeArray`,`NativeList`,`NativeHashMap`,`NativeMultiHashMap`,`NativeQueue`。
#### 生命周期
在创建 `NativeContainer`时，我们需要为它指定 `Alloctor`, 不同的 `Alloctor` 有不同的内存管理方式，已经分配速度。
共有三种可用的 `Alloctor`: `Allocator.Temp`, `Allocator.TempJob`, `Allocator.Persistent`。
#### IJobParallelFor
并行化`Job` 会被分配到 CPU 的多个线程中同时执行，每个线程处理一部分数据。
并行化`Job` 使用一个 `NativeArray` 来存储它的数据源，它的`Excute(int index)`函数包含`index` 参数用于读取数据。


## Burst Compiler
[Unity Burst 用户指南](https://blog.csdn.net/alph258/article/details/83997917)