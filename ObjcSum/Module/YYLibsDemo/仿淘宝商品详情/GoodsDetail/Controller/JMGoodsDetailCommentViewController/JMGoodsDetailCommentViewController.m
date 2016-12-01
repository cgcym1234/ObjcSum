//
//  JMGoodsDetailCommentViewController.m
//  JuMei
//
//  Created by yangyuan on 2016/9/26.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailCommentViewController.h"

#import "JMSimpleSegment.h"

#pragma mark - Const

static NSInteger const TopContainerViewHeightDefault = 44;

#pragma mark  Key

static NSString * const CommentCellIdentifier = @"CommentCellIdentifier";

@interface JMGoodsDetailCommentViewController ()

@property (nonatomic, weak) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContainerViewHeight;
@property (nonatomic, strong) JMSimpleSegment *topSegmentControl;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation JMGoodsDetailCommentViewController

#pragma mark - instance

+ (instancetype)instanceFromStoryboard {
    JMGoodsDetailCommentViewController *vc = [[UIStoryboard storyboardWithName:JMGoodsDetailStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return vc;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization

- (void)setupContext {
    
    [self setupUI];
    
}

- (void)setupUI {
    self.topContainerView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MAEProductDetailCommentCell" bundle:nil] forCellReuseIdentifier:CommentCellIdentifier];
    [self showTopView:NO];
}

#pragma mark - Public

- (void)reloadData {
    // 加载首页数据
    
}

#pragma mark - UI

- (void)showTopView:(BOOL)isShow {
    
}


#pragma mark - Private

- (NSString *)commentTypeName:(JMGoodsDetailCommentType)commentType {
    NSString *name = nil;
    switch (commentType) {
        case JMGoodsDetailCommentTypeAll:
            name = @"全部评价";
            break;
        case JMGoodsDetailCommentTypePositive:
            name = @"好价";
            break;
        case JMGoodsDetailCommentTypeModerate:
            name = @"中评";
            break;
        case JMGoodsDetailCommentTypeNegative:
            name = @"差评";
            break;
    }
    return name;
}

- (NSString *)commentTypeValue:(JMGoodsDetailCommentType)commentType {
    NSString *value = nil;
    switch (commentType) {
        case JMGoodsDetailCommentTypeAll:
            value = nil;
            break;
        case JMGoodsDetailCommentTypePositive:
            value = @"4";
            break;
        case JMGoodsDetailCommentTypeModerate:
            value = @"3";
            break;
        case JMGoodsDetailCommentTypeNegative:
            value = @"2";
            break;
    }
    return value;
}

#pragma mark - Public

- (void)reloadWithCommentType:(JMGoodsDetailCommentType)commentType {
    if (_defaultCommentType == commentType) {
        return;
    }
    _defaultCommentType = commentType;
    
}

#pragma mark - Getter

- (JMGoodsDetailCommentType)defaultCommentType {
    return self.topSegmentControl.selectedIndex;
}

@end



