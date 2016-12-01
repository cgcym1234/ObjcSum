//
//  JMGoodsDetailPublicPraiseViewController.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailPublicPraiseViewController.h"
#import "JMGoodsDetail.h"

#pragma mark - Const

#define kTableHeaderHeight 139.0f

#define kReputationSummaryInfoHeight 40.0f
#define kReputationSummaryInfoWidth 282.0f

#define kReputationStarViewWidth 96.0f

#define kReputationSplitInfoHeight 49.0f
#define kReputationSplitInfoWidth 319.0f

static NSString *const ReputationCellIdentifier = @"ReputationCellIdentifier";

#pragma mark  Key

static NSString * const CellIdentifier = @"KeyCell";

#pragma mark  Segue

static NSString * const ToViewController = @"ToViewController";


@interface JMGoodsDetailPublicPraiseViewController ()


@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end

@implementation JMGoodsDetailPublicPraiseViewController

#pragma mark - instance

+ (instancetype)instanceFromStoryboard {
    JMGoodsDetailPublicPraiseViewController *vc = [[UIStoryboard storyboardWithName:JMGoodsDetailStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return vc;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)dealloc {
    
}

#pragma mark - Initialization

- (void)setupContext {
    
}

- (void)setupUI {
    
}




@end


