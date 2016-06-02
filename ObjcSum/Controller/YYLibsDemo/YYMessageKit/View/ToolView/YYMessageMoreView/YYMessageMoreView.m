//
//  YYMessageMoreView.m
//  ObjcSum
//
//  Created by sihuan on 16/2/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageMoreView.h"
#import "YYMessageMoreViewCell.h"



#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"YYMessageMoreViewCell";

@interface YYMessageMoreView ()
<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation YYMessageMoreView


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}


- (void)setContext {
    _dataArray = @[
                   [YYMessageMoreViewCellModel modelWithText:@"照片" imageName:@"ChatWindow_Photo"],
                   [YYMessageMoreViewCellModel modelWithText:@"拍照" imageName:@"ChatWindow_Camera"],
                   ];
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private


#pragma mark - Public


#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<YYCellDelegate> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KeyCell forIndexPath:indexPath];
    [cell renderWithModel:_dataArray[indexPath.item] atIndexPath:indexPath inContainer:collectionView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Setter


#pragma mark - Getter



@end


