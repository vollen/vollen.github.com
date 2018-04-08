

clang -fobjc-arc files -o program

[receiver message ];
[receiver message : data, ...];

@interface NewClassName : ParentClassName
    propertyAndMethodDeclarations;
-(returnType) memberFunc:(paramType) param1;
+classFunc
@end

@implementation NewCalssName
{
    memberDeclarations;    
}
methodDefinitions;
@end

@synthesize 能让编译器自动生成一些内容

分配一个对象， 并进行初始化
myFraction = [[Fraction alloc] init];
[Class new] 等价于 [[Class alloc] init] 

ARC 机制， automatic release counting， 自动引用计数

访问方法名和成员变量名可以一致.


数据类型：
int float double char

for( init_expression; loop_condition; loop_expression){
    program statement;
}

if( expression)
    program statement
else
    statement 2
NAN not a number

&& ||

<ctype.h>
<Foundation/Foundation.h>

双引号用于引用本地文件，
尖括号用于引用系统文件

合成getter/setter

```OC
@interface Fraction : NSObject
@property int numerator, denominator;
@end

@implementation Fraction
@synthesize numerator, denominator;
//如果忽略 @synthesize 指令， 编译器生成的成员变量名会以_开头。
@end
```

instance.property  等价于
[instance property]

instance.property = value 等价于
[instance setProperty: value]


多参数方法
@interface
-（void) setTo: (int) n over: (int) d;
-(void) set:(int) n: (int)d;
@end

@implematation
-(void) setTo: (int) n over: (int) d
{
    numerator = n;
    denominator = d;
}
-(void) set: (int) n over: (int) d
{
    同上
}
@end

static
方法内局部静态变量
文件内局部静态变量

self 关键字

继承
在实现部分声明和合成的变量是私有的， 子类不能直接访问。
需要在接口部分声明，子类才能访问。

取值方法与直接使用实例变量是不同的， 有可能父类的成员是私有的， 但是暴露了取值方法。

@class 指令
当对应的文件只需要知道某类型是否存在而不需要了解他的其他细节时， 可通过@class指令声明。

abstract
printf

多态
id类型， 可以用来保存任意类型的对象 ， 不需要添加*号。
不能对id类型的变量使用点运算符，编译时会出错。