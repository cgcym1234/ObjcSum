//
//  YYSegmentedControl.m
//  MLLSalesAssistant
//
//  Created by sihuan on 16/3/16.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "YYSegmentedControl.h"

#pragma mark - Const

#define ScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])

static NSString * const CellIdentifierDefault = @"YYSegmentedControlCell";

@interface YYSegmentedControl ()
<UICollectionViewDelegate, UICollectionViewDataSource>

//使用UICollectionView实现
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, assign) CGSize itemSize;

//条形指示条
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation YYSegmentedControl


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArr {
    _dataArray = dataArr;
    return [self initWithFrame:frame];
}

- (void)setContext {
    self.bottomLineEnable = YES;
    self.bottomLineColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.indicatorView];
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.cellIdentifier = CellIdentifierDefault;
    [self.collectionView registerNib:[UINib nibWithNibName:_cellIdentifier bundle:nil] forCellWithReuseIdentifier:_cellIdentifier];
    
    if (_dataArray.count > 0) {
        [self reloadData];
    }
}


- (void)layoutSubviews {
    if (!CGRectEqualToRect(self.bounds, self.collectionView.frame)) {
        self.collectionView.frame = self.bounds;
        [self resetItemLayout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setIndicatorLocationAtIndex:_selectedIndex animation:NO];
        });
    }
}

- (void)drawRect:(CGRect)rect {
    if (_bottomLineEnable && _bottomLineColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, _bottomLineColor.CGColor);
        CGContextMoveToPoint(context, 0, self.frame.size.height-0.5);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
        CGContextStrokePath(context);
    }
}

- (void)setIndicatorLocationAtIndex:(NSInteger)index {
    [self setIndicatorLocationAtIndex:index animation:YES];
}

- (void)setIndicatorLocationAtIndex:(NSInteger)index animation:(BOOL)animation {
    CGFloat _itemWith = _itemSize.width;
    if (!_indicatorViewEnable || _itemWith <= 0 || _itemWith >= CGFLOAT_MAX) {
        return;
    }
    
    _indicatorView.hidden = !_indicatorViewEnable;
    CGFloat positionX = _itemWith * index;
    CGFloat height = CGRectGetHeight(self.bounds);
    
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            _indicatorView.frame = CGRectMake(positionX, height - _indicatorViewHeight, _itemWith, _indicatorViewHeight);
        }];
    } else {
        _indicatorView.frame = CGRectMake(positionX, height - _indicatorViewHeight, _itemWith, _indicatorViewHeight);
    }
}


#pragma mark - Public

- (void)reloadData {
    [_collectionView reloadData];
}

- (void)resetItemLayout {
    [_collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark- UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.itemSize = CGSizeMake(CGRectGetWidth(collectionView.bounds)/_dataArray.count, CGRectGetHeight(collectionView.bounds));
    return _itemSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<YYSegmentedControlItem> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.item;
    [cell renderWithItem:_dataArray[indexPath.item] atIndex:indexPath.item inSegmentControl:self];
    [cell setSelected:cell.tag == _selectedIndex animated:NO];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_selectedIndex == indexPath.item) {
        return;
    }
    
    UICollectionViewCell<YYSegmentedControlItem> *cell = (UICollectionViewCell<YYSegmentedControlItem> *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
    if (cell) {
        [cell setSelected:NO animated:YES];
    }
    
    _selectedIndex = indexPath.item;
    
    cell = (UICollectionViewCell<YYSegmentedControlItem> *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [cell setSelected:YES animated:YES];
    }
    
    [self setIndicatorLocationAtIndex:_selectedIndex];
    
    if ([self.delegate respondsToSelector:@selector(yySegmentedControl:didSelectItemAtIndex:)]) {
        [self.delegate yySegmentedControl:self didSelectItemAtIndex:_selectedIndex];
    }
}


#pragma mark - Setter

- (void)setDataArr:(NSArray *)dataArr {
    if (dataArr.count != _dataArray.count) {
        [self resetItemLayout];
    }
    _totalNum = dataArr.count;
    _dataArray = dataArr;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    [self reloadData];
    [self setIndicatorLocationAtIndex:_selectedIndex];
}

- (void)setIndicatorViewEnable:(BOOL)indicatorViewEnable {
    _indicatorViewEnable = indicatorViewEnable;
    self.indicatorView.hidden = !indicatorViewEnable;
    if (indicatorViewEnable) {
        [self layoutIfNeeded];
    }
}

- (void)setIndicatorViewHeight:(CGFloat)indicatorViewHeight {
    if (_indicatorViewHeight == indicatorViewHeight) {
        return;
    }
    _indicatorViewHeight = indicatorViewHeight;
    if (_indicatorViewEnable) {
        [self layoutIfNeeded];
    }
}

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [self setIndicatorViewWith:itemSize.width];
    }
}

- (void)setIndicatorViewWith:(CGFloat)width {
    CGRect frame = _indicatorView.frame;
    frame.size.width = width;
    _indicatorView.frame = frame;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.bounces = NO;
        collectionView.pagingEnabled = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        flowLayout.headerReferenceSize = CGSizeZero;
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorViewHeight = 2;
        _indicatorViewEnable = YES;
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, CGRectGetHeight(_collectionView.bounds) - _indicatorViewHeight, 0, _indicatorViewHeight);
        view.backgroundColor = ItemColorSelected;
        _indicatorView.hidden = YES;
        _indicatorView = view;
    }
    return _indicatorView;
}


@end
