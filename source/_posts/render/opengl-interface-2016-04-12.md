title: opengl_interface
tags:
  - opengl
date: 2016-04-12 15:00:11
---


# VAO
* void glGenVertexArrays(GLsizei n, Gluint * arrays)
    - 创建n个VAO对象，并将索引存储在arrays中
* void glBindVertexArray(GLuint array​)
    - 绑定VAO
* void glEnableVertexAttribArray(GLuint index​)

* void glDisableVertexAttribArray(GLuint index​)
    - 启用或禁用指定VAO
* void glDeleteVertexArrays(GLsizei n, const GLuint * arrays)
    - 根据 arrays 数组中的索引， 删除n个VAO
* void glVertexAttribPointer(GLuint index​, GLint size​, GLenum type​, GLboolean normalized​, GLsizei stride​, const GLvoid * pointer​)
<!--more-->
    - 

# VBO
* void glGenBuffers(GLsizei n, GLuint * buffers)
    - 创建 n 个VBO, 并将索引存储在buffers 中

* void glBindBuffer(GLenum target, GLuint buffer)
    - 绑定buffer到[target](#ENUM_BUFFER_TARGET)的缓存， 同一种类型的缓存只能指向一个buffer

* void glBufferData(GLenum target, GLsizeiptr size, const GLvoid * data, GLenum usage)
    - 为绑定到[target](#ENUM_BUFFER_TARGET)的缓存分配size大小的空间， 如果data不为NULL, 则会被拷贝至目标缓存，用法被限定为[usage](#ENUM_BUFFER_USAGE)

* void glBufferSubData(GLenum target, GLintptr offset, GLsizeptr size, const GLvoid * data)
    - 以data为数据源， 缓存对象 + offset 为目标地址， 拷贝size大小的数据 

* void * glMapBuffer(GLenum target, GLenum access)
    - 将当前绑定到[target](#ENUM_BUFFER_TARGET)的VBO的地址，使用这个地址可以直接操作缓冲区。 [access](#ENUM_ACCESS)该指针指向数据的访问策略

* GLboolean glUnmapBuffer(GLenum target)
    - 解除[target](#ENUM_BUFFER_TARGET)

* void glDeleteBuffers(GLsizei n, const GLuint * buffers)
    - 根据 buffers数组中的索引，删除n个VBO

* 深度测试
    void glDepthFunc(GLenum func)
    - 指定深度测试时使用的函数类型， func必须是[深度测试函数](#ENUM_DEPTH_TEST_FUNC)中的一个。

[Shader and Program编程基本概念](http://blog.csdn.net/myarrow/article/details/7737313)
# SHADER
* GLuint glCreateShader()

* void glShaderSource(GLuint prog, GLsizei size, const GLchar** source, const Glint * length)

* void glCompileShader(GLuint shader)

* void glGetShaderiv(GLuint shader, GLenum pname, GLint * params)
    - 获取指定shader的[pname](ENUM_SHADER_PARAM)属性
* void glGetShaderSource(GLuint shader, GLsizei bufSize, GLsizei* length, GLchar* source)
    - 将shader的源码写入source， bufSize 为缓冲区长度，length为返回的代码长度

# PROGRAM
* GLuint glCreateProgram()

* void glAttachShader(GLuint prog, GLuint shader)

* void glLinkProgram(GLuint prog)

* void glUseProgran(GLuint prog)

* void glGetProgramiv(GLuint prog, GLenum panme, GLint* params)

* void glGetActiveAttrib(GLuint program​, GLuint index​, GLsizei bufSize​, GLsizei *length​, GLint *size​, GLenum *type​, GLchar *name​)

* void glGetActiveUniform(GLuint program​, GLuint index​, GLsizei bufSize​, GLsizei *length​, GLint *size​, GLenum *type​, GLchar *name​)

* void glGetProgramInfoLog(GLuint program​, GLsizei maxLength​, GLsizei *length​, GLchar *infoLog​)

*  GLuint glGetUniformLocation(GLuint prog, const GLchar* name)

* void glUniform{1234}{fdi ui}(GLint location, TYPE value)
  void glUniform{1234}{fdi ui}v(GLint location, GLsizei count, const TYPE* values)
  void glUniformMatrix{234}{fd}v(GLint location, GLsizei count, GLboolean transpose, const GLfloat* values)
        --对角矩阵
  void glUniformMatrix{2x3,2x4,3x2,3x4,4x2,4x3}{fd}v(GLint location, GLsizei count, GLboolean transpose, const GLfloat* values)
        -- 设置与locate索引位置对应的uniform变量的值,其中向量形式的函数会载入count个数据的集合
        --transpose 为GL_TRUE, 已行主序读入，为GL_FALSE则以列主序读入。

# 变量储存限定符
* attribute     --顶点着色器中声明的变量, 可使用函数glAttrib*来操作
    + void glBindAttribLocation(GLuint prog, GLuint index, const Glchar* name)
        * 将prog程序中的name变量关联到index上
    + void glGetAttribLocation(GLuint prog, const GLchar* name)

* uniform       --由应用程序指定，所有着色器共享但无法更改的变量，可使用glUniform*操作

* varying       --顶点着色器声明赋值，片元着色器使用的变量

# [TEXTURE](https://www.opengl.org/wiki/Texture)
[OpenGL学习笔记（一） 纹理基础知识](http://blog.csdn.net/lixiang996/article/details/6859575)
* void glActiveTexture(GLenum texture​)

* void glBindTexture(GLenum target​, GLuint texture​)

* void glDeleteTextures(GLsizei n​, const GLuint * textures​)

* void glPixelStore*(GLenum pname, type, param)

* void glTexParameter*(GLenum target​, GLenum pname​, Type param​)

* void glCompressedTexImage2D(GLenum target​, GLint level​, GLenum internalformat​, GLsizei width​, GLsizei height​, GLint border​, GLsizei imageSize​, const GLvoid * data​)

* void glTexSubImage2D(GLenum target​, GLint level​, GLint xoffset​, GLint yoffset​, GLsizei width​, GLsizei height​, GLenum format​, GLenum type​, const GLvoid * data​)

* void glGenerateMipmap(GLenum target​)





# DRAW
* void glDrawElements(GLenum mode, GLsizei count, GLenum type, const GLvoid * indices) 
    - 使用 GL_ELEMENT_ARRAY_BUFFER中起始偏移为indeices的count个顶点索引来绘制[mode](#ENUM_PRIMITIVE)图元
* void glDrawArrays(GLenum mode​, GLint first​, GLsizei count​);

# STATE
* void glGetXXX(GLenum pname, type)
    - 返回pname属性的当前设置
* void glEnable(GLenum cap​)

* void glDisable(GLenum cap​)
    - 启用/停用 cap指定状态
* void glBlendFunc(GLenum sfactor, GLenum dfactor)
* void glBlendFunci(GlUint buf, GLenum sfactor, GLenum dfactor)
    - 设置[指定缓存]颜色混合逻辑
*  void glBlendFuncSeparate(GLenum srcRGB​, GLenum dstRGB​, GLenum srcAlpha​, GLenum dstAlpha​)

* void glBlendFuncSeparatei(GLuint buf​, GLenum srcRGB​, GLenum dstRGB​, GLenum srcAlpha​, GLenum dstAlpha​)
    - 逐分量设置[指定缓存]颜色混合逻辑
*  void glBlendEquation(GLenum mode​)      --todo 不甚了解，大概是设置混合方程？


# <span id="ENUM">枚举</span>
+ <span id="ENUM_DEPTH_TEST_FUNC">深度测试函数</span>
    + GL_NEVER      **所有**都**不**通过
    + GL_LESS       当输入深度**小于**缓冲深度时通过
    + GL_EQUAL      当输入深度**等于**缓冲深度时通过
    + GL_LEQUAL     **小于等于时***通过
    + GL_GREATER    **大于时** 通过
    + GL_NOTEQUAL   **不等于**时通过
    + GL_GEQUAL     **大于或等于**时通过    
    + GL_ALWAYS     **无条件**通过

+ <span id="ENUM_BUFFER_TARGET">缓冲区类型</span>

+ <span id="ENUM_BUFFER_USAGE">缓冲区使用限定</span>

+ <span id="ENUM_ACCESS">访问策略</span>
    * GL_READ_ONLY      只能从该地址读取数据
    * GL_WRITE_ONLY     只能向该地址写入数据
    * GL_READ_WRITE     既可以从地址读数据，也可以向地址写数据

+ <span id="ENUM_PRIMITIVE">[图元类型](https://www.opengl.org/wiki/Primitive)</span> 
    * GL_POINTS                 点(直接使用顶点数据)
    * GL_LINES                  线(每两个连续的点绘制成一条线段[01],[23])
    * GL_LINE_STRIP             条带线(相邻的两个顶点绘制成一条线段[01],[12])
    * GL_LINE_LOOP              循环线(与条带线类似，而且末点与首点相连成线)
    * GL_TRIANGLES              三角形(每三个连续顶点组成一个三角形[012],[345])
    * GL_TRIANGLE_STRIP         三角形条带(相邻的三个顶点组成一个三角形[012][123])
    * GL_TRIANGLE_FAN           扇形带(从第二个点起每两个连续的顶点与第一个顶点组成三角形[012][034][056])
    * GL_PATCHES                批量渲染(每一组顶点一起渲染， 可通过 glPatchParameteri​ 来设置)
[邻接图元](http://blog.csdn.net/pizi0475/article/details/7932900)
邻接图元与以上基本图元不同的是，这些图元会附带邻接数据，邻接数据只会在几何着色器中被处理，如果没有几何着色器，则邻接数据会被直接抛弃。
    * GL_LINES_ADJACENCY        包含4个顶点，第23个顶点构成线段，1,4为邻接信息
    * GL_LINE_STRIP_ADJACENCY   相邻的四个顶点([0123][1234]为一个GL_LINES_ADJACENCY
    * GL_TRIANGLES_ADJACENCY    包含6个顶点， 第1,3,5个顶点构成三角形，第2,4,6个保存邻接信息
    * GL_TRIANGLE_STRIP_ADJACENCY 需要配合图例解释，详见以上链接

+ <span id="ENUM_SHADER_PARAM">Shader属性</span>
    * GL_SHADER_TYPE            shader类型
    * GL_DELETE_STATUS          shader是否待删除
    * GL_COMPILE_STATUS         shader编译状态，返回GL_TRUE表示编译成功
    * GL_INFO_LOG_LENGTH        shader LOG信息长度
    * GL_SHADER_SOURCE_LENGTH   shader源码长度

# 参考资料
1.[官方文档](www.opengl.org/wiki/GLAPI)

