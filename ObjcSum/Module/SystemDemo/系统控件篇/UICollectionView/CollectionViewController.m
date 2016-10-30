//
//  UICollectionViewController.m
//  UI控件
//
//  Created by michael chen on 14-9-26.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "CollectionViewController.h"

#define CellIdentifier @"cell"

@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectinView;
    NSArray *_imageNames;
}
@end

@implementation CollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageNames=@[
               @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
               @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
               @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
               @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
               @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
               
               @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
               
               @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
               
               @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
               
               @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"
               ];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self collectionViewDemo];
    
}

#pragma mark - UICollectionView相关方法和属性
- (void)collectionViewDemo
{
    #pragma mark - UICollectionViewFlowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.itemSize = CGSizeMake(200, 200);
    flowLayout.headerReferenceSize = CGSizeMake(200, 100);
    flowLayout.footerReferenceSize = CGSizeMake(200, 100);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    #pragma mark - UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    #pragma mark - 属性
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //collectionView.collectionViewLayout;
    
    // will be automatically resized to track the size of the collection view and placed behind all cells and supplementary views.
    //collectionView.backgroundView;
    
    collectionView.allowsSelection = YES;   // default is YES
    collectionView.allowsMultipleSelection = NO;    // default is NO
    
    
    /**
     *  弹簧效果打开后，可能会出现滑动太快，界面衔接不上的情况
     */
    collectionView.bounces = YES;
    collectionView.pagingEnabled = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    
    #pragma mark - Cell相关
    //必须使用下面的方法进行Cell类的注册
    [collectionView registerNib:[UINib nibWithNibName:@"YYCycleScrollViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    /**
     *  // If a class is registered, it will be instantiated via alloc/initWithFrame:
     - (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
     - (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
     
     - (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
     - (void)registerNib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;
     
     - (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;
     - (id)dequeueReusableSupplementaryViewOfKind:(NSString*)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;
     */
    
//    NSArray *visibleCells = [collectionView visibleCells];
//    UICollectionViewCell *cellForItemAtIndexPath = [collectionView cellForItemAtIndexPath:nil];
    
    
    #pragma mark - indexPath相关
//    NSArray *indexPathsForSelectedItems = [collectionView indexPathsForSelectedItems];
//    NSArray *indexPathsForVisibleItems = [collectionView indexPathsForVisibleItems];
//    NSIndexPath *indexPathForItemAtPoint = [collectionView indexPathForItemAtPoint:CGPointZero];
//    NSIndexPath *indexPathForCell = [collectionView indexPathForCell:nil];
    /**
     - (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
     - (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
     */
    
    #pragma mark - UICollectionViewLayout切换
    /**
     - (void)setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated; // transition from one layout to another
     - (void)setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
     
     - (UICollectionViewTransitionLayout *)startInteractiveTransitionToCollectionViewLayout:(UICollectionViewLayout *)layout completion:(UICollectionViewLayoutInteractiveTransitionCompletion)completion NS_AVAILABLE_IOS(7_0);
     - (void)finishInteractiveTransition NS_AVAILABLE_IOS(7_0);
     - (void)cancelInteractiveTransition NS_AVAILABLE_IOS(7_0);
     */
    
//    UICollectionViewLayoutAttributes *layoutAttributesForItemAtIndexPath = [collectionView layoutAttributesForItemAtIndexPath:nil];
//    UICollectionViewLayoutAttributes *layoutAttributesForSupplementaryElement= [collectionView layoutAttributesForSupplementaryElementOfKind:nil atIndexPath:nil];
    
    
    /**
     *  // Interacting with the collection view.
     
     - (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
     */
    
    #pragma mark - 动态修改内容
    /**
     // These methods allow dynamic modification of the current set of items in the collection view
     
     - (void)insertSections:(NSIndexSet *)sections;
     - (void)deleteSections:(NSIndexSet *)sections;
     - (void)reloadSections:(NSIndexSet *)sections;
     - (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;
     
     - (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
     - (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
     - (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;
     - (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
     
     - (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion; // allows multiple insert/delete/reload/move calls to be animated simultaneously. Nestable.

     */
    
    
    [self.view addSubview:collectionView];
    _collectinView = collectionView;
}


#pragma mark- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageNames.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    [cell updateWithItem:_imageNames[indexPath.item] inCycleScrollView:nil atIndexPath:indexPath];
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(_collectinView.bounds), 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(200, 100);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(200, 100);
}

#pragma mark - UICollectionViewDelegate

#pragma mark - 选中和取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// called when the user taps on an already-selected item in multi-select mode
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - These methods provide support for copy/paste actions on cells.
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}

#pragma mark - support for custom transition layout
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    return nil;
}








































@end
