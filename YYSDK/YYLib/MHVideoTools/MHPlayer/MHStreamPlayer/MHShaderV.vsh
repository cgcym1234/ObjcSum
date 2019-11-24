//顶点着色器

attribute vec4 position;
attribute vec2 textCoordinate;

varying highp vec2 varyTextCoord;//传递给fragm shader的纹理坐标，会自动插值
void main()
{
   mat4 rotationMatrix = mat4(cos(0.0), -sin(0.0), 0.0, 0.0,
                               sin(0.0),  cos(0.0), 0.0, 0.0,
                               0.0,                        0.0, 1.0, 0.0,
                               0.0,                        0.0, 0.0, 1.0);
    gl_Position = position * rotationMatrix;
    varyTextCoord = textCoordinate;
}
