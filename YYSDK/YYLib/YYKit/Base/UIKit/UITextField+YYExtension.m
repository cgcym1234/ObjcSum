
//
//  UITextField+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/15.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UITextField+YYExtension.h"

@implementation UITextField (YYExtension)

/**
 Set all text selected.
 */
- (void)selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

/**
 Set text in range selected.
 
 @param range  The range of selected text in a document.
 */
- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectedRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectedRange];
}
@end
