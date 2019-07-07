

[取不到环境变量，[非]登录[非]交互式shll](https://blog.csdn.net/zzusimon/article/details/57080337)
[中文教程](https://jenkins.io/zh/doc/pipeline/tour/hello-world/)
[设置中文](https://blog.csdn.net/qq_15807167/article/details/79896131)
## 插件
- [description setter 设置最后输出描述格式](https://wiki.jenkins.io/display/JENKINS/Description+Setter+Plugin)
- [Multiple SCMs 多仓库管理]()

## 权限问题
在官网下载dmg安装包，安装完毕即可在本机搭建jenkins的工作。但是jenkins不会用本地的用户去构建，任何创建的文件都是“jenkins”用户所有，这会造成很多权限问题，无法调用自己写的脚本，执行shell会出现没有权限的错误。

## 解决办法：
查看自己的用户群组和用户名
系统偏好设置 -> 用户与群组 -> 点按🔒锁按钮进行更改 -> 输入密码确认 -> 右键高级选项… -> 查看群组和用户名

### 停止Jenkins
`sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist`
### 修改 org.jenkins-ci.plist 配置
`sudo vi /Library/LaunchDaemons/org.jenkins-ci.plist`

1. JENKINS_HOME 为 JENKINS 的根目录地址，默认 /Users/Shared/Jenkins/Home/ 需要改到当前用户下 /Users/userName/.jenkins 解决权限问题和工作路径找不到问题；
2. GroupName 群组名，改为当前用户的群组；
3. UserName 用户名，改为当前用户的用户名；

### 重启 Jenkins
```sh
 # 如果 Jenkins 本地服务启动失败需要停止当前Jenkins 执行以下操作再重启Jenkins
 $ sudo chown -R userName /Users/Shared/Jenkins
 $ sudo chown -R userName /var/log/jenkins
 # 重启Jenkins
 $ sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist

 # 手动启动脚本
 sh /Library/Application Support/Jenkins/jenkins-runner.sh
```
## 安装 plugins
- 由于更改了 Jenkins 的根目录所以要重新安装一遍`plugins`