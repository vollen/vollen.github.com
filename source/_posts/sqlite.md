title: sqlite
tags:
    - database
    - sqlite
    - android
---

sqlite 是一个轻量级的数据库, 适用于少量数据的CURD, 并且支持大部分的sql语法.
Android 开发中, 经常使用sqlite来存储数据.

## SQL
[SQL As Understood By SQLite][SQL_by_sqlite]
sqlite 支持大部分的sql语法, 不过还是有一些不太一样, 在增加部分特性的同时也去掉了一些.

## CLI
[sqlite3 命令行工具命令][sqlite3_cli]
sqlite数据库有一个叫做 sqlite3的命令行工具. 可以在命令行中输入命令或者sql语句来管理操作sqlite数据库.

## Android Sqlite 开发
[【Android 应用开发】Android 数据存储 之 SQLite数据库详解][android_sqlite]
在Android项目开发中, 我们经常用到sqlite来存储数据, Android 在 `android.database.sqlite`包中封装了很多sqlite操作的API.
### SQLiteDataBase
### SQLiteOpenHelper
### Cursor
### SimpleCursorAdapter

[SQL_by_sqlite]:https://www.sqlite.org/lang.html
[sqlite3_cli]:http://www.cnblogs.com/frankliiu-java/archive/2010/05/18/1738144.html
[android_sqlite]: http://blog.csdn.net/shulianghan/article/details/19028665

