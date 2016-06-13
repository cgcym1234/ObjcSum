//
//  UITabBarController+Extension.m
//  ObjcSum
//
//  Created by sihuan on 16/6/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UITabBarController+Extension.h"



@implementation TabBarItemInfo

+ (instancetype)modelWithStoryBoardName:(NSString *)storyBoardName titleTab:(NSString *)titleTab imageName:(NSString *)imageName imageNameSelected:(NSString *)imageNameSelected  {
    TabBarItemInfo *model = [TabBarItemInfo new];
    model.storyBoardName = storyBoardName;
    model.titleTab = titleTab;
    model.imageName = imageName;
    model.imageNameSelected = imageNameSelected;
    return model;
}

@end

@implementation UITabBarController (Extension)

- (void)appendViewControllers:(NSArray<TabBarItemInfo *> *)tabBarItemsInfo {
    if (tabBarItemsInfo.count > 0) {
//        NSArray *arr = self.viewControllers ?: @[];
//        //这样相当于添加新的controller
//        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:arr];
//        for (TabBarItemInfo *itemInfo in tabBarItemsInfo) {
//            
//        }
    }
}

@end



























