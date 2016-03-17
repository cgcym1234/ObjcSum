//
//  YYScrollSigmentDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/6.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYScrollSigmentDemo.h"
#import "YYScrollSigment.h"
#import "YYPageController.h"
#import "YYSegmentedControl.h"
#import "YYAlertTextViewDemo.h"

@interface YYScrollSigmentDemo ()<YYPageControllerDelegate>

@property (nonatomic, weak)IBOutlet UIView *containerView;
@property (nonatomic, weak)IBOutlet YYScrollSigment *segment;
@property (nonatomic, strong) YYScrollSigment *segment2;
@property (nonatomic, strong) YYPageController *viewController;
@property (nonatomic, strong) YYSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *texts;

@end

@implementation YYScrollSigmentDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _texts = @[@"太阳",@"叉叉1",@"叉叉2",@"叉叉叉",@"叉叉叉",@"叉叉叉"];
    _segment.currentIndex = 1;
//    _segment.indicatorViewEnable = YES;
    _segment.dataArr = @[@"太阳",@"牛叉叉叉叉"];
    
    
//    __weak typeof(self) weekSelf = self;
    _segment.didSelectedItemBlock = ^(YYScrollSigment *view, NSInteger idx) {
    };
    
    [self.view addSubview:self.segmentedControl];
    
    
    YYPageController *viewController = [[YYPageController alloc] init];
    viewController.delegate = self;
    [self addChildViewController:viewController];
    [self.containerView addSubview:viewController.view];
//    viewController.view.frame = self.containerView.bounds;
    [viewController didMoveToParentViewController:self];
    _viewController = viewController;
    
//    [self.view addSubview:self.segment2];
//    self.segment2.frame = CGRectMake(0, 50, 320, 44);
}

- (YYSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        YYSegmentedControl *segmentedControl = [[YYSegmentedControl alloc] initWithFrame:CGRectMake(0, 50, 320, 44) dataArray:@[@"全部",@"呵呵和",@"全部"]];
        _segmentedControl = segmentedControl;
    }
    return _segmentedControl;
}

- (YYScrollSigment *)segment2 {
    if (!_segment2) {
        __weak typeof(self) weakSelf = self;
        YYScrollSigment *segment = [[YYScrollSigment alloc] initWithDataArr:_texts];
        segment.indicatorViewEnable = YES;
        segment.itemSizeAuto = NO;
        segment.itemWith = 80;
        segment.didSelectedItemBlock = ^(YYScrollSigment *view, NSInteger idx) {
            weakSelf.viewController.currentPage = idx;
        };

        _segment2 = segment;
    }
    return _segment2;
}

- (NSInteger)yyPageControllerNumberOfControllers {
    return _texts.count;
}

- (UIViewController *)yyPageController:(YYPageController *)pageController controllerAtIndex:(NSInteger)index {
    return [[YYAlertTextViewDemo alloc] init];
}

- (void)yyPageController:(YYPageController *)pageController didScrollToPage:(NSInteger)page {
    NSLog(@"didScrollToPage %ld", (long)page);
    self.segment2.currentIndex = page;
}

@end
