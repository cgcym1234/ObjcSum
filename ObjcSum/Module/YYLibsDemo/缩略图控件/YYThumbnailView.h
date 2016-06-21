//
//  YYThumbnailView.h
//  MySimpleFrame
//
//  Created by sihuan on 15/9/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYThumbnailItem.h"

#pragma mark - 缩略图控件

@interface YYThumbnailView : UIView

//缩略图边长
@property (nonatomic, strong) NSString *thumbSideLength;

- (instancetype)initWithThumbItems:(NSArray *)thumbItems;

@end
