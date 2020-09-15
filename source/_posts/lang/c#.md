

# 基础
## 大小写敏感
## namespace
声明一个命名空间
## using
using 可以在程序中包含命名空间
## 注释
- `//` `/* */` 可以添加注释
- `///` 文档注释
## 标识符
+ 必须由 数字，字母，下划线(_)，@ 组成
+ 不能由数字开头
+ @ 只能放在开头
+ 不能与保留字或类库名称相同，可以在前面加上 @ 作为前缀来使用。
## 类型
变量分为三种类型： 值类型，引用类型，指针类型
### 值类型
值类型直接包含数据，都是从类 System.ValueType 派生而来。
可用的值类型： bool, byte(8位无符号整数), char（16位 unicode 字符）, decimal, double, float, int, long, sbyte(8位有符号整数), short, uint, ulong, ushort。
sizeof(type) 可以获得一个类型或者变量在指定平台上的准确尺寸。
```c#
/*
Sizeof bool : 1
Sizeof byte : 1
Sizeof char : 2
Sizeof decimal : 16
Sizeof double : 8
Sizeof float : 4
Sizeof int : 4
Sizeof long : 8
Sizeof sbyte : 1
Sizeof short : 2
Sizeof uint : 4
Sizeof ulong : 8
Sizeof ushort : 2
*/
```
### 引用类型
引用类型的变量不直接存储数据，但是包含对多个数据引用。 多个不同的变量可以引用同一个数据，一处修改，其他引用也会受到影响。
内置的引用类型有：object, dynamic, String
#### 对象类型 object
object 是 c# 中所有类型的基类，是 System.Object 的别名。
任何别的类型都可以转换成 Object 类型。
装箱， 一个值类型转换为对象类型。
拆箱， 一个对象类型转换为值类型。
#### 动态类型 dynamic
动态类型的变量可以存储任何类型的值，它的类型检查是在运行时发生的。
dynamic 类型用于与其他的 .net 动态脚本交互。
#### 字符串类型 String
字符串类型的变量可以指向任何字符串值。是 System.String 的别名，由 Object 派生而来。
+ "string"
+ @"string"
- 字符串前面加 @ 可以将转义字符(\\)当做普通字符来处理
@"C:\Windows" 等价于 "C:\\Windows"
- @ 字符串可以任意换行
#### 用户自定义类型
+ class
+ interface
+ delegate

### 指针类型
指针类型的变量存储另外一种类型的内存地址。与 C C++ 中的指针一样。
### 可空类型
可空类型(Nullable), 可以表示在其基础类型的值范围内，再加上一个 null 值。
+ ? 
单问号用于将 int, double, bool 等无法直接赋值null的类型赋值为 null。
```c#
    int i; // i = 0
    int? ii; // ii = null
    i = null; // Error, can't convert null to 'bool', because it is a value type
    ii = null; //OK
```
+ ??
Null 合并运算符 (??) 用于定义可控类型的默认值。
```c#
    int? num1 = null;
    int? num2 = 3;
    int num3;
    num3 = num1 ?? 4; //num = 4;
    num3 = num2 ?? 4; //num = num2 = 3;
```
### 类型转换
#### 隐式类型转换
隐式类型转换是默认的转换，不会造成数据丢失。比如小的整数类型转换成大的类型，子类转换成基类。
#### 显式类型转换
+ 强制类型转换需要用到 (type) 运算符，可能会丢失数据。
+ 内置转换方法
使用 Convert 类 
- ToBoolean
- To...

## 常量
### 整数常量
+ 前缀标识基数， 0x 表示16进制， 0 表示八进制， 没有前缀表示十进制
+ 后缀可以是 U(unsigned) 和 L(long) 的组合， 不区分大小写。
### 自定义常量
const <data\_type> <constant\_name> = value;

## 运算符 
### 基础运算符与 C 一致
### 其他运算符
+ sizeof
+ typeof
返回对象的类型
+ is
判断对象是否为某一类型
+ as
强制转换

## 判断
+ if ..
+ if .. else ..
+ if .. else if .. else ..
+ switch(a) case v: .. break; 
+ exp1 ? exp2 : exp3;

