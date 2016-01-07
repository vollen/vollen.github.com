title: android知识点小记
tags: [android]
---


[安卓官方文档](http://developer.android.com/reference/packages.html)


# View
+ setFocusable()
+ setFocusableInTouchMode()
    [Android的Touch Mode](http://www.cnblogs.com/frydsh/archive/2012/10/15/2724909.html)

## [Activity](http://developer.android.com/intl/zh-cn/guide/components/activities.html)

## [Fragment](http://developer.android.com/intl/zh-cn/guide/components/fragments.html)

## Surface

## SurfaceView
+ setZOrderMediaOverlay 不管它的层级如何,直接显示在所有媒体前

## SurfaceHolder
[Android图形系统之Surface、SurfaceView、SurfaceHolder及SurfaceHolder.Callback之间的联系](http://www.linuxidc.com/Linux/2012-08/67619.htm)
[Android笔记：SurfaceView与SurfaceHolder对象](http://www.jcodecraeer.com/a/anzhuokaifa/androidkaifa/2012/1201/658.html)

# Environment
+ getExternalStorageDirectory()
    * 返回SD卡的绝对路径

# Context
+ getPackageName()
    * 返回包名
+ public abstract Object getSystemService (String name)
    * 获取一些系统相关的管理器

## 返回 应用在 【内置存储/SDCARD】 上的【数据目录/缓存目录】
+ getCacheDir()
+ getFilesDir()
+ getExternalFilesDir(
+ getExternalCacheDir()
```java
//用于获取可写缓冲区的一段代码
public String getDiskCacheDir(Context context) {  
    String cachePath = null;  
    if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())
            || !Environment.isExternalStorageRemovable()) {  
        cachePath = context.getExternalCacheDir().getPath();  
    } else {  
        cachePath = context.getCacheDir().getPath();  
    }  
    return cachePath;  
}  
```

# File
## 返回 [定义时的路径/  绝对路径 / 规范化路径（不包含./..的路径）]
+ public String getPath ()
+ public String getAbsolutePath ()
+ public String getCanonicalPath ()

# [RandomAccessFile](http://developer.android.com/reference/java/io/RandomAccessFile.html)
[前人引路](http://blog.csdn.net/akon_vm/article/details/7429245)

# 通过DexClassLoader来动态加载类
[Android动态加载基础 ClassLoader工作机制](http://segmentfault.com/a/1190000004062880)
```java
        DexClassLoader loader = new DexClassLoader("dexPath", "optimizedDirectory", "libraryPath", parent);
        Class class = loader.loadClass("classpath");
        Constructor ctor = class.getConstructor(Class...<?> parameterTypes);
        Object obj = ctor.newInstance(Object... args);
```

# Environment
+ SDCARD 是否存在
    - Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())  
+ SDCARD 不可移除
    - Environment.isExternalStorageRemovable()
+ 获取SDCARD目录fi
    - Environment.getExternalStorageDirectory()

# NET
[连接网络](http://developer.android.com/training/basics/network-ops/connecting.html)
## ConnectivityManager
+  获取实例
```java
    Context.getSystemService(Context.CONNECTIVITY_SERVICE)`
```


## SSLContext
## HttpURLConnection

## [URI和URL](http://www.cnblogs.com/gaojing/archive/2012/02/04/2413626.html)

# SECURITY
## [KeyStore](http://developer.android.com/training/articles/keystore.html)
## KeyFactory
## [Java使用RSA加密解密签名及校验](http://blog.csdn.net/wangqiuyun/article/details/42143957)

# IO

# [JAVA-加密解密](http://wenku.baidu.com/link?url=9PvkJo7fjXDrpUElyC_67GyUQrp4kJIL-zHeQUpoR8Hfgrc_X56ukC2XN-oCplHD89HfdFhUemcVtETAduLoLLuRYIkBCcD5L7G5zJcACNu)

# Runable
## AsyncTask
## TimerTask
 
