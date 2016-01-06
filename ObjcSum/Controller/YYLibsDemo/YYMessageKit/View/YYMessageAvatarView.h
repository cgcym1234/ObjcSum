//
//  YYMessageAvatarView.h
//  ObjcSum
//
//  Created by sihuan on 16/1/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMessageAvatarView;

typedef void (^YYMessageAvatarViewTouchUpInsideBlock)(YYMessageAvatarView *view);

@interface YYMessageAvatarView : UIButton

//是否圆形
@property (nonatomic, assign) BOOL round;

//点击回调
@property (nonatomic, copy) YYMessageAvatarViewTouchUpInsideBlock touchUpInsideBlock;

- (void)setImage:(UIImage *)image;
- (void)setImageUrlSting:(NSString *)urlString;

@end
