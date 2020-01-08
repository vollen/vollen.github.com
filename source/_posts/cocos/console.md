
在程序中添加监听
Director::getInstance()->getConsole->listenOnTCP(5678)

使用nc 命令发起连接
nc localhost 5678

通过管道发送内容至nc 
echo content | nc 


在console 环境下, 输入help 查看帮助 

touch 的坐标是相对于glView的， 坐标原点在左上角，所以使用的时候， 要做处理

socat 一个端口转发工具， 或许可以用来模拟发送协议
