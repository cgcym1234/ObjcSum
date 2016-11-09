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

#pragma mark - Const

@interface YYSegmentedView ()<UIScrollViewDelegate>

//条形指示条
@property (nonatomic, strong) UIView *indicatorView;

@property(nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;

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
    
    _titleLabels = [NSMutableArray new];
    _prevIndex = 0;
    _selectedIndex = 0;
    
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger index = point.x / _itemWith;
    if (index != _selectedIndex) {
        [self setSelectedIndex:index animated:YES notify:YES];
    }
}

//bottomLine
- (void)drawRect:(CGRect)rect {
    if (_bottomLineEnable && _bottomLineColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, _bottomLineColor.CGColor);
        CGContextMoveToPoint(context, 0, self.frame.size.height-0.5);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
        CGContextStrokePath(context);
    }
}

#pragma mark - Public

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    //数量不相等的话重建
    if (titles.count != _titleLabels.count) {
        [self removeTitleLabels];
        [self addTitleLabels];
    }
    [self updateTitleLabels];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self updateTitleLabels];
}

- (void)setTitleColorNomal:(UIColor *)titleColorNomal {
    _titleColorNomal = titleColorNomal;
    [self updateTitleLabels];
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected {
    _titleColorSelected = titleColorSelected;
    [self updateTitleLabels];
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

- (void)setItemWith:(CGFloat)itemWith {
    if (_itemWith == itemWith) {
        return;
    }
    _itemWith = itemWith;
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
    
    _titleLabels[_prevIndex].textColor = _titleColorNomal;
    _titleLabels[_selectedIndex].textColor = _titleColorSelected;
    
    if (notify && _indexChangedBlock) {
        _indexChangedBlock(self, _selectedIndex, _prevIndex);
    }
}

#pragma mark - Private

- (BOOL)isValidIndex:(NSInteger)index {
    return index >= 0 && index < _titleLabels.count;
}

- (void)layoutItems {
    [self layoutTitleLabels];
    [self layoutIndicatorView];
    self.contentSize = CGSizeMake(_titleLabels.count * _itemWith, 0);
}

- (void)removeTitleLabels {
    [_titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        [label removeFromSuperview];
    }];
    [_titleLabels removeAllObjects];
}

- (void)addTitleLabels {
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self titleLabel];
        label.text = text;
        [self addSubview:label];
        [_titleLabels addObject:label];
    }];
}

- (void)updateTitleLabels {
    [_titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = _titles[idx];
        label.font = _titleFont;
        label.textColor = idx == _selectedIndex ? _titleColorSelected : _titleColorNomal;
    }];
    _indicatorView.backgroundColor = _titleColorSelected;
}

- (void)layoutTitleLabels {
    CGFloat itemHeight = self.height - _indicatorViewHeight;
    [_titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * _itemWith;
        label.frame = CGRectMake(x, 0, _itemWith, itemHeight);
    }];
    
}

- (void)layoutIndicatorView {
    _indicatorView.height = _indicatorViewHeight;
    _indicatorView.y = self.height - _indicatorViewHeight;
    [self setIndicatorViewToIndex:_selectedIndex animated:NO];
}

//滚动到某个位置需要判断前后的内容是否需要滚动到可见区域
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.contentSize.width <= self.bounds.size.width) {
        return;
    }
    
    CGFloat positionX = index * _itemWith;
    CGFloat maxContenOffsetX = (_itemWith * _titleLabels.count) - CGRectGetWidth(self.bounds);
    CGFloat contentOffsetX = MIN(MAX(0, positionX - _itemWith/2), maxContenOffsetX);
    
    [self setContentOffset:CGPointMake(contentOffsetX, 0) animated:animated];
}

- (void)setIndicatorViewToIndex:(NSInteger)index animated:(BOOL)animated {
    UILabel *selectedLabel =  _titleLabels[index];
    void(^block)() = ^{
        _indicatorView.width = selectedLabel.intrinsicContentSize.width + 2;
        _indicatorView.centerX = selectedLabel.centerX;
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
        view.backgroundColor = _titleColorSelected;
        view.hidden = !_indicatorViewEnable;
        _indicatorView = view;
    }
    return _indicatorView;
}

- (UILabel *)titleLabel {
    UILabel *label = [UILabel new];
    label.font = _titleFont;
    label.textColor = _titleColorNomal;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSInteger)totalIndex {
    return _titleLabels.count;
}

@end





