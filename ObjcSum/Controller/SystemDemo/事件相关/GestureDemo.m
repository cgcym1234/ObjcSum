//
//  GestureDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/1/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "GestureDemo.h"
#import "DragImageView.h"
#import "DragImageViewGesture.h"
#import "DragImageViewGesture3.h"
#import "TouchEventDemo.h"

#import "UIViewController+Extension.h"

@interface GestureDemo ()

@property (nonatomic, strong) DragImageView *dragImageView;
@property (nonatomic, strong) DragImageViewGesture *dragImageViewGesture;
@property (nonatomic, strong) DragImageViewGesture3 *dragImageViewGesture3;
@end

@implementation GestureDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.dragImageView];
//    [self.view addSubview:self.dragImageViewGesture];
//    [self.view addSubview:self.dragImageViewGesture3];
    __weak typeof(self) weakSelf = self;
    int btnNum = 2;
    [self addButtonWithTitle:@"TouchEventDemo" action:^(UIButton *btn) {
        [weakSelf.navigationController pushViewController:[TouchEventDemo instanceFromStoryboard] animated:YES];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (DragImageView *)dragImageView {
    if (_dragImageView == nil) {
        DragImageView *imageView = [DragImageView new];
        imageView.frame = CGRectMake(0, 60, 200, 200);
        _dragImageView = imageView;
    }
    return _dragImageView;
}

- (DragImageViewGesture *)dragImageViewGesture {
    if (_dragImageViewGesture == nil) {
        DragImageViewGesture *imageView = [DragImageViewGesture new];
        imageView.frame = CGRectMake(0, 60, 200, 200);
        _dragImageViewGesture = imageView;
    }
    return _dragImageViewGesture;
}

- (DragImageViewGesture3 *)dragImageViewGesture3 {
    if (_dragImageViewGesture3 == nil) {
        DragImageViewGesture3 *imageView = [DragImageViewGesture3 new];
        imageView.frame = CGRectMake(0, 60, 200, 200);
        _dragImageViewGesture3 = imageView;
    }
    return _dragImageViewGesture3;
}

@end




