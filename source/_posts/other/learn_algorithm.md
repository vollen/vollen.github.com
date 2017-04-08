


学习小象学院算法课程笔记

# 字符串
## 循环左移
将一个字符串循环左移, 要求时间复杂度为O(N), 空间复杂度为O(1).
理论： (A'B')' = (BA)'
实现：
```cpp
    void reverse(char * str, int from, int to){
        while (from < to){
            char t = str[from];
            str[from ++] = str[to];
            str[to --] = t; 
        }
    }

    void leftRotate(char * str, int n, int k){
        reverse(str, 0, k - 1);
        reverse(str, k, n - 1);
        reverse(str, 0, n - 1);
    }
```

## LCS 
最长公共子序列
