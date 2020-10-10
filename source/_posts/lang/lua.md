
# 解释器
```sh
#脚本第一行写入执行程序
#!/usr/bin/env lua

#解释器参数
lua [options] [script [params]]
-e : 直接在命令行执行代码
-l : 加载库文件
-i : 执行完之后进入交互模式

_PROMPT 全局变量，可以修改交互模式的提示符。
LUA_INIT 环境变量，配置初始化的代码或文件。
```

# 类型
nil, boolean, number, string, table, userdata, function, thread 
+ type(value)
可返回值的类型

a, b = b, a, 先计算右边的值， 再进行赋值操作

# 循环
lua 中， 声明在循环体中的局部变量的作用域包括了条件测试。
```lua
local sqr = x/2;
repeat
    sqr = (sqr + x/sqr) / 2
    local error = math.abs(sqr^2 - x)
until error < x / 10000
```
## for
+ 控制变量，只在循环体内可用，循环结束后就不存在了。
### 数字for
+ for 循环的三个表达式是在循环开始前一次性求值。
```lua
for i = starti, endi, step do end
```
### 泛型for
+ for 循环通过一个迭代器函数来遍历所有的值。
常用迭代器：
- io.lines()
- pairs()
- ipairs()
- string.gmatch()
```lua
for i,v in ipairs(t) do print(v) end
```
## break 和 return
它们只能是一个块内的最后一个语句

# 函数
+ 函数在lua中是`第一类值`，可以存储在变量中，可以作为参数传递，可以作为返回值。
+ 函数可以有多个返回值
+ 变长参数
`...` 表示该函数可以接受不同数量的实参
变长参数必须放在固定参数之后
```lua
function value(...)
    local a, b, c = ...
    local a, b, c = unpack({...})
    select("#", ...); --返回变长参数的总长， 包括nil
    select(n, ...); --返回变长参数的第n个值
end

local function foo() end 
--等价于
local foo; foo = function()end
```
## 高阶函数
以函数作为参数的函数

## 闭包(closure)
+ 函数A内部的函数B可以访问到A中定义的临时变量，这些变量被称作`非局部变量(upvalue)`；
+ closure 就是一个函数以及它所需要访问的所有`upvalue`的总和。

## 尾调用
```lua
function f() return g() end
--以下都不是尾调用, 因为 g 返回之后， 还有事要做 
function f() g() end --还需要释放 g() 返回的临时结果
return g() + 1; -- 还需要做一次加法
return x or g(); --还需要调整为一个返回值
return (g()); --还需要调整为一个返回值
```
f 调用完 g 之后, 不需要做别的事情. 这种情况下，程序不需要再返回 f , 所以 g 函数调用之后, 不需要保存 函数f 的函数栈了， g 返回时， 执行控制权直接返回到调用 f 的那个点上。 

+ 尾调用能防止过多次的递归导致的调用栈溢出
+ 只有到一个函数调用是另一个函数的最后一个动作时，该调用才算是尾调用

# 迭代器
迭代器是一种可以遍历一种集合中所有元素的机制。 在 lua 中通常表示为函数， 每调用一次，返回集合中的下一个元素。
迭代器通常有状态， 可以用闭包来实现。
```lua
--迭代器工厂
function values(t)
    local i = 0;
    --迭代器
    local iter = function() i = i + 1; return t[i]; end
    return iter
end
local iter = values({1, 2, 3});
for v in iter do
    print(v)
end
```
迭代器的语义
```lua
for var_1, ..., var_n in <explist> do <block> end
--等价于
do
    local _f, _s, _var = <explist>;
    while true do
        local var_1, ..., var_n = _f(_s, _var);
        _var = var_1
        if(_var == nil) then break end
        <block>
    end
end

--改进后的values
local iter = function(t, i) 
    i = i + 1; 
    local val = t[i]; 
    if(val) then
        return i, val
    else
        return nil
    end
end
function ipairs(t)
    return iter, t, 0
end
for i, v in ipairs({1, 2, 3}) do
    print(i, v)
end
```

# 编译
解释性语言的关键点在于编译器是否是运行时库的一部分，即是否有能力执行动态生成的代码。lua 允许在运行源代码之前，先将代码编译成字节码。

## 加载 lua 代码 
+ `loadfile` 和 `loadstring` 都会调用一个内部函数 `load`; 只不过输入源不一样
+ `load` 总在全局环境中编译它的字符串
+ 发生错误时 `load` 函数返回 `nil` 和一条错误消息

## 加载 C 代码 
加载 C 代码需要先链接一个应用程序。通常是用动态链接的方式。动态链接并不是ANSI的一部分，按理说 Lua 不应该包含无法通过ANISI 实现的机制， 但因为动态链接是其他所有各种机制的母机制，通过它可以加载任何不在 Lua 中的机制，所以 Lua 打破了可移植性的准则， 为各个平台实现了一套动态链接机制。

+ package.loadlib(path, name), 如果加载库发生错误，将返回 nil 及一个错误消息。
+ 通常可以用 `require` 来加载 C 程序库，它在底层调用 `loadlib`。

# 错误处理
+ error(msg, level)
+ assert(expr, msg)
+ pcall(func, ...)
+ xpcall(func, handler)
+ debug.traceback(level)

