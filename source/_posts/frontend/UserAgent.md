UserAgent.md

[whoishostingthis](http://www.whoishostingthis.com/tools/user-agent/)

+ 概况
userAgent是位于用户与服务器之间的一层代理， 用于帮助用户更好的使用网页。
常见的userAgent有： 浏览器/爬虫/各种终端/电子书阅读器等等

+ http User Agent 字符串
不同的User Agent 在连接服务器的时候， 会向服务器端发送自己的唯一标识符。 这个就是Http的User Agent 字段。
服务器端可以通过字段中的信息， 来为客户端提供不同的内容，或者服务。
+ User Agent 欺骗
User Agent 字段是有可能被外部修改的，[user-agent switcher](https://chrome.google.com/webstore/detail/user-agent-switcher-for-c/djflhoibgkdhkhhcedjiklpkjnoahfmg)
所以不要切记完全依赖UserAgent.

+ js 里查看UserAgent串
`navigator.userAgent`

+ 各种不同的UserAgent
[useragentstring](http://www.useragentstring.com/pages/useragentstring.php)

