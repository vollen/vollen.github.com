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


#注册表编辑
[在windows右键菜单中加入自己的程序](http://blog.csdn.net/marklr/article/details/4006356)
Windows Registry Editor Version 5.00
如果卸载注册表键值，只在记事本中的[HKEY_CLASSES_xxx]的前面加“-”号即可。 [HKEY_CLASSES_ROOT\XXXActiveControl]修改为
[-HKEY_CLASSES_ROOT\XXXActiveControl]

reg /?
reg add/delete

在windows 右键菜单添加命令行入口
```reg
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Folder\shell\cmd]
@="打开命令行"

[HKEY_CLASSES_ROOT\Folder\shell\cmd\command]
@="cmd.exe /K CD %1"
```
//右键， 打开命令行
@="CMD.EXE /K CD %1"  

shellNew
    NullFile 空