title: '[Power-shell]'
date: 2015-07-22 17:42:49
tags: 
    - power-shell
---

Power-shell 是 Microsoft 推出的Windows 自带的一款命令行工具.

# 特点
+ 直接执行C#代码
+ 自动补全

# 基本命令
## 帮助
查看各种命令的帮助文档
`GetHelp XXX`
## 查看版本信息
## 更新
下载[Windows Management Framework 4.0](https://www.microsoft.com/zh-CN/download/details.aspx?id=40855)更新, 并安装重启即可更新到ps4.0
## 设置权限
  `Set-ExecutionPolicy Remote`
## 系统变量
+ `$PSVersionTable` 版本信息
+ `$profile`  配置文件目录


# PsGet
PsGet 是一个能让你快速搜索和安装Power shell模块的工具.
[官方网站](http://psget.net/)
## 安装
在Power shell 终端中执行如下命令:
```
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
```
## 使用
安装了PsGet之后, 就可以使用如下命令来管理你的模块了.
### install-module
安装模块
`install-module XXX`
### Get-PsGEtModuleInfo
查找/查看模块信息, 支持通配符.
`Get-PsGEtModuleInfo XXX`
