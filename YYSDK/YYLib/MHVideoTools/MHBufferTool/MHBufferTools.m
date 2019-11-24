//
//  MHBufferTools.m
//  MHVideoTool
//
//  Created by mahao on 2019/5/22.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHBufferTools.h"

#define clamp(a) (a>255?255:(a<0?0:a))

@implementation MHBufferTools

+(NSData *)charToData:(char *)ar
{
    NSData *data = [NSData dataWithBytes:ar length:strlen(ar)];
    return data;
}
+(char *)dataToChar:(NSData *)data
{
    char * a= (char *)[data bytes];
    return a;
}
#pragma mark - 将420YpCbCr8BiPlanar(y_uv)格式的视频buffer转换为y_uv格式NSData
+(MHVideoData)convertVideoBufferToY_UVData:(CVPixelBufferRef)videoBuffer
{
    MHVideoData videoData = {nil,0,0};
    OSType pixelFormatType = CVPixelBufferGetPixelFormatType(videoBuffer);
    
    if (pixelFormatType == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange || pixelFormatType == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        // 获取yuv数据
        //表示开始操作数据
        CVPixelBufferLockBaseAddress(videoBuffer, 0);
                
        //图像宽度（像素）
        size_t pixelWidth = CVPixelBufferGetWidth(videoBuffer);
        //图像高度（像素）
        size_t pixelHeight = CVPixelBufferGetHeight(videoBuffer);
        //yuv中的y所占字节数
        size_t y_size = pixelWidth * pixelHeight;
        //yuv中的u和v分别所占的字节数
        size_t uv_size = y_size / 4;
        
        uint8_t *yuv_frame = malloc(uv_size * 2 + y_size);
        
        //获取CVImageBufferRef中的y数据
        uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(videoBuffer, 0);
        memcpy(yuv_frame, y_frame, y_size);
        
        //获取CMVImageBufferRef中的uv数据
        uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(videoBuffer, 1);
        memcpy(yuv_frame + y_size, uv_frame, uv_size * 2);
        
        CVPixelBufferUnlockBaseAddress(videoBuffer, 0);
        
        NSData *nv12Data = [NSData dataWithBytesNoCopy:yuv_frame length:y_size + uv_size * 2];
        
        videoData.videoData = nv12Data;
        videoData.width = (int)pixelWidth;
        videoData.height = (int)pixelHeight;
    }else {
        NSLog(@"buffer转换失败，只支持420YpCbCr8BiPlanar格式视频帧");
    }
    return videoData;
}

#pragma mark - 将32BGRA格式视频buffer转为y_uv格式NSData
+(MHVideoData)convertBGRABufferToY_UVData:(CVPixelBufferRef)videoBuffer
{
    MHVideoData videoData = {nil,0,0};
    OSType pixelFormatType = CVPixelBufferGetPixelFormatType(videoBuffer);
    if (pixelFormatType == kCVPixelFormatType_32BGRA) {
        int width = (int)CVPixelBufferGetWidth(videoBuffer);
        int height  = (int)CVPixelBufferGetHeight(videoBuffer);
        //宽*高
        int w_x_h = width * height;
        //yuv数据长度 = (宽 * 高) * 3 / 2
        int yuv_len = w_x_h * 3 / 2;
        //yuv数据
        uint8_t *yuv_bytes = malloc(yuv_len);
        
        //ARGBToNV12这个函数是libyuv这个第三方库提供的一个将bgra图片转为yuv420格式的一个函数。
        //libyuv是google提供的高性能的图片转码操作。支持大量关于图片的各种高效操作，是视频推流不可缺少的重要组件，你值得拥有。
        CVPixelBufferLockBaseAddress(videoBuffer, 0);
        uint8_t *srcAddress = CVPixelBufferGetBaseAddress(videoBuffer);
        ARGBToNV12(srcAddress, width * 4, yuv_bytes, width, yuv_bytes + w_x_h, width, width, height);
        CVPixelBufferUnlockBaseAddress(videoBuffer, 0);
        
        NSData *yuvData = [NSData dataWithBytesNoCopy:yuv_bytes length:yuv_len];
        free(yuv_bytes);
        yuv_bytes = nil;
        
        videoData.videoData = yuvData;
        videoData.width = (int)width;
        videoData.height = (int)height;
    }else{
        NSLog(@"buffer转换失败，只支持32BGRA格式视频帧");
    }
    return videoData;
}

