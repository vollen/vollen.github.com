闲来没事鼓捣系统， 准备从unbuntu14.04 升级到16.04，结果中途升级程序被中断， GG。
从子翔处借U盘来重装系统（linux mint）， 系统全部安装在固态硬盘中， 起始并没有将原来的/home分区挂载到新系统上。
所以需要手动将原来的home分区挂到系统的home 分区

[参考资料]http://www.mintos.org/skill/home-partition.html

那原来的系统上的home哪去了呢？ 
其实它还在原来的硬盘， 原来的位置上， 我们可以通过挂载它之前所在的分区，来找到它。
比如原来home 在 / 下， 硬盘分区为 /dev/sda2
则可以通过以下命令
```
mkdir /mnt/root
mount /dev/sda2 /mnt/root
```
这时候进入 /mnt/root/home， 就能发现挂载之前的文件了。