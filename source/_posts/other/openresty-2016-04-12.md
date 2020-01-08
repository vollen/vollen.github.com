title: openresty
date: 2016-04-12 15:00:12
tags:
    - openresty
    - service
---


[官网](https://openresty.org/)
[邮件列表](openresty@googlegroups.com)
# 安装
+ 在官网下载安装包
+ 解压
+ 进入解压目录
<!--more-->
+ 配置
    ```shell
        ./configure\
                --without-http_redis2_module \
                --with-luajit\
                --with-http_drizzle_module \
                --with-http_postgres_module \
                --with-http_iconv_module
    ```

    #--prefix=/home/leng/server/openresty 指定安装目录， 默认在 /usr/local/openresty
    其中依赖的各种,只能一个个添加了.(哭)
+ 安装 `sudo make && make install`


# 相关技能点
这两天在探索openresty 的路上, 陆续碰到了相关的点.这里列一下:

+ openresty 框架
    * vanilla
    * lor
    * lapis
        可以使用`moonscript` 或`lua`
+ nginx 扩展
    * VeryNginx
+ 部署工具
    * luarocks
        包管理工具
+ debug
    * busted
        lua 单元测试框架
    * systemtap
        内核调试工具
+ 数据库
    * mysql
    * redis
+ 网络
    * Raknet
        一个完善的网络相关函数库, 常用与游戏
    * Kafka
        一种高吞吐量的分布式发布订阅消息系统
    * zmq
        一个传输层网络框架, 用于主机或进程间的通信.
        [官网](http://zeromq.org/)
        [csdn简介](http://news.cnblogs.com/n/154000/)
    

