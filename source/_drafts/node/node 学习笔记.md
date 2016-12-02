
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
npm install file | url | folder
+ 非官方源
npm install xxx --registry=[url]
npm config set registry [url]
##### 钩子命令
可通过在 `package.json` 的`scripts`中配置钩子脚本，在执行npm命令的时候该脚本会被执行。如：
```json
"scripts":{
    "test":"test.js",
    "install":"install.js"
}
```