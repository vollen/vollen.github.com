title: amazonec2
tags: [vps]
---


# ssh 无密码登陆VPS
将登陆机的公钥放在 VPS 的.ssh/authorized_keys 文件中, 这样当登陆机使用ssh访问VPS的时候,
公钥私钥配对成功, 就可以通过认证.

1. 在登陆机上生成密钥对.[参考](https://lgfng.github.io/2015/10/10/配置ssh密钥/)
2. `cat id_rsa.pub` 并将内容复制到 vps 上的 .ssh/authorized_keys 中.
3. 完成: 使用 `ssh vps_ip` 就可以登陆
4. 通过修改 `/etc/hosts` 文件,就可以将 `vps_id` 替换成方便好记的域名了. 

# 文件传输 scp
