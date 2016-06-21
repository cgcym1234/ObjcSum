//
//  YYRefreshConfig.h
//  ObjcSum
//
//  Created by sihuan on 2016/6/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYRefreshConfig : NSObject

@property (nonatomic, strong) NSString *textIdle;
@property (nonatomic, strong) NSString *textReady;
@property (nonatomic, strong) NSString *textRefreshing;

@property (nonatomic, assign) CGFloat readyOffset;

+ (instancetype)defaultConfig;

@end
