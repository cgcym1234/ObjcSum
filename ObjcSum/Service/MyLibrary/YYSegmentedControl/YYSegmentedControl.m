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
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.cellIdentifier = CellIdentifierDefault;
    [self.collectionView registerNib:[UINib nibWithNibName:_cellIdentifier bundle:nil] forCellWithReuseIdentifier:_cellIdentifier];
    if (_dataArray.count > 0) {
        [self reloadData];
    }
}

#pragma mark - Override

- (void)layoutSubviews {
    if (!CGRectEqualToRect(self.bounds, self.collectionView.frame)) {
        self.collectionView.frame = self.bounds;
        [self resetItemLayout];
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

#pragma mark - Public

- (void)reloadData {
    [_collectionView reloadData];
}

- (void)resetItemLayout {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark- UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds)/_dataArray.count, CGRectGetHeight(collectionView.bounds));;
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


@end
