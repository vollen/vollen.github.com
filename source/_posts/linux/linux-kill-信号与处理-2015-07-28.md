title: linux kill 信号与处理
date: 2015-07-28 15:13:59
tags:
    - linux 
    - kill 
    - 信号
---

# 关于linux命令发送的信号,以及信号监听处理

## linux kill 信号列表
在shell中通过使用 kill -l 来查看kill命令能发送的信号列表

<!--more-->
```bash
    $ kill -l
     1) SIGHUP   2) SIGINT   3) SIGQUIT  4) SIGILL   5) SIGTRAP
     6) SIGABRT  7) SIGBUS   8) SIGFPE   9) SIGKILL 10) SIGUSR1
    11) SIGSEGV 12) SIGUSR2 13) SIGPIPE 14) SIGALRM 15) SIGTERM
    16) SIGSTKFLT   17) SIGCHLD 18) SIGCONT 19) SIGSTOP 20) SIGTSTP
    21) SIGTTIN 22) SIGTTOU 23) SIGURG  24) SIGXCPU 25) SIGXFSZ
    26) SIGVTALRM   27) SIGPROF 28) SIGWINCH    29) SIGIO   30) SIGPWR
    31) SIGSYS  34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
    38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42)SIGRTMIN+8
    43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
    48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
    53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
    58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
    63) SIGRTMAX-1  64) SIGRTMAX   
```

**其中1-31 是传统UNIX支持的信号**
下面对于这些信号进行讨论

+ 1) SIGHUP

    > 在终端连接结束时发出,通常实在终端的控制进程结束时,通知同一session内的其他进程

+ 2) SIGINT  
    
    > 程序终止信号,在用户输入INTR字符(Ctrl+C)时发出,用于通知前台进程终止进程

+ 3) SIGQUIT  

    > 和SIGINT类似,但是由QUIT字符(Ctrl+\\)控制,进程在收到SIGQUIT退出时会产生core文件, 因此这类似于一个程序错误信号

+ 4) SIGILL   
    
    > 执行了非法指令.通常是因为可执行文件本身出错,内存越界,内存溢出都有可能产生

+ 5) SIGTRAP

    > 由断点指令或其他trap指令产生, 由debugger使用
    
+ 6) SIGABRT
    
    > 调用abort函数生成的信号

+ 7) SIGBUS   
    
    > 非法地址,包括内存地址对齐出错.比如访问一个四字长的整数,但其地址不是4的倍数

+ 8) SIGFPE   

    > 在发生致命的算术运算错误时发出, 比如 div 0 操作.
    
+ 9) SIGKILL 

    > 用来立即结束程序的运行, **该信号不能被阻塞//处理和忽略**. 可用于强制终止进程
    
+ 10) SIGUSR1
   
    > 留给用户使用
    
+ 11) SIGSEGV 
    
    > 访问未分配给自己的内存,或这试图往没有权限的内存地址写数据

+ 12) SIGUSR2 

    > 第二个留给用户使用的信号

+ 13) SIGPIPE 

    > 管道破裂. 在进程间通信过程中产生

+ 14) SIGALRM 

    > 时钟信号. 计算的是实际的时间或时钟时间, alarm函数使用该信号

+ 15) SIGTERM

    > 程序结束信号. **该信号可以被阻塞和处理**, shell 中的kill命令默认产生这个信号. 如果进程终止不了,我们才会去尝试SIGKILL

+ 16) SIGSTKFLT   

    > Wait for edit

+ 17) SIGCHLD 

    > 子进程结束时,父进程会收到这个信号

+ 18) SIGCONT 

    > 让一个stopped 的进程继续执行,**该信号不能被阻塞** 

+ 19) SIGSTOP 

    > stopped 进程的执行, **该信号不能被阻塞**, **只是挂起该进程,不会结束**

+ 20) SIGTSTP

    > 停止该进程的运行, 但是可以被处理和忽略. 用户键入SUSP字符时(Ctrl+Z) 时发出这个信号

+ 21) SIGTTIN 

    > 当后台作业要从用户终端读数据时, 该作业的所有进程会收到SIGTTIN信号, 缺省时这些进程会停止执行

+ 22) SIGTTOU 

    > 类似于SIGTOUT, 但是在写终端时收到.

+ 23) SIGURG  

    > 有"紧急"数据或out-of-band数据到达socket时收到

+ 24) SIGXCPU 

    > 超过CPU时间资源显示,这个限制可以由 getrlimit/setrlimit来读取/改变.

+ 25) SIGXFSZ

    > 进程试图扩大文件以至于超过文件大小资源限制时发出

+ 26) SIGVTALRM   

    >　虚拟时钟信号，类似于　SIGALRM　但是计算的是该进程占用的CPU时间

+ 27) SIGPROF 

    > 类似于　SIGALRM /IGVTALRM, 但宝货该进程用的ＣＰＵ时间以及系统调用时间

+ 28) SIGWINCH    

    > 串口大小改变时发出

+ 29) SIGIO   
    
    > 文件描述符准备就绪，可以开始进行输入输出操作
    
+ 30) SIGPWR
    
    ＞　power failure

+ 31) SIGSYS 

    > 非法的系统调用


其中 SIGKILL 和 SIGSTOP 是不能被捕获的
SIGSTOP 和 SIGCONT 用来暂停和继续目标进程.
SIGABRT,SIGALRM,SIGFPE,SIGPIPE,SIGINT,SIGHUP,SIGILL,SIGQUIT,SIGSEGV,SIGTERM,SIGUSR1,SIGUSR2这12种信号，如果在进程中没有对其进行捕获处理的话，进程在收到它们时，会终止，当然还有不可捕获的SIGKILL。

## 信号的捕获与处理
在进程中需要等待某个信号时,可以用pause()函数,在pause调用前,一定要有对目标信号的捕获机制,这样在收到目标信号后,程序会继续运行,捕获信号最简单的是signal函数:

```c
 typedef void (*sighandler_t)(int);
 sighandler_t signal(int signum, sighandler_t handler);
 //第一个参数为目标信号, 第二个参数是处理函数,可以是自定义的函数,
 //也可以是SIG_IGN(忽略)或SIG_DFL(恢复默认)
```

```c
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

//处理函数
void handler()
{
    printf("capture a SIGALRM signal\n");
}

int main()
{   
    signal(SIGALRM,handler); //捕获SIGALRM信号
    /*struct sigaction act;

     act.sa_handler = handler;
     sigemptyset(&act.sa_mask);
     act.sa_flags = 0;

     sigaction(SIGALRM, &act, 0);*/

    pause();                //等待信号
    printf("end\n");        //继续执行
}
```

程序会在pause处阻塞, 在收到SIGALRM信号时,执行处理函数,并继续往下执行.

signal 是一个比较老的函数了,现在通常用 sigaction

```c
int sigaction(int signum, const struct sigaction *act,struct sigaction *oldact);
//第一个参数为目标信号，第二个参数为sigaction结构，内有处理机制，信号掩码，和标志。
```

具体测试代码,见以上被注释部分, 运行效果完全一样.


## 参考链接
1. [linux kill信号列表](http://www.2cto.com/os/201202/119425.html)
2. [linux 捕获kill命令的信号](http://blog.sina.com.cn/s/blog_72e502400100qlx9.html)

