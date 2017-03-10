//
//  YYLibsDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/4.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYLibsDemo.h"

@interface YYLibsDemo ()

@end

@implementation YYLibsDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[
                     [[LibDemoInfo alloc] initWithTitle:@"PushPresentDemo" desc:@"Push或Present时监听" controllerName:@"PushPresentDemo"],
                   [[LibDemoInfo alloc] initWithTitle:@"YYGlobalTimerDemo" desc:@"全局定时器" controllerName:@"YYGlobalTimerDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"AutoLayoutDemo" desc:@"AutoLayout测试" controllerName:@"AutoLayoutDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"GoodsDetailContainer" desc:@"仿淘宝商品详情" controllerName:@"GoodsDetailContainer"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"PullRefreshDemo" desc:@"自定义下拉刷新" controllerName:@"PullRefreshDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYMessageViewController" desc:@"聊天界面demo" controllerName:@"YYMessageViewController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"MVVMDemo" desc:@"随手记MVVM版" controllerName:@"MVVMDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYCacheTest" desc:@"YYCache性能测试" controllerName:@"YYCacheTest"],
                   
                   
                   [[LibDemoInfo alloc] initWithTitle:@"LoginDemo" desc:@"登录demo" controllerName:@"LoginDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYKeyValueStoreDemo" desc:@"KV存储库" controllerName:@"SqlliteDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYScrollSigmentDemo" desc:@"ScrollSigment滑动选择条" controllerName:@"YYScrollSigmentDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"一些Alert控件" desc:@"弹出输入,选择等控件" controllerName:@"YYAlertTextViewDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"EncryptionDemo" desc:@"加密相关" controllerName:@"EncryptionDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"CountdownDemo" desc:@"倒计时功能" controllerName:@"CountdownDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYComponentsDemo" desc:@"一些小控件" controllerName:@"YYComponentsDemo"],
                   ];
    
}


//- (void)layoutItems {
//    CGFloat maxWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
//    CGFloat itmeWith = [JMMetroCellItem fixedSize].width;
//    CGFloat itmeHeight = [JMMetroCellItem fixedSize].height;
//    CGFloat x = 0;
//    CGFloat y = 0;
//    CGFloat itemSpacing = 0;
//    NSInteger itemCount = _items.count;
//    
//    NSInteger totalLine = ((itemCount-1) / ItemCountPerLine) + 1;
//    totalLine = MIN(totalLine, MaxLine);
//    
//    NSInteger absoluteIndex = 0;
//    //从最后一行开始计算坐标
//    for (NSInteger currentLine = totalLine; currentLine > 0; currentLine--) {
//        NSInteger itemCountCurrentLine = 0;
//        //最后一行
//        if (currentLine == totalLine) {
//            itemCountCurrentLine = (itemCount-1) % ItemCountPerLine + 1;
//        } else {
//            itemCountCurrentLine = ItemCountPerLine;
//        }
//        
//        //该行显示5个item的话就有6个间距
//        itemSpacing = (maxWidth - itemCountCurrentLine*itmeWith) / (itemCountCurrentLine+1);
//        y = MarginTopBottom * currentLine + itmeHeight * (currentLine-1);
//        for (int i = 0; i < itemCountCurrentLine; i++) {
//            absoluteIndex = ItemCountPerLine * (currentLine-1) + i;
//            x = itemSpacing * (i+1) + itmeWith * i;
//            JMMetroCellItem *cellItem = _items[absoluteIndex];
//            cellItem.frame = CGRectMake(x, y, itmeWith, itmeHeight);
//        }
//    }
//}


@end
