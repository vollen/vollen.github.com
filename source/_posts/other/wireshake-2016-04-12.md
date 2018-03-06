title: wireshake
date: 2016-04-12 15:00:17
tags:
    - debug
    - network
---


网络抓包神器 wireshake

# 安装
+ 在ubuntu 中，可直接通过命令 ```sudo apt-get install wireshake``` 来安装
<!--more-->

# 运行
+ 最简便的方法，是直接使用root用户来运行。 ```sudo wireshake```
wireshark要监控eth0，但是必须要root权限才行。但是，直接用root运行程序是相当危险，也是非常不方便的。
为了安全，通常是通过添加用户组wireshake，并赋予wireshake组访问网卡的权限，然后将当前用户添加到wireshake 用户组中。这样，就可以用普通用户运行wireshake 了。

```
1.添加wireshark用户组 
sudo groupadd wireshark 

2.将dumpcap更改为wireshark用户组 
sudo chgrp wireshark /usr/bin/dumpcap 

3.让wireshark用户组有root权限使用dumpcap 
sudo chmod 4755 /usr/bin/dumpcap 

4.将需要使用的用户名加入wireshark用户组，我的用户名是leng 
sudo gpasswd -a leng wireshark
```

# 抓包
+ 选中网卡，点击start,即可开始抓包

# 过滤条件
当然，按上面的方法，会得到乱七八糟的各种包，这时我们就需要使用各种条件来过滤一下所需要抓的包。过滤条件有两种：
+ 捕捉过滤器
现在用到的过滤条件: src or dst 192.168.1.220
修改了过滤条件之后,记得要编译哦

+ 显示过滤器
[具体请戳](http://openmaniak.com/cn/wireshark_filters.php#capture)


# 结尾
好厉害，我也要去抓包玩。
