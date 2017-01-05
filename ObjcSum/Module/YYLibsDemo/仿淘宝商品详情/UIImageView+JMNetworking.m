//
//  UIImageView+JMNetworking.m
//  JMKit
//
//  Created by Pinglin Tang on 13-5-3.
//  Copyright (c) 2013年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "UIImageView+WebCache.h"
#import "SDWebImageDownloaderOperation.h"
#import "SDWebImageCompat.h"


#pragma maek - 处理SDWebImage 图片scale与旧版本中的不同
@interface SDWebImageDownloaderOperation (ImageScale)

@end

@implementation SDWebImageDownloaderOperation (ImageScale)

- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image
{
    if ([image.images count] > 1) {
        return SDScaledImageForKey(key, image);
    }
    
    return image;
}

@end

@interface SDImageCache (ImageScale)

@end

@implementation SDImageCache (ImageScale)

- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image
{
    if ([image.images count] > 1) {
        return SDScaledImageForKey(key, image);
    }
    
    return image;
}

@end

#pragma mark - END -- 处理SDWebImage 图片scale与旧版本中的不同

@implementation UIImageView (JMNetworking)

- (void)setImageWithURLArray:(NSArray *)imageArray
                   animation:(CAAnimation *)animation{
    if (!imageArray||![imageArray isKindOfClass:[NSArray class]]||[imageArray count]==0) {
        return;
    }
    NSURL* url_=[imageArray firstObject];
    if (![url_ isKindOfClass:[NSURL class]]) {
        return;
    }
    NSMutableArray* tempArray_=[NSMutableArray arrayWithArray:imageArray];
    [tempArray_ removeObject:url_];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url_];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __weak __typeof(self) weakSelf_=self;
    __weak NSMutableArray* weakArray_=tempArray_;
    __weak CAAnimation*    weakAnimation_=animation;
    [self setImageWithURLRequest:request
                placeholderImage:nil
                       animation:animation
                      imageScale:0
                        priority:NSOperationQueuePriorityNormal
                         success:nil
                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         [weakSelf_ setImageWithURLArray:weakArray_ animation:weakAnimation_];
     }];
}

- (void)setImageWithURL:(NSURL *)url
              animation:(CAAnimation *)animation {
    [self setImageWithURL:url
         placeholderImage:nil
                animation:animation
               imageScale:0
                 priority:NSOperationQueuePriorityNormal];
}

- (void)setImageWithURL:(NSURL *)url
             imageScale:(CGFloat)imageScale {
    [self setImageWithURL:url
         placeholderImage:nil
                animation:nil
               imageScale:imageScale
                 priority:NSOperationQueuePriorityNormal];
}

- (void)setImageWithURL:(NSURL *)url
               priority:(NSOperationQueuePriority)priority {
    [self setImageWithURL:url
         placeholderImage:nil
                animation:nil
               imageScale:0
                 priority:priority];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
              animation:(CAAnimation *)animation {
    [self setImageWithURL:url
         placeholderImage:placeholderImage
                animation:animation
               imageScale:0
                 priority:NSOperationQueuePriorityNormal];
}



- (void)setImageWithURL:(NSURL *)url
             imageScale:(CGFloat)imageScale
               priority:(NSOperationQueuePriority)priority {
    [self setImageWithURL:url
         placeholderImage:nil
                animation:nil
               imageScale:imageScale
                 priority:priority];
}

- (void)setImageWithURL:(NSURL *)url
              animation:(CAAnimation *)animation
             imageScale:(CGFloat)imageScale {
    [self setImageWithURL:url
         placeholderImage:nil
                animation:animation
               imageScale:imageScale];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
              animation:(CAAnimation *)animation
             imageScale:(CGFloat)imageScale {
    [self setImageWithURL:url
         placeholderImage:placeholderImage
                animation:animation
               imageScale:imageScale
                 priority:NSOperationQueuePriorityNormal];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
              animation:(CAAnimation *)animation
             imageScale:(CGFloat)imageScale
               priority:(NSOperationQueuePriority)priority {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest:request
                placeholderImage:placeholderImage
                       animation:animation
                      imageScale:imageScale
                        priority:priority
                         success:nil
                         failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                     animation:(CAAnimation *)animation
                    imageScale:(CGFloat)imageScale
                      priority:(NSOperationQueuePriority)priority
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    //解决该 API 不能更新头像的bugs ---chengbin
   __weak __typeof(self)wself = self;
    dispatch_main_async_safe(^{
        if (placeholderImage) {
            self.image = placeholderImage;
            [wself setNeedsDisplay];
        }
    });

    
    [self sd_setImageWithURL:urlRequest.URL placeholderImage:placeholderImage options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong __typeof(wself) strongSelf = wself;
        if (error) {
            if (failure) {
                failure(nil,nil,error);
            }
        }
        else{
            if (success) {
                success(nil,nil,image);
            }
            
            if (image) {
                
                [strongSelf setImage:image];
                [strongSelf setNeedsDisplay];
            }
            
            if (cacheType == SDImageCacheTypeNone && animation) {
                [strongSelf.layer addAnimation:animation forKey:nil];
            }
        }
    }];
}

- (void)cancelImageRequestOperation {
    [self sd_cancelCurrentImageLoad];
}

//获取本地image
- (BOOL )imageCachedWithURL:(NSURL *)url completeHandle:(void (^)(UIImage *image))completeHandle{
    SDWebImageManager *imgManager = [SDWebImageManager sharedManager];
    BOOL cached = [imgManager cachedImageExistsForURL:url];
    if (cached) {
        NSString *cachedKey = [imgManager cacheKeyForURL:url];
        UIImage *image = [imgManager.imageCache imageFromMemoryCacheForKey:cachedKey];
        if (nil == image) {
            image = [imgManager.imageCache imageFromDiskCacheForKey:cachedKey];
        }
        
        if (completeHandle) {
            completeHandle(image);
        }
    }
    
    return cached;
}
-(void)setObjct:(NSObject *)obj forkey:(NSString *)key inDic:(NSMutableDictionary *)dic{
    if (obj) {
        [dic setObject:obj forKey:key];
    }else{
        [dic setObject:[NSNull null] forKey:key];
    }
}
-(id)objForKey:(NSString *)key inDic:(NSMutableDictionary *)dic{
    NSObject *obj = [dic objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]] ) {
        return nil;
    }else{
        return obj;
    }
}

@end


