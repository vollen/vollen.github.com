
# 各种模块化标准
[JavaScript模块化](https://juejin.im/post/6844903663404580878)
[前端模块化标准对比 iife amd cmd cjs umd es6](https://blog.whyoop.com/2018/08/01/js-modules/)

+ iife
iife 就是立即执行函数
+ amd
requireJs 出来之后， 为了推广， 提出了 [AMD 标准](https://github.com/amdjs/amdjs-api)
主要包含一对函数 `define` 和 `require`。
+ cjs
commonJs 是 nodejs 环境下被广泛使用的模块化机制。 模块必须通过 `module.exports` 导出对外的变量。使用 `require` 来导入其他模块的变量。
同步加载，不适合在浏览器环境下使用。
+ umd
umd 其实就是 iife amd + cjs 的兼容版。可以使用上面任意一种方式加载。
+ esm
esm 是 ecmascript2015 标准中提出的语言层面的的模块化机制。
esm 而且实现得相当简单，import 引入 export 导出.
esm 模块的设计思想是尽量的静态化，使得编译时就能确定模块的依赖关系，以及输入和输出的变量。

+ 其他
[systemjs](https://github.com/systemjs/systemjs) 加载器可以加载上述所有标准的模块.
[rollup](https://github.com/rollup/rollup) 可以把 es6/cjs 打包成各种标准的文件.

# webpack
