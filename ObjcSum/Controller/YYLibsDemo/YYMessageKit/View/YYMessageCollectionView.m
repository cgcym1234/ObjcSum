//
//  YYMessageCollectionView.m
//  ObjcSum
//
//  Created by sihuan on 16/1/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageCollectionView.h"
#import "YYMessageCellLayoutConfig.h"

@implementation YYMessageCollectionView

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.headerReferenceSize = CGSizeZero;
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        [self setContext];
    }
    return self;
}

- (void)setContext {
    self.alwaysBounceVertical = YES;
    self.pagingEnabled = NO;
    self.backgroundColor = [YYMessageCellConfig defaultConfig].messageBackgroundColor;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}




@end
