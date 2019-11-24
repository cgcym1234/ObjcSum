//
//  MHStreamPlayer.m
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/6.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHStreamPlayer.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import "MHStreamHeader.h"


@interface MHStreamPlayer ()
{
    CAEAGLLayer * _mhEagLayer;
    // 上下文对象
    EAGLContext *_context;
    // 着色器
    GLuint _program;
    // buffer的引用
    GLuint _frameBuffer;
    GLuint _renderBuffer;
    
    CVOpenGLESTextureRef YTexture; //亮度文理
    CVOpenGLESTextureRef UVTexture;//色彩文理
    CVOpenGLESTextureCacheRef TextureCache;
    
    GLuint TextureRGBd;
    GLuint TextureRgb;
    GLuint TextureY;
    GLuint TextureU;
    GLuint TextureV;
    
    // layer的像素尺寸
    GLint _backingWidth;
    GLint _backingHeight;
    
    //渲染数据类型
    mhTextureFragMode modeType;
    
    //片段着色器属性
    GLuint shModeType;//模式类型
    //模式modeType = 1 (RGBA)
    GLint shColorRGB;//默认编号为0的纹理
    //模式modeType = 2 (Y-UV)
    GLuint shSamplerY;
    GLuint shSamplerUV;
    GLuint shMatrix;
    //模式modeType = 3 (Y-U-V)
    GLuint shSaY;
    GLuint shSaU;
    GLuint shSaV;
    //模式modeType = 4 (RGB)
    GLuint shRGBd;
    
    //顶点着色器属性
    GLuint shPosition;  //传给着色器 顶点
    GLuint shTextCoor;  //传给着色器 贴图
}
@property(nonatomic,assign)CGFloat frameWidth;//要渲染的数据宽度
@property(nonatomic,assign)CGFloat frameHeight;//要渲染的数据高度
@property(nonatomic,strong)CADisplayLink * updateLink;//刷新定时器
@property(nonatomic,assign)BOOL isUpdateTexture;//定时器判断 是否需要刷新数据
@end

@implementation MHStreamPlayer

+ (Class)layerClass {
    return [CAEAGLLayer class];
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        //初始化eagLayer
        [self setupEagLayer];
        //初始化context
        [self setupContext];
        //加载着色器
        [self loadShaders];
        [self setupFrame];
        //初始化buffer
        [self setupBuffer];
    }
    return self;
}
#pragma mark - 初始化eagLayer
-(void)setupEagLayer
{
    _mhEagLayer = (CAEAGLLayer*)self.layer;
    // 设置像素比例，也就是iOS的原图、@2x、@3x像素密度是按倍数渲染的
    _mhEagLayer.contentsScale = [[UIScreen mainScreen] scale];
    // 默认是透明的，透明的性能不好，设置为不透明
    _mhEagLayer.opaque = YES;
    // 设置描绘属性，设置不缓存渲染内容
    /*
     kEAGLDrawablePropertyRetainedBacking设置是否需要保留已经绘制到图层上面的内容，用NSNumber来包装，
     为FALSE，表示不想保持呈现的内容，因此在下一次呈现时，应用程序必须完全重绘一次。将该设置为 TRUE 对性能和资源影像较大，因此只有当renderbuffer需要保持其内容不变时，我们才设置 kEAGLDrawablePropertyRetainedBacking  为 TRUE。
     kEAGLDrawablePropertyColorFormat 设置绘制对象内部的颜色缓冲区的格式 32位的RGBA的形式
     包含的格式
     kEAGLColorFormatRGBA8; 32位RGBA的颜色 4x8=32
     kEAGLColorFormatRGB565; 16位的RGB的颜色
     kEAGLColorFormatSRGBA8 SRGB
     */
    _mhEagLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking :@(FALSE), kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8};
}
#pragma mark - 初始化context
-(void)setupContext
{
    // 根据API版本创建上下文
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context || ![EAGLContext setCurrentContext:_context]) {
        NSLog(@"----初始化context上下文失败----");
    }
    glEnable(GL_DEPTH_TEST);
}
- (void)setupFrame
{
    GLfloat lgScale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，
    GLfloat width  = self.frame.size.width * lgScale;
    GLfloat height = self.frame.size.height * lgScale;
    
    [EAGLContext setCurrentContext:_context];
    glViewport(0, 0, width, height);
}
#pragma mark - 初始化buffer
-(void)setupBuffer
{
    [EAGLContext setCurrentContext:_context];
    [self destoryBuffer];
    
    //申请一个缓冲区
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    //渲染缓存绑定到渲染图层
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_mhEagLayer];
    //获取渲染缓存对象的宽高属性，获取到的实际上就是当前layer尺寸 * 像素倍数 （@2x @3x）
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    //申请一个缓存区句柄
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    //将 renderbuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    GLenum bufferStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (bufferStatus != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", bufferStatus);
    }
    
    glGenTextures(1,&TextureRGBd);
    glGenTextures(1,&TextureRgb);
    glGenTextures(1,&TextureY);
    glGenTextures(1,&TextureU);
    glGenTextures(1,&TextureV);
}

