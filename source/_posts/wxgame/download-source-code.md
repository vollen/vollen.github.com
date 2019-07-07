<!-- TITLE: 导出小游戏源码 -->
<!-- SUBTITLE: A quick summary of 导出小游戏源码 -->

# 查找小游戏路径
	在终端中输入
	//连接上模拟器
	#adb kill-server
	#adb shell
	//查找相应的pkg路径
	#cd /data/data/com.tencent.mm/MicroMsg/{xxxxxx}/appbrand/pkg/
	//退出模拟器
	#exit
# 解压小游戏包
	//从模拟器下载pkg包
	#adb pull /data/data/com.tencent.mm/MicroMsg/{xxxxxx}/appbrand/pkg/
	//找到相应的小游戏包
	#python unwxapkg.py <刚才下载的小游戏包地址>
[Unwxapkg.py](/static/unwxapkg.py "Unwxapkg")

