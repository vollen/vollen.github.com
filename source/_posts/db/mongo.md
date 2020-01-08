
# 安装
## mac os
brew install mongodb

## 远程连接
[设置远程连接访问mongodb数据库](https://www.cnblogs.com/kimkat/p/9192785.html)

##
## 插入数据
`db.foo.insert({"bar":"baz"})`

+ 导入原始数据
mongoimport
### 批量插入
传递一个由文档组成的数组给数据库,能实现批量插入, 加快运行速度.
批量插入有最大长度限制，
### 插入原理
驱动程序将数据转换成 `BSON` 数据格式传入数据库，数据库解析 `BSON` 并检查大小和是否包含`_id`键。
然后直接存入数据库中。
--objcheck选项,启动插入之前检查文档结构
`Object.bsonsize(doc)` 计算文档的转换为bson的大小 

## 删除文档
+ `db.users.remove()`
删除所有文档,但不删除集合本身
+ `db.users.remove($matcher)`
删除匹配 `matcher` 的文档
数据删除是永久性的，不能撤销，也不能恢复.
+ 如果要清除整个集合，那么直接删除集合会更快.
`db.drop_collection('bar')`
## 更新文档
`db.users.update($matcher, $modifier)`
+ 更新是原子的,先到达
+ `modifier` 会替换整个文档内容.
+ 当`matcher`匹配到多个文档的时候，更新会失败。在`shell`中会报错，在其他程序中使用`getLastError`可以获取错误信息。 
### 更新修改器
当文档只有一部分要更新时，可以更高效的更新。
+ 使用修改器时，"_id"不能修改.
+ 更新修改器是原子的
#### 修改键值对
$set 用来指定一个键的值，如果这个键不存在，则创建它.
$set 可以修改除`_id`之外的一切, 包括数据类型。
$unset 用于将键完全删除。
#### 增加和减少
+ $inc 用于使指定键的值增加, 如果键不存在，则直接将键值设为增加量;
只能用于整数、长整数和双精度浮点数
`db.users.update({name:'vollen'}, {"$inc":{"age", 1}})`
#### 数组修改器
只能用在值为数组的键上
+ $push
如果指定键存在，则向已有数组末尾加入元素，否则会创建一个新数组。
+ $ne
查找到不含值得数组
+ $addToSet
将值添加到数组，如果已经存在，则不处理
+ $each
```js
db.users.update({_id:ObjectId("xxxxx")},
    {"$addToSet":
        {"emails":
            {"$each":
                ['vollen@a.com', 'vollen@b.com']
            }
        }
    })
```
+ $pop
将值当做队列来使用。
从数组末尾删除
`{$pop:{key: 1}}`
从数组开头删除
`{$pop:{key: -1}}`
+ $pull
使用特定条件将所有匹配项从数组中删除元素
`{$pill:$matcher}`
+ 定位器
`db.user.update({"friends.name":"vollen"}, {"$set":{"friends.$.name":"vollen2"}})`;
找到好友数组中，"name" 为 "vollen" 的数据, 并将这一条数据的 "name" 改为 "vollen2";
`$`用于定位数组中匹配的那一项，每次只能更新第一个匹配的元素.
### 修改器速度
+ $inc 原地就能修改，所以非常快
+ $set 如果不修改文档大小，就会非常快。否则性能会下降。
+ `数组修改器`可能更改文档大小，会慢一些
### upsert
`update` 第三个函数传入`true`,当更新的文档不存在时，会执行插入操作

## 游标 cursor


## 高级
$maxscan 指定查询最多扫描的文档数量
$min 查询的开始条件
$max 查询的结束条件