

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
