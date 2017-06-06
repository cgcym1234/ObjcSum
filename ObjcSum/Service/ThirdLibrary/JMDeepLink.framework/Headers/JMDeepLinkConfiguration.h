//
//  JMDeepLinkConfiguration.h
//  JuMei
//
//  Created by bojiaz on 2017/5/5.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMDeepLinkConfigurationDelegate <NSObject>

/** deeplink跳转回调函数
 * @param params 跳转携带的信息
 * @param error 跳转出错携带信息
 */
- (void)deeplinkDataReturned: (NSDictionary *) params withError: (NSError *) error;

@end

@interface JMDeepLinkConfiguration : NSObject

@property(nonatomic, weak) id<JMDeepLinkConfigurationDelegate> delegate;

/**
 *  内部请求需要额外携带的参数
 */
@property (nonatomic, strong) NSDictionary *requestDynamicParams;

/**
 *  内部请求需要额外携带的Cookie
 */
@property (nonatomic, strong) NSDictionary *requestDynamicCookies;

/**
 *  手动启动时，是否需要通过模糊匹配获得Url,默认为YES
 */
@property (nonatomic, assign) BOOL needGetUrlWhenLaunch;

/**
 *  返回默认配置
 */
+ (JMDeepLinkConfiguration *)defaultConfiguration;

@end
