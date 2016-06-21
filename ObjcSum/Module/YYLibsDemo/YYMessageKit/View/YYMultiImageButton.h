//
//  YYMultiImageButton.h
//  ObjcSum
//
//  Created by sihuan on 16/1/12.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYMultiImageButton : UIButton

/**
 *  点击按钮后会按images数组里的图片依次切换
 */
@property (nonatomic, strong) NSArray *images;

//当前显示的是第几张图片，从0开始
@property (nonatomic, assign) NSInteger currentImageIndex;

@end
