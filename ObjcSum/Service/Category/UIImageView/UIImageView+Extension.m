//
//  UIImageView+Extension.m
//  ObjcSum
//
//  Created by sihuan on 2016/8/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Extension)

- (void)setImageWithURLStr:(NSString *)str {
    [self setImageWithURLStr:str placeholderImage:nil];
}

- (void)setImageWithURLStr:(NSString *)str placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURLStr:str placeholderImage:placeholder completed:nil];
}

- (void)setImageWithURLStr:(NSString *)str placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:placeholder options:SDWebImageRetryFailed progress:nil completed:completedBlock];
}

- (void)setImageProgressWithURLStr:(NSString *)str
                          progress:(SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(SDWebImageCompletionBlock)completedBlock {
    
    return [self sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:SDWebImageRetryFailed progress:progressBlock completed:completedBlock];
}

@end
