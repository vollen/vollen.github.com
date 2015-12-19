title: cocos2d_render
tags: [cocos2d, renderer]
---

从头梳理一下cocos2d渲染器相关的代码，并借此熟悉OopenGL相关内容。

# 类分析
+ RenderQueue   --渲染队列
+ CCRenderer    
+ GLProgramState
+ RendererState     --渲染状态
+ RenderCommand     --渲染命令基类
    * TrianglesCommand
    * QuadCommand
    * PrimitiveCommand
    * MeshCommand
    * GroupCommand
    * CustomCommand
    * BatchCommand

+ ccGLStateCache    定义命名空间GL，封装了一些OPENGL相关的全局函数， 用法：GL::XXX

# 功能宏
+ CHECK_GL_ERROR_DEBUG  --todo 看似一个调用GL函数之后，检查有效行的宏

# 结构体
+ ccTypes.h 中定义的结构体
    * Tex2F     包含UV信息的结构体
    * V3F_C4B_T2F  包含 vec3(float) 顶点坐标， c4b 颜色信息， Tex2F 纹理UV信息


# 参考资料
[cocosdx渲染流程](http://www.2cto.com/kf/201409/336234.html)

