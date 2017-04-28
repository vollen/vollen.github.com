nvm 管理node
npm 管理包
    npm --registry=https://xxx  指定npm源

https://registry.npm.taobao.org 淘宝提供的npm 镜像 
cnpm 


module.exports 和 exports
    module 是对当前模块的引用， 
    module.exports 是模块导出的接口 
    exports默认是module.exports的引用
    当 exports != module.exports 时, 以module.exports 为准

npm 常用命令
    npm search express      查找
    npm install -g express  安装， -g表示全局安装
    npm update express      更新
    npm uninstall express   卸载

    npm config list 查看npm 配置
    npm config set prefix="xx" 修改npm 全局安装目录