//
//  YYScrollSigmentDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/6.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYScrollSigmentDemo.h"
#import "YYScrollSigment.h"

#import "YYSegmentedControl.h"
#import "YYAlertTextViewDemo.h"
#import "YYPageViewController.h"
#import "YYSegmentedView.h"
#import "UIViewController+Extension.h"
#import "UIView+Frame.h"

@interface YYScrollSigmentDemo ()<YYSegmentedControlDelegate, YYPageViewControllerDelegate>

@property (nonatomic, weak)IBOutlet UIView *containerView;
@property (nonatomic, weak)IBOutlet YYScrollSigment *segment;
@property (nonatomic, strong) YYScrollSigment *segment2;

@property (nonatomic, strong) YYPageViewController *pageController;
@property (nonatomic, strong) YYSegmentedControl *segmentedControl;

@property (nonatomic, strong) YYSegmentedView *segmentedView;

@property (nonatomic, strong) NSArray *texts;

@end

@implementation YYScrollSigmentDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _texts = @[@"太阳",@"叉叉1",@"叉叉2",@"叉叉叉叉",@"叉叉叉叉叉",@"叉叉叉叉叉叉"];
//    _segment.currentIndex = 1;
////    _segment.indicatorViewEnable = YES;
//    _segment.dataArr = @[@"太阳",@"牛叉叉叉叉"];
//    
//    
////    __weak typeof(self) weekSelf = self;
//    _segment.didSelectedItemBlock = ^(YYScrollSigment *view, NSInteger idx) {
//    };
    
//    [self.view addSubview:self.segmentedControl];
    _segmentedControl.selectedIndex = 2;
    
    
    
//    [self.view addSubview:self.segment2];
//    self.segment2.frame = CGRectMake(0, 50, 320, 44);
    
    [self.view addSubview:self.segmentedView];
    
    
    __weak __typeof(self) weakSelf = self;
    [self addButtonWithTitle:@"fixedItemWith = 80" action:^(UIButton *btn) {
        weakSelf.segmentedView.fixedItemWidth = 80;
    }].y = 4;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addPage2];
    
}


- (void)addPage2 {
    if (_pageController) {
        return;
    }
    YYPageViewController *pageController = [YYPageViewController new];
    pageController.delegate = self;
    [self addChildViewController:pageController];
    [self.containerView addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
    _pageController = pageController;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_pageController reloadData];
    });
}

- (YYSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        YYSegmentedControl *segmentedControl = [[YYSegmentedControl alloc] initWithFrame:CGRectMake(0, 50, 320, 44) dataArray:@[@"全部",@"呵呵和",@"全部"]];
        segmentedControl.delegate = self;
        _segmentedControl = segmentedControl;
    }
    return _segmentedControl;
}

- (YYSegmentedView *)segmentedView {
    if (!_segmentedView) {
        YYSegmentedView *segmentedView = [YYSegmentedView new];
        segmentedView.frame = CGRectMake(0, 50, 320, 44);
//        segmentedView.fixedItemWith = 40;
        [segmentedView setTitles:_texts];
        
        __weak __typeof(self) weakSelf = self;
        segmentedView.indexChangedBlock = ^(YYSegmentedView *view, NSInteger toIndex, NSInteger prevIndex) {
            [weakSelf.pageController setCurrentPage:toIndex];
        };
        
        _segmentedView = segmentedView;
    }
    return _segmentedView;
}

#pragma mark - YYSegmentedControlDelegate

- (void)yySegmentedControl:(YYSegmentedControl *)segmenteControl didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}


- (YYScrollSigment *)segment2 {
    if (!_segment2) {
        __weak typeof(self) weakSelf = self;
        YYScrollSigment *segment = [[YYScrollSigment alloc] initWithDataArr:_texts];
        segment.indicatorViewEnable = YES;
        segment.itemSizeAuto = NO;
        segment.itemWith = 100;
        segment.didSelectedItemBlock = ^(YYScrollSigment *view, NSInteger idx) {
            
        };

        _segment2 = segment;
    }
    return _segment2;
}

#pragma mark - YYPageViewControllerDelegate

- (NSInteger)numberOfControllersInYYPageViewController:(YYPageViewController *)pageViewController {
    return _texts.count;
}

- (UIViewController *)yyPageViewController:(YYPageViewController *)pageViewController controllerAtPage:(NSInteger)index {
    UIViewController *vc = [[YYAlertTextViewDemo alloc] init];
    vc.view.backgroundColor = ColorRandom;
    return vc;
}

- (void)yyPageViewController:(YYPageViewController *)pageViewController didScrollToPage:(NSInteger)page prevPage:(NSInteger)prevPage {
    [self.segmentedView setSelectedIndex:page animated:YES notify:NO];
}

@end
