

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
这块代码能生效的原理是利用了`IEEE754`标准中对浮点数的存数规则。
double在内存中， 占用64个比特位， 使用符号数值表示法。其中:

+ 0-51位为尾数部分
+ 52-63位为指数部分
  * 第63位为指数符号位。
+ 64位为符号位

浮点数运算规则: 先对齐指数部分， 然后尾数部分相加，最后规范化。
6755399441055744.0 = 00000011 * 2^52.
所以当一个数与它相加的时候， 指数部分强行对齐到52， 尾数部分右移， 正好将所有的小数点之后的部分移调。
例： 8.75 = 1000.11 = 1.00011 * 2^3 次方， 对齐到52位后，右移49位，原有尾数保留3位,算上会跟着移下来的那个1， 最后得到
0000...1000。小数部分全部被移掉。
至于最后达成4舍5入效果， 则是由于CPU的舍入机制决定。

将得到的尾数部分直接强制转换为整型(只会取后32个比特位)，即可得到取整的效果。

+ 为什么用1.5*2^52, 而不是1*2^52次方呢？
  因为当操作的数为负数的时候，使用1*2^52，会出现向最高位借位的情况， 导致最高位不为1，在最后规范化处理的时候， 无法保持指数部分为52. 结果异常。
  为了使能操作负数，所以需要除了省略的最高位外， 还需要有一个比特位为1. 

  因为整型只取低32位, 所以尾数部分的高20位都是随意的，只要不全为0就行，
  所以理论上， 一共有2^20-1 个这样的神奇的数字。
