//
//  YYMessageCollectionView.m
//  ObjcSum
//
//  Created by sihuan on 16/1/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageCollectionView.h"

@implementation YYMessageCollectionView

#pragma mark - Life Cycle

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
    self.alwaysBounceVertical = YES;
    self.pagingEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}




@end
