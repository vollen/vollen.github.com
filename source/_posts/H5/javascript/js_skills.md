

## isArray
```js
export function isArray(obj: any): obj is Array<any> {
    return Object.prototype.toString.call(obj) === '[object Array]';
}
```

## V8 tips
因为JS 没有类型的概念， 但是在V8中， 为了让代码执行的更快， 都会尝试给对象一个类型， 当对象的类型不断发生变化时， 就会导致额外的消耗。
```js
//bad
function Point(x, y) {
  this.x = x;
  this.y = y;
}

var p1 = new Point(11, 22);
var p2 = new Point(33, 44);
// At this point, p1 and p2 have a shared hidden class
p2.z = 55;
//better
function Point(x, y) {
  this.x = x;
  this.y = y;
  this.z = z;
}

/*********************/
//bad
var a = new Array();
a[0] = 77;   // Allocates
a[1] = 88;
a[2] = 0.5;   // Allocates, converts
a[3] = true; // Allocates, converts
//better
var a = [77, 88, 0.5, true];
```

## [会导致V8优化失败的代码](https://github.com/vhf/v8-bailout-reasons)
### 对已经被arguments引用的参数重新赋值

### 
允许使用原生函数
node --allow-natives-syntax

Built in functions
这些內建函数能在src/runtime/runtime.h; CodeStubAssembler; src/builtins/builtins.h;里找到
%HaveSameMap(a, b) 两个对象是否有相同的存储结构


hidden class, 每个对象都会有个hiddenClass,当给一个对象添加新的属性的时候， V8会构造一个新的基于老的class构造一个新的HiddenClass.
这种结构被称作 "transition tree" 转换树;
当函数调用的参数的hiddenClass 与上次的不一致的时候， 便会导致函数的deopt.

--trace-ic 可以调试对象的V8 的IC记录

