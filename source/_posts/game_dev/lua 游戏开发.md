

## 全局变量
防止忘写`local`前缀，错误的声明全局变量
1. 通过设置_G 元表， 来防止错误的全局变量声明.
2. 新增声明全局变量的方法， 全局变量统一声明

## class

## reload
Tango 库，基于Socket,在这里可用于实现进程间的跨lua虚拟机访问。
可参考开源lua服务器框架， 看看对应的重新加载逻辑怎么做的？
需要处理问题在于， 如何将所有的函数引用都替换成新的。 包括通过临时变量引用的。

## 内存实时查看
[Hdg Remote Debug](https://assetstore.unity.com/packages/tools/utilities/hdg-remote-debug-live-update-tool-61863)
基于Tango跨Lua进程的特性，配合一个基于pyQT的gui界面
Python的rpyc

## hotfix
1. 程序发现要修复的bug，编写特殊的Hotfix代码进行修复，测试通过后上传到svn服务器；
2. 通过发布指令，将svn上更新后的Hotfix代码同步到服务器上；
3. 服务器发现Hotfix代码有更新，则将其压缩序列化后通过socket发送给所有在线的客户端，同时带上字符串的MD5值供客户端验证；
4. 客户端收到Hofix消息之后，首先反序列化数据得到代码内容，校验MD5值之后，如果和本地已经执行过的Hotfix的MD5值不同，则执行替换逻辑，并记录当前已经执行过Hotfix的MD5值，如果相同则不再执行；
5. 客户端连接服务器的时候会主动请求一次Hofix。

## skynet 开源服务器框架

