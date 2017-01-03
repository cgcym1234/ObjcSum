//
//  YYSegmentedView.m
//  ObjcSum
//
//  Created by yangyuan on 2016/11/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYSegmentedView.h"
#import "UIView+Frame.h"
#import "UIColor+YYSDK.h"

@interface YYSegmentedView ()<UIScrollViewDelegate>

//条形指示条
@property (nonatomic, strong) UIView *indicatorView;

@property(nonatomic, strong) NSMutableArray<UIButton *> *titleItems;

@end

@implementation YYSegmentedView


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
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    
    _titleItems = [NSMutableArray new];
    _prevIndex = 0;
    _selectedIndex = 0;
    
    _fixedItemWidth = 0;
    _paddingLeftRight = 10;
    
    _titleColorNomal = [UIColor colorWithHexString:@"0x333333"];
    _titleColorSelected = [UIColor colorWithHexString:@"0xF33873"];
    _titleFont = [UIFont systemFontOfSize:14];
    
    _indicatorViewEnable = YES;
    _indicatorViewHeight = 2;
    
    _bottomLineEnable = NO;
    _bottomLineColor = [UIColor colorWithHexString:@"d8d8d8"];
    
    [self addSubview:self.indicatorView];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutItems];
}

#pragma mark - Action

- (void)titleButtonDidClicked:(UIButton *)button {
    NSInteger index = button.tag;
    if (index != _selectedIndex) {
        [self setSelectedIndex:index animated:YES notify:YES];
    }
}

#pragma mark - Public

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    //数量不相等的话重建
    if (titles.count != _titleItems.count) {
        [self removeTitleItems];
        [self addTitleItems];
    }
    [self updateTitleItems];
    [self setNeedsLayout];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self updateTitleItems];
}

- (void)setTitleColorNomal:(UIColor *)titleColorNomal {
    _titleColorNomal = titleColorNomal;
    [self updateTitleItems];
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected {
    _titleColorSelected = titleColorSelected;
    [self updateTitleItems];
}

- (void)setIndicatorViewEnable:(BOOL)indicatorViewEnable {
    _indicatorViewEnable = indicatorViewEnable;
    _indicatorView.hidden = !indicatorViewEnable;
    _indicatorView.height = indicatorViewEnable ? _indicatorViewHeight : 0;
    [self setNeedsLayout];
}

- (void)setIndicatorViewHeight:(CGFloat)indicatorViewHeight {
    if (_indicatorViewHeight == indicatorViewHeight) {
        return;
    }
    _indicatorViewHeight = indicatorViewHeight;
    [self setNeedsLayout];
}

- (void)setfixedItemWidth:(CGFloat)fixedItemWidth {
    if (_fixedItemWidth == fixedItemWidth) {
        return;
    }
    _fixedItemWidth = fixedItemWidth;
    [self setNeedsLayout];
}

- (void)setPaddingLeftRight:(CGFloat)paddingLeftRight {
    if (_paddingLeftRight == paddingLeftRight) {
        return;
    }
    _paddingLeftRight = paddingLeftRight;
    [self setNeedsLayout];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    if (![self isValidIndex:index]) {
        return;
    }
    
    if (_selectedIndex == index) {
        return;
    }
    
    _prevIndex = _selectedIndex;
    _selectedIndex = index;
    
    [self setIndicatorViewToIndex:index animated:animated];
    [self scrollToIndex:index animated:animated];
    
    _titleItems[_prevIndex].enabled = YES;
    _titleItems[_selectedIndex].enabled = NO;
    
    if (notify && _indexChangedBlock) {
        _indexChangedBlock(self, _selectedIndex, _prevIndex);
    }
}

#pragma mark - Private

- (BOOL)isValidIndex:(NSInteger)index {
    return index >= 0 && index < _titleItems.count;
}

- (void)layoutItems {
    [self layoutTitleItems];
    [self layoutIndicatorView];
    
//    [self scrollToIndex:_selectedIndex animated:NO];
}

- (void)removeTitleItems {
    [_titleItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item removeFromSuperview];
    }];
    [_titleItems removeAllObjects];
}

- (void)addTitleItems {
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *item = [self titleButton];
        item.tag = idx;
        [self addSubview:item];
        [_titleItems addObject:item];
    }];
}

- (void)updateTitleItems {
    [_titleItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitle:_titles[idx] forState:UIControlStateNormal];
        [item setTitle:_titles[idx] forState:UIControlStateDisabled];
        [item setTitleColor:_titleColorNomal forState:UIControlStateNormal];
        [item setTitleColor:_titleColorSelected forState:UIControlStateDisabled];
        item.titleLabel.font = _titleFont;
        item.enabled = idx != _selectedIndex;
    }];
//    _indicatorView.backgroundColor = _titleColorSelected;
}

- (void)layoutTitleItems {
    __block CGFloat itemWith = 0;
    CGFloat itemHeight = self.height - _indicatorViewHeight;
    __block CGFloat x = 0;
    [_titleItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        itemWith = _fixedItemWidth > 0 ? _fixedItemWidth : (item.titleLabel.intrinsicContentSize.width + _paddingLeftRight);
        item.frame = CGRectMake(x, 0, itemWith, itemHeight);
        x += itemWith;
    }];
    self.contentSize = CGSizeMake(x + itemWith, 0);
}

- (void)layoutIndicatorView {
    _indicatorView.height = _indicatorViewHeight;
    _indicatorView.y = self.height - _indicatorViewHeight;
    [self setIndicatorViewToIndex:_selectedIndex animated:NO];
}

// 让选中的item位于中间
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.contentSize.width <= self.bounds.size.width || !self.scrollEnabled) {
        return;
    }
    
    CGRect frame = _titleItems[index].frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.width;
    CGSize contentSize = self.contentSize;
    if (itemX > width/2) {
        CGFloat targetX;
        if ((contentSize.width-itemX) <= width/2) {
            targetX = contentSize.width - width;
        } else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        // 应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self setContentOffset:CGPointMake(targetX, 0) animated:animated];
    } else {
        [self setContentOffset:CGPointMake(0, 0) animated:animated];
    }
}

- (void)setIndicatorViewToIndex:(NSInteger)index animated:(BOOL)animated {
    UIButton *selectedItem =  _titleItems[index];
    void(^block)() = ^{
        _indicatorView.width = selectedItem.width + 2;
        _indicatorView.centerX = selectedItem.centerX;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:block];
    } else {
        block();
    }
}

#pragma mark - Delegate

#pragma mark - UIScrollViewDelegate


#pragma mark - Setter



#pragma mark - Getter

- (UIView *)indicatorView {
    if (!_indicatorView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bottomLine_selected"].CGImage);
        view.layer.contentsScale = [UIScreen mainScreen].scale;
        view.layer.contentsCenter = CGRectMake(0.25, 1, 0.5, 0);
        view.hidden = !_indicatorViewEnable;
        _indicatorView = view;
    }
    return _indicatorView;
}

- (UIButton *)titleButton {
    UIButton *button = [UIButton new];
    button.contentEdgeInsets = UIEdgeInsetsZero;
    button.titleLabel.font = _titleFont;
    [button setTitleColor:_titleColorNomal forState:UIControlStateNormal];
    [button setTitleColor:_titleColorSelected forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(titleButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSInteger)totalIndex {
    return _titleItems.count;
}

@end





