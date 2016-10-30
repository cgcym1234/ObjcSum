//
//  MyCollectionViewLayout.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/24.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "MyCollectionViewLayout.h"

@implementation MyCollectionViewLayout

#pragma mark - property
/**
 *  @property (nonatomic, readonly) UICollectionView *collectionView;
 

 */

#pragma mark - func

/**
*  Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
*  Subclasses must always call super if they override.
*/
- (void)invalidateLayout {
    [super invalidateLayout];
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)elementKind {
    [super registerClass:viewClass forDecorationViewOfKind:elementKind];
}
- (void)registerNib:(UINib *)nib forDecorationViewOfKind:(NSString *)elementKind {
    [super registerNib:nib forDecorationViewOfKind:elementKind];
}

#pragma mark - UISubclassingHooks

// provide a custom class to be used when instantiating instances of UICollectionViewLayoutAttributes
+ (Class)layoutAttributesClass {
    return [super layoutAttributesClass];
}

//provide a custom class to be used for invalidation contexts
+ (Class)invalidationContextClass {
    return [super invalidationContextClass];
}

/**
 The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
 The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
 Subclasses should always call super if they override.
 */
- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark UICollectionView calls these four methods to determine the layout information.
/**
 Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}
/**
 *  Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

//If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes
                                    withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes NS_AVAILABLE_IOS(8_0) {
    return YES;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
    return [super invalidationContextForBoundsChange:newBounds];
}
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes NS_AVAILABLE_IOS(8_0) {
    return [super invalidationContextForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
}

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return CGPointZero;
}

// a layout can return the content offset to be applied during transition or update animations
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0) {
    return CGPointZero;
}

/**
 *  Subclasses must override this method and use it to return the width and height of the collection view’s content. 
 
 These values represent the width and height of all the content, not just the content that is currently visible. 
 The collection view uses this information to configure its own content size to facilitate scrolling.
 */
- (CGSize)collectionViewContentSize {
    return CGSizeZero;
}

#pragma mark - UIUpdateSupportHooks - This method is called when there is an update with deletes/inserts to the collection view.

/**
 *  It will be called prior to calling the initial/final layout attribute methods  below 
 to give the layout an opportunity to do batch computations for the insertion and deletion layout attributes.
 
 The updateItems parameter is an array of UICollectionViewUpdateItem instances for each element that is moving to a new index path.
 */
- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    
}
// called inside an animation block after the update
- (void)finalizeCollectionViewUpdates {
    
}

// UICollectionView calls this when its bounds have changed inside an animation block before displaying cells in its new bounds
- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds {
    
}
- (void)finalizeAnimatedBoundsChange {
    
}


// UICollectionView calls this when prior the layout transition animation on the incoming and outgoing layout
- (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout NS_AVAILABLE_IOS(7_0) {
    
}
- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout NS_AVAILABLE_IOS(7_0) {
    
}
// called inside an animation block after the transition
- (void)finalizeLayoutTransition NS_AVAILABLE_IOS(7_0) {
    
}

#pragma mark This set of methods is called when the collection view undergoes an animated transition such as a batch update block or an animated bounds change.
/**
 - (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
 - (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
 - (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath;
 - (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath;
 - (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath;
 - (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath;
 */

#pragma mark These methods are called by collection view during an update block.
/**
 *  // Return an array of index paths to indicate views that the layout is deleting or inserting in response to the update.
 - (NSArray *)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0);
 - (NSArray *)indexPathsToDeleteForDecorationViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0);
 - (NSArray *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0);
 - (NSArray *)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0);
 */


#pragma mark - UICollectionViewLayoutAttributes
- (void)uicollectionViewAttributes {
    /**
     *  UICollectionViewLayoutAttributes的实例中包含了诸如边框，中心点，大小，形状，透明度，层次关系和是否隐藏等信息。
     和DataSource的行为十分类似，当UICollectionView在获取布局时将针对每一个indexPath的部件（包括cell，追加视图和装饰视图），
     向其上的UICollectionViewLayout实例询问该部件的布局信息（在这个层面上说的话，实现一个UICollectionViewLayout的时候，其实很像是zap一个delegate，之后的例子中会很明显地看出），
     这个布局信息，就以UICollectionViewLayoutAttributes的实例的方式给出。
     */
#pragma mark property
    /**
     @property (nonatomic) CGRect frame;
     @property (nonatomic) CGPoint center;
     @property (nonatomic) CGSize size;
     @property (nonatomic) CATransform3D transform3D;
     @property (nonatomic) CGRect bounds NS_AVAILABLE_IOS(7_0);
     @property (nonatomic) CGAffineTransform transform NS_AVAILABLE_IOS(7_0);
     @property (nonatomic) CGFloat alpha;
     @property (nonatomic) NSInteger zIndex; // default is 0
     @property (nonatomic, getter=isHidden) BOOL hidden; // As an optimization, UICollectionView might not create a view for items whose hidden attribute is YES
     @property (nonatomic, retain) NSIndexPath *indexPath;
     
     @property (nonatomic, readonly) UICollectionElementCategory representedElementCategory;
     @property (nonatomic, readonly) NSString *representedElementKind; // nil when representedElementCategory is UICollectionElementCategoryCell
     
     */
    
    
#pragma mark  Init
    /**
     + (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath;
     + (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath;
     + (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath*)indexPath;
     */
}








































@end
