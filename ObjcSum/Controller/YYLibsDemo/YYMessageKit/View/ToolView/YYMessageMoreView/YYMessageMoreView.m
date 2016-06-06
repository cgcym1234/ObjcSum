//
//  YYMessageMoreView.m
//  ObjcSum
//
//  Created by sihuan on 16/2/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageMoreView.h"
#import "YYMessageMoreViewCell.h"
#import "YYMessageDefinition.h"
#import "UIView+AutoLayout.h"

#pragma mark - Const

static NSString * const CellIdentifierDefault = @"YYMessageMoreViewCell";

@interface YYMessageMoreView ()

@property (nonatomic, strong) YYHorizontalScrollView *moreView;

@end

@implementation YYMessageMoreView


#pragma mark - Initialization


- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.moreView];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YYInputViewHeight);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_moreView reloadData];
    });
}


#pragma mark - Override


#pragma mark - Private


#pragma mark - Public


#pragma mark - Delegate


#pragma mark - Setter


#pragma mark - Getter

- (YYHorizontalScrollView *)moreView {
    if (!_moreView) {
        YYHorizontalScrollView *moreView = [YYHorizontalScrollView new];
        
        moreView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YYInputViewHeight);
        moreView.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/4, 100);
        [moreView registerClass:[YYMessageMoreViewCell class]];
        moreView.dataArray = @[
                               [YYMessageMoreViewCellModel modelWithText:@"照片" imageName:@"ChatWindow_Photo"],
                               [YYMessageMoreViewCellModel modelWithText:@"拍照" imageName:@"ChatWindow_Camera"],
                               ];
        _moreView = moreView;
    }
    return _moreView;
}


@end