## 循环
+ for( init; condi; increa){ expr;}
+ foreach( type a in arr){expr;}
foreach 能一次遍历出多维数组中的值
+ while(condi) ...
+ do .. while(condi)

## 方法
```c#
<Access Specifier> <Return Type> <Method Name>(Parameter List)
{
   Method Body
}
```
### 参数
+ 值传递
+ 引用传递 (ref)
```c#
public void func(ref int a){
    a = 100;
}
public void test(int a){
    int a = 1; // a = 1
    func(ref a);
    // a = 100
}
```
+ 输出参数 (out)
输出参数会在函数退出的时候，将方法输出数据赋给自己，从而实现返回多个数据的目的。
效果同上例，将关键字修改即可。 不同点在于，提供给输出参数的变量不需要赋值。
### 递归
调用自身的方法
## 程序入口
带有 Main 方法的类的 Main 方法。
## 访问修饰符
+ public
+ private
+ protected
+ internal
同一程序集内可访问
+ protected internal
同一程序集或派生类内可访问

* 程序集：被打包成的一个 exe 或 dll. 
* 类的默认访问修饰符为 private

## 数组
```c#
datatype[] arrayName;
double[] arr = new double[10]; // 声明一个10元素的数组
double[] arr = {1, 2, 3}; //声明一个数组，并给它赋值

double[,] arr = {{1,2}, {2,2}}; // 二维数组；
double val = arr[0,0];//访问多维数组的 0行0列
double[,,] arr; // 三维数组

double[][] a = new int[][]{new int[]{0,1}, new int[]{1,2,3}};//交错数组 
//交错数组与多维数组不一样的地方在于，每一维的数量可以不一样
double val = a[i][j]; //访问交错数组的元素。

//参数数组
public void func( params int[] arr){};
func(1, 2, 3, 4);

//Array 类， 封装了不少方法
```
## 字符串
## struct
+ 结构体是值类型数据结构。
+ 可以有方法，字段， 索引，熟悉，运算符方法和事件
+ 可以定义构造函数，但不能定义析构函数，不能定义默认构造函数
+ 不能继承其他类或结构
+ 可实现一个或多个接口
+ 成员不能指定为 absract, virtual, protected
+ 使用 new 操作符的时候，会调用适当的构造函数来创建
+ 不适用 new 操作符即可被实例化
## 与类不同的地方
+ 结构是值类型，类是引用类型
+ 结构不支持继承
+ 结构不能声明默认构造函数

## 枚举
枚举是一组命名整型常量， 由 enum 关键字声明。枚举是值类型。

## 类
+ 由 class 定义， 是引用类型。
+ 类的默认访问类型是 internal, 成员的默认访问类型是 private 。
+ 使用点运算符 (.) 来访问类的成员。
```c#
<access specifier> class  class_name{

}
```
### 声明周期函数
+ 构造函数
+ 析构函数
+ abstract 
抽象类，抽象函数
抽象类不能实例化
+ override 
重写父类方法是要加 override 关键字
+ 不支持多继承， 可通过接口来实现
+ sealed
sealed 关键字标识一个类不能被继承， 抽象类不能声明为 sealed.
+ virtual
需要在子类中实现的方法需要添加 virtual 关键字，虚方法的调用时在运行时发生的。

### 多态
多态是指一个接口实现多个不同的功能。
#### 静态多态
静态多态对函数的调用在编译器就已经明确了。
+ 函数重载
相同函数名有多个定义， 它们接受不同的参数个数,参数类型
+ 运算符重载
运算符重载能定义类的一些基础行为， 通过关键字 operator 后跟运算符符号来定义。
#### 动态多态
动态多态对函数的调用需要在运行时才能确定。

## 接口 (interface)
接口只包含成员的声明，由派生类负责实现

## 命名空间 (namespace)
命名空间目的是让一组名称与其他名称分割开。
使用 using 关键字来引入命名空间，
也可以不使用 using ， 直接使用 命名空间.name 的方式来使用命名空间的成员。
命名空间可以嵌套

