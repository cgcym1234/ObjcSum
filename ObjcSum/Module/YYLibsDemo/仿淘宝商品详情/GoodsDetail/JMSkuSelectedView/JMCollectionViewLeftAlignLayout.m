//
//  JMCollectionViewLeftAlignLayout.m
//  ObjcSum
//
//  Created by yangyuan on 2016/12/29.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "JMCollectionViewLeftAlignLayout.h"
#import "JMSkuSelectedViewConsts.h"

@interface JMCollectionViewLeftAlignLayout ()

@end

@implementation JMCollectionViewLeftAlignLayout

- (void)prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = JMSkuSelectedViewSkuItemSpacing;
    self.minimumLineSpacing = JMSkuSelectedViewSkuLineSpacing;
    self.sectionInset = UIEdgeInsetsMake(0, JMSkuSelectedViewPaddingLeftRight, JMSkuSelectedViewSkuItemSpacing, JMSkuSelectedViewPaddingLeftRight);
    self.footerReferenceSize = CGSizeZero;
    self.headerReferenceSize = CGSizeZero;
    self.itemSize = CGSizeMake(10, 10);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray<UICollectionViewLayoutAttributes *> *attris = [[NSMutableArray alloc] initWithArray:attributes copyItems:YES];
    
    if (attris.count > 0) {
        CGFloat maxX = self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right);
        UICollectionViewLayoutAttributes *attrPrev = attributes.firstObject;
        UICollectionViewLayoutAttributes *attrCurrent = attributes.firstObject;
        
        for (int i = 1; i < attris.count; i++) {
            attrCurrent = attris[i];
            CGFloat prevCellMaxX = CGRectGetMaxX(attrPrev.frame);
            if (prevCellMaxX < maxX - self.minimumInteritemSpacing ) {
                CGFloat expectedCurrentCellX = prevCellMaxX + self.minimumInteritemSpacing;
                CGFloat currentCellWith = attrCurrent.frame.size.width;
                if (expectedCurrentCellX != attrCurrent.frame.origin.x && expectedCurrentCellX + currentCellWith <= maxX) {
                    attrCurrent.frame = CGRectMake(expectedCurrentCellX, attrCurrent.frame.origin.y, currentCellWith, attrCurrent.frame.size.height);
                }
            }
            attrPrev = attrCurrent;
        }
    }
    
    return attris;
}


@end

























