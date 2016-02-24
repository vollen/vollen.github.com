title: openresty
tags:
---

[官网](https://openresty.org/)
# 安装
+ 在官网下载安装包
+ 解压
+ 进入解压目录
+ 配置
    ```shell
        ./configure --prefix=/home/leng/server/openresty\
                --without-http_redis2_module \
                --with-http_postgres_module \
                --with-lua51 \
                --with-http_drizzle_module \
                --with-http_postgres_module \
                --with-http_iconv_module
    ```
    其中依赖的各种,只能一个个添加了.(哭)
+ 安装 `sudo make && make install`