## 预处理器
+ 预处理器在实际编译之前对信息进行预处理
+ 预处理器指令以 `#` 开头，只有空白字符可以出现在预处理器指令前。
+ 不是语句， 不以分号结尾
+ 预处理器用于实现条件编译， 不用于创建宏。
```c#
#define TEST
#if (TEST && !VC_10)
    Console.Write("TEST is defined, not VC_10");
#elif (TEST && VC_10)
# else
# endif
#undef TEST 
#line  1  //修改编译器的行数
#error    //在指定地方输出一个错误
#warning //在指定地方输出一个警告
#region    // 用于在代码编辑器中声明一个可展开的区块
#endregion //结束上文定义
```

## 正则表达式
### 转义字符
+ \a 匹配报警符(\u0007)
+ \b 匹配退格符(\u0008)
+ \t 匹配制表符(\u0009)
+ \r 匹配回车符(\u000D)
+ \v 匹配垂直制表符(\u000B)
+ \f 匹配换页符(\u000C)
+ \n 匹配换行符(\u000A)
+ \e 匹配转义符(\u001B)
### 字符类
+ [character_group] 匹配 group 中的所有字符，区分大小写
+ [^ ...] 非， 不匹配该组字符
+ [first - last] 匹配范围内的字符
+ .  匹配除 \n 外的所有字符
+ \w 匹配任何单词字符
+ \s 匹配空白字符
+ \d 匹配十进制数字
### 定位点
+ ^ 匹配开头
+ \A 同上
+ $ 匹配末尾
+ \Z 同上
+ \G 上一个匹配结束的地方
+ \b 匹配单词结束的地方
### 分组
+ (subexpresion)  定义一个捕获组
+ (?<name>subexpression) 定义一个命名捕获组
+ (?:subexpression) 定义一个非捕获组
### 限定符
+ \* 
+ \+
+ ?
+ {n}
+ {n ,}
+ {n, m}
+ 限定符? 限定符的非贪婪版本
### 反向引用
+ \number 引用第 number 个捕获组
+ \k<name> 引用命名捕获组
### 替换
用于替换模式中的正则表达式, 主要是用 $ 来引用
+ $number 替换为第 number 个捕获组
+ ${name} 替换为命名捕获组
+ $` 替换为输入字符串匹配前的文本
+ $' 替换为输入字符串匹配后的文本
+ $+ 替换为最后的匹配组
+ $_ 替换为整个输入字符串
+ $& 替换为整个匹配项
### Regex 类

## 异常
try{ expr.. } catch(Exception e){} finally{}
Throw(ex)
## 文件输入输出
文件通过流的方式与程序交互，输入流用于读取文件， 输出流用于向文件写入数据。
System.IO 命名空间有各种类处理文件操作。

# 高级部分
## 特性
特性用于在运行时传递程序中各种元素的行为信息的声明性标签。
特性用于添加元数据，如编译器指令和注释、描述、方法和类等其他信息。
### 规定特性
```c#
[attribute(positional_parameters, name_parameter = value, ...)]
element
```
特性的名称和值实在方括号内规定的， 放置在它所应用的元素之前。positional_parameters 规定必须的信息， name_parameter 规定可选的信息。
### 预定义特性
+ AttributeUsage 描述如何使用一个自定义特性类
+ Conditional 标记一个条件方法，当条件为真时，调用该方法，否则跳过对该方法的调用。
```c#
    [Conditional("DEBUG")]
    public static void Message(string msg)
    {
        Console.WriteLine(msg);
    }
    //当没有定义 DEBUG 时，对该方法的调用为一个空调用
```
+ Obsolete 标记一个不应该被程序使用的实体，如过期的方法。
```c#
    //语法 [Obsolete( message,?iserror)]
   [Obsolete("Don't use OldMethod, use NewMethod instead", true)]
   static void OldMethod()
   { 
      Console.WriteLine("It is the old method");
   }
```
### 自定义特性
自定义特性应该派生自 System.Attribute 类，使用 AttributeUsage 来修饰该特性的行为。
```c#
[AttributeUsage(AttributeTargets.Class |
AttributeTargets.Constructor |
AttributeTargets.Field |
AttributeTargets.Method |
AttributeTargets.Property,
AllowMultiple = true)]

