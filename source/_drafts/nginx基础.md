title: nginx基础
tags:
---

nginx 是一个应用比较广, 功能比较强大的web服务器.
从这里开始, 我们将初步了解一下nginx的安装 和基本的使用. 
(以下内容基于ubuntu操作系统)
[官方文档](http://nginx.org/en/docs)

<!--more-->

## 安装
* 安装openssl (nginx依赖)
    `sudo apt-get install openssl`
* 从[官网](http://nginx.org/en/download.html)下载安装包
* `tar -zvxf nginx_***.tar.gz` 解压
* 进入解压后的目录, 执行 `./configure --prefix=[dest/dir]  --with-http_ssl_module --with-http_stub_status_module`
* `make && sudo make install` 执行安装步骤

## 启动
+ [用非root用户启动Apache|Nginx的方法](http://blog.itpub.net/29773961/viewspace-1377290/)
    - 进入nginx可执行文件目录(默认是 /usr/local/nginx/sbin/nginx)
    - `sudo chown root:nginx nginx`
    - `sudo chmod u+s nginx`  -- 修改文件的SUID位, 使该文件在执行时有root权限

+ 启动命令
`nginx -c /usr/local/nginx/conf/nginx.conf`

+ 重启
修改了配置文件,需要重启的时候,有以下两种方法
    * 使用 nginx自带命令(推荐)
    `nginx -s reload`
    * 找到nginx进程, 使用kill 命令发送信号
    ```shell
        ps -es | grep nginx
        kill -HUP [主进程号]
    ```

+ 测试配置文件语法是否正确
`nginx -s /usr/local/nginx/conf/nginx.conf`

+ 关闭
```shell
    #查询nginx主进程号
    ps -ef | grep nginx
    #从容停止
    kill -QUIT [主进程号]
    #快速停止   
    kill -TERM [主进程号]
    #强制停止   
    kill -KILL [主进程号]
```

+ 升级
```shell
    + #先用新程序替换旧程序文件
    + `kill -USR2 [旧版程序的主进程号]`
        #此时旧的nginx主进程会把自己的进程文件改名为.oldbin，然后执行新版nginx，此时新旧版本同时运行
    + kill -WINCH [旧版本主进程号]
```


## 配置
+ 修改环境变量, 在`PATH`变量的最后追加nginx的可执行文件目录
    ```shell
        export NGINX_HOME=/usr/local/nginx/sbin
        export PATH=$NGINX_HOME:$PATH
    ```
+ 配置的修改主要是修改 nginx.conf
每个字段含义
//todo

+ rewrite
[nginx rewrite 指令](http://www.94cto.com/index/Article/content/id/196.html)
[nginx rewrite 指令](http://www.nginx.cn/216.html)
//todo 待完善


## SSL相关
[nginx配置SSL实现服务器/客户端双向认证](http://blog.csdn.net/kunoy/article/details/8239653)
* 生成密钥, 颁发证书
    ```shell
        #用于生成rsa私钥文件
        openssl genrsa -des3 -out server.key 1024  
        #用于生成证书请求
        openssl req -new -key server.key -out server.csr
        #利用openssl进行RSA为公钥加密
        openssl rsa -in server.key -out server_nopwd.key 
        #生成证书 
        openssl x509 -req -days 365 -in server.csr -signkey server_nopwd.key -out server.crt
    ```

* 添加nginx证书 
```
    server {
         listen 443 ssl; 
         #证书路径
         ssl_certificate /usr/local/nginx/ssl/server.crt; 
         ssl_certificate_key /usr/local/nginx/ssl/server_nopwd.key; 
    }
```

## 负载均衡
nginx 的负载均衡由 HTTP Upstream 实现, 可以使用 upstream 关键字来配置.
upstream 一共支持六种负载均衡算法:
    * 轮询 (default)    每个服务器可以配置weight值, 根据weight 的数值,来决定使用该服务器的几率
    * ip_hash           请求按ip地址hash到固定的服务器
    * url_hash          请求按访问的url来hash到固定服务器
    * fair              请求按响应时间分配服务器
    * less_conn         使用当前连接最少的服务器
    * hash              包含  普通hash 和 一致性 hash 两种
upstream 支持的服务器状态参数:
    * down              该服务器不参与负载均衡
    * backup            只有当其他非backup服务器都不可用,才启用该服务器
    * max_fails         允许请求失败次数
    * fail_timeout      到达最大失败次数后,停用时长
**TIPS**:当使用ip_hash算法时, 服务器不能是backup的

