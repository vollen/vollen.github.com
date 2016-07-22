title: sdk阶段总结
tags:
---

--主播平台sdk
设备标识
fataar
retrofit
rxjava
dagger
clean code (分层思想)

--支付宝支付
--小米登陆

--google_sdk
auth2 认证流程

--gradle
build variants


































google　登陆流程。

准备一台装有GooglePlay服务框架的手机
准备一个可以翻墙的VPN
[Google开发者后台](https://console.developers.google.com)注册账号
新建项目
在Api管理器->凭据中添加


TW 多平台SDK结构
--
GGame
    PayProxy 
        GooglePay
    AuthProxy
        AuthPlat
            AuthHandler
    SdkActivity       
