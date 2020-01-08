

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
新生代回收时全停顿
老生代增加了增量标记，延迟清理与增量整理等策略，来防止应用逻辑中断时间过长。
### 垃圾回收日志
在启动时添加`--trace_gc`参数，可以在标准输出中打印垃圾回收的日志信息。
启动时添加`--prof`参数， 可得到`V8`的性能分析数据， 其中包括垃圾回收占用时间。可以在目录下得到一个`V8.log`文件。
使用`linux-ticj-processor`工具打开该日志文件可以统计日志信息，windows对应文件为`windows-tick-processor.bat`。

## 高效使用内存
### 作用域
作用域链
变量主动释放： 使用delete 或者给变量赋值为undefined。
### 闭包
闭包有可能会导致作用域内的变量无法被回收。
## 内存指标
### 查看内存使用情况
process.memoryUsage()
os.totalmem()
os.freemem()
#### 堆外内存
Buffer对象不同于其他对象， 不经过V8的内存分配机制，有Node自行分配，所以不会有内存大小限制。
## 内存泄漏
### 缓存
缓存一般使用键值对来实现，这样当缓存内容过多的时候， 如果没有合适的清理机制， 缓存会占用大量内存不会被释放。
而且进程间无法共享内存，所以多个进程的缓存不会共享， 这也会造成内存浪费。
应该使用redis或者memcache等缓存数据库。
### 未及时消费的队列
采用更高效的队列消费方案
监控并限制队列的长度，当发生堆积时，产生警报并通知相关人员。
异步调用添加超时机制， 限定时间未完成， 则通过回调传递超时异常。
### 作用域未释放
## 内存泄漏排查
V8-profiler
node-heapdump
node-mtrace
dtrace
node-memwatch
## 大内存应用
stream 模块
fs.createReadStream()
fs.createWriteStream()

# Buffer
## 结构
### 模块结构
Buffer模块是一个典型的JavaSctipt与C++结合的模块， 性能相关部分用C++实现，非性能部分使用JavaScript实现。
### Buffer 对象
Buffer存储结构类似于数组，它的元素是16进制的两位数， 范围从0-255.不同编码的字符占用的元素个数不相同，汉字占3个元素，字母占1个元素。
Buffer对象初始化之后，其中是一个0-255之间的随机值。
可以通过下标给Buffer赋值，它会将该值取余到 0-255之间，并取整，然后存入数组。
### 分配内存
C++层面申请内存， javascript层面分配内存， 分配策略使用slab机制。
每次至少分配8K的内存， Node以8K为界限来区分Buffer是大对象还是小对象。
#### 小BUffer对象
对于小Buffer对象， Node会先分配一个8K的SlowBuffer， 这就是一个slab单元，使用一个局部变量pool指向它。
然后将buffer对象的parent属性指向该pool，并记录下起始使用位置。
之后再次分配的时候，会去检查slab对象中是否还有足够的空间，如果有，则继续从这个slab对象中分配内存给buffer对象使用。
如果剩余空间不足，则重新分配一个slab单元，并标记。
#### 大Buffer对象
对于大Buffer对象，则会直接分配一个指定大小的SlowBuffer对象为slab单元， 这个slab单元会被这个Buffer对象独占。
## Buffer转换
Buffer对象可以与字符串之间相互转换，目前支持的字符串编码类型有以下几种：
+ ascall
+ utf-8
+ utf-16le/ucs-2
+ Base64
+ Binary
+ Hex
### 字符串转Buffer
```new Buffer(str, [encoding]);```
encoding 不传递时， 默认使用utf-8编码进行转码和存储。
同一个Buffer对象可以存储不同编码类型的字符串转码， 可以通过write()方法实现。
buff.write(string, [offset], [length], [encoding])
### Buffer转字符串
Buffer对象的toString()可以将Buffer对象转换为字符串。
```buff.toString([encoding],[start],[end]);```
可以指定编码，和起止位置。 这样可以达到整体或局部转换的效果。
如果Buffer对象由多种编码写入，就需要在局部指定不同的编码， 才能转换成正常的编码。
### Buffer不支持的编码类型
Buffer.isEncoding(encoding)
#### iconv
调用C++库libiconv完成。
#### iconv-lite
纯JavaScript实现， 比iconv更轻量， 更高效。
## Buffer 拼接
```javascript
data += buffer
//等价于
data = data.toString() + buffer.toString()
```
当buffer使用宽字符的时候，有可能存在被截断的情况，就会出现乱码。
### setEncoding() 与string_decoder()
```readable.setEncoding(encoding)```
该方法的作用是让data事件传递的不再是Buffer对象， 而是使用指定编码编码后的字符串， 所以不会出现乱码问题。
setEncoding 时， 内部会保存一个string_decoder对象， 该对象在编码时， 如果有发现被截断的部分， 会保存在内部， 下次write时，再追加在一起编码。
但是它目前只能处理utf-8, base64和ucs-2/utf-16le这三种编码， 所以不能根本性解决问题。
### 终极方案
用数组来存储收到的所有Buffer片段， 并记录下所有片段的总长度， 然后调用`Buffer.concat()`合成为一个大Buffer对象。
然后在使用指定的编码方式或者iconv转换成字符串。
```javascript
    let chunks=[];
    let size = 0;
    res.on('data', （chunk）=>{
        chunks.push(chunk);
        size += chunk.length;
    });
    res.on('end', ()=>{
        const buffer = Buffer.concat(chunks, size);
        const str = iconv.decode(buffer, 'utf8');
        console.log(str);
    })

```
## Buffer 与性能
在网络传输中使用Buffer能大幅提高传输速率。
### 静态内容
静态内容预先转换为Buffer 的方式， 直接读取传输， 不需要做额外的转换， 能减少CPU的重复运算。
### 文件读取 与 highWaterMark 参数
对于大文件而言， highWaterMark越大， 读取速度越快。