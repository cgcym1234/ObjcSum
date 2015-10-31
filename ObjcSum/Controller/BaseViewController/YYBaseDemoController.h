//
//  YYBaseDemoController.h
//  MySimpleFrame
//
//  Created by sihuan on 15/9/4.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 显示demoController列表的模板

@interface YYBaseDemoController : UITableViewController

//DemoInfo的数组
@property (nonatomic, strong) NSArray *dataArr;

@end


@interface LibDemoInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *controllerName;

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc controllerName:(NSString *)controllerName;


@end

