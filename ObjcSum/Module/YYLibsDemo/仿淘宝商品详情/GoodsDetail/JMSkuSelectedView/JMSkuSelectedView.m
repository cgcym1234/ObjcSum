//
//  JMSkuSelectedView.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuSelectedView.h"
#import "UIView+JMCategory.h"
#import "UIView+Utils.h"
#import "UIView+Additionals.h"
#import "JMCollectionViewLeftAlignLayout.h"
#import "JMSkuSelectedViewConsts.h"
#import "JMSkuSelectedViewModel+HeaderDisplayView.h"
#import "JMSkuSelectedViewModel+MiddleCollectionView.h"
#import "JMSkuSelectedViewModel+BottomConfirmView.h"
#import "YYKeyboardManager.h"

#pragma mark - Const


@interface JMSkuSelectedView ()<UICollectionViewDelegate, UICollectionViewDataSource, JMSkuCellDelegate, JMSkuNumSelectedCellDelegate, YYKeyboardObserver>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) JMSkuDisplayView *skuDisplayView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JMSkuConfirmView *skuConfirmView;

/**< Sku数量选择，某些情况不显示 */
@property (nonatomic, weak) JMSkuNumSelectedCell *skuNumSelectedView;

@end

@implementation JMSkuSelectedView


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContext];
    }
    return self;
}

- (void)setupContext {
    self.userInteractionEnabled = YES;
    self.clipsToBounds = NO;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    _containerView = [UIView new];
    [_containerView addSubview:self.skuDisplayView];
    [_containerView addSubview:self.collectionView];
    [_containerView addSubview:self.skuConfirmView];
    [self addSubview:_containerView];
    
    CGFloat width = [JMSkuSelectedViewModel viewWidth];
    self.frame = [UIScreen mainScreen].bounds;
    _skuDisplayView.frame = CGRectMake(0, 0, width, [JMSkuSelectedViewModel skuDisplayViewHeight]);
    _collectionView.frame = CGRectMake(0, _skuDisplayView.bottom, width, [JMSkuSelectedViewModel collectionViewHeight]);
    _skuConfirmView.frame = CGRectMake(0, _collectionView.bottom, width, [JMSkuSelectedViewModel skuConfirmViewHeight]);
    
    _containerView.frame = CGRectMake(0, 0, width, _skuConfirmView.bottom);
    
    [[YYKeyboardManager defaultManager] addObserver:self];
}

- (void)dealloc {
    [[YYKeyboardManager defaultManager] removeObserver:self];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self dismiss];
    [self endEditing:YES];
}

#pragma mark - Public

- (void)reloadData {
    [_skuDisplayView reloadWithData:_model.skuDisplayModel];
    [_collectionView reloadData];
    [_skuConfirmView reloadWithData:_model.skuConfirmModel];
}

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuSelectedViewModel class]]) {
        return;
    }
    _model = model;
    [self reloadData];
}


- (void)showAnimated {
    _containerView.frameY = self.height;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _containerView.frameY = self.height - _containerView.height;
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.62];
                     }
                     completion:nil];
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0.0 options:0
                     animations:^{
                         _containerView.frameY = self.height;
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)showInWindowWithData:(JMSkuSelectedViewModel *)data {
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    [self reloadWithData:data];
    [self showAnimated];
}

#pragma mark - YYKeyboardObserver

