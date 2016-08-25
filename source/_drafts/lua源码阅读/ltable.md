

# 数据结构
```c
typedef struct Table {
  CommonHeader;
  lu_byte flags;  /* 1<<p means tagmethod(p) is not present */ 
  lu_byte lsizenode;  /* log2 of size of `node' array */
  struct Table *metatable;
  TValue *array;  /* array part */
  Node *node;
  Node *lastfree;  /* any free position is before this position */
  GCObject *gclist;
  int sizearray;  /* size of `array' array */
} Table;
```
Table 的数据结构定义在`lobject.h`中,
+ flags 标识位, 标识是否设置了对应的metamethod 
+ lsizenode 存储node部分的长度的 log2对数, 使用的时候需要还原回来
+ metatable 元方法， 定义了一些方法
+ array 数组部分， 直接存储TValue
+ node  hash部分
+ lastfree 永远指向最后一个可用的结点， 当找不到的时候， 需要重新rehash
+ sizearray 数组部分长度

# 接口

+ luaH_getn
    判断
+ luaH_set
    `lua_Hset`并不真正设置值， 而是返回该key的结点。
    先尝试调用`luaH_get`, 如果返回nil,则使用`newkey`得到一个新的结点并返回 。
+ luaH_get
+ luaH_next
+ newkey
    首先根据key的hash值找到对应位置。然后判断该位置是否被占用
        如果没有，则直接赋值。 
        否则， 判断当前结点的`hash位置`是不是这里
            如果不是，则把它放到合适的位置，放到它自己的主位置， 或者找其他空节点，并调整对应key的结点链表。
            如果是，根据`lastfree`找可用结点。
                如果没有可用结点， 则`rehash`。
                有则插入结点， 并将该结点链接到该key对应的链表末尾。
+ rehash
    统计当前`table`中key为数字(且在最大数组下标范围内)的结点， 和总的结点数。
    然后重新计算需要的数组大小`computesizes`，并分配内存`resize`。

# 题外话
看到一段神奇的代码，用于将`lua_number(double)` 快速转换成`int`.
```c
union luai_Cast { double l_d; long l_l; };
#define lua_number2int(i,d) \
  { volatile union luai_Cast u; u.l_d = (d) + 6755399441055744.0; (i) = u.l_l; }
```