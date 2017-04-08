title: es6 学习笔记
tags: 
    - javascript
    - ECMAScript6
---

# 1. 简介
##ECMAScript 与 javascript
ECMAScript 是 javascript 的标准, javascript 是ECMAScript的实现.
##部署
使用[nvm][nvm]来管理node版本.
##babel
[babel][babel]是一个js转码器, 使用babel需要在`.bashrc`中配置.
```json
{
    "preset":{
        //配置转码规则
    },
    "plugin":{
        //配置插件
    }
}
```
+ babel-cli / babel-node
引入babel环境，在项目中配置构建
+ babel-polyfill
补全ES6中新增的API,比如Array.from
+ babel-register
替换require命令
+ babel-core
在程序中调用 babel API 转码

##ESLint
Js语法检查
##Mocha
##Traceur转码器

# 2. let 与 const
## 2.1 共有性质
+ 块作用域
+ 暂时性死区
在变量声明的整个块作用域存在, 但是在声明之前不可访问.
+ 不能重复声明

##2.1 let
+ 块作用域内声明函数, 当作 let 处理

##2.2 const
+ 不能修改变量指向的地址. 对于对象,对象的属性可以被改变.
    如果要冻结对象, 应使用 `Object.freeze`. 

##2.3 全局对象 / 全局变量
+ 对于浏览器环境, 全局对象为 window.
+ 对于node环境, 全局对象为global.

let, const, class 声明的全局变量不再是全局对象的属性.
为了兼容ES5, var/function 声明的全局变量依然是全局对象的属性.

# 3.变量的解构赋值
变量的解构实质上就是模式匹配, 将右侧对应位置的值赋给左侧变量.
任何一个架构都可以改写为以下形式:
```javascript
    let value1,value2;
    ({p1:value1=default1, p2:value2=default2} = {k1:v1, k2:v2});
```

+ 其中 `p1`,`p2`是模式串, `value1`,`value2`是变量.
+ 匹配: 从右值找匹配项赋值.
+ 当变量名与模式名一致时, 可只写一个变量名.
这是常用的对象解构的写法, 例:
```javascript
    let {bar, foo}={bar:1, foo:2}; //bar = 1,foo=2, 等价于
    let {bar:bar, foo:foo} = {bar:1, foo:2};
```
+ 当右值具有Iterator接口时, 左侧将`{}`写成`[]`, 并省略模式串和冒号.例:
```javascript
    let [,value1, , value2]=[1, 2, 3, 4]; //value1 = 2,value2=4, 等价于
    let {1:value1, 3:value2} = [1, 2, 3, 4];
```
+ 默认值: 如果没有匹配项或者匹配项的值`===undefined`, 会将默认值赋给变量, 默认的默认值是undefined.
```javascript
    let {a, b, c= 2} = {a:1, b:null,c:undefined};//a = 1, b= null, c=2
```
+ 解构可以用于函数参数.例:
```javascript
function add([x, y]){
    return x + y;
}
add([1, 2]); //3
```
+ 当右值为基本类型时, 会尝试转换成对象. 
`undefined` 和`null` 不能转换成对象,所以不能作为右值.
+ 默认值是惰性求职的.
+ 嵌套解构时, 嵌套的部分必须有值,不然相当于解析空值, 会报错.例:
```javascript
    let [x, y,[z]] = [1, 2, []];  //OK. z === undefined.
    let [x, y,[z]] = [1, 2]; // 报错, 因为z相当于索引一个undefined的值.
```
+ 左边模式中, 可以不包含任何变量; 例:
```javascript
    ({} = {1,2, 3}); //OK
```

## 3.1 字符串
+ 字符串可以按照数组形式解构, 也可以按照对象形式解构.
```javascript
    let {a,b,c} ="Hello"; // a="H",b="e",c="l";
    let {length}="Hello"; // length = 5
```

## 3.2 圆括号
圆括号不能随便用于解构语句, 会造成解析错误.
+ **变量声明**的解构语句, 不能使用圆括号.
+ **函数参数**解构, 不能使用圆括号, 因为就是声明.
+ 不能单独给**模式**, 或者**模式的一层**加圆括号.
+ **可以**给要赋值的**变量**加圆括号
+ **可以**给**整个解构表达式**加圆括号
## 3.3 用途
+ 交换变量
+ 函数返回
+ 函数传值
+ 函数参数默认值
+ 遍历Map
+ 快速提取Json数据
+ 导入模块

# 字符串扩展
## Unicode
以下所列出的方法,都是针对四字节的长Unicode字符做的扩展,都会列出对应的ES5标准(最长只支持2两字节字符).
### 字符的Unicode表示法
对于占用两个字节的字符, 可以直接使用的形式表示
对于四字节的字符, 以上方法便会出问题,只能分别读到高位和低位的内容, 而不能正确的处理所有4字节内容. 为此,ES6增加了 `\u{xxxxx}`方式来表示Unicode字符.
>>ES5表示方法是: `\uxxxx`

###codePointAt()
返回Unicode字符的Unicode码点.
>>ES5 API是: `charAt()` 和 `charCodeAt()`

###String.fromCodePoint()
`fromCodePoint()`从码点构造字符, 正好与`codePointAt()`.
>>ES5 API是:`fromCharCode()`.

###字符串的遍历器接口
`for ... of` 循环能遍历字符串, 并正确识别四字节的字符.而普通的`for`循环则做不到这点.
```javascipt
    let str = String.fromCodePoint("\u{20BB7)")
    for (let i of str){ console.log(i);} // 𠮷
    for (let i = 0; i < str.length; i ++){ console.log(str[i]);} // 输出两个不可见字符
```
>>对应的是普通`for循环`

