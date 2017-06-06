//
//  MapNavigationDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2017/5/31.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "MapNavigationDemo.h"
#import "YYMapNavigation.h"
#import "UIViewController+Extension.h"
#import "NSURL+YYExtension.h"

@interface MapNavigationDemo ()

@end

@implementation MapNavigationDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self) weakSelf = self;
    [self addButtonWithTitle:@"导航" action:^(UIButton *btn) {
        [weakSelf navitationDemo];
    }];
    
    
    //jmbasewebview，通过触发jmweb://navigation?ori_latitude=起始纬度&ori_longitude=起始纬度&ori_name=起始点名称encode后的值&desti_latitude=目的地纬度&desti_longitude=目的地纬度&desti_name=目的地名称encode后的值
    
    NSURL *url = [NSURL new];
    if (![url.host isEqualToString:@"jmweb"] ||
        ![url.lastPathComponent isEqualToString:@"navigation"]) {
        return;
    }
    
    NSDictionary *params = [url yy_dictionaryFromParameters];
    
    YYMapNavigationItem *from = [YYMapNavigationItem instanceWithName:params[@"ori_name"] latitude:[params[@"ori_latitude"] floatValue] longitude:[params[@"ori_longitude"] floatValue]];
    
    YYMapNavigationItem *to = [YYMapNavigationItem instanceWithName:params[@"desti_name"] latitude:[params[@"desti_latitude"] floatValue] longitude:[params[@"desti_longitude"] floatValue]];
    
    [YYMapNavigation showNavigationFrom:from to:to inController:self];
}

- (void)navitationDemo {
    
    YYMapNavigationItem *from = [YYMapNavigationItem instanceWithName:@"桂溪街道" latitude:30.541156663504914 longitude:104.05202815583193];
    
    YYMapNavigationItem *to = [YYMapNavigationItem instanceWithName:@"前门东大街3号院(首都大酒店内)" latitude:39.901358702212328 longitude:116.40961199998856];
    [YYMapNavigation showNavigationFrom:from to:to inController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
