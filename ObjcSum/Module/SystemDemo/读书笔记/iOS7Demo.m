//
//  iOS7Demo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "iOS7Demo.h"
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation iOS7Demo

+ (void)load {
    [self NSURLComponentsDemo];
}

/**
 *  [参考链接](http://nshipster.cn/ios7/)
 
 iOS 7里面精彩的新API
 
 ### NSData (NSDataBase64Encoding)
 
 Base64是作为ASCII文本为二进制编码的常用方式之一。因为很多核心技术都被设计用来支持文本，而不是原始二进制，所以Base64在网络上被广泛的使用。
 
 比如，CSS可以通过inline data:// URIs嵌入图像，这通常是Base64编码的。另一个例子是基本认证头标，这也是通过Base64来编码用户名／密码对，这也比它们完全暴露要稍好一些。
 
 iOS7终于加入Base64了：
 
 ```
 NSString *string = @"Lorem ipsum dolor sit amet.";
 NSString *base64EncodedString = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
 
 NSLog(@"%@", base64EncodedString); // @"TG9yZW0gaXBzdW0gZG9sYXIgc2l0IGFtZXQu"
 ```
 */
- (void)base64 {
    NSString *string = @"Lorem ipsum dolor sit amet.";
    NSString *base64EncodedString = [[string dataUsingEncoding:NSUTF8StringEncoding]  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSLog(@"%@", base64EncodedString); // @"TG9yZW0gaXBzdW0gZG9sYXIgc2l0IGFtZXQu"
    
}

/**
 *  ### NSURLComponents & NSCharacterSet (NSURLUtilities)
 
 许多用来操控URL的API都因为NSURL的不可变性而仍在使用NSString.
 
 NSURLComponents改变了这个情况。你可以把它想成NSMutableURL：
 
 ```
 NSURLComponents *components = [NSURLComponents componentsWithString:@"http://nshipster.com"];
 components.path = @"/ios7";
 components.query = @"foo=bar";
 
 NSLog(@"%@", components.scheme); // @"http"
 NSLog(@"%@", [components URL]); // @"http://nshipster.com/iOS7?foo=bar"
 ```
 
 
 每一个URL components的property还有一个percentEncoded*的演变(比如user & percentEncodedUser)，
 通过这个变形就不需要使用其他额外的URI特殊字符百分号编码。
 
 哪些字符是特殊的呢？这取决于你所指的是URL的哪一部分。
 好消息是NSCharacterSet增加了一个用来在iOS 7里允许使用新的URL字符的新的类别：
 
 - + (id)URLUserAllowedCharacterSet
 - + (id)URLPasswordAllowedCharacterSet
 - + (id)URLHostAllowedCharacterSet
 - + (id)URLPathAllowedCharacterSet
 - + (id)URLQueryAllowedCharacterSet
 - + (id)URLFragmentAllowedCharacterSet
 */
+ (void)NSURLComponentsDemo {
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://nshipster.com"];
    components.path = @"/ios7";
    components.query = @"foo=bar哈哈";//自动转码了
    
    NSLog(@"%@", components.scheme); // @"http"
    NSLog(@"%@", [components URL]); // @"http://nshipster.com/ios7?foo=bar%E5%93%88%E5%93%88"
}

/**
 
 ### NSProgress
 
 NSProgress 可以被用来通过本地化方式简单的报告整体的进程：
 
 ```
 NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
 progress.completedUnitCount = 42;
 
 NSLog(@"%@", [progress localizedDescription]);// 42% completed
 
 //或者我们可以给它一个完全停止工作的处理器：
 NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
 target:self
 selector:@selector(incrementCompletedUnitCount:) userInfo:nil
 repeats:YES];
 progress.cancellationHandler = ^ {
 [timer invalidate];
 };
 
 [progress cancel];
 ```
 
 ### NSArray -firstObject
 */

+ (void)NSProgressDemo {
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
    progress.completedUnitCount = 42;
    
    NSLog(@"%@", [progress localizedDescription]);// 42% completed
    
    //或者我们可以给它一个完全停止工作的处理器：
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(incrementCompletedUnitCount:) userInfo:nil
                                            repeats:YES];
    progress.cancellationHandler = ^ {
        [timer invalidate];
    };
    
    [progress cancel];
}

/**
 ### CIDetectorSmile & CIDetectorEyeBlink
 
 自从iOS5以来，Core Image框架提供了通过CIDetector类可实现的面部监测与识别功能。
 在iOS 7中我们甚至可以识别这张脸是在微笑还是闭眼睛了。
 
 这又是一个免费应用的想法，这里的代码片段或许可以被照相机使用来仅仅存储带有笑脸的照片：
 */
- (void)CIDetectorSmileDemo {
    CIContext *context;
    CIImage *ciImage;
    CIDetector *simleDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                   context:context
                                                   options:@{CIDetectorTracking: @YES,
                                                             CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *features = [simleDetector featuresInImage:ciImage options:@{CIDetectorSmile:@YES}];
    if ([features count] > 0 && [features[0] hasSmile]) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(ciImage)], self, @selector(didFinishWritingImage), (__bridge void * _Nullable)(features));
    } else {
//        self.label.text = @"Say Cheese!"
    }
}

/**
### AVCaptureMetaDataOutput
 
通过AVCaptureMetaDataOutput扫瞄各式各样的UPC，QR码和条形码，是iOS 7的新功能。你所需要做的就是将它设置为AVCaptureSession的输出，并相应地实现captureOutput:didOutputMetadataObjects:fromConnection:方法：
 */

@end



























