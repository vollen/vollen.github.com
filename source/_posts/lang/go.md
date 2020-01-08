# env
```bash
export GOROOT=/usr/local/go
export GOPATH=$HOME/env/go/libs;$HOME/go
```

# go 包获取
## 代理配置
go 的很多依赖包都是在 golang.org 上, 这个地址因为众所周知的原因, 无法直接访问。

首先我们需要准备一个能爬墙的梯子, 这里使用 shadowsocks。
点击小图标 -> Http 代理设置 -> http 代理开启, 记录下这里的监听地址和监听端口. 我这里是 (127.0.0.1: 1087)
在需要更新依赖的控制台执行以下命令, 即可设置代理. 运行 `go get` 即可安装依赖
```bash
export HTTP_PROXY=http://127.0.0.1:1087
export HTTPS_PROXY=http://127.0.0.1:1087
```

### vs code 代理设置
Code -> 首选项 -> 设置 -> 应用程序 -> 代理服务器 中配置
也可以 Cmd+Shift+P 输入 setting, 打开用户设置, 输入 `proxy` 搜索对应配置

## git 地址配置
对于公司自己部署的`git`服务器, go 依赖模块无法解析到实际的域名. 依赖会安装失败。
这时候需要在 `~/.gitconfig` 配置对应的域名, 如下.
``` git config
[url "git@git.hortorgames.com:"]
insteadOf = https://git.hortorgames.com/
[url "git@git.hortorgames.com:"]
insteadOf = http://git.hortorgames.com/
```

## goland
有钱了还是付费的好呀。
[注册码获取地址](http://idea.lanyus.com/)