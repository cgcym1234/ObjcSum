//
//  YYHud.h
//  Progress
//
//  Created by sihuan on 15/6/17.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYHudMaskType) {
    YYHudMaskTypeNone = 1,      // 透明背景，默认可以交互
    YYHudDim,                   //  添加灰色蒙板，默认不能交互
};

@interface YYHud : UIView

@property (weak, nonatomic) IBOutlet UIView *hudContainer;

@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *stringLabel;

//
@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;

//是否让原来的view交互，默认是
@property (nonatomic, assign) BOOL allowUserInteraction;

#pragma mark - 自定义配置
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) YYHudMaskType defaultMaskType;

+ (void)config:(void(^)(YYHud *hud))cofig;


#pragma mark - 快速构建
/*
 显示到window上，并且只有一个YYHud实例
 */
+ (YYHud *)showSpinner;

+ (YYHud *)show:(NSString *)msg;
+ (YYHud *)show:(NSString *)msg maskType:(YYHudMaskType)maskType;

+ (YYHud *)showTip:(NSString *)msg;
+ (YYHud *)showTip:(NSString *)msg duration:(NSTimeInterval)duration;

+ (YYHud *)showSucess:(NSString *)msg;
+ (YYHud *)showError:(NSString *)msg;

+ (YYHud *)showInView:(UIView *)superView image:(UIImage *)image str:(NSString *)str duration:(NSTimeInterval)duration maskType:(YYHudMaskType)maskType;
+ (void)dismiss;


#pragma mark - Pulic

- (YYHud *)showSpinner;

- (YYHud *)show:(NSString *)msg;

//下面3个都是默认1.8秒后消失
- (YYHud *)showTip:(NSString *)msg duration:(NSTimeInterval)duration;
- (YYHud *)showSucess:(NSString *)msg;
- (YYHud *)showError:(NSString *)msg;

/**
 *  显示hud
 *
 *  @param superView    显示到哪个view上，superView=nil,会添加到当前window上
 *  @param image        显示图片, 36*36 pt png
 *  @param str          显示内容
 *  @param duration     显示时间，然后会自动消失，单位：秒，duration=DISPATCH_TIME_FOREVER表示不消失
 *  @param maskType
 *  @param isText       是否只显示文字
 */
- (YYHud *)showInView:(UIView *)superView image:(UIImage *)image str:(NSString *)str duration:(NSTimeInterval)duration maskType:(YYHudMaskType)maskType isText:(BOOL)isText;

- (void)dismiss;

@end
