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


--Service
android:process
--baordcast

--apktool
```
apktool d test.apk
apktool b test -o test.apk
```
[sign your app](https://developer.android.com/studio/publish/app-signing.html#signing-manually)
```
//keytool tab键 可以查看各参数的意思
keytool -genkey -v -keystore test.keystore -alias test -keyalg RSA -keysize 2048 -validity 10000

//给apk签名
jarsigner -tsa http://timestamp.digicert.com -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ../../key/test.keystore app-debug.apk alias
//验证签名
jarsigner -verify -verbose -certs app-debug.apk
//zip对齐
zipalign -v 4 app-debug-unalign.apk app-debug.apk
//检查一个APK 是否对齐
zipalign -c -v 4  app-debug.apk
```

使用AS调试smail代码
+ 使用apktool解压得到包含smail的文件夹
+ 使用AS, File->New->Import Project->
            "Create project from existing sources"-> 选中上步得到的文件夹
            -> ok
+ 选中smail 文件夹， 右键， Mark As -> Sources Root.
+ Run->Edit Configurations -> "+" -> 选中Remote 类型-> 修改端口为8700.
+ apktool 重新生成apk，安装在手机上， 运行。
+ As 上打开 Android Device Monitor， 选中指定进程
+ As 上， Run -> Debug -> 选中刚才的Remote 调试器
+ 可以打断点， 开始调试了。


































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
