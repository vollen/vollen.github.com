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
ES5中使用 `\uxxxx`的形式表示Unicode字符.
1. 字符的Unicode表示法
对于占用两个字节的字符, 可以直接使用的形式表示
对于四字节的字符, 以上方法便会出问题,只能分别读到高位和低位的内容, 而不能正确的处理所有4字节内容. 为此,ES6增加了 `\u{xxxxx}`方式来表示Unicode字符.
2. codePointAt()
对于四字节字符, `charAt()` 和 `charCodeAt()` 均不能正确处理.
针对这个问题, ES6新增API`codePointAt()`.
3. String.fromCodePoint()
对应于`codePointAt()`,`fromCodePoint()`从码点构造字符串.
对应的只能处理两字节字符的API为`fromCharCode()`.
4. 字符串的遍历器接口

5. at()
6. normalize()
7. includes(), startsWith(), endsWith()
8. repeat()
9. padStart()，padEnd()
10. 模板字符串
11. 实例：模板编译
12. 标签模板
13. String.raw()

[nvm]:https://github.com/creationix/nvm
[babel]:https://babeljs.io/
[traceur]:https://github.com/google/traceur-compiler
