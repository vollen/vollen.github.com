title: cocos2d_render
tags: [cocos2d, renderer]
---

从头梳理一下cocos2d渲染器相关的代码，并借此熟悉OopenGL相关内容。

# 类分析
+ RenderQueue   --渲染队列
+ CCRenderer    
+ RendererState     --渲染状态
+ RenderCommand     --渲染命令基类
    * TrianglesCommand			--渲染三角形
    * QuadCommand				--渲染四边形（相当于保存了两个三角形）
    * PrimitiveCommand			--图元
    * MeshCommand				--用于3d蒙皮渲染
    * GroupCommand				--组渲染（一系列渲染指令保存在一个新的渲染队列，单独渲染，可用于渲染到图片）
    * CustomCommand				--用户自定义操作		
    * BatchCommand				--批渲染
+ VertexAttribBinding
+ GLProgram       --封装的glProgram对象
+ GLProgramCache  --提供了一个静态对象，来管理可能用到的各种类型的glProgram，减少频繁创建和释放glProgram对象
+ GLProgramState  --GLProgram的代理器，由它负责与外部直接沟通
+ GLProgramStateCache   --类似GLProgramCache， 不过是管理GLProgramState
+ Texture2D

+ ccGLStateCache    定义命名空间GL，封装了一些OPENGL相关的全局函数， 用法：GL::XXX

# 功能宏
+ CHECK_GL_ERROR_DEBUG  --todo 看似一个调用GL函数之后，检查有效行的宏

# 结构体
+ ccTypes.h 中定义的结构体
    * Tex2F     包含UV信息的结构体
    * V3F_C4B_T2F  包含 vec3(float) 顶点坐标， c4b 颜色信息， Tex2F 纹理UV信息


# 参考资料
[cocosdx渲染流程](http://www.2cto.com/kf/201409/336234.html)