#pragma mark - 将CMSampleBufferRef音频桢转为Pcm NSData
+(NSData *)convertAudioBufferToPcmData:(CMSampleBufferRef)audioSample
{
    //获取pcm数据大小
    NSInteger audioDataSize = CMSampleBufferGetTotalSampleSize(audioSample);
    //分配空间
    int8_t *audio_data = malloc((int32_t)audioDataSize);
    //获取CMBlockBufferRef
    //这个结构里面就保存了 PCM数据
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(audioSample);
    //直接将数据copy至我们自己分配的内存中
    CMBlockBufferCopyDataBytes(dataBuffer, 0, audioDataSize, audio_data);
    //返回数据
    NSData * pcmData = [NSData dataWithBytesNoCopy:audio_data length:audioDataSize];
    return pcmData;
}

#pragma mark - 将CVPixelBufferRef转为y_u_vData
+(MHVideoData)convertVideoBufferToY_U_VData:(CVPixelBufferRef)videoBuffer
{
    MHVideoData videoData = {nil,0,0};
    //表示开始操作数据
    CVPixelBufferLockBaseAddress(videoBuffer, 0);
    
    //图像宽度（像素）
    size_t pixelWidth = CVPixelBufferGetWidth(videoBuffer);
    //图像高度（像素）
    size_t pixelHeight = CVPixelBufferGetHeight(videoBuffer);
    //yuv中的y所占字节数
    size_t y_size = pixelWidth * pixelHeight;
    //yuv中的u和v分别所占的字节数
    size_t uv_size = pixelWidth * pixelHeight / 4;
    
    if (CVPixelBufferIsPlanar(videoBuffer)) {
        
        uint8_t *yuv_frame = malloc(pixelWidth * pixelHeight * 3 / 2);

        int planeCount = (int)CVPixelBufferGetPlaneCount(videoBuffer);
        /*
        I420格式：y,u,v 3个部分分别存储：Y0,Y1...Yn,U0,U1...Un/2,V0,V1...Vn/2
        NV12格式：y和uv 2个部分分别存储：Y0,Y1...Yn,U0,V0,U1,V1...Un/2,Vn/2
        NV21格式：同NV12，只是U和V的顺序相反。
         */
        if (planeCount == 2) {
            //y_uv
            //获取CVImageBufferRef中的Y数据
            uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(videoBuffer, 0);
            memcpy(yuv_frame, y_frame, y_size);
            
            //获取CMVImageBufferRef中的UV数据
            uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(videoBuffer, 1);
            memcpy(yuv_frame, uv_frame, uv_size * 2);
            
        }else if (planeCount == 3) {
            //y_u_v
            //获取CVImageBufferRef中的Y数据
            uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(videoBuffer, 0);
            memcpy(yuv_frame, y_frame, y_size);
            
            //获取CMVImageBufferRef中的U数据
            uint8_t *u_frame = CVPixelBufferGetBaseAddressOfPlane(videoBuffer, 1);
            memcpy(yuv_frame, u_frame, uv_size);
            
            //获取CMVImageBufferRef中的V数据
            uint8_t *v_frame = CVPixelBufferGetBaseAddressOfPlane(videoBuffer, 2);
            memcpy(yuv_frame, v_frame, uv_size);
        }
        NSData *yuvData = [NSData dataWithBytesNoCopy:yuv_frame length:y_size + uv_size * 2];
        
        videoData.videoData = yuvData;
        videoData.width = (int)pixelWidth;
        videoData.height = (int)pixelHeight;
    }
    CVPixelBufferUnlockBaseAddress(videoBuffer, 0);
    return videoData;
}

