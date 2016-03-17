//
//  YYScrollSigment.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYScrollSigment.h"
#import "YYScrollSigmentCell.h"

#define CellIdentifierDefault @"YYScrollSigmentCell"



@interface YYScrollSigment ()<UICollectionViewDelegate, UICollectionViewDataSource>

#pragma mark - 当显示图片的时候，滑动到选中的item
@property (nonatomic, assign) BOOL needScrollToSelectedIndex;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) CGSize itemSize;

@end

@implementation YYScrollSigment

#pragma mark - Init

- (void)awakeFromNib {
    [self envInit];
}

- (instancetype)init {
    return [self initWithDataArr:nil frame:CGRectZero cellXibName:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithDataArr:nil frame:frame cellXibName:nil];
}

- (instancetype)initWithDataArr:(NSArray *)dataArr frame:(CGRect)frame {
    return [self initWithDataArr:dataArr frame:frame cellXibName:nil];
}

- (instancetype)initWithDataArr:(NSArray *)dataArr {
    return [self initWithDataArr:dataArr frame:CGRectZero cellXibName:nil];
}

#pragma mark - 可以使用自定义cell,传入xib名称
- (instancetype)initWithDataArr:(NSArray *)dataArr frame:(CGRect)frame cellXibName:(NSString *)cellXibName {
    if (self = [super initWithFrame:frame]) {
        [self envInit];
        self.dataArr = dataArr;
    }
    return self;
}

- (void)envInit {
    _pagingEnabled = NO;
    _itemSizeAuto = YES;
    
    _itemWith = 0;
    _indicatorViewHeight = 4;
    _indicatorViewEnable = YES;
    
    _bottomLineEnable = YES;
    _bottomLineColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    
    [self addSubview:self.collectionView];
    [_collectionView addSubview:self.indicatorView];
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    _cellIdentifier = CellIdentifierDefault;
    [_collectionView registerNib:[UINib nibWithNibName:_cellIdentifier bundle:nil] forCellWithReuseIdentifier:_cellIdentifier];
    
    
}

- (void)layoutSubviews {
    //    CGRect frame = self.frame;
    //    CGFloat width = CGRectGetWidth(self.superview.bounds);
    //    frame.size.width = width;
    //    self.frame = frame;
    //旋转相关
    if (!CGRectEqualToRect(self.bounds, self.collectionView.frame)) {
        self.collectionView.frame = self.bounds;
        [self.collectionView.collectionViewLayout invalidateLayout];
        
        if (_itemSizeAuto) {
            _itemWith = CGRectGetWidth(self.bounds)/_dataArr.count;
        }
        
        [self setIndicatorLocationAtIndex:_currentIndex animation:NO];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        flowLayout.headerReferenceSize = CGSizeZero;
        
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.alwaysBounceHorizontal = YES;
        collectionView.pagingEnabled = _pagingEnabled;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView = collectionView;
        _flowLayout = flowLayout;
    }
    return _collectionView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, CGRectGetHeight(_collectionView.bounds) - _indicatorViewHeight, _itemWith, _indicatorViewHeight);
        view.backgroundColor = ItemColorSelected;
        _indicatorView = view;
        _indicatorView.hidden = !_indicatorViewEnable;
    }
    return _indicatorView;
}

#pragma mark - Private

- (void)reloadData {
    
    if (_itemSizeAuto) {
        _itemWith = CGRectGetWidth(self.bounds)/_dataArr.count;
    }
    
    [_collectionView reloadData];
    
    if (!_itemSizeAuto) {
        [self scrollToIndex:_currentIndex animated:YES];
    }
    
    [self setIndicatorLocationAtIndex:_currentIndex];
}


#pragma mark - Public

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

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    _totalIndex = dataArr.count;
    [self reloadData];
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    _collectionView.pagingEnabled = pagingEnabled;
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


#pragma mark 滑到某个item
- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    [self reloadData];
}

- (void)scrollToIndex:(NSInteger)idx animated:(BOOL)animated {
    if (_collectionView.contentSize.width <= _collectionView.bounds.size.width) {
        return;
    }
    CGFloat positionX = idx * _itemWith;
    CGFloat maxContenOffsetX = (_itemWith * _totalIndex) - CGRectGetWidth(self.collectionView.bounds);
    CGFloat contentOffsetX = MIN(MAX(0, positionX-_itemWith/2), maxContenOffsetX);
    if (contentOffsetX != _collectionView.contentOffset.x) {
        [_collectionView setContentOffset:CGPointMake(contentOffsetX, 0) animated:animated];
    }
}


#pragma mark- UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize = CGSizeMake(_itemWith, CGRectGetHeight(self.bounds));
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<YYScrollSigmentCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.item;
    [cell updateWithItem:_dataArr[indexPath.item] atIndexPath:indexPath inView:self];
    [cell setSelected:cell.tag == _currentIndex animated:NO];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_currentIndex == indexPath.item) {
        return;
    }
    
    UICollectionViewCell<YYScrollSigmentCellProtocol> *cell = (UICollectionViewCell<YYScrollSigmentCellProtocol> *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    if (cell) {
        [cell setSelected:NO animated:YES];
    }
    
    _currentIndex = indexPath.item;
    
    cell = (UICollectionViewCell<YYScrollSigmentCellProtocol> *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [cell setSelected:YES animated:YES];
    }
    
    [self setIndicatorLocationAtIndex:_currentIndex];
    if (_didSelectedItemBlock) {
        _didSelectedItemBlock(self, _currentIndex);
    }
}


- (void)setIndicatorLocationAtIndex:(NSInteger)index {
    [self setIndicatorLocationAtIndex:index animation:YES];
}

- (void)setIndicatorLocationAtIndex:(NSInteger)index animation:(BOOL)animation {
    if (!_indicatorViewEnable || _itemWith <= 0 || _itemWith >= CGFLOAT_MAX) {
        return;
    }
    
    CGFloat positionX = _itemWith * index;
    CGFloat height = CGRectGetHeight(self.bounds);
    
    
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            _indicatorView.frame = CGRectMake(positionX, height - _indicatorViewHeight, _itemWith, _indicatorViewHeight);
            [self scrollToIndex:index animated:NO];
        }];
    } else {
        _indicatorView.frame = CGRectMake(positionX, height - _indicatorViewHeight, _itemWith, _indicatorViewHeight);
    }
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    NSInteger page=(NSInteger)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%_totalIndex;
//
//    if (_currentIndex != page) {
//        _currentIndex = page;
//        if (_didScrollingBlock) {
//            _didScrollingBlock(self, page);
//        }
//    }
//
//}


@end
