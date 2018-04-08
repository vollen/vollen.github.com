

# 缩窄错误
当将一个范围更大的变量赋值给范围较小的变量时，如`int`到`short`, 就会出现缩窄错误。
但是正常赋值的话，编译不会有问题，部分编译器会有个警告，运行时可能会出现错误。
+ 使用列表初始化可以避免这种错误，它会直接在编译阶段抛出错误。
```cpp
int large = 1;
float small{large}; //compile error
```

# auto 类型推断
可以根据赋给变量的初值，自动推断出其类型。
也可用于函数返回类型
```cpp
auto intNum = 1; //int
```
# constexpr 定义常量表达式
```cpp
constexpr double GetPi(){
    return 22.0 / 7;
}
constexpr double TwicePi(){
    return 2 * GetPi();
}
//常量表达式会在编译期间被替换为计算好的常量值。
```

# lambda 函数
[optional parameters](parameter list){ statements; }

# new 和 delete
```cpp
//使用try_catch 处理分配异常。
try{
    int * huge = new int[0x7fffffff];
}catch(bad_alloc){

}

//使用判断结果指针
int * huge2 = new(nothrow) int[0x7fffffff];
if(huge2){
    cout<<"alloced successed" << endl;
} else {
    cout<<"alloced failed" << endl;
}
```

# 指针
1. 务必初始化指针变量，否则它将包含垃圾值。
2. 务必仅在指针有效时才使用它，否则程序可能崩溃。
3. 对于使用 new 分配的内存，一定要记得使用 delete 进行释放，否则应用程序将泄露内存.
4. 指针被delete之后不应该再访问它.
5. 不要对一个指针多次delete

## 指针与const
```cpp
//根据const 离谁更近， 则修饰谁。
int* const ptr; //常指针，指针指向的地址不能被修改
const int * ptr; //指针指向的地址可以修改， 但是地址内部的内容可以修改
const int * const //都不能修改
```


# 类
## 构造函数
为避免类的隐式转换，可以在构造函数前加`explicit`。

## 复制构造函数
1. 当函数参数使用值传递时， 对象会被复制一份， 然后在函数内使用。
2. 如果类没有复制构造函数， 那么会默认才用二进制复制的方式，指针是浅复制，可能会出问题。
3. 如果有复制构造函数， 则会通过复制构造函数实现复制。
4. 复制构造函数的参数必须按引用传递， 否则会不断调用自己。
5. 复制构造函数的参数最好使用`const`
6. 除非万不得已， 不要将类成员声明为原始指针。
7. 使用原始指针的情况下， 必须要写复制构造函数和复制赋值运算符。

## 移动构造函数

## 特殊的类
### 禁止复制
私有的复制构造函数，私有的赋值运算符重载
### 单例类
禁止复制的类， 并且私有的构造函数， 提供静态实例
### 禁止在栈中实例化的类
私有的析构函数, 并提供静态函数，在类内部delete
在栈中实例化的对象，出栈时自动析构， 私有的析构函数会导致析构失败。

## 使用子类调用父类方法
```cpp
//当子类中只重载了父类部分函数时，未重载的同名函数会被隐藏。
sub.Base::func();
//使用using关键字
class Sub: public Base
{
public:
using Base::func;
};
//重载所有版本
```

## final 
禁止继承