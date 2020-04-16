nvm 管理node
[https://github.com/creationix/nvm](nvm git)

npm 管理包
    npm --registry=https://xxx  指定npm源

[http://www.cnblogs.com/kaiye/p/4937191.html](使用nvm管理npm包)

npm config set registry https://registry.npm.taobao.org  //淘宝提供的npm 镜像源
npm install -g cnpm --registry=https://registry.npm.taobao.org 安装cnpm


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
    npm dedupe  

    npm config list 查看npm 配置
    npm config set prefix="xx" 修改npm 全局安装目录s


typings 在vscode中使用代码提示

babel
    babel-cli
    babel-eslint
    babel-preset-es2015
    
    babel -w src -d build -s 默认编译命令

# npm 版本
[About semantic versioning](https://docs.npmjs.com/about-semantic-versioning)


[基于https的express](http://blog.mgechev.com/2014/02/19/create-https-tls-ssl-application-with-express-nodejs/)

# webpack

# 调试
## node js 调试代码
node --inspect-brk ./server.js
## electron 调试主进程
https://electronjs.org/docs/tutorial/debugging-main-process