-(BOOL)compileShader:(GLuint *)shader type:(GLenum)type filePath:(NSString *)filePath
{
    GLchar* source = NULL;
    NSString* content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    source = (GLchar *)[content UTF8String];
    if(source == NULL){
        return NO;
    }
    const GLchar* Str = source;
    //创建着色器
    *shader = glCreateShader(type);
    //加载着色器源码
    glShaderSource(*shader, 1, &Str, NULL);
    //编译着色器
    glCompileShader(*shader);
    // 获取结果，没获取到就释放内存
    GLint status = 0;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}
#pragma mark - 加载着色器
-(BOOL)loadShaders
{
    
    //读取文件路径
    NSString* vertFile = [[NSBundle mainBundle] pathForResource:@"MHShaderV" ofType:@"vsh"];
    NSString* fragFile = [[NSBundle mainBundle] pathForResource:@"MHShaderF" ofType:@"fsh"];
    
    GLuint verShader, fragShader;
    GLint program = glCreateProgram();
    //编译
    BOOL comV = [self compileShader:&verShader  type:GL_VERTEX_SHADER   filePath:vertFile];
    if (!comV) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    BOOL comF = [self compileShader:&fragShader type:GL_FRAGMENT_SHADER filePath:fragFile];
    if (!comF) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    glAttachShader(program, verShader);
    glAttachShader(program, fragShader);
    
    //释放不需要的shader
    glDeleteShader(verShader);
    glDeleteShader(fragShader);
    
    _program = program;
    //链接着色器程序
    glLinkProgram(_program);
    
    //获取链接结果，失败则释放内存
    GLint status;
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"Shader Program Error:%@", messageString);
        return NO;
    }
    
    //启动着色器程序
    glUseProgram(_program);
    
    //获取全局属性，一定要在链接完成后才行，否则拿不到
    //片段着色器属性
    shModeType = glGetUniformLocation(_program, "FragMode");
    shColorRGB  = glGetUniformLocation(_program, "ColorRGB");
    shSamplerY = glGetUniformLocation(_program, "SamplerY");
    shSamplerUV = glGetUniformLocation(_program, "SamplerUV");
    shMatrix = glGetUniformLocation(_program, "Matrix");
    shSaY = glGetUniformLocation(_program, "SaY");
    shSaU = glGetUniformLocation(_program, "SaU");
    shSaV = glGetUniformLocation(_program, "SaV");
    shRGBd = glGetUniformLocation(_program, "RGBd");
    
    shPosition = glGetAttribLocation(_program, "position");
    shTextCoor = glGetAttribLocation(_program, "textCoordinate");
    
    return YES;
}
#pragma mark - 输入CVPixelBufferRef数据进行播放
-(void)inputPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        return;//后台不贴图
    }
    if (!_context || ![EAGLContext setCurrentContext:_context]) {
        return;
    }
    if (pixelBuffer == NULL) {
        NSLog(@"Pixel buffer is null");
        return;
    }
    modeType = mhTextureFragModePixelBuf;
    
    //清空纹理
    [self cleanUpTextures];
    // 创建纹理对象
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &TextureCache);
    if(err != noErr){
        NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
        return;
    }
    
    //获取视频数据中的宽高
    CGFloat frameWidth = CVPixelBufferGetWidth(pixelBuffer);
    CGFloat frameHeight = CVPixelBufferGetHeight(pixelBuffer);
    
    //启用纹理缓冲区0
    glActiveTexture(GL_TEXTURE0);
    // 创建亮度纹理，也就是YUV数据的Y分量
    //err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, TextureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RED_EXT, frameWidth, frameHeight, GL_RED_EXT, GL_UNSIGNED_BYTE, 0, &YTexture);
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, TextureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_LUMINANCE, frameWidth, frameHeight, GL_LUMINANCE, GL_UNSIGNED_BYTE, 0, &YTexture );
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
        return;
    }
    
    glBindTexture(CVOpenGLESTextureGetTarget(YTexture), CVOpenGLESTextureGetName(YTexture));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    /// 激活纹理缓冲区1
    glActiveTexture(GL_TEXTURE1);
    // UV分量数据
    //err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, TextureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RG_EXT, frameWidth / 2, frameHeight / 2, GL_RG_EXT, GL_UNSIGNED_BYTE, 1, &UVTexture);
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, TextureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_LUMINANCE_ALPHA, frameWidth/2, frameHeight/2, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 1, &UVTexture);
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
        return;
    }
    
    glBindTexture(CVOpenGLESTextureGetTarget(UVTexture), CVOpenGLESTextureGetName(UVTexture));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    //获取视频数据格式
    CFTypeRef colorAttachments = CVBufferGetAttachment(pixelBuffer, kCVImageBufferYCbCrMatrixKey, NULL);
    //判断视频格式
    const GLfloat * preferredConversion;
    if (CFStringCompare(colorAttachments, kCVImageBufferYCbCrMatrix_ITU_R_601_4, 0) == kCFCompareEqualTo) {
        preferredConversion = kColorConversion601FullRange;
    }else {
        preferredConversion = kColorConversion709;
    }
    
    //在创建纹理之前，有激活过纹理单元，就是那个数字.GL_TEXTURE0,GL_TEXTURE1
    //指定着色器中亮度纹理对应哪一层纹理单元，这样就会把亮度纹理往着色器上贴
    glUniform1i(shSamplerY, 0);
    glUniform1i(shSamplerUV, 1);
    glUniform1i(shModeType , modeType);
    glUniformMatrix3fv(shMatrix, 1, GL_FALSE, preferredConversion);

    
    self.frameWidth = frameWidth;
    self.frameHeight = frameHeight;
    self.isUpdateTexture = YES;
    //开启定时器
    [self startUpdateLink];
}
#pragma mark - 设置顶点着色器顶点/纹理坐标+绘制/渲染
-(void)updatePositionTextCoor_FrameWidth:(CGFloat)frameWidth height:(CGFloat)frameHeight
{
    // 固定宽高比缩放到当前layer的尺寸
    CGRect viewBounds = self.bounds;
    CGSize contentSize = CGSizeMake(frameWidth, frameHeight);
    // 把图像画面的尺寸等比例缩放到当前视图的尺寸
    CGRect vertexSamplingRect = AVMakeRectWithAspectRatioInsideRect(contentSize, viewBounds);
    // 计算一下图像画面缩放后哪个边没填充满。例如画面尺寸是(180,320)，layer的尺寸是(200,320)，那么下面计算出来应该是(0.9,1)
    CGSize normalizedSamplingSize = CGSizeMake(0.0, 0.0);
    CGSize cropScaleAmount = CGSizeMake(vertexSamplingRect.size.width / viewBounds.size.width,
                                        vertexSamplingRect.size.height / viewBounds.size.height);
    // 哪个边大就哪个边填充整个layer
    if (cropScaleAmount.width > cropScaleAmount.height) {
        normalizedSamplingSize.width = 1.0;
        normalizedSamplingSize.height = cropScaleAmount.height/cropScaleAmount.width;
    } else {
        normalizedSamplingSize.width = cropScaleAmount.width/cropScaleAmount.height;
        normalizedSamplingSize.height = 1.0;;
    }
    // 确定顶点数据结构
    GLfloat quadVertexData [] = {
        -1 * normalizedSamplingSize.width, -1 * normalizedSamplingSize.height,
        normalizedSamplingSize.width, -1 * normalizedSamplingSize.height,
        -1 * normalizedSamplingSize.width, normalizedSamplingSize.height,
        normalizedSamplingSize.width, normalizedSamplingSize.height,
    };
    /** 设置顶点着色器属性
     参数indx：属性ID，给哪个属性描述信息
     参数size：顶点属性由几个值组成，这个值必须位1，2，3或4；
     参数type：表示属性的数据类型
     参数normalized:GL_FALSE表示不要将数据类型标准化
     参数stride 表示数组中每个元素的长度；
     参数ptr 表示数组的首地址
     */
    glVertexAttribPointer(shPosition, 2, GL_FLOAT, 0, 0, quadVertexData);
    // 激活顶点数组
    glEnableVertexAttribArray(shPosition);
    
    // 确定纹理数据结构
    CGRect textureSamplingRect = CGRectMake(0, 0, 1, 1);
    GLfloat quadTextureData[] =  {
        CGRectGetMinX(textureSamplingRect), CGRectGetMaxY(textureSamplingRect),
        CGRectGetMaxX(textureSamplingRect), CGRectGetMaxY(textureSamplingRect),
        CGRectGetMinX(textureSamplingRect), CGRectGetMinY(textureSamplingRect),
        CGRectGetMaxX(textureSamplingRect), CGRectGetMinY(textureSamplingRect)
    };
    // 设置顶点着色器纹理坐标
    glVertexAttribPointer(shTextCoor, 2, GL_FLOAT, 0, 0, quadTextureData);
    // 激活顶点纹理数组
    glEnableVertexAttribArray(shTextCoor);
    
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // 设置绘制窗口
    glViewport(0, 0, _backingWidth, _backingHeight);
    // 把上下文的东西渲染到屏幕上
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}
#pragma mark - 输入YUV数据进行播放
-(void)inputYuvDataTexture:(char *)yuv width:(int)width height:(int)height
{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        return;//后台不贴图
    }
    if(!_context || yuv == NULL || width <= 0 || height <= 0){
        return;
    }
    modeType = mhTextureFragModeYuv;
    
    [self displayYUVData:yuv width:width height:height];
    
    self.isUpdateTexture = YES;
    //开启定时器
    [self startUpdateLink];
}
-(void)displayYUVData:(char *)yuv width:(int)width height:(int)height
{
    [EAGLContext setCurrentContext:_context];
    self.frameWidth = width;
    self.frameHeight = height;
    
    [self textureYUV:yuv glt:GL_TEXTURE0 texture:TextureY width:width height:height];
    [self textureYUV:yuv+width*height glt:GL_TEXTURE1 texture:TextureU width:width/2 height:height/2];
    [self textureYUV:yuv+width*height*5/4 glt:GL_TEXTURE2 texture:TextureV width:width/2 height:height/2];

    glUniform1i(shSaY, 0);
    glUniform1i(shSaU, 1);
    glUniform1i(shSaV, 2);
    glUniform1i(shModeType , modeType);
}
-(void)textureYUV:(const char *)buffer glt:(GLenum)glt texture:(GLuint)texture width:(GLuint)width height:(GLuint)height
{
    //激活GL_TEXTURE0 1 2 这个纹理单元，用于之后的纹理采样
    glActiveTexture(glt);
    //绑定纹理对象texture到纹理目标GL_TEXTURE_2D，接下来对纹理目标的操作都发生在此对象上
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, width, height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, buffer);
}
#pragma mark - 输入CGImageRef数据渲染播放
- (void)inputCgImageTexture:(CGImageRef)spriteImage
{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        return;//后台不贴图
    }
    if(!_context || spriteImage == NULL){
        return;
    }
    modeType = mhTextureFragModeCgImage;
    
    [EAGLContext setCurrentContext:_context];
    //2.读取图片的大小
    CGFloat width = CGImageGetWidth(spriteImage);
    CGFloat height = CGImageGetHeight(spriteImage);
    self.frameWidth = width;
    self.frameHeight = height;
    //RGBA共4个byte
    GLubyte * spriteData = (GLubyte *)calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    //3.在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    //unsigned char *Pt = CGBitmapContextGetData(spriteContext);
    //4.绑定纹理到默认的纹理ID（这里只有一张图片，故而相当于默认于片元着色器里面的colorMap，如果有多张图不可以这么做）
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, TextureRgb);//绑定到0号纹理
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glUniform1i(shColorRGB, 0);
    
    CGContextRelease(spriteContext);
    free(spriteData);
    
    self.isUpdateTexture = YES;
    //开启定时器
    [self startUpdateLink];
}
#pragma mark - 输入Rgb数据渲染播放
- (void)inputRgbDataTexture:(const char *)rgb width:(int)width height:(int)height
{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        return;//后台不贴图
    }
    if(!_context || rgb == NULL || width <= 0 || height <= 0){
        return;
    }
    modeType = mhTextureFragModeRgb;
    
    [self displayRgbBuffer:rgb width:width height:height];
    
    self.isUpdateTexture = YES;
    //开启定时器
    [self startUpdateLink];
}
-(void)displayRgbBuffer:(const char *)rgb width:(int)width height:(int)height
{
    self.frameWidth  = width;
    self.frameHeight = height;
    
    [EAGLContext setCurrentContext:_context];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, TextureRGBd);//绑定到0号纹理
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, self.frameWidth, self.frameHeight, 0, GL_RGB, GL_UNSIGNED_BYTE, rgb);
    
    glUniform1i(shRGBd, 0);
}
#pragma mark - 输入Rgba数据渲染播放
- (void)inputRgbaDataTexture:(const char *)rgba width:(int)width height:(int)height
{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        return;//后台不贴图
    }
    if(!_context || rgba == NULL || width <= 0 || height <= 0){
        return;
    }
    modeType = mhTextureFragModeRgba;
    
    [self displayRgbaBuffer:rgba width:width height:height];
    
    self.isUpdateTexture = YES;
    //开启定时器
    [self startUpdateLink];
}
-(void)displayRgbaBuffer:(const char *)rgba width:(int)width height:(int)height
{
    self.frameWidth  = width;
    self.frameHeight = height;
    
    [EAGLContext setCurrentContext:_context];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, TextureRGBd);//绑定到0号纹理
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, self.frameWidth, self.frameHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, rgba);
    
    glUniform1i(shRGBd, 0);
}
#pragma mark - 定时器响应方法
-(void)onUpdateLink
{
    if(self.isUpdateTexture){
        self.isUpdateTexture = NO;
        [self updatePositionTextCoor_FrameWidth:self.frameWidth height:self.frameHeight];
    }
}
#pragma mark - 开启定时器
-(void)startUpdateLink
{
    if (!self.updateLink) {
        self.updateLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onUpdateLink)];
        self.updateLink.frameInterval = 1;//每秒60桢
        [self.updateLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
#pragma mark - 关闭定时器
- (void)stopUpdateLink
{
    if(self.updateLink){
        [self.updateLink invalidate];
        self.updateLink = nil;
    }
}
#pragma mark - 清空纹理
-(void)cleanUpTextures
{
    //清空亮度引用
    if (YTexture) {
        CFRelease(YTexture);
        YTexture = NULL;
    }
    //清空色度引用
    if (UVTexture) {
        CFRelease(UVTexture);
        UVTexture = NULL;
    }
    //清空纹理缓存
    if (TextureCache) {
        CVOpenGLESTextureCacheFlush(TextureCache, 0);
        CFRelease(TextureCache);
        TextureCache = NULL;
    }
}
#pragma mark - 清空buffer引用
- (void)destoryBuffer
{
    if(_frameBuffer){
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    if(_renderBuffer){
        glDeleteRenderbuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
}
#pragma mark - 清除播放器内容
-(void)cleanPlayer
{
    [self stopUpdateLink];
    //清空引用
    [self destoryBuffer];
    //释放着色器
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
    glDeleteTextures(1,&TextureRGBd);
    glDeleteTextures(1,&TextureRgb);
    glDeleteTextures(1,&TextureY);
    glDeleteTextures(1,&TextureU);
    glDeleteTextures(1,&TextureV);
    //清空纹理
    [self cleanUpTextures];
    if (_context) {
        _context = nil;
    }
}
#pragma mark - dealloc释放
-(void)dealloc
{
    [self cleanPlayer];
}
@end
