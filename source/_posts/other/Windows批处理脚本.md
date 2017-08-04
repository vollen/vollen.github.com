Windows 批处理脚本

[参考资料](http://www.cnblogs.com/taoxu0903/archive/2011/06/28/2092212.html)

# 简单内部命令
## help [cmd] ， cmd /?
查看帮助， 可指定命令，一下内置命令都可以通过help来查看帮助
## echo
echo {[on | off]} [message]
## @命令
表示不回显@后面的命令
## Goto
跳转到指定标签
## Rem, ::
注释
## Pause
挂起程序， 等待用户响应
## Call
在脚本内调用另一个批处理程序
## start
打开一个新窗口调用 Dos命令或命令行程序
## choice /c:abc
让用户输入一个字符， /c: 可置顶可选字符
## dir 
显示当前目录中的文件和子目录
```dir /a``` 显示所有文件， 包括隐藏文件和系统文件
## md/mkdir
创建目录
## rd
删除目录
## del
删除指定文件
## ren
重命名文件
## cls
清空屏幕内容
## type 
显示文件内容
## copy
拷贝文件
>> con 代表屏幕， prn 代表打印机， nul 代表空设备
```copy con test.txt```
从键盘输入到test.txt, Ctrl+Z 结束输入

```copy test.txt +```
拷贝文件到自己， 修改文件修改时间。
## xcopy
复制文件和目录树
## title
设置窗口标题
## ver
显示系统版本
## vol
显示卷标
## label
显示卷标并提示输入新卷标
## date, time
显示日期和时间
## find
```find "str" file```
在文件中查找含有字符串的行， 找不到则errorlevel为1。
+ /i 忽略大小写
+ /c 显示匹配的行数
## more
逐屏显示
## tree
显示目录结构
## %0， %1 ... %9, %*
+ %0 批处理文件本身
+ %1 ... %9 传入程序的第1-9个参数
+ %* 从第一个参数开始的所有参数
+ 自带的参数扩展标记， 已第i个参数为输入，得到对应结果， 参数并不会改变
- %~i 去除引号
- %~fi 扩充为一个完整的路径名
- %~di 扩充为一个驱动器号
- %~pi 扩充到一个路径
- %~ni 扩充到一个文件名
- %~xi 扩充到一个文件扩展名
- %~si 扩充的路径只含有短名
- %~ai 扩充到文件属性
- %~ti 扩充到文件的时间
- %~zi 扩充到文件的大小
- %~$PATH:i 查找PATH环境变量指向的目录， 并获得第一个完全合格的名称。
## setlocal， endlocal
设置和取消[命令扩展名 和 延缓变量扩展]
```SETLOCAL ENABLEEXTENSIONS```
```SETLOCAL ENABLEDELAYEDEXPANSION```
[enabledelayedexpansion](http://www.jb51.net/article/29323.htm)
批处理是逐条命令读取的，for循环内部块算作一条， 在读取的过程中， 会将变量填充补全。 
所以for循环内部的set命令， 不会对之后的命令生效。
如果启用了变量延迟， 则读取命令的时候，不对变量填充，而是在执行之前计算。
但是要是用变量填充， 需要将%p% 换成!p!,否则仍然不会延迟计算。

## set
set 显示目前可用变量
set p 显示p开头的变量
set p=1 设置变量p的值为1
## assoc 
设置'文件扩展名'关联到'文件类型'
## ftype
设置'文件类型'关联到'执行程序和参数'
## pushd, popd


## if
### if param1 == param2
### if exist [filename]
### if [not] errorlevel
## for
### for {%variable | %%variable} in (set) do command  [command-parameters]
### /D
```for /D %variable in (set)```
与目录名匹配， 不与文件名匹配
### /R
```for /R [[drive:]path] %variable in (set)```
检查已[drive:]path为根的目录树，不指定目录则为当前目录。
### /L
```for /L %variable in (start, step, end)```
表示遍历一个已增量形式从开始到结束的集合。
### /F
```FOR /F ["options"] %variable IN ([file-set | "string" | 'command'])```
打开，读取并处理集合中的文件。
处理包括读取文件，将其分成一行行文字。 然后解析成符号， 然后用找到的符号调用for循环。
默认方式为使用空白符号分割， 跳过空白行
#### options
options可以指定参数替换默认解析操作。
##### eol=c 
指定行结尾字符
##### skip=n
指定在文件开头忽略的行数
##### delims=xxx
指定分隔符集， 替换默认的空白符号。
##### tokens=x,y, m-n
指定for循环中取到的变量集。 如果返回的最后为*， 则剩余的所有符号会被传入最后一个变量。
##### usebackq
将括号之间的字符串变成一个反括号字符串，该字符串会被当做一个命令行执行， 并将其输出当做输入文件来分析。
```FOR /F "eol=; tokens=2,3* delims=, " %i in (myfile.txt) do command ```
读取myfile.txt, 忽略`;`之后的内容， 已`,`和 ` `作为分隔符， 使用 %i取第二个符号， %j取第三个符号， %k取剩余的所有符号。

#组合命令
## &
顺序执行多个命令， 不管是否成功，都会执行完
## &&
顺序执行多个命令，如果某一条失败， 则不继续执行后面的命令。
## ||
顺序执行多个命令，如果某一条成功， 则不继续执行后面的命令。
## | 
管道命令, 将迁移命令的输出当做后一命令的输入。
## > , >>
讲命令的输出写入到指定文件中。 > 会先清空改文件内容再写入， >> 则是在文件最后追加内容.
## <
`<` 从文件中而不是键盘读入输入。
`>&` 将一个句柄的输出传给另一个句柄当输入
`<&` 从一个句柄读取内容，并写入到另一个句柄的输出 

# 字符串处理
## 赋值
set str1=xxx xx
## 连接
set str1=xxx
set str2= xxxx
set str3=%str1%%str2%
## 截取
set str2 = %str1:~起始值,长度%
如果省略长度和逗号， 则一直截取到末尾
## 求长度
使用循环，每次截取1，计算循环次数。
```bat
set str=adfds
set num=0
:loop
if not "%str%" == ""
(
    set /a num+=1
    set str=%str:~1%
    goto loop
)
echo %num%
```
## 替换
set str=%str:src=dst%




