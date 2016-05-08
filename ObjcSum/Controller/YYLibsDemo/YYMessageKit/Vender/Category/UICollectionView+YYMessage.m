//
//  UICollectionView+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/4/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UICollectionView+YYMessage.h"

@implementation UICollectionView (YYMessage)

- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self numberOfSections] == 0) {
        return;
    }
    NSInteger items = [self numberOfItemsInSection:0];
    if (items == 0) {
        return;
    }
    CGFloat collectionViewContentHeight = [self.collectionViewLayout collectionViewContentSize].height;
    BOOL isContentTooSmall = collectionViewContentHeight < CGRectGetHeight(self.bounds);
    if (!isContentTooSmall) {
        NSInteger finalRow = items - 1;
        NSIndexPath *finalPath = [NSIndexPath indexPathForItem:finalRow inSection:0];
        
        //  workaround for really long messages not scrolling
        //  if last message is too long, use scroll position bottom for better appearance, else use top
        //  possibly a UIKit bug, see #480 on GitHub
//        CGFloat maxHeightForVisibleMessage = CGRectGetHeight(self.bounds) - self.contentInset.top;
        
        
        [self scrollToItemAtIndexPath:finalPath atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
    } else {
        //  workaround for the first few messages not scrolling
        //  when the collection view content size is too small, `scrollToItemAtIndexPath:` doesn't work properly
        //  this seems to be a UIKit bug, see #256 on GitHub
//        [self scrollRectToVisible:CGRectMake(0, collectionViewContentHeight - 1, 1, 1) animated:animated];
    }
}

@end





























