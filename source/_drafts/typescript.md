typescript 笔记汇总

+ 声明依赖关系
`///<reference path="TestA.ts" />`

+ [声明合并](https://zhongsp.gitbooks.io/typescript-handbook/content/doc/handbook/Declaration%20Merging.html)
-   接口合并
    合并同名接口内的所有声明， 变量不能有重复, 否则会报错。多个不同签名的方法会被视为函数重载.
-   命名空间合并
    合并命名空间里所有导出的声明。未导出的方法，变量只能在合并前的命名空间使用。
-   命名空间和类
    保留两者的所有声明，类似于类的静态变量. 可以实现类的内部类的效果
-   命名空间和函数
```typescript
    function buildLabel(name: string): string {
        return buildLabel.prefix + name + buildLabel.suffix;
    }
    namespace buildLabel {
        export let suffix = "";
        export let prefix = "Hello, ";
    }
```
-   命名空间和枚举

-   模块扩展
全局扩展是模块扩展的一种.
```typescript
declare global {
    interface Array<T> {
        extends(): void;
    }
    Array.prototype.extends = function(){}:
}
```
   