//
//  MHCVPixelBuffer.m
//  MHVideoTool
//
//  Created by mahao on 2019/5/22.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHCVPixelBuffer.h"

@implementation MHCVPixelBuffer

#pragma mark - 将CVPixelBufferRef转为Y_UV格式buffer
+(CVPixelBufferRef)convertBufferToY_UV:(CVPixelBufferRef)pixelBuffer
{
    OSType pixelFormatType = CVPixelBufferGetPixelFormatType(pixelBuffer);
    
    if (pixelFormatType == kCVPixelFormatType_32BGRA) {
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        
        int width = (int)CVPixelBufferGetWidth(pixelBuffer);
        int height = (int)CVPixelBufferGetHeight(pixelBuffer);
        
        int half_width = (width + 1) / 2;
        int half_height = (height + 1) / 2;
        
        const int y_size = width * height;
        const int uv_size = half_width * half_height * 2 ;
        const size_t total_size = y_size + uv_size;
        
        uint8_t* outputBytes = calloc(1,total_size);
        
        uint8_t* interMiediateBytes = calloc(1,total_size);
        
        uint8_t *srcAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
 
        ARGBToI420(srcAddress,
                   width * 4,
                   interMiediateBytes,
                   half_width * 2,
                   interMiediateBytes + y_size,
                   half_width,
                   interMiediateBytes + y_size + y_size/4,
                   half_width,
                   width, height);
        
        I420ToNV12(interMiediateBytes,
                   half_width * 2,
                   interMiediateBytes + y_size,
                   half_width,
                   interMiediateBytes + y_size + y_size/4,
                   half_width,
                   outputBytes,
                   half_width * 2,
                   outputBytes + y_size,
                   half_width * 2,
                   width, height);
        
        free(interMiediateBytes);
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        CVPixelBufferRef pixel_buffer = NULL;
        
        CVPixelBufferCreate(kCFAllocatorDefault, width , height,
                            kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                            NULL, &pixel_buffer);
        
        CVPixelBufferLockBaseAddress(pixel_buffer, 0);
        
        uint8_t * plan1 = CVPixelBufferGetBaseAddressOfPlane(pixel_buffer,0);
        size_t  plan1_height = CVPixelBufferGetHeightOfPlane(pixel_buffer,0);
        size_t  plan1_sizePerRow = CVPixelBufferGetBytesPerRowOfPlane(pixel_buffer,0);
        
        memcpy(plan1, outputBytes, plan1_height * plan1_sizePerRow);
        
        uint8_t * plan2 = CVPixelBufferGetBaseAddressOfPlane(pixel_buffer,1);
        size_t  plan2_height = CVPixelBufferGetHeightOfPlane(pixel_buffer,1);
        size_t  plan2_sizePerRow = CVPixelBufferGetBytesPerRowOfPlane(pixel_buffer,1);
        
        memcpy(plan2, outputBytes +  plan1_height * plan1_sizePerRow, plan2_height * plan2_sizePerRow);
        
        CVPixelBufferUnlockBaseAddress(pixel_buffer, 0);
        
        free(outputBytes);
        
        return pixel_buffer;
        
    }else if(pixelFormatType == kCVPixelFormatType_420YpCbCr8Planar || pixelFormatType == kCVPixelFormatType_420YpCbCr8PlanarFullRange) {
        // i420
        
        NSLog(@"send kCVPixelFormatType_420YpCbCr8PlanarFullRange");
        
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        
        int width = (int)CVPixelBufferGetWidth(pixelBuffer);
        int height = (int)CVPixelBufferGetHeight(pixelBuffer);
        
        int half_width = (width + 1) / 2;
        int half_height = (height + 1) / 2;
        
        const int y_size = width * height;
        const int uv_size = half_width * half_height * 2 ;
        const size_t total_size = y_size + uv_size;
        
        uint8_t* outputBytes = calloc(1,total_size);
        
        //uint8_t* srcBase = CVPixelBufferGetBaseAddress(pixelBuffer);
        
        I420ToNV12(CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0),
                   half_width * 2,
                   CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1),
                   half_width,
                   CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 2),
                   half_width,
                   outputBytes,
                   half_width * 2,
                   outputBytes + y_size,
                   half_width * 2,
                   width, height);
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        CVPixelBufferRef pixel_buffer = NULL;
        
        CVPixelBufferCreate(kCFAllocatorDefault, width , height,
                            kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                            NULL, &pixel_buffer);
        
        CVPixelBufferLockBaseAddress(pixel_buffer, 0);
        
        uint8_t * plan1 = CVPixelBufferGetBaseAddressOfPlane(pixel_buffer,0);
        size_t  plan1_height = CVPixelBufferGetHeightOfPlane(pixel_buffer,0);
        size_t  plan1_sizePerRow = CVPixelBufferGetBytesPerRowOfPlane(pixel_buffer,0);
        
        memcpy(plan1, outputBytes, plan1_height * plan1_sizePerRow);
        
        uint8_t * plan2 = CVPixelBufferGetBaseAddressOfPlane(pixel_buffer,1);
        size_t  plan2_height = CVPixelBufferGetHeightOfPlane(pixel_buffer,1);
        size_t  plan2_sizePerRow = CVPixelBufferGetBytesPerRowOfPlane(pixel_buffer,1);
        
        memcpy(plan2, outputBytes +  plan1_height * plan1_sizePerRow, plan2_height * plan2_sizePerRow);
        
        CVPixelBufferUnlockBaseAddress(pixel_buffer, 0);
        
        free(outputBytes);
        
        return pixel_buffer;
        
    }
    NSLog(@"要转化的buffer格式不支持!");
    return pixelBuffer;
}
void pixelBufferReleaseCallBack(void *releaseRefCon, const void *baseAddress) {
    if (baseAddress != NULL) {
        free((void *)baseAddress);
    }
}
#pragma mark - 裁剪CVPixelBufferRef到指定大小size
+(CVPixelBufferRef)cropPixelBuffer:(CVPixelBufferRef)sourcePixelBuffer scaledSize:(CGSize)scaledSize
{
    size_t width = CVPixelBufferGetWidth(sourcePixelBuffer);
    size_t height = CVPixelBufferGetHeight(sourcePixelBuffer);
    CGRect videoRect = CGRectMake(0, 0, width, height);
    CGRect croppingRect = AVMakeRectWithAspectRatioInsideRect(scaledSize, videoRect);
    
    CVPixelBufferLockBaseAddress(sourcePixelBuffer, kCVPixelBufferLock_ReadOnly);
    void *sourceData = CVPixelBufferGetBaseAddress(sourcePixelBuffer);
    
    size_t sourceBytesPerRow = CVPixelBufferGetBytesPerRow(sourcePixelBuffer);
    size_t offset = CGRectGetMinY(croppingRect) * sourceBytesPerRow + CGRectGetMinX(croppingRect) * 4;
    
    vImage_Buffer croppedvImageBuffer = {
        .data = ((char *)sourceData) + offset,
        .height = (vImagePixelCount)CGRectGetHeight(croppingRect),
        .width = (vImagePixelCount)CGRectGetWidth(croppingRect),
        .rowBytes = sourceBytesPerRow
    };
    
    size_t scaledBytesPerRow = scaledSize.width * 4;
    void *scaledData = malloc(scaledSize.height * scaledBytesPerRow);
    if (scaledData == NULL) {
        NSLog(@"Error: out of memory");
        CVPixelBufferUnlockBaseAddress(sourcePixelBuffer, kCVPixelBufferLock_ReadOnly);
        return sourcePixelBuffer;
    }
    
    vImage_Buffer scaledvImageBuffer = {
        .data = scaledData,
        .height = (vImagePixelCount)scaledSize.height,
        .width = (vImagePixelCount)scaledSize.width,
        .rowBytes = scaledBytesPerRow
    };
    
    /* The ARGB8888, ARGB16U, ARGB16S and ARGBFFFF functions work equally well on
     * other channel orderings of 4-channel images, such as RGBA or BGRA.*/
    vImage_Error error = vImageScale_ARGB8888(&croppedvImageBuffer, &scaledvImageBuffer, nil, 0);
    CVPixelBufferUnlockBaseAddress(sourcePixelBuffer, kCVPixelBufferLock_ReadOnly);
    
    if (error != kvImageNoError) {
        NSLog(@"Error: %ld", error);
        free(scaledData);
        return sourcePixelBuffer;
    }
    
    OSType pixelFormat = CVPixelBufferGetPixelFormatType(sourcePixelBuffer);
    CVPixelBufferRef outputPixelBuffer = NULL;
    CVReturn status = CVPixelBufferCreateWithBytes(nil, scaledSize.width, scaledSize.height, pixelFormat, scaledData, scaledBytesPerRow, pixelBufferReleaseCallBack, nil, nil, &outputPixelBuffer);
    
    if (status != kCVReturnSuccess) {
        NSLog(@"Error: could not create new pixel buffer");
        free(scaledData);
        return sourcePixelBuffer;
    }
    
    return outputPixelBuffer;
}
#pragma mark - 旋转CMSampleBufferRef
+ (CVPixelBufferRef)rotateBuffer:(CVImageBufferRef)imageBuffer withConstant:(uint8_t)rotationConstant
{
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    OSType pixelFormatType = CVPixelBufferGetPixelFormatType(imageBuffer);
    if (pixelFormatType != kCVPixelFormatType_32ARGB) {
        NSLog(@"旋转只支持argb或者bgra格式，其他格式可能不支持-直接返回，可注释掉判断条件测试");
        return imageBuffer;
    }
    
    const size_t kAlignment_32ARGB = 32;
    const size_t kBytesPerPixel_32ARGB = 4;
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    BOOL rotatePerpendicular = (rotationConstant == 1) || (rotationConstant == 3); // Use enumeration values here
    const size_t outWidth = rotatePerpendicular ? height : width;
    const size_t outHeight = rotatePerpendicular ? width  : height;
    
    size_t bytesPerRowOut = kBytesPerPixel_32ARGB * ceil(outWidth * 1.0 / kAlignment_32ARGB) * kAlignment_32ARGB;
    
    const size_t dstSize = bytesPerRowOut * outHeight * sizeof(unsigned char);
    
    void *srcBuff = CVPixelBufferGetBaseAddress(imageBuffer);
    
    unsigned char *dstBuff = (unsigned char *)malloc(dstSize);
    
    vImage_Buffer inbuff = {srcBuff, height, width, bytesPerRow};
    vImage_Buffer outbuff = {dstBuff, outHeight, outWidth, bytesPerRowOut};
    
    uint8_t bgColor[4] = {0, 0, 0, 0};
    
    vImage_Error err = vImageRotate90_ARGB8888(&inbuff, &outbuff, rotationConstant, bgColor, 0);
    if (err != kvImageNoError) {
        NSLog(@"%ld", err);
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        return imageBuffer;
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    CVPixelBufferRef rotatedBuffer = NULL;
    CVPixelBufferCreateWithBytes(NULL,
                                 outWidth,
                                 outHeight,
                                 pixelFormatType,
                                 outbuff.data,
                                 bytesPerRowOut,
                                 pixelBufferReleaseCallBack,
                                 NULL,
                                 NULL,
                                 &rotatedBuffer);
    
    return rotatedBuffer;
}

@end
