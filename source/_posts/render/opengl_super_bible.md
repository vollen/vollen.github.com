

glu
glut/freeglut
glew
glTools

GLenum glGetError(void);

void glHint(GLenum target, GLenum mod);

--状态机
void glEnable(GLenum capacity);
void glDisable(GLenum capacity);
Glboolean glIsEnabled(GLenum capacity);

void glGetBooleanv(GLenum pname, GLboolean *params);
void glGetDoublev(GLenum pname, GLdouble *params);
void glGetIntv(GLenum pname, GLint *params);
void glGetFloatv(GLenum pname, GLfloat *params);


void glUniform*(...)

void glViewPort(GLint x, GLint y, GLint width, GLint height);
void glClearColor(GLclampf r, GLclampf g, GLclampf b, GLclampf a);
void glClear(GLenum types);


渲染管线
    顶点着色器 --> 几何着色器 --> 图元装配 --> 光栅化 --> 片元着色器
客户端/服务端架构
    客户端运行在CPU上， 通过API提交操作及数据。
    服务端运行在GPU上， 获取客户端提供的数据， 执行渲染。超高的并发。
    客户端 与 服务端 是 独立分开运行的。

向着色器传递的三种方法
    Attribute, Uniform 值, Texture,
着色器之间的数据传递
    上一个着色器的输出会作为下一个着色器的输入

正投影/透视投影

7种基本图元
GL_POINTS 独立的顶点
    void glPointSize(GLfloat size);
    void glGetFloatv(GL_POINT_SIZE_RANGE, sizes);
    void glGetFloatv(GL_POINT_SIZE_GRANULARITY, &step);
    glEnable(GL_PROGRAM_POINT_SIZE);
    gl_PointSize 在着色器中控制点的大小。
GL_LINES  每一对定点定义了一条线段
    void glLineWidth(GLfloat width); 调整线宽
GL_LINE_STRIP 条带
GL_LINE_LOOP  调环
GL_TRIANGLES 
    三角形， OpenGl中的最基本图元。
    环绕方向由顶点传入方向决定， 绘制顺序总是： vo->v1->v2->v0. 环绕方向为逆时针方向的被看做是正面, 顺时针方向的被看做反面。
    glFrontFace(GL_CW) 函数可以设置哪个方向的环绕是正面， GL_CCW 为逆时针方向, GL_CW 为顺时针方向.
GL_TRIANGLE_STRIP
GL_TRIANGLE_FAN

背面剔除
glEnable(GL_CULL_FACE)
void glCullFace(GLenum face); // face : GL_FRONT, GL_BACK, GL_FRONT_AND_BACK

深度测试
glEnable(GL_DEPTH_TEST)

多边形填充规则
glPolygonMode(GLenum face, GLenum mode); // mod : GL_FILL, GL_LINE, GL_POINT
