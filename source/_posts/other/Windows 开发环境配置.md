title: Windows 开发环境配置
tags: 
    -   环境搭建
---

# git 
[git](https://git-scm.com)
[tortoisegit](https://tortoisegit.org/)
# Power Shell
# Node
[nodejs](https://nodejs.org/zh-cn/)

# fiddler2
抓取手机数据包

# 将Win7的用户文件夹从C盘移到D盘
[参考链接](https://zhidao.baidu.com/question/576103899.html)
操作, 开机按F8进入安全模式， 执行如下指令
```
robocopy "C:\Users" "D:\Users" /E /COPYALL /XJ
rmdir "C:\Users" /S /Q
mklink /J "C:\Users" "D:\Users"
```