#pragma mark - 将NSData(y_uv)转换为CVPixelBufferRef
+(CVPixelBufferRef)y_uvDataToBuffer:(NSData *)y_uvData frameWidth:(int)width height:(int)height
{
    //yuv 变成 转CVPixelBufferRef
    //视频宽度
    size_t pixelWidth = (size_t)width;
    //视频高度
    size_t pixelHeight = (size_t)height;
    //把NV12数据放入 CVPixelBufferRef中
    CVPixelBufferRef pixelBuf = NULL;
    //初始化pixelBuf，数据类型是kCVPixelFormatType_420YpCbCr8BiPlanarFullRange，此类型数据格式同NV12格式相同。
    CVPixelBufferCreate(NULL, pixelWidth, pixelHeight, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, NULL, &pixelBuf);
    // Lock address，锁定数据，应该是多线程防止重入操作。
    CVPixelBufferLockBaseAddress(pixelBuf, 0);
    //将yuv数据填充到CVPixelBufferRef中
    size_t y_size = pixelWidth * pixelHeight;
    size_t uv_size = pixelWidth * pixelHeight / 4;
    uint8_t *yuv_frame = (uint8_t *)y_uvData.bytes;
    //处理y frame
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuf, 0);
    memcpy(y_frame, yuv_frame, y_size);
    //处理uv frame
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuf, 1);
    memcpy(uv_frame, yuv_frame + y_size, uv_size * 2);
    
    CVPixelBufferUnlockBaseAddress(pixelBuf, 0);
    
    return pixelBuf;
}
#pragma mark - CVImageBufferRef转换为CGImageRef
+(CGImageRef)imageRefFromimageBuffer:(CVImageBufferRef)imageBuffer
{
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    uint8_t *yBuffer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    size_t yPitch = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    uint8_t *cbCrBuffer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
    size_t cbCrPitch = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 1);
    
    int bytesPerPixel = 4;
    uint8_t *rgbBuffer = malloc(width * height * bytesPerPixel);
    
    for(int y = 0; y < height; y++) {
        uint8_t *rgbBufferLine = &rgbBuffer[y * width * bytesPerPixel];
        uint8_t *yBufferLine = &yBuffer[y * yPitch];
        uint8_t *cbCrBufferLine = &cbCrBuffer[(y >> 1) * cbCrPitch];
        
        for(int x = 0; x < width; x++) {
            int16_t y = yBufferLine[x];
            int16_t cb = cbCrBufferLine[x & ~1] - 128;
            int16_t cr = cbCrBufferLine[x | 1] - 128;
            
            uint8_t *rgbOutput = &rgbBufferLine[x*bytesPerPixel];
            
            int16_t r = (int16_t)roundf( y + cr *  1.4 );
            int16_t g = (int16_t)roundf( y + cb * -0.343 + cr * -0.711 );
            int16_t b = (int16_t)roundf( y + cb *  1.765);
            
            rgbOutput[0] = 0xff;
            rgbOutput[1] = clamp(b);
            rgbOutput[2] = clamp(g);
            rgbOutput[3] = clamp(r);
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbBuffer, width, height, 8, width * bytesPerPixel, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(rgbBuffer);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return quartzImage;
}
#pragma mark - CVImageBufferRef转换为UIImage
+(UIImage *)imageFromimageBuffer:(CVImageBufferRef)imageBuffer
{
    CGImageRef cgImage = [self imageRefFromimageBuffer:imageBuffer];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}
#pragma mark - 裁剪YUV数据
+(void)cutxYUV420:(char *)srcBuffer srcW:(int)srcW srcH:(int)srcH desBuffer:(char *)desBuffer cutX:(int)x cutY:(int)y cutW:(int)desW cutH:(int)desH
{
    int tmpRange;
    int bufferIndex;
    
    int yIndex = 0;
    bufferIndex = 0 + x + y * srcW;
    tmpRange = srcW * desH;
    for (int i = 0; i < tmpRange;) {
        memcpy(desBuffer + yIndex, srcBuffer + bufferIndex + i, desW);
        i += srcW;
        yIndex += desW;
    }
    
    int uIndex = desW * desH;
    int uIndexStep = srcW / 2;
    int uWidthCopy = desW / 2;
    bufferIndex = srcW * srcH + x / 2 + y / 2 * srcW / 2;
    tmpRange = srcW * desH / 4;
    for (int i = 0; i < tmpRange;) {
        memcpy(desBuffer + uIndex, srcBuffer + bufferIndex + i, uWidthCopy);
        i += uIndexStep;
        uIndex += uWidthCopy;
    }
    
    int vIndex = desW * desH + desW * desH / 4;
    int vIndexStep = srcW / 2;
    int vWidthCopy = desW / 2;
    bufferIndex = srcW * srcH + srcW * srcH / 4 + x / 2 + y / 2 * srcW / 2;
    tmpRange = srcW * desH / 4;
    for (int i = 0; i < tmpRange;) {
        memcpy(desBuffer + vIndex, srcBuffer + bufferIndex + i, vWidthCopy);
        i += vIndexStep;
        vIndex += vWidthCopy;
    }
}
@end
