# ios
## 获取 ios ipa 包
[如何获取ipa安装包](https://blog.csdn.net/chengqiang0414/article/details/82143930)
1. 首先 去Mac上的App Store下载Apple Configurator 2。然后把iphone连接上Mac，点击Apple Configurator 
2. 菜单中->账户->登陆（用连接设备的Apple ID）[如果担心设备数据会丢失，就备份下数据]
2. 所有设备->1 选中当前iPhone->2 添加-> 3 应用，找到您想要ipa的那个应用->添加
3. 添加后会显示如下图片表示正在下载App Store上的应用
当你的设备上存在这个应用的时候会有如下提示： 
这个时候切记，不要点击任何按钮！不要点击任何按钮！不要点击任何按钮！（重要的事情说三遍）直接进入第四步！

4. 打开Finder前往文件夹，或者直接快捷键command+shift+G并输入下面路径
~/Library/Group\ Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Assets/TemporaryItems/MobileApps/
可以看到我们需要的包，这个时候拷贝出来（一定要拷贝出来），然后回到第三步点击【停止】会发现刚才目录下的文件也消失了！

5. 拿到包后，就随便你怎么操作了

## 获取 ios ipa 方法2
用手机连上电脑代理， 然后下载游戏安装包， 使用 `charles` 拿到下载地址.
下载地址格式形如: `http://iosapps.itunes.apple.com/itunes-assets/.*.thinned.signed.dpkg.ipa?accessKey=`
使用下载地址可以下载到一个  `pre-thinnedxxxxxxx.thinned.signed.dpkg.ipa` 形式的包.
这个包,直接使用常用的解压工具是解不开的，需要用到下面这个库.
[解压算法](https://sskaje.me/2017/08/unzip-with-lzfse-support/)
[算法相关库](https://github.com/lzfse/lzfse)
解压之后可以看到包里面的所有东西
```
$ git clone https://github.com/sskaje/unzip-lzfse
$ git checkout lzfse
$ cd unzip-lzfse
$ export LZFSE_PATH=/usr/local
$ make -f unix/Makefile all
$ ./unzip -d test ../pre-thinned12345678.thinned.signed.dpkg.ipa
```

## plist 文件乱码
游戏的很多配置文件都是使用的 `plist` 格式，但是我们刚刚解压的包里，`plist` 文件打开是乱码， 这该怎么办呢？
`plist` 文件有两种格式, 一种是编码后的二进制格式, 另一种是大家平时所见的 `XML` 格式. 
使用如下命令可以将二进制格式的文件转换成`XML`格式的
```bash
    plutil -convert xml1 xxx.plist
```

## 解压ipa
将文件名后缀修改成 zip, 直接解压即可
## 提取资源包
在 windows 下使用 AssetStudio 可以提取。
[DevX-GameRecovery](http://devxdevelopment.com/)
一个付费的解包工具， 非常强大， 能直接还原工程。
mac 下暂时没找到办法