//
//  YYImageBrowser.m
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import "YYImageBrowser.h"
#import "YYImageBrowserCell.h"
#import "YYTransitioningDelegate.h"

static NSString * const reuseIdentifier = @"Cell";
static CGFloat  const countLabelWidth = 40;

@implementation YYImageBrowserItemModel

+ (instancetype)instanceWithBigImageUrl:(NSString *)bigImageUrl smallImageUrl:(NSString *)smallImageUrl {
    YYImageBrowserItemModel *item = [YYImageBrowserItemModel new];
    item.bigImageUrl = bigImageUrl;
    item.smallImageUrl = smallImageUrl;
    return item;
}
@end


@interface YYImageBrowser ()
<UICollectionViewDelegate, UICollectionViewDataSource, YYImageBrowserCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YYTransitioningDelegate *transitionDelegate;
@property (nonatomic, assign) NSInteger totalPages;

@end

@implementation YYImageBrowser

#pragma mark - Initialization
- (instancetype)initWithPhotoUrlStrings:(NSArray *)photoUrlStrings {
    if ((self = [super init])) {
        self.dataArr = photoUrlStrings;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
    [self reloadDataAndScrollToPage:_showPage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _collectionView.hidden = NO;
}

- (void)setupContext {
    self.itemSpacing = 10;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.countLabel];
}

#pragma mark - Public

- (void)reloadData {
    [_collectionView reloadData];
    [_collectionView.collectionViewLayout invalidateLayout];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    if (page < _totalPages) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
        });
    }
}

- (void)reloadDataAndScrollToPage:(NSInteger)page {
    [self reloadData];
    [self scrollToPage:page animated:NO];
    _countLabel.current = page;
}

- (UIScrollView *)innerScrollView {
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _collectionView.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell updateWithItem:_dataArr[indexPath.item] inImageBrowser:self atIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.showPage = indexPath.item;
    YYImageBrowserCell *cell = (YYImageBrowserCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.transitionDelegate setAnimatingImageView:cell.imageScroll.imageView];
    
    if ([_delegate respondsToSelector:@selector(imageBrowser:willDismissAtIndex:)]) {
        [_delegate imageBrowser:self willDismissAtIndex:_showPage];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_totalPages == 0) {
        return;
    }
    
    CGRect visibleBounds = scrollView.bounds;
    NSInteger index = (NSInteger) (floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > _totalPages - 1) index = _totalPages - 1;
    
    if (_showPage != index) {
        self.showPage = index;
        if ([_delegate respondsToSelector:@selector(imageBrowser:didShowPhotoAtIndex:)]) {
            [_delegate imageBrowser:self didShowPhotoAtIndex:_showPage];
            [(UICollectionViewFlowLayout *)_collectionView.collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, -(_itemSpacing * _showPage), 0, 0)];
        }
    }
}

#pragma mark - YYImageBrowserCellDelegate
- (void)imageBrowserCellDidTap:(YYImageBrowserCell *)cell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    if (indexPath) {
        [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - Setter

- (void)setDataArr:(NSArray<NSString *> *)dataArr {
    _dataArr = [dataArr copy];
    self.totalPages = dataArr.count;
}

- (void)setAnimatingImageView:(UIImageView *)animatingImageView {
    _animatingImageView = animatingImageView;
    
    self.transitionDelegate.initialImageView = animatingImageView;
    self.transitioningDelegate = self.transitionDelegate;
}

- (void)setShowPage:(NSInteger)showPage {
    _showPage = showPage;
    self.countLabel.current = showPage;
}

- (void)setTotalPages:(NSInteger)totalPages {
    _totalPages = totalPages;
    self.countLabel.total = totalPages;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = _itemSpacing;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        flowLayout.headerReferenceSize = CGSizeZero;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        collectionView.alwaysBounceHorizontal = YES;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[YYImageBrowserCell class] forCellWithReuseIdentifier:reuseIdentifier];
        collectionView.hidden = YES;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (YYTransitioningDelegate *)transitionDelegate {
    if (!_transitionDelegate) {
        _transitionDelegate = [YYTransitioningDelegate new];
        _transitionDelegate.dismissAnimated = YES;
    }
    return _transitionDelegate;
}

- (YYCountLabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [YYCountLabel newInstance];
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat height = CGRectGetHeight(self.view.bounds);
        _countLabel.frame = CGRectMake(width-10 - countLabelWidth, height-10 - countLabelWidth, countLabelWidth, countLabelWidth);
        _countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return _countLabel;
}

@end
