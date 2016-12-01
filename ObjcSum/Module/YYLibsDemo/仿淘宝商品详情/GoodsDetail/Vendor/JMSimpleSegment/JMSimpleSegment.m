//
//  JMSimpleSegment.m
//  JuMei
//
//  Created by yangyuan on 2016/9/27.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSimpleSegment.h"
#import "UIView+Frame.h"

#pragma mark - Const

static NSString * const KeyCell = @"KeyCell";

@interface JMSimpleSegment ()

@property (nonatomic, retain) NSMutableArray<JMSimpleSegmentItem *> *items;

@end

@implementation JMSimpleSegment


#pragma mark - Initialization

- (instancetype)initWithItemModels:(NSArray<JMSimpleSegmentItemModel *> *)itemModels {
    if (self = [super initWithFrame:CGRectZero]) {
        self.itemModels = itemModels;
        [self setContext];
    }
    return self;
}

- (void)setContext {
    self.userInteractionEnabled = YES;
    
    _items = [NSMutableArray arrayWithCapacity:_itemModels.count];
    for (JMSimpleSegmentItemModel *model in _itemModels) {
        JMSimpleSegmentItem *item = [JMSimpleSegmentItem instanceFromNib];
        [item reloadWithModel:model];
        [_items addObject:item];
        [self addSubview:item];
    }
    
    _selectedIndex = 0;
    _items[_selectedIndex].selected = YES;
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutItems];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    UIView *touchedView = touch.view;
    [_items enumerateObjectsUsingBlock:^(JMSimpleSegmentItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (touchedView == item) {
            self.selectedIndex = idx;
            *stop = YES;
        }
    }];
}

#pragma mark - Private

- (void)layoutItems {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat itemWidth = self.width / _items.count;
    CGFloat itemHeight = self.height;
    for (int i = 0; i < _items.count; i++) {
        x = itemWidth * i;
        JMSimpleSegmentItem *item = _items[i];
        item.frame = CGRectMake(x, y, itemWidth, itemHeight);
    }
}

#pragma mark - Public

- (void)reloadData {
    [_itemModels enumerateObjectsUsingBlock:^(JMSimpleSegmentItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JMSimpleSegmentItem *item = _items[idx];
        [item reloadWithModel:obj];
    }];
}


#pragma mark - Delegate


#pragma mark - Setter

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex == selectedIndex || selectedIndex >= _items.count) {
        return;
    }
    _items[_selectedIndex].selected = NO;
    _items[selectedIndex].selected = YES;
    
    if (_didClickBlock) {
        _didClickBlock(self, selectedIndex);
    }
    _selectedIndex = selectedIndex;
}

#pragma mark - Getter



@end
