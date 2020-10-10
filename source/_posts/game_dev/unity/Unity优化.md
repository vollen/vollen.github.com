[Unity性能优化大合集](https://blog.uwa4d.com/archives/allinone.html)
[Unity优化百科（UWA 博客目录）](https://blog.uwa4d.com/archives/Index.html)
[UWA问答精选 优化篇](https://blog.uwa4d.com/archives/TechSharing_uwa2019.html)


[z fighting](3D渲染中的Z-fighting现象)
[unity 中使用的遮挡剔除技术 Umbra](https://www.cnblogs.com/umbra/archive/2012/07/31/2617456.html)

## TBR
[后处理效率问题和Tile-Based GPU](https://zhuanlan.zhihu.com/p/135285010)
[IMR, TBR, TBDR 还有GPU架构方面的一些理解](https://zhuanlan.zhihu.com/p/259760974)
[移动设备GPU架构知识汇总](https://zhuanlan.zhihu.com/p/112120206)
[针对移动端TBDR架构GPU特性的渲染优化](https://gameinstitute.qq.com/community/detail/123220)

### 关键词
Early-Z, TBR(tiled based rendering), TBDR, HSR(hidden surface removal)
+ 切换framebuffer在tbdr的架构是性能瓶颈。
#### IMR
渲染过程中，GPU 直接与显存进行交互。当然
#### TBR
移动端的 GPU, 一般都没有单独的显存, 而是在主存中划分了一块独立的区域作为显存, 但是有一块很小的 `on-chip内存(on-clip memeory)`。
主存的访问速度相对较慢， 而 on-chip 内存则快很多。 所以如果渲染的时候直接与主存进行交互，带宽就成了最大的性能瓶颈, 也会引发严重的发热。
TBR 是把屏幕划分成多个 Tile, 每个 Tile 渲染的时候，把对应 Tile 的深度缓存和颜色缓存读取到 onchip 上，计算时读写都与 on-chip 交互，渲染完成之后，再写入主存。
这样就相当于只对主存进行了一次读取。 最频繁的交互操作如 frame shader, alpha blend, depth test 等都从 on-clip 读取， 从而大大提升了效率， 也减少了发热。
#### TBDR
在TBR的架构里，并不是来一个绘制就执行一个的，因为任何一个绘制都可能影响到到整个FrameBuffer，如果来一个画一个，那么GPU可能会在每一个绘制上都来回运输所有的Tile，这太慢了。
所以TBR一般的实现策略是对于Cpu过来的绘制，只对他们做顶点处理，也就是上图中的Geometry Processor部分，产生的结果（Frame Data）暂时写回到物理内存，等到非得刷新整个FrameBuffer的时候，比如说在代码里显示的执行GLFlush，GLFinish，Bind和Unbind FrameBuffer这类操作的时候，总之就是我告诉GPU现在我就需要用到FrameBuffer上数据的时候，GPU才知道拖不了了，就会将这批绘制做光栅化，做tile-based-rendering。
所以其实使用了 TBR 的架构都是 Defer Renderer。但为什么不叫 TBDR 呢。
因为 TBR 的引入主要是减少了 IMR 的带宽开销。但没有彻底解决 OverDraw。
只有 PowerVR 提出了 HSR 技术，才真正的从硬件层面解决了 overdraw 的问题。

#### TBR 与 TBDR
+ TBR：VS - Defer - RS - PS
+ TBDR：VS - Defer - RS - Defer - PS
第一个Defer大家都有，而且通过第一篇链接的文章我们可以明白，第一个Defer是Tile-Based渲染架构所必须的，没有这个Defer，Tile-Based优势就无从发挥。而第二个Defer则是Power VR的TBDR架构所特有。通过这第二个Defer，PowerVR的渲染架构真正最大程度上实现了“延后（Defer）PS的执行”，以避免执行不必要的PS计算与相关资源调用的带宽开销，以达到最少的性能消耗和最高的渲染效率。

#### Early-Z
传统管线的深度剔除发生在偏远着色器之后，但其实我们在顶点着色器之后，就已经知道了片元的深度值。 所以硬件在片元着色器之前, 光栅化之后加入了 Early-Z 阶段。
这样能让被其他片元遮挡的片元不用再执行片元着色器的计算， 从而提高了性能。
我们有两种方式来最大化的利用硬件的 Early-Z 优化。
1. 新增一个 pass 不写颜色缓冲， 只写入深度缓冲。对于 `延迟渲染管线` 来说，不需要这一步。
2. 不透明物体从前往后渲染。（unity引擎已经实现了）
需要注意的是，在片元着色器中 `使用discard`(如`alpha test`) 或者`修改片元的深度值`会使 Early-Z 失效。

#### HSR
当一个像素通过了EarlyZ准备执行PS进行绘制前，先不画，只记录标记这个像素归哪个图元来画。等到这个Tile上所有的图元都处理完了，最后再真正的开始绘制每个图元中被标记上能绘制的像素点。这样每个像素上实际只执行了最后通过EarlyZ的那个PS，而且由于TBR的机制，Tile块中所有图元的相关信息都在片上，可以极小代价去获得。最终零Overdraw，毫无浪费，起飞。
