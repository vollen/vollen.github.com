

# 模块机制
 核心模块
 內建模块
 文件模块
     .node / .js / .json
加载过程：
    标识符解析 路径分析 文件定位 [编译分析] 加载执行

require.extensions
progress.dlopen()
progress.binding()
 v8 gyp工具 libuv

## 包 NPM
[NPM官网](https://www.npmjs.com/)
### 包结构
    package.json
    bin
    lib
    doc
    test 
#### package.json
    name
    description
    version
    keywords
    maintainers : [{"name": xxx, "email": xxx, "web": xxx}]
    contributors :
    licenses
    repositories
    dependencies
    其他可选字段：scripts/homepage/os/cpu/engine/builtin/directories/implements
    npm 使用额外字段：author、bin、main􀖖devDependencies
#### npm 常用
##### install
+ -g 全局安装
根据`package.json`的 `bin`字段安装一个全局可用的可执行命令
安装目录为：path.resolve(process.execPath, '..', '..', 'lib', 'node_modules');
+ 本地安装
包含package.json的归档文件， 或者目录， 或者链接.
npm install <file | url | folder>
+ 非官方源
npm install xxx --registry=<url>
npm config set registry <url>
##### 钩子命令
可通过在 `package.json` 的`scripts`中配置钩子脚本，在执行npm命令的时候该脚本会被执行。如：
```json
"scripts":{
    "test":"test.js",
    "install":"install.js"
}
```
##### 发布包
npm init
npm adduser
npm publish <folder>
npm owner <ls | add | rm>
##### 分析包
npm ls 分析当前路径下课找到的所有包，生成依赖树
##### 如何考察一个包
良好的测试
良好的文档
良好的测试覆盖率
良好的编码规范
其他


# 异步IO
## 事件循环
Windows下基于IOCP， *nix 基于多线程创建
Windows中的系统调用过程： 
调用过程: js调用 --> 生成请求对象 --> 设置参数和回调函数 --> 加入线程池等待执行 --> 调用返回。
线程池执行： 线程可用 --> 执行完毕--> 设置结果 --> 通过IOCP --> 释放线程。
事件循环： 检查IOCP --> 获取完成的请求对象给观察者 --> 从观察者获取回调函数和结果 --> 执行回调。

核心概念: 时间循环， 线程池， 观察者， 请求对象。
## 非IO异步API
setTimeout        //放入红黑树中，循环时检查时间到了，拿出来执行
setInterval       //同上
setImmediate      //每轮事件循环只会执行一个immediate，立马进入下一个循环。
process.nextTick  //在事件循环的最开始执行

idle观察者 > IO观察者 > check 观察者

# 异步编程
EventEmitter();
EventProxy();
## Promises/Deferred
Q
when
## 流程控制库
### 尾触发与next
Connect 一个http库， 能已切面的形式，流式处理每一个步骤。
### async
### Step
### wind
## 过载保护
异步API， 可能会快速消耗系统资源， 所以需要控制。
### bagpip
### async 
async.parallelLimit()
async.queue()

# 内存控制
## V8内存限制
64位系统约为 1.4G, 32位系统约为 0.7G
## V8对象分配
所有对象都是通过堆来分配。
查看V8内存使用量: provess.memoryUsage()
限制原因是因为垃圾回收机制， 对于过大的堆内存， V8垃圾回收时间太长。
当然， 也可以通过以下命令来放开，程序运行时生效，中途不能修改。
```javascript
    node --max-old-space-size=1700 test.js  //单位为 MB
    node --max-new-space-size=1700 test.js  //单位为 KB
```
## V8垃圾回收机制
### 算法
分代式垃圾回收机制， 根据对象的存活时间，进行不同的分代， 不同的分代使用不同的垃圾回收算法。
V8中， 内存主要分为新生代和老生代。新生代为存活时间短的对象， 老生代为存活时间教长的对象， 或常驻内存的对象。
以上两条命令， 分别用于设置这两个分代的内存空间。
#### Scavenge算法
新生代主要使用Scavenge算法，具体实现主要采用了Cheney算法。
将内存一分为2，其中一个处于使用状态， 另一个处于空闲状态。 
垃圾回收时，将使用状态内存中的存活对象拷贝到空闲状态的内存中， 然后交换两个内存块的角色。
因为对于新生代对象生命周期短， 所以存活对象少， 效率很高。 **典型的空间换时间**
因为V8使用分代机制， 所以在一定条件下， 会被移入老生代内存中。
1. 当一个对象多次在拷贝过程中存活。
2. 目标内存块利用率超过25%，因为该内存块是接下来的使用块， 所以内存占比过高， 会影响接下来的内存分配。
#### Mark-Sweep + Mark-Compact