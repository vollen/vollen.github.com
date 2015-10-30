

# 动作分析
## 简单动作
* slideV
* jump
* climb
* jumpV

## 复杂动作
+ [jump + jump] 二段跳
+ [jumpV + jumpV] 二段跳
+ [jump + climb] 跳到梯子上 爬
+ [climb + jumpV] 爬 + 跳
+ [slideV + -slideV] 左走 再右走 

# 路径生成
+ 无法到达
    - 距离过远 dx > [xmax]
    - 过高 且无梯子 dy > [dmax]
    - 在下方，但中间有障碍 

+ slideV 
    - 相连
    - 在下方，且距离小于 [dis], 中间无障碍
    - 

# 寻路

# 执行