##at()
可以正确的识别出四字节字符.
**不属于ES6的内容**,ES7提案. 可通过[polyfill库][String.at]扩展.
>>ES5/ES6 API 为: `charAt()`

## normalize()
许多欧洲语言有语调符号和重音符号。为了表示它们，Unicode提供了两种方法。一种是直接提供带重音符号的字符，比如`Ǒ`（\u01D1）。另一种是提供合成符号（combining character），即原字符与重音符号的合成，两个字符合成一个字符，比如`O`（\u004F）和`ˇ`（\u030C）合成`Ǒ`（\u004F\u030C）。
`normalize()`提s供了在这两种表达方式中转换的能力.
>>然而不支持中文

## includes(), startsWith(), endsWith()
这三个API用于判断字符串中是否存在指定的子串.
```javascript
    let str = "Hello World";
    str.includes("Hello"); // true
    str.includes("Hello", 1); // false, 第二个参数表示从源串的第几个字符开始查找
    str.startsWith("World"); // false
    str.startsWith("World", 6); // true, 同上
    str.endsWith("World");  //true
    str.endsWith("Hello", 5);  //true, 第二个参数表示查找源串的前n个字符.
```
## repeat()
+ 重复一个字符串.
+ 传入的参数会被取整.
+ 传入的参数如果是字符串, 会先转成数字.
+ 参数取整后不可为负数或Infinity.
+ (-1,0] 区间内的数字是合法的, 因为取整后为0.
```js
    'na'.repeat(2.9) // "nana"
```

## padStart()，padEnd()
自动补全字符串
```js
    'x'.padStart(5, 'ab') // 'ababx'
    'x'.padStart(4, 'ab') // 'abax', 超过位数的补全串会被截断。
    'abc'.padStart(10, '0123456789')// '0123456abc'
    'abc'.padStart(2, 'abab')// 'abc', 源串长度大于等于指定长度， 返回源串.
```
`padEnd`用法与`padStart`一致， 只是在尾部补全。
>>ES7功能

## 模板字符串
+ 使用`\``反引号标识.
+ 可当作普通字符串使用
+ 可多行，完整保留其中的换行符和空格.
+ 可插入变量或表达式. `${name}` 或 `${a+b}`
+ \`需要使用反斜杠转义.

## 标签模板
将模板紧跟在一个函数后面，则该函数会被调用来处理该模板。
当模板中有参数的时候， 模板会被根据参数拆分成一个字符串数组。作为函数的第一个参数，传入函数，模板所需的其他参数座位函数的其他参数。
传进去的参数数组strings有一个raw属性， 也指向一个数组，这个数组的所有成员的斜杠都已经转义过了，这样可以保存最原始的模板。
```js
    var a = 5;
    var b = 10;
    tag`Hello ${ a + b } world ${ a * b }`;//等价于下面函数
    function tag(stringArr, ...values){
      // stringArr = ["Hello","world", ""]
      //values = [a+b, a*b] = [15, 50]
    }
```
常被用于: 过滤HTML字符串， 国际化处理。

## String.raw
返回一个所有参数都被替换过， 且所有斜杠都被转义过的字符串.
是处理模板字符串的基本方法.
```js
    String.raw`tes\t${2} `; //tes\\t2
```
也可以当作函数来用， 第一个参数应该是一个具有raw属性的对象。且raw的属性应该是一个数组.
此时，他会遍历raw属性， 并挨个将参数插入.
```js
    String.raw({ raw: 'tes\t' }, 0, 1, 2); //t0e1s2\t
```

# 正则表达式扩展
## RegExp构造函数
```js
    let regex = new RegExp('xyz'); // 等价于
    let regex = /xyz/;
    let regex = new RegExp('xyz', 'i'); // 等价于
    let regex = /xyz/i;
    let regex = new RegExp('/xyz/i'); // 等价于
    let regex = /xyz/i;
    let regex = new RegExp('/xyz/ig', 'i'); 
    //指定的修饰符会覆盖源正则对象的修饰符 等价于
    let regex = /xyz/i;
```

## 字符串的正则方法
字符串一共有四个方法能使用正则表达式`match()`,`search()`,`replace()`,`split()`.
他们内部都调用`RegExp`的方法来实现.

+ String.prototype.match 调用 RegExp.prototype[Symbol.match]
+ String.prototype.search 调用 RegExp.prototype[Symbol.search]
+ String.prototype.replace 调用 RegExp.prototype[Symbol.replace]
+ String.prototype.split 调用 RegExp.prototype[Symbol.split]

## u修饰符
`u`修饰符表示`Unicode模式`，用于正确处理四字节的Unicode字符.
在`u`修饰符作用下， 

## y修饰符
## sticky属性
## flags属性
## RegExp.escape()
## 后行断言

# 数值扩展
# 数组扩展
# 函数扩展
# 对象扩展
# Symbol
# Proxy 和 Reflect
# 二进制数组
# Set 和 Map 数据结构
# Iterator 和 for...of 循环
# Generator 函数
# Promise 对象
# 异步操作 和 Async 函数
# Class
# Decorator
# Module
# 编程风格
# 读懂规格



[nvm]:https://github.com/creationix/nvm
[babel]:https://babeljs.io/
[traceur]:https://github.com/google/traceur-compiler
[String.at]:https://github.com/es-shims/String.prototype.at
