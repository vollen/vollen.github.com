
i start to set up my own server.

os: ubuntu 16.04

## things install by apt
```bash
apt install git
apt install mysql
```
## 中文环境
```bash
#安装中文字符集包
apt-get install language-pack-zh 
#使生效
sudo locale-gen
#配置默认字符集
vi /etc/default/locale
LANG="zh_CN.UTF-8"
#重启
reboot
#查看默认字符集
locale
```
## gogs

## mailgun

## openresty
### nginx

## mysql
### phpmyAdmin
