//
//  JMGoodsDetailNavTitleView.m
//  JuMei
//
//  Created by yangyuan on 2016/9/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailNavTitleView.h"
#import "YYSegmentedView.h"

@interface JMGoodsDetailNavTitleView ()

@property (nonatomic, strong) YYSegmentedView *segmentControl;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation JMGoodsDetailNavTitleView


#pragma mark - Initialization

+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.titleLabel.alpha = 0;
    self.segmentControl.alpha = 0;
    self.sectionTitleMaxCount = 1;
    [self addSubview:self.segmentControl];
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSegmentControl];
}

#pragma mark - Private

- (void)layoutSegmentControl {
    NSInteger titlesCount = _sectionTitles.count;
    CGFloat itemWith = _sectionTitleMaxCount > 0 ? CGRectGetWidth(self.bounds) / _sectionTitleMaxCount : 0;
}

#pragma mark - Public

- (void)switchTitleAnimated {
    if (_segmentControl.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _segmentControl.alpha = 1;
            _titleLabel.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _segmentControl.alpha = 0;
            _titleLabel.alpha = 1;
        }];
    }
}

- (void)showSectionTilesAnimated {
    self.hidden = NO;
    _segmentControl.alpha = 0;
    [self switchTitleAnimated];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    [_segmentControl setSelectedIndex:index animated:animated notify:notify];
}

#pragma mark - Delegate


#pragma mark - Setter

- (void)setIndexChangeBlock:(JMGoodsDetailNavTitleViewIndexChangeBlockBlock)indexChangeBlock {
    _indexChangeBlock = indexChangeBlock;
    
}

- (void)setSectionTitles:(NSArray<NSString *> *)sectionTitles {
    _sectionTitles = sectionTitles;
    _segmentControl.titles = sectionTitles;
    [self layoutSegmentControl];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    [_segmentControl setSelectedIndex:selectedSegmentIndex animated:YES notify:NO];
}

#pragma mark - Getter

- (YYSegmentedView *)segmentControl {
    if (!_segmentControl) {
        YYSegmentedView *segmentedView = [YYSegmentedView new];
        segmentedView.scrollEnabled = NO;
        __weak __typeof(self) weakSelf = self;
        segmentedView.indexChangedBlock = ^(YYSegmentedView *view, NSInteger toIndex, NSInteger prevIndex) {
            if (weakSelf.indexChangeBlock) {
                weakSelf.indexChangeBlock(toIndex);
            }
        };
        _segmentControl = segmentedView;
    }
    return _segmentControl;
}

- (NSInteger)selectedSegmentIndex {
    return _segmentControl.selectedIndex;
}

@end
