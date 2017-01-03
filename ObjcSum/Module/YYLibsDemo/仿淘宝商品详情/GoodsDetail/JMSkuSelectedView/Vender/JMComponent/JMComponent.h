//
//  JMComponent.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMComponentModel <NSObject>

@end


@protocol JMComponent <NSObject>

@required
@property (nonatomic, strong) id<JMComponentModel> model;

- (void)reloadWithData:(id<JMComponentModel>)model;

@end


