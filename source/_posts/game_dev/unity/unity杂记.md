
# c# 编译器
unity 2020.2 中使用 .net 4.6, C# 编译器为 Roslyn, 对应的 C# 语言版本是 C# 8.0.
unity 2020.1 中使用 .net 4.6, C# 编译器为 Roslyn, 对应的 C# 语言版本是 C# 7.3.

## C# 8.0
[What's new in C# 8.0](https://docs.microsoft.com/en-us/dotnet/c#/whats-new/c#-8)
[浅谈 C# 8.0 实际使用感受](https://zhuanlan.zhihu.com/p/124290152)
### Readonly members of Struct
### Default interface methods
interface 可以提供默认的实现
interface 可以提供 static 函数及成员变量, 这些变量可以是用任意访问限制修饰符修饰，如 `private`, `protected` 等。 
interface 的默认实现只能使用 interface 的类型来调用， 不可以使用实现类的类型调用。
interface 的实现类实现接口时， 可以调用 interface 的静态接口。
示例代码:
```c#
public interface ICustomer
{
    private static string _defaultName = "defaultName"; // interface 可以有 private 的 static 成员。  
    // interface 可以有 static 方法。
    public static void SetDefaultName( string name){ 
        _defaultName = name;
    }

    protected static string DefaultGetName(ICustomer c)
    {
        return _defaultName;
    }

    // interface 的默认实现
    public string GetName() => DefaultGetName(this);
}

//使用默认接口
public class SampleCustomer : ICustomer{
}

SampleCustomer c = new SampleCustomer();
ICustomer.SetDefaultName("My default name"); // 设置接口的默认参数
ICustomer theCustomer = c; // 这里必须转换成 ICustomer 接口， 因为默认实现是在 interface 中， 而不会被实现类继承.
Console.WriteLine($"Current discount: {theCustomer.GetName()}"); //输出 My default name

//重新实现了接口， 并且再默认情况下调用了默认的实现
public class SampleCustomer2 : ICustomer{
    private string _name = "";
    public decimal GetName()
    {
        if(_name != ""){ return _name;}
        return ICustomer.DefaultGetName(this);
    }
}
```
### More patterns in more places
[Using pattern matching features to extend data types](https://docs.microsoft.com/en-us/dotnet/c#/tutorials/pattern-matching)
更强大的模式匹配, 每一个模式匹配表达式的结果还是一个表达式， 所以能递归使用。
结合 `is` 和 `switch` 关键字更好用。 一大波语法糖来袭。
#### Switch expressions
switch 表达式。
大幅减少 switch 的代码量， 主要有下面几点变化。
1. `switch` 放在 `value表达式` 后面， 能更明显的看出它是一个`switch`， 好像没什么用
2. 对于每一个`case`, 直接使用 `=>` 箭头表达式处理。
3. 对于默认的 `default`情况，使用 `_` 加箭头表达式处理。
4. 每一个方法体都是表达式，而不需要是语句。

```c#
//返回一个彩虹枚举对应的颜色值
public static RGBColor FromRainbow(Rainbow colorBand) =>
    colorBand switch
    {
        Rainbow.Red    => new RGBColor(0xFF, 0x00, 0x00),
        Rainbow.Orange => new RGBColor(0xFF, 0x7F, 0x00),
        // ... 其他 case
        _              => throw new ArgumentException(message: "invalid enum value", paramName: nameof(colorBand)),
    };
```
#### Property patterns
属性模式匹配
```c#
public static decimal ComputeSalesTax(Address location, decimal salePrice) =>
    location switch
    {
        { State: "WA" } => salePrice * 0.06M,
        { State: "MN" } => salePrice * 0.075M,
        // other cases removed for brevity...
        _ => 0M
    };
```
#### Tuple patterns
元组模式匹配
```c#
public static string RockPaperScissors(string first, string second)
    => (first, second) switch
    {
        ("rock", "paper") => "rock is covered by paper. Paper wins.",
        ("rock", "scissors") => "rock breaks scissors. Rock wins.",
        // ......
        (_, _) => "tie"
    };
```
#### Positional patterns
配合 `Deconstruct` 解构函数以及`when`表达式，可以实现更强大的功能。
```c#
public class Point
{
    public int X { get; }
    public int Y { get; }
    public Point(int x, int y) => (X, Y) = (x, y);
    public void Deconstruct(out int x, out int y) => (x, y) = (X, Y);
}
static Quadrant GetQuadrant(Point point) => point switch
{
    (0, 0) => Quadrant.Origin,
    var (x, y) when x > 0 && y > 0 => Quadrant.One,
    var (x, y) when x < 0 && y > 0 => Quadrant.Two,
    var (x, y) when x < 0 && y < 0 => Quadrant.Three,
    var (x, y) when x > 0 && y < 0 => Quadrant.Four,
    var (_, _) => Quadrant.OnBorder,
    _ => Quadrant.Unknown
};
```
### Using declarations
using 声明语句， using 语句的一个语法糖。 它能在离开 `using` 修饰的变量的声明周期时，自动释放变量所引用的资源。
### Static local functions
静态内部函数, 使用 `static` 修饰的内部函数不会捕获任何外部变量， 否则会有编译错误。
### Disposable ref structs
没太看明白， 大概就是 使用 `ref` 修饰的 struct 必须包含一个可访问的 `void Dispose()` 方法， 否则它可能无法被释放。同样的还有 `readonly ref struct`;
### Nullable reference types
在可为空注释上下文中，引用类型的任何变量都被视为不可为空引用类型。 若要指示一个变量可能为 null，必须在类型名称后面附加 ?，以将该变量声明为可为空引用类型。
### Asynchronous streams
异步数据流，类似 `typescript` 里的 `generator`, 不断的产生数据， 而不是普通 `async` 函数的结果一次性返回。
```c#
public static async System.Collections.Generic.IAsyncEnumerable<int> GenerateSequence()
{
    for (int i = 0; i < 20; i++)
    {
        await Task.Delay(100);
        yield return i;
    }
}
await foreach (var number in GenerateSequence())
{
    Console.WriteLine(number);
}
``` 
### Indices and ranges
序列访问语法
^n 等价于 `seq[seq.length - n]`
a..b 表示取序列的索引`a`到索引`b` 之间的切片。 前面的数字可以为空，表示 0。
```c#
words[^2..^1] // words 倒数第二个数到第一个数之间的子序列
words[0..^1] // words 第一个数到第一个数之间的子序列
Range range = 1..4 // 可以把变量指向一个range表达式。
```
### Null-coalescing assignment
新操作符 `??=` 只有在左值为`null`的情况下才会将右值赋给左值。 `i ??= a; `等价于 `i = i == null ? a : i; `;
```c#
int ? i = null;
i ??= 1; // i = 1;
i ??= 2; // 因为 i 不再是 null, 所以不会把 2 赋给 i, i = 1;
```
### Unmanaged constructed types
非托管构造类型, 如果一个值类型的构造函数中，只包含非托管类型， 那么这个类型也是非托管类型。
[C# 基础——托管类型和非托管类型](https://www.jianshu.com/p/bb76a3f3c8d8)
### 嵌套表达式中的 stackalloc
如果一个 `stackalloc` 表达式的结果是 `Span<T>`, 那么它可以内嵌在其他表达式中。
### 内插逐字字符串的增强功能
内插表达式中的 `$` 和 `@` 可以以任意顺序出现。

## C# 7.3
### stackalloc 数组支持初始值设定项
```c#
Span<int> arr = stackalloc [] {1, 2, 3};
```
### 元组支持 == 和 !=
### 将特性添加到自动实现的属性的支持字段

## C# 7.2
### 非尾随命名参数
可以使用参数名字传递参数
### 数值文字中的前导下划线
十六进制和二进制文本可以使用 `_` 开头。
### 条件 ref 表达式
```c#
ref var r = ref (arr != null ? ref arr[0] : ref otherArr[0]);
//变量 r 是对 arr 或 otherArr 中第一个值的引用。
```

## C# 7.1
### default 文本表达式
```c#
Func<string, bool> whereClause = default(Func<string, bool>);
//可以替换成
Func<string, bool> whereClause = default;
```
### 推断元组元素名称
```c#
int count = 5;
string label = "Colors used in the map";
var pair = (count, label); // 自动捕获上下文中匹配的值放入元组中
```
### 泛型类型参数的模式匹配
`is` 和 `switch` 中的模式可以使用泛型类型参数。

## C# 7.0
### out 变量
可以在方法调用的参数列表中声明 `out` 变量，并且可以使用自动类型推断。
```c#
if (int.TryParse(input, out var answer))
    Console.WriteLine(answer);
else
    Console.WriteLine("Could not parse input");
```
### 元组
元组用于表示需要包含多个数据元素的简单结构。 `Deconstruct` 可以定义类的实例如何结构。
### 弃元
弃元是一个名为`_`的只写变量。用于任何不需要该变量， 但是需要语法占位的情况。
在以下方案中支持弃元：
+ 在对元组或用户定义的类型进行解构时。
+ 在使用 `out` 参数调用方法时。
+ 在使用 `is` 和 `switch` 语句匹配操作的模式中。
+ 在要将某赋值的值显式标识为弃元时用作独立标识符。
### 模式匹配
#### is
is 可以判断变量是否符合条件，并且可以将成功结果分配给类型正确的新变量。
```c#
if (input is int count)
    sum += count;
```
#### switch
`switch` 不再限定在基础类型， 可能使用任何类型
可在每个 `case` 标签中测试表达式的类型，并且如给新的变量
可以添加 `when` 自居进一步测试新变量条件 
执行第一个匹配的分支，其他将跳过，因此 `case` 的顺序变得更重要
### 本地函数
可以在函数内部声明内部函数。
### 更多的地方可以使用箭头函数
可以在属性和索引器上实现构造函数、终结器以及 get 和 set 访问器。
### 通用的异步返回类型
`async` 函数不再必须返回 `Task` 类型， 可以返回 `ValueTask<T>`, `ValueTask<T>`是对值的包装， 更轻量。
```c#
public async ValueTask<int> Func()
{
    await Task.Delay(100);
    return 5;
}
```
### 数字文本语法改进
可以在数字内部插入 `_` 分隔符使得数字更容易理解。
```c#
public const int Sixteen =   0b0001_0000;
public const int ThirtyTwo = 0b0010_0000;
public const int SixtyFour = 0b0100_0000;
public const int OneHundredTwentyEight = 0b1000_0000;
```


## C# 6.0
### 只读自动属性
只读自动属性只能在同一个类的构造函数中赋初值， 也可以在属性的声明语句中赋值。
```c#
    public string FirstName { get; }
```
### 自动属性初始化表达式
自动属性初始值设定项 可让你在属性声明中声明自动属性的初始值。
```c#
public ICollection<double> Grades { get; } = new List<double>();
```
### 箭头函数成员
可以直接将箭头表达式作为类的成员函数。
```c#
public override string ToString() => $"{LastName}, {FirstName}";
```
### using static
`using static` 可以导入类的静态方法。
```c#
using static System.Math;
```
### null 条件运算符
如果对象不为空的情况， 取它的属性值。
```c#
var first = person?.FirstName;
this.SomethingHappened?.Invoke(this, eventArgs); // 当事件不为空的时候， 触发事件
```
### 字符串内插
使用`$""` 关键字可以在字符串中内嵌表达式， 让字符串更清晰
```c#
public string FullName => $"{FirstName} {LastName:F2}"; // :F2 用于设置格式
```
### 异常筛选器
只有`when`子句计算结果为`True` 的情况下， 才会处理该异常， 否则将跳过 catch。
```c#
try{
} catch(Exception e) when(e.Message.Contains("502")){
} catch(Exception e){
}
```
### nameof 表达式
nameof 表达式返回符号的名称, 在 unity 中使用 `startCoroutine` 时非常适用， 使编译器能检测到引用依赖。
### Catch 和 Finally 块中可以使用 await 了
### 使用索引器初始化关联集合
```c#
private Dictionary<int, string> webErrors = new Dictionary<int, string>
{
    [404] = "Page not Found",
    [302] = "Page moved, but left a forwarding address.",
};
```
### 改进了重载解析