# 协程
协程与线程类似， 都拥有自己独立的调用栈，局部变量和指令指针，同事与其他协程共享全局变量和其他大部分东西。
与线程不一样的是， 一个程序的多个线程可以并行执行， 而多个协程同时只能有一个在运行。
+ coroutine 库
所有的协程相关函数都放在这个 table 中。
```lua
--创建一个协程
local co = coroutine.create(function()
end)
--查看一个协程的状态
print(coroutine.status(co));
--启动或再次移动一个协程, 知道该协程 yield 或结束，才会最终返回， 并可以获得 yield 传递的参数 
local result, params = coroutine.resume(co, ...)
--挂起， 直到下一次 resume 调用， yield 函数才最终返回, 并且获得 resume 传递过来的参数
local params = coroutine.yield(...)
-- 生成迭代器，使用 func 创建一个协程， 每次调用迭代器，都会调用 resume 这个协程.
local funcIter = coroutine.wrap(func)
```

## 状态
协程有四种状态
+ suspended
+ running
+ dead
+ normal

## 非抢先式多线程
无法从外部停止一个协程的运行，只有协程自己能显示的要求挂起时，它才会停止。
当某一个协程执行了一个阻塞操作， 那么整个程序都会停下来。


# 字符串连接
```lua
local t = {};
local str= "";
for i, v in ipairs(t) do str = str .. v end 
--当字符串特别多或者占用内存很大时， 上面的做法会消耗大量的内存。 使用下面的做法能提升性能。
local str = table.concat(t)
```

# 模块加载
+ require
- lua 通过带有 ? 的模式串来定义文件加载路径, 在加载时将模式中的 ? 替换成要加载的模块名，可得到最终的路径名, 并检查是否存在并加载
- 模式串存放在 package.path 和 package.cpath 中
- 定义环境变量 LUA\_PATH 或 LUA\_CPATH 可修改 模式串的值, 这两个变量中的 `;;` 会被替换成默认的加载路径。
- 风格良好的 C 程序块应该导出一个名为 `luaopen_<模块名>` 的函数, require 会在链接完程序库之后尝试条用这个函数，
- 使用 . 作为模块分隔符, require 会先用原始模块名查找缓存，查找不到搜索文件时，会将 . 替换成系统对应的目录分隔符去搜索.

+ package.loaded
+ package.preload
+ module 函数
```lua
module(..., option)
--等价于下面代码
local modname = ...;
local M = package.loaded[modname] or {};
_G[modname] = M;
package.loaded[modname] = M;
setfenv(1, M);
_M = M; _NAME = modname;
--当 option==package.seeall 时，在 setfenv 之前还有如下语句
setmetatable(M, {__index = _G});
```

# 面向对象
+ 使用元表来实现
+ 内置支持 `self` 以及 `:`

# 弱引用
+ table 的弱引用类型是通过其元表的 __mode 字段来决定的
+ 如果 __mode 中含有字母 "k", 那么它的 key 是弱引用的
+ 如果 __mode 中含有字母 "v", 那么它的 value 是弱引用的

# 字符串
## 基础部分
+ string.len(str)
+ string.rep(str, n)
+ string.byte(str, i, j)
+ string.char(code1, code2, ...)
+ string.lower(str)
+ string.upper(str)
+ string.sub(str, i, j)

## 模式匹配
+ string.find(str, pattern, start)
+ string.match(str, pattern)
+ string.gsub(str, pattern, replace)
+ string.gmatch(str, pattern)
返回一个迭代器函数

# io
## 简单io
+ io.read(option)
- *a 读取整个文件
- *line 读取下一行
- *number 读取一个数字
- <num> 读取一个不超过<num> 个字符的字符串
+ io.write(content)
往当前输出文件写入内容
+ io.input(filename)
打开filename, 并且之后的输入都从此文件读取
+ io.output(filename)
修改标准输出文件
## 完整模型
+ io.open(filename, option)
- r 读
- w 写
- a 追加
- b 二进制文件
+ io.flush()
+ f:seek(whence, offset) -> curPos
whence 指定如何解释 offset
- "set" 相对文件起始的偏移
- "cur" 相对当前位置的偏移, default
- "end" 相对于文件末尾的偏移

# 操作系统
操作系统相关的接口都在 os 库
+ os.time(t)
返回 从某一时间点开始到 t 描述的时间所经过的秒数
+ os.date(format, sec)
返回指定格式的时间
- "*t" 会返回一个table，存储改时间的各个部分的值
- 其他格式 ...
+ os.exit()
中止当前程序的执行
+ os.getenv(name)
获取一个环境变量的值
+ os.execute(cmd)
执行一条系统命令， 并返回一个错误码
+ os.setlocale
设置程序执行的区域

# 调试库
调试库都封装在 debug 表中
+ 栈层
栈层是一个数字， 表示一个活动的函数。调用调试库的函数是层1，它的调用者是2， 类推。
## 自省函数
### debug.getInfo
+ 当该函数的参数为函数时， 返回改函数相关信息组成的表
- source 函数定义的位置
- short_src
- linedefined 行号
- lastlinedefined 最后一行行号
- what 函数的类型，有三种： `"Lua"`, `C`, `main`
- name 函数的名称
- namewhat name的含义
- nups upvalue 的数量
- activelines 函数中所有有代码行的集合
- func 函数本身
### debug.get

## 钩子
可以注册钩子函数，这个函数在特定事件发生时调用。
### 钩子事件
+ call
+ return 
+ line
+ count
### 开启钩子
+ debug.sethook(func, option, countN)
+ 要监听 `call`, `return`, `line` 事件， 只需要将它们的首字母放到 option 中
+ 要监听 `count` 事件，只需要在第三个参数传入数量
### 取消钩子
debug.sethook()


# 垃圾回收
[深入Lua：垃圾回收](https://zhuanlan.zhihu.com/p/100897212)
