
## abi 
Application binary interface
常用的有：
    armeabi
    armeabi­v7a
    arm64­v8a
    x86
    x86_64
    mips
    mips64

```groovy
    defaultConfig {    
        ...
        ndk {
            // 设置支持的 SO 库构架，注意这里要根据你的实际情况来设置
            abiFilters 'armeabi'// 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64', 'mips', 'mips64'
        }
    }
```