//
//  YYHorizontalScrollView.m
//  ObjcSum
//
//  Created by sihuan on 16/6/3.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYHorizontalScrollView.h"
#import "UIView+AutoLayout.h"

#pragma mark - Const

static NSInteger const Sections = 100;
static NSString * const KeyCell = @"KeyCell";
#define IndicationCurrentPageColor                    [UIColor colorWithRed:230/255.0 green:59/255.0 blue:83/255.0 alpha:1]
#define IndicationNomalColor                          [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]

@interface YYHorizontalScrollView ()<UICollectionViewDelegate, UICollectionViewDataSource>

//使用UICollectionView实现
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *cellXibName;
@property (nonatomic, copy) NSString *cellIdentifier;

//圆点指示器
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YYHorizontalScrollView


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


- (void)setContext {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    self.pagingEnabled = YES;
    self.pageControlShow = YES;
    self.autoScrollInterval = 0;
}

#pragma mark - Override

- (void)layoutSubviews {
    if (!CGRectEqualToRect(_collectionView.frame, self.bounds)) {
        _collectionView.frame = self.bounds;
        [_collectionView.collectionViewLayout invalidateLayout];
    }
    _pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-20);
    NSLog(@"%@", self.pageControl);
}

#pragma mark - Private

- (void)addTimer {
    if (_autoScrollInterval > 0) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollInterval target:self selector:@selector(unlimitedScroll) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

// 这里就实现了无限滚动的效果
- (void)unlimitedScroll {
    // 1. 获取正在界面上显示的item项
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    // 2. 每次进来就让用户看中间那组的信息,立刻看到，没有动画(第50组)
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:indexPath.item inSection:Sections / 2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 3. 获取下一张图片的信息
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    
    if(nextItem == self.dataArray.count){
        nextItem = 0;
        nextSection++;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - Public

- (void)registerClass:(Class<YYHorizontalScrollViewCell>)cellClass {
    _cellXibName = [cellClass xibName];
    _cellIdentifier = [cellClass identifier];
    _cellXibName != nil ? [_collectionView registerNib:[UINib nibWithNibName:_cellXibName bundle:nil] forCellWithReuseIdentifier:_cellIdentifier] : [_collectionView registerClass:cellClass forCellWithReuseIdentifier:_cellIdentifier];
    _collectionView.dataSource = self;
}
- (void)reloadData {
    [_collectionView reloadData];
}

#pragma mark - Delegate

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _infiniteScroll ? Sections : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeEqualToSize(_itemSize, CGSizeZero) ? _collectionView.bounds.size : _itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<YYHorizontalScrollViewCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.item;
    [cell renderWithModel:_dataArray[indexPath.item] atIndexPath:indexPath inView:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    _currentPage = indexPath.item;
    if (_didSelectItemBlock) {
        _didSelectItemBlock(self, indexPath.item);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_totalPages == 0) {
        return;
    }
    NSInteger page=(NSInteger)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%_totalPages;
    
    if (_currentPage != page) {
        _currentPage = page;
        _pageControl.currentPage = page;
        if (_didScrollingBlock) {
            _didScrollingBlock(self, page);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    self.totalPages = dataArray.count;
}

- (void)setTotalPages:(NSInteger)totalPages {
    _totalPages = totalPages;
    _pageControl.numberOfPages = totalPages;
}

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [_collectionView.collectionViewLayout invalidateLayout];
    }
}

- (void)setInfiniteScroll:(BOOL)infiniteScroll {
    if (_infiniteScroll != infiniteScroll) {
        _infiniteScroll = infiniteScroll;
        [self reloadData];
    }
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    _collectionView.pagingEnabled = pagingEnabled;
}

- (void)setPageControlShow:(BOOL)pageControlShow {
    _pageControlShow = pageControlShow;
    _pageControl.hidden = !pageControlShow;
}

- (void)setAutoScrollInterval:(NSInteger)autoScrollInterval {
    _autoScrollInterval = autoScrollInterval;
    [self removeTimer];
    if (autoScrollInterval > 0) {
        [self addTimer];
    }
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        flowLayout.headerReferenceSize = CGSizeZero;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.alwaysBounceHorizontal = YES;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
//        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.translatesAutoresizingMaskIntoConstraints = YES;
        pageControl.bounds = CGRectMake(0, 0, 150, 20);
        
        // 一共显示多少个圆点（多少页）
        pageControl.numberOfPages = _totalPages;
        
        // 设置非选中页的圆点颜色
        pageControl.pageIndicatorTintColor = IndicationNomalColor;
        
        // 设置选中页的圆点颜色
        pageControl.currentPageIndicatorTintColor = IndicationCurrentPageColor;
        
        // 禁止默认的点击功能
        pageControl.enabled = NO;
        _pageControl = pageControl;
    }
    return _pageControl;
}


@end
