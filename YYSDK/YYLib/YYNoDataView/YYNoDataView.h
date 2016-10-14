//
//  YYNoDataView.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/18.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYNoDataView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *stringLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (copy, nonatomic) void (^buttonBlock)();

- (instancetype)init;

#pragma mark - Pulic
+ (YYNoDataView *)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image;

- (YYNoDataView *)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image;

- (YYNoDataView *)showInView:(UIView *)superView
                     content:(NSString *)content
                       image:(UIImage *)image
                 buttonTitle:(NSString *)buttonTitle
                 buttonBlock:(void(^)())buttonBlock;

- (void)update:(NSString *)content image:(UIImage *)image;
- (void)update:(NSString *)content
         image:(UIImage *)image
   buttonTitle:(NSString *)buttonTitle
   buttonBlock:(void(^)())buttonBlock;

@end
