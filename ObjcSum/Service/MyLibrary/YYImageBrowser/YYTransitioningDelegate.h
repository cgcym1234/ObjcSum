//
//  YYTransitioningDelegate.h
//  MLLCustomer
//
//  Created by yangyuan on 16/7/21.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIImageView *initialImageView;
@property (nonatomic, weak) UIImageView *animatingImageView;
@property (nonatomic, assign) BOOL dismissAnimated;

@end



#import "YYEmoticonInputView.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

@interface YYEmoticonInputView ()

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

