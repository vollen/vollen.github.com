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
## 脚本权限
PowerShell在第一次安装时默认的执行策略是"Restricted"，也就是“受限制的”，这意味着PowerShell将不能运行任何脚本和配置文件。
### PowerShell的执行策略分级：
+ Restricted - 不能运行任何脚本和配置文件
+ AllSigned - 所有脚本和配置文件必须拥有受信任的发布者的签名
+ RemoteSigned - 所有脚本和配置文件从可以是互联网上下载，但必须拥有受信任的发布者的签名
+ Unrestricted - 所有脚本和配置文件都将运行，从互联网上下载的脚本在运行前会有提示。
### 查看当前策略级别
`Get-ExecutionPolicy`
### 设置当前策略级别
`Set-ExecutionPolicy -Scope CurrentUser Unrestricted`

## 系统变量
+ `$PSVersionTable` 版本信息
+ `$profile`  配置文件目录
[PowerShell下使用Aliases](https://www.jb51.net/article/32449.htm)

### Alias
#### 导入导出 alias
+ 导出 `Export-Alias -Path a.txt`
+ 导入 `Import-Alias -Path a.txt`
#### 使用PowerShell的配置文件
`$profile` 查看powershell配置文件
`test-path $profile` 判断配置文件不存在，如果不存在可以在指定目录创建文本
`. $profile` 修改配置内容之后， 可以运行使配置生效
##### 示例，配置`git status`别名
```powershell
function git-status {git status}
set-alias gst git-status
```
设置`gst`为`git status`的别名。 因为别名必须指向一个函数或者命令， 所以我们需要把我们最终带参数的命令封装在一个函数里。 然后在将`gst`指向这个函数。


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
