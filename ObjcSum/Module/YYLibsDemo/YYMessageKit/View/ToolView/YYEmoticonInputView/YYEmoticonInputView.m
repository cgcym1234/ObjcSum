//
//  YYEmoticonInputView.m
//  ObjcSum
//
//  Created by sihuan on 16/3/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYEmoticonInputView.h"
#import "YYEmoticonInputViewCell.h"
#import "UIView+YYMessage.h"

#pragma mark - Const

#define ScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])

//static NSInteger const PageViewHeight = 120;
static NSInteger const PageControlHeight = 37;
static NSInteger const TabViewHeight = 38;

static NSInteger const RowCount = 3;
static NSInteger const ColumnCount = 7;
static NSInteger const SectionCount = 10;

static NSString * const CellIdentifierDefault = @"YYEmoticonInputViewCell";

@interface YYEmoticonInputView ()
<UICollectionViewDelegate, UICollectionViewDataSource>

//使用UICollectionView实现
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout *flowLayout;

//圆点指示
@property (nonatomic, weak) IBOutlet  UIPageControl *pageControl;

@property (nonatomic, weak) IBOutlet  UIView *tabContainerView;
@property (nonatomic, weak) IBOutlet  UIButton *sendButton;


@property (nonatomic, strong) NSMutableArray *dataArray;

//当前表情页
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation YYEmoticonInputView


#pragma mark - Initialization

+ (instancetype)instance {
    return [self newInstanceFromNib];
}

- (void)awakeFromNib {
    [self setContext];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}


- (void)setContext {
//    [self addSubview:self.collectionView];
    self.translatesAutoresizingMaskIntoConstraints = YES;
//    self.backgroundColor = [UIColor whiteColor];
    [self _initCollectionView];
    [self loadEmoticonData];
    if (_dataArray.count > 0) {
        [self reloadData];
        [self scrollToMiddlle];
    }
}


#pragma mark - Override

- (void)layoutSubviews {
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    CGFloat collectionViewHeight = CGRectGetHeight(_collectionView.bounds);
    CGFloat collectionViewWidth = CGRectGetHeight(_collectionView.bounds);
    if (collectionViewWidth != ScreenWidth || collectionViewHeight != (viewHeight - PageControlHeight - TabViewHeight)) {
        [self resetItemLayout];
    }
}

#pragma mark - Private

- (void)_initCollectionView {
    UICollectionView *collectionView = self.collectionView;
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.bounces = YES;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:CellIdentifierDefault bundle:nil] forCellWithReuseIdentifier:CellIdentifierDefault];
    
    UICollectionViewFlowLayout *flowLayout = self.flowLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置行列间距
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
//    flowLayout.itemSize = CGSizeMake(30, 30);
}

- (void)_initPageControl {
    _pageControl.currentPage = 0;
    _pageControl.enabled = YES;
}

- (void)loadEmoticonData {
    NSMutableArray *dataArray = [NSMutableArray array];
    int emojiRangeArray[10] = {0xE001,0xE05A,0xE101,0xE15A,0xE201,0xE253,0xE401,0xE44C,0xE501,0xE537};
    for (int i = 0; i < 10; i += 2) {
        int startIndex = emojiRangeArray[i];
        int endIndex = emojiRangeArray[i+1];
        for (int emojiCode = startIndex; emojiCode < endIndex; emojiCode++) {
            //添加表情code到数据源数组
            [dataArray addObject:[NSString stringWithFormat:@"%C", (unichar)emojiCode]];
        }
    }
    self.dataArray = dataArray;
}

- (void)scrollToMiddlle {
    [self scrollToPage:0 animated:NO];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    if (page < 0 || page > _dataArray.count - 1) {
        page = 0;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page*RowCount*ColumnCount inSection:SectionCount/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    });
}


#pragma mark - Public

- (void)reloadData {
    [_collectionView reloadData];
}

- (void)resetItemLayout {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = CGRectGetWidth(collectionView.bounds)/ColumnCount;
    CGFloat itemHeight = CGRectGetHeight(collectionView.bounds)/RowCount;
    return CGSizeMake(itemWidth, itemHeight);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYEmoticonInputViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierDefault forIndexPath:indexPath];
    cell.label.text =_dataArray[indexPath.item] ;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *emojiCode = _dataArray[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(yyEmoticonInputView:didTapText:)]) {
        [self.delegate yyEmoticonInputView:self didTapText:emojiCode];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_totalPage == 0) {
        return;
    }
    NSInteger page=(NSInteger)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%_totalPage;
    
    if (_currentPage != page) {
        _currentPage = page;
        _pageControl.currentPage = page;
    }
}

#pragma mark - Action

- (IBAction)didTapSendButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(yyEmoticonInputView:didTapText:)]) {
        [self.delegate yyEmoticonInputViewDidTapSend:self];
    }
}

- (IBAction)didTapPageControl:(UIPageControl *)sender {
    if (_currentPage != sender.currentPage) {
        _currentPage = sender.currentPage;
        [self scrollToPage:_currentPage animated:YES];
    }
}


#pragma mark - Setter

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    _totalPage = dataArray.count/(ColumnCount*RowCount);
    self.pageControl.numberOfPages = _totalPage;
}

#pragma mark - Getter



@end