public class DebugInfo : System.Attribute{
}
//使用
[DebugInfo()]
```

## 反射
反射指程序可以访问、检测和修改它本身状态或行为的一种能力。
你可以使用反射动态的创建类型的实例， 将类型绑定到现有对象，或从现有对象中获取类型，然后可以调用类型的方法或访问其字段和属性。
### 优点：
1. 反射提高了程序的灵活性和扩展性。
2. 降低耦合性，提高自适应能力。
3. 它允许程序创建和控制任何类的对象，无需提前硬编码目标类。
### 缺点：
1. 性能问题：使用反射基本上是一种解释操作，用于字段和方法接入时要远慢于直接代码。因此反射机制主要应用在对灵活性和拓展性要求很高的系统框架上，普通程序不建议使用。
2. 使用反射会模糊程序内部逻辑；程序员希望在源代码中看到程序的逻辑，反射却绕过了源代码的技术，因而会带来维护的问题，反射代码比相应的直接代码更复杂。
### 用法
```c#
System.Reflection.MemberInfo info = typeof(MyClass);
object[] attributes = info.GetCustomAttributes(true);
```

## 属性
属性是类结构或接口中的命名成员， 是域的扩展，它们使用访问其来私有域的值可被读写或操作。
### 访问器
访问器包含用于获取或设置属性的语句，访问器声明可包含一个 get 访问器， 一个 set 访问器， 
```c#
class Accestor{
    private string code = "N.A";
    // 声明类型为 string 的 Code 属性
    public string Code {
        get {
            return code;
        }
        set {
            code = value;
        }
    }
}
```
### 抽象属性
抽象类可用拥有抽象属性，这些属性应该在派生类中实习。 抽象属性只定义行为，不实现。

## 索引器
索引器允许一个对象像数组一样的索引，当你为一个类定义了一个索引器之后，就可以使用数组访问运算符 ([]) 来访问类的实例。
### 语法
```c#
element-type this[int index] {
   // get 访问器
   get {
      // 返回 index 指定的值
   }
   // set 访问器
   set {
      // 设置 index 指定的值 
   }
}
```
### 重载索引器
索引器声明的时候也可带有多个参数，且每个参数可以是不同类型。
每个不同的索引器必须有不同的参数列表。

## 委托
委托类似于函数指针，存在一个对被委托函数的的引用，使用 new 关键字， 加上被委托方法作为参数来创建。调用委托时会调用被委托对象。
### 多播
+ \+ 运算符可以将委托进行合并。
+ \- 运算符可用于从合并的委托中移除组件委托。
+ 使用这个特点， 可以用一个委托代理多个方法，达到多播的效果。

## 事件
事件(event)是一个用户操作， 或者说一个消息，它使用委托来与事件处理函数关联。
+ 发布器， 包含事件的类，用于发布事件。
+ 订阅器， 接受事件并处理事件处理函数的类。
```c#
class Publisher{
    public delegate void Handler();
    public event Handler myEvent;
    public void send(){
        if(myEvent != null){
            myEvent();
        }
    }
    public void subscriber(){
        Console.WriteLine("handler event");
    }

    public static void Main(){
        Publisher publiser = new Publisher();
        publisher.myEvent += publisher.subscriber;
        publisher.send(); 
    }
}
```

## 集合
集合 (Collection) 类是专门用于数据存储和检索的类。
+ 动态数组 (ArrayList)
+ 哈希表 (Hashtable)
+ 排序列表 (SortedList)
+ 堆栈 (Stack)
+ 队列 (Queue)
+ 点阵列 (BitArray)

## 泛型
泛型用于实现一些通用的行为，在实现时用类型的替代参数编写代码。在需要构造函数或调用类的方法的时候，编译器会生成对应类型的代码来处理指定的数据类型。
可以通过类型参数定义泛型委托。

## 匿名函数
匿名方法提供了一种使用代码块作为委托参数的技术， 您名方法中不需要指定返回类型，它会自动通过 return 语句推断。
```c#
public delegate void Handler(int n);
Handler hd = delegate(int n){expr...};
hd(10);
```
## 不安全代码
当一个代码块使用 unsafe 修饰符标记时，允许在函数中使用指针。
不安全代码块是使用了指针变量的代码块。
## 多线程
System.Threading.Thread


## C# 反编译
[推荐.Net、C# 逆向反编译四大工具利器](https://blog.csdn.net/kongwei521/article/details/54927689)
