//
//  YYCountLabel.h
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYCountLabel : UILabel

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger total;

+ (instancetype)newInstance;
- (void)setCurrent:(NSInteger)current total:(NSInteger)total;

@end
