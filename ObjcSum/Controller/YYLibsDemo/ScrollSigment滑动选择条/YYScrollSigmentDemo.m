//
//  YYScrollSigmentDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/6.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYScrollSigmentDemo.h"
#import "YYScrollSigment.h"

@interface YYScrollSigmentDemo ()

@property (nonatomic, weak)IBOutlet YYScrollSigment *segment;

@end

@implementation YYScrollSigmentDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segment.currentIndex = 1;
    _segment.indicatorViewEnable = YES;
    _segment.dataArr = @[@"太阳",@"牛叉叉叉叉"];
    
    
//    __weak typeof(self) weekSelf = self;
    _segment.didSelectedItemBlock = ^(YYScrollSigment *view, NSInteger idx) {
    };
}



@end
