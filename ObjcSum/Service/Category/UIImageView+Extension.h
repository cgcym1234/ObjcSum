//
//  UIImageView+Extension.h
//  ObjcSum
//
//  Created by sihuan on 2016/8/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface UIImageView (Extension)

- (void)setImageWithURLStr:(NSString *)str;
- (void)setImageWithURLStr:(NSString *)str placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURLStr:(NSString *)str placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)setImageProgressWithURLStr:(NSString *)str
                          progress:(SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(SDWebImageCompletionBlock)completedBlock;


@end
