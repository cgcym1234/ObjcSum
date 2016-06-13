//
//  UITabBarController+Extension.h
//  ObjcSum
//
//  Created by sihuan on 16/6/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarItemInfo : NSObject

@property (nonatomic, strong) NSString *storyBoardName;
@property (nonatomic, strong) NSString *titleTab;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imageNameSelected;

+ (instancetype)modelWithStoryBoardName:(NSString *)storyBoardName titleTab:(NSString *)titleTab imageName:(NSString *)imageName imageNameSelected:(NSString *)imageNameSelected;
@end

@interface UITabBarController (Extension)

- (void)appendViewControllers:(NSArray<TabBarItemInfo *> *)tabBarItemsInfo;

@end
