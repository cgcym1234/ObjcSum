//
//  MainTabBarController.m
//  justice
//
//  Created by sihuan on 15/10/17.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "LoginManager.h"
#import "YYLogger.h"

#define KeyTitle              @"titile"
#define KeySelectedImag       @"selectedImag"
#define KeyUnselectedImag     @"unselectedImag"

#define StoryboardNameTasks        @"Tasks"
#define StoryboardNameApproval     @"Approval"
#define StoryboardNameMessages     @"Messages"
#define StoryboardNameUser         @"User"




@interface MainTabBarController ()
<UITabBarControllerDelegate>

@end


@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self envInit];
    
    NSLog(@"-----------aaaaaaaa----------------");
    
    yyLogSetDefaultMiniLevel(YYLogLevelDebug);
    yyLog(YYLogLevelDebug, @"%@", @"YYLogLevelDebug");
    yyLogInfo(@"%@", @[@"1", @"2", @"3"]);
    yyLogWarning(@"%@", @"yyLogWarning");
    yyLogError(@"%@", @{@"key": @"yyLogError"});
    yyLogFatal(@"%@", self);
    
    NSLog(@"-----------bbbbbbbb----------------");
    
    /*
     😀[DEBUG][2016-10-14 03:21:26 +0000][MainTabBarController.m: -[MainTabBarController viewDidLoad]: 41] YYLogLevelDebug
     🤔[INFO][2016-10-14 03:21:26 +0000][MainTabBarController.m: -[MainTabBarController viewDidLoad]: 42] (
     1,
     2,
     3
     )
     😅[WARN][2016-10-14 03:21:26 +0000][MainTabBarController.m: -[MainTabBarController viewDidLoad]: 43] yyLogWarning
     😱[ERROR][2016-10-14 03:21:26 +0000][MainTabBarController.m: -[MainTabBarController viewDidLoad]: 44] {
     key = yyLogError;
     }
     😭[FATAL][2016-10-14 03:21:26 +0000][MainTabBarController.m: -[MainTabBarController viewDidLoad]: 45] <MainTabBarController: 0x7fc1ce709bc0>
     */
}


- (void)envInit {
    [self.tabBar setTranslucent:NO];
    self.delegate = self;
    
//    LoginModel *user = [LoginManager getLatestUserInfo];
//    if (!user.sessionId) {
//        [LoginManager gotoLogin];
//    }
//    [self composeMainViewControllers];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 整合首页页面
- (void)composeMainViewControllers {
    self.tabBar.tintColor = ColorFlattingBlue;
    NSArray *tabInfoArr = @[
                            @{KeyTitle:@"待办任务", KeyUnselectedImag:@"tab0", KeySelectedImag:@"tab0"},
                            @{KeyTitle:@"应用", KeyUnselectedImag:@"tab1", KeySelectedImag:@"tab1"},
                            @{KeyTitle:@"消息", KeyUnselectedImag:@"tab2", KeySelectedImag:@"tab2"},
                            @{KeyTitle:@"我", KeyUnselectedImag:@"tab3", KeySelectedImag:@"tab3"},
                            ];
    
    
    int i = 0;
    NSDictionary *tabInfo;
    
    tabInfo = tabInfoArr[i];
    UIStoryboard *firstStory = [UIStoryboard storyboardWithName:StoryboardNameTasks bundle:nil];
    BaseNavigationController *firstNav = [firstStory instantiateInitialViewController];
    firstNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabInfo[KeyTitle] image:[UIImage imageNamed:tabInfo[KeyUnselectedImag]] tag:i++];
    
    //调整文字位置
    firstNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    
    tabInfo = tabInfoArr[i];
    UIStoryboard *secondStory = [UIStoryboard storyboardWithName:StoryboardNameApproval bundle:nil];
    BaseNavigationController *secondNav = [secondStory instantiateInitialViewController];
    secondNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabInfo[KeyTitle]image:[UIImage imageNamed:tabInfo[KeyUnselectedImag]] tag:i++];
    
    
    
    self.viewControllers = @[firstNav, secondNav];
}


@end
