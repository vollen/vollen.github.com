[官网](https://algs4.cs.princeton.edu/home/)

# 排序

排序成本模型：在研究排序算法时， 我们需要计算比较和交换的数量，对于不交换的算法， 我们会计算访问数组的次数。

N = 问题规模
## 选择排序
找到数组中最小的元素， 然后将它交换到最前方，然后依次找到第i小的，并交换到i - 1位。
选择排序的总消耗次数约为: (N * (N - 1)) / 2 次比较 和 N - 1 次交换.
选择排序的消耗 与 输入数据的原始顺序无关。
交换次数是最少的， 因为它每次交换都代表着一个数字被正确的排序。