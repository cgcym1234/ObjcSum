//
//  PushPresentDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2017/2/8.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "PushPresentDemo.h"
#import "UIViewController+Extension.h"
#import "SmallViewsController.h"
#import "YYGlobalTimer.h"

@interface PushPresentDemo ()

@end

@implementation PushPresentDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [self addButtonWithTitle:@"push" action:^(UIButton *btn) {
        UIViewController *vc = [weakSelf.class new];
        vc.view.backgroundColor = [UIColor redColor];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [weakSelf pushVC];
    }];
    
    [self addButtonWithTitle:@"present" action:^(UIButton *btn) {
        UIViewController *vc = [PushPresentDemo new];
        vc.view.backgroundColor = [UIColor redColor];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    
    [self addButtonWithTitle:@"dismiss" action:^(UIButton *btn) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
//    [YYGlobalTimer addTaskForTarget:self key:@"sss" interval:0.1 action:^(NSDate * _Nonnull currentDate) {
//        //isBeingDismissed present的vc被dismiss时候为yes
//        NSLog(@"isBeingDismissed = %d", weakSelf.isBeingDismissed);
//    } executedInMainThread:YES];
    
    
    [YYGlobalTimer addTaskForTarget:self key:@"sss" interval:0.1 action:^(NSDate * _Nonnull currentDate) {
        NSLog(@"isMovingToParentViewController = %d", weakSelf.isMovingToParentViewController);
    } executedInMainThread:YES];
    
    [self pushVC];
//    [self pushSelf];
    //  在低版本中当前现实的View有可能会出：《返回就崩了。。
    //    iOS7.1.2 :
    //    2015-12-13 11:41:33.837 xxx[4418:60b] nested push animation can result in corrupted navigation bar
    //    2015-12-13 11:41:34.195 xxx[4418:60b] Finishing up a navigation transition in an unexpected state. Navigation Bar subview tree might get corrupted.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.presentedViewController) {
        NSLog(@"presenting");
    }
    
    if (self.isBeingDismissed) {
        
    }
    if (self.navigationController.topViewController != self) {
        NSLog(@"push");
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    NSLog(@"willMoveToParentViewController");
}

- (void)pushVC {
    UIViewController *vc = [SmallViewsController new];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)pushSelf {
    UIViewController *vc = [self.class new];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
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