- (void)yyKeyboardManager:(YYKeyboardManager *)keyboardManager
   keyboardWithTransition:(YYKeyboardTransition)transition {
    CGRect keyboardFrame = [keyboardManager convertRect:transition.toFrame toView:self];
    //默认最底部
    CGFloat contentOffsetY = 0;
    self.collectionView.scrollEnabled = YES;
    
    //键盘显示
    if (CGRectGetMinY(keyboardFrame) < self.height) {
        CGPoint expectedPointInCollectionView = [self convertPoint:keyboardFrame.origin toView:self.collectionView];
        contentOffsetY = self.collectionView.contentSize.height - expectedPointInCollectionView.y;
        self.collectionView.scrollEnabled = NO;
    }

    [self.collectionView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
}


#pragma mark - Delegate


#pragma mark - JMSkuCellDelegate

- (void)jmSkuCellDidClicked:(JMSkuCell *)cell {
    [_model refreshWithSelectedCellModel:cell.model];
    
    [self reloadData];
}

#pragma mark - JMSkuNumSelectedCellDelegate

- (void)jmSkuNumSelectedCell:(JMSkuNumSelectedCell *)cell didClickWithAction:(JMSkuNumSelectedButtonAction)action {
    [_model refreshNumSelectedModelWithAction:action];
    
    [self.skuNumSelectedView reloadData];
}

- (void)jmSkuNumSelectedCell:(JMSkuNumSelectedCell *)cell inputValueChanged:(NSString *)value {
    NSInteger inputNum = [value integerValue];
    if (inputNum > _model.maxStockCurrent) {
        [self showTip:@"超出最大范围"];
    }
    
    [_model refreshNumSelectedModelWithInputValue:inputNum];
    [self.skuNumSelectedView reloadData];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_model sections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_model numberOfItemsInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    if (section != SkuAdditonalInfoSection) {
        return size = CGSizeMake(collectionView.width, [JMSkuGroupHeader viewHeight]);
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_model sizeForItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SkuAdditonalInfoSection) {
        return nil;
    }
    JMSkuGroupHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[JMSkuGroupHeader jm_identifier] forIndexPath:indexPath];
    id<JMComponentModel> model = [_model headerDataForItemAtIndexPath:indexPath];
    [header reloadWithData:model];
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [_model cellIdentifierForCellAtIndexPath:indexPath];
    UICollectionViewCell<JMComponent> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([cell isKindOfClass:[JMSkuNumSelectedCell class]]) {
        self.skuNumSelectedView = (JMSkuNumSelectedCell *)cell;
        [(JMSkuNumSelectedCell *)cell setDelegate:self];
    } else if ([cell isKindOfClass:[JMSkuCell class]]) {
        [(JMSkuCell *)cell setDelegate:self];
    }
    
    id<JMComponentModel> model = [_model cellDataForItemAtIndexPath:indexPath];
    [cell reloadWithData:model];
    return cell;
}

#pragma mark - Setter


#pragma mark - Getter

- (JMSkuDisplayView *)skuDisplayView {
    if (!_skuDisplayView) {
        _skuDisplayView = [JMSkuDisplayView instanceFromNib];
        __weak __typeof(self) weakSelf = self;
        _skuDisplayView.closeButtonDidClickBlock = ^(JMSkuDisplayView *view) {
            if ([weakSelf.delegate respondsToSelector:@selector(jmSkuSelectedViewDidPerformCloseAction:)]) {
                [weakSelf.delegate jmSkuSelectedViewDidPerformCloseAction:weakSelf];
            }
            [weakSelf dismiss];
        };
    }
    return _skuDisplayView;
}

- (JMSkuConfirmView *)skuConfirmView {
    if (!_skuConfirmView) {
        _skuConfirmView = [JMSkuConfirmView instanceFromNib];
        __weak __typeof(self) weakSelf = self;
        _skuConfirmView.didClickBlock = ^(JMSkuConfirmView *view) {
            if (!weakSelf.model.isSelectedAllGroup) {
                [weakSelf showTip:weakSelf.model.skuDisplayModel.selectingTip];
                return;
            }
            
            if ([weakSelf.delegate respondsToSelector:@selector(jmSkuSelectedViewDidPerformConfirmAction:)]) {
                [weakSelf.delegate jmSkuSelectedViewDidPerformConfirmAction:weakSelf];
            }
        };
    }
    return _skuConfirmView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JMCollectionViewLeftAlignLayout *flowLayout = [[JMCollectionViewLeftAlignLayout alloc] init];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerNib:[JMSkuGroupHeader jm_nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[JMSkuGroupHeader jm_identifier]];
        
        [collectionView registerNib:[JMSkuAdditionalInfoCell jm_nib] forCellWithReuseIdentifier:[JMSkuAdditionalInfoCell jm_identifier]];
        [collectionView registerNib:[JMSkuCell jm_nib] forCellWithReuseIdentifier:[JMSkuCell jm_identifier]];
        [collectionView registerNib:[JMSkuNumSelectedCell jm_nib] forCellWithReuseIdentifier:[JMSkuNumSelectedCell jm_identifier]];
        [collectionView registerNib:[JMSkuConfirmView jm_nib] forCellWithReuseIdentifier:[JMSkuConfirmView jm_identifier]];
        _collectionView = collectionView;
    }
    return _collectionView;
}


@end
