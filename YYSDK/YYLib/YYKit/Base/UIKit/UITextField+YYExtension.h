//
//  UITextField+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/15.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YYExtension)

/**
 Set all text selected.
 */
- (void)selectAllText;

/**
 Set text in range selected.
 
 @param range  The range of selected text in a document.
 */
- (void)setSelectedRange:(NSRange)range;

@end
