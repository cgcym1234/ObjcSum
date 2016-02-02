//
//  YYMultiImageButton.m
//  ObjcSum
//
//  Created by sihuan on 16/1/12.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMultiImageButton.h"
#import "Aspects.h"
#import "NSObject+YYExtension.h"

@interface YYMultiImageButton ()

@end

@implementation YYMultiImageButton

- (void)awakeFromNib {
    _currentImageIndex = 0;
}

/**
 *  拦截UIControlEventTouchUpInside方法，
 在点击之前先执行图片切换回调
 */
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (controlEvents & UIControlEventTouchUpInside) {
        __weak typeof(self) weakSelf = self;
        [target aspect_hookSelector:action withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo) {
            weakSelf.currentImageIndex++;
        }error:nil];
    }
    [super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setImages:(NSArray *)images {
    _images = [images copy];
    self.currentImageIndex = 0;
}

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex {
    
    if (_images.count > 0) {
        currentImageIndex = currentImageIndex % _images.count;
        [self setImage:_images[currentImageIndex] forState:UIControlStateNormal];
    } else {
        currentImageIndex = 0;
    }
    _currentImageIndex = currentImageIndex;
}

